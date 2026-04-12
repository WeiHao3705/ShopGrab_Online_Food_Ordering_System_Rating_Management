SET SERVEROUTPUT ON;
SET DEFINE OFF;
SET LINESIZE 200;   
SET PAGESIZE 200;

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_rpt_f3';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX idx_order_date';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1418 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX idx_restaurant_type';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1408 THEN
            RAISE;
        END IF;
END;
/

CREATE SEQUENCE seq_rpt_f3 START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE VIEW v_order_summary AS
SELECT 
    o.orderID,
    o.order_date,
    o.total_amount,
    o.order_status,
    mi.restaurantID,
    r.is_halal
FROM Orders o
JOIN OrderDetails od ON o.orderID = od.orderID
JOIN MenuItem mi ON od.menuitemID = mi.menuitemID
JOIN Restaurant r ON mi.restaurantID = r.restaurantID
WHERE o.order_status = 'Completed';

CREATE OR REPLACE VIEW v_monthly_summary AS
SELECT 
    TO_CHAR(order_date,'YYYY-MM') AS month_year,
    is_halal,
    COUNT(orderID) AS total_orders,
    SUM(total_amount) AS total_sales,
    ROUND(AVG(total_amount),2) AS avg_order,
    MAX(total_amount) AS highest_order,
    MIN(total_amount) AS lowest_order
FROM v_order_summary
GROUP BY TO_CHAR(order_date,'YYYY-MM'), is_halal;

BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX idx_order_date ON Orders(order_date)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1408 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX idx_restaurant_type ON Restaurant(is_halal)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1408 THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PROCEDURE rpt_halal_monthly_sales (
    p_month IN VARCHAR2
)
IS
    -- Outer cursor: fetches the distinct month (validates data exists)
    CURSOR cur_month IS
        SELECT DISTINCT month_year
        FROM v_monthly_summary
        WHERE month_year = p_month;

    -- Inner cursor: fetches halal vs non-halal rows for a given month
    CURSOR cur_type (p_month_year VARCHAR2) IS
        SELECT *
        FROM v_monthly_summary
        WHERE month_year = p_month_year
        ORDER BY is_halal DESC;

    v_month_rec cur_month%ROWTYPE;
    v_type_rec  cur_type%ROWTYPE;
    v_separator VARCHAR2(90);
    v_rows      NUMBER := 0;
BEGIN
    IF NOT REGEXP_LIKE(p_month, '^\d{4}-\d{2}$') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid month format. Use YYYY-MM.');
    END IF;

    v_separator := RPAD('=', 90, '=');

    DBMS_OUTPUT.PUT_LINE(v_separator);
    DBMS_OUTPUT.PUT_LINE('  SHOPGRAB - HALAL VS NON-HALAL MONTHLY SALES REPORT');
    DBMS_OUTPUT.PUT_LINE('  Report Run ID: ' || seq_rpt_f3.NEXTVAL);
    DBMS_OUTPUT.PUT_LINE('  Selected Month : ' || p_month);
    DBMS_OUTPUT.PUT_LINE('  Generated : ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE(v_separator);
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Month',10)      ||
        RPAD('Type',12)       ||
        LPAD('Orders',8)      ||
        LPAD('Total Sales',14)||
        LPAD('Avg Order',12)  ||
        LPAD('Highest',12)    ||
        LPAD('Lowest',12)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 90, '-'));

    -- Outer loop: runs once if the month exists in the view
    OPEN cur_month;
    LOOP
        FETCH cur_month INTO v_month_rec;
        EXIT WHEN cur_month%NOTFOUND;

        -- Inner loop: iterates over Halal / Non-Halal rows for that month
        OPEN cur_type(v_month_rec.month_year);
        LOOP
            FETCH cur_type INTO v_type_rec;
            EXIT WHEN cur_type%NOTFOUND;

            v_rows := v_rows + 1;

            DBMS_OUTPUT.PUT_LINE(
                RPAD(v_type_rec.month_year, 10) ||
                RPAD(CASE v_type_rec.is_halal WHEN 1 THEN 'Halal' ELSE 'Non-Halal' END, 12) ||
                LPAD(TO_CHAR(v_type_rec.total_orders), 8) ||
                LPAD(TO_CHAR(v_type_rec.total_sales,   '999,999.00'), 14) ||
                LPAD(TO_CHAR(v_type_rec.avg_order,     '999,999.00'), 12) ||
                LPAD(TO_CHAR(v_type_rec.highest_order, '999,999.00'), 12) ||
                LPAD(TO_CHAR(v_type_rec.lowest_order,  '999,999.00'), 12)
            );
        END LOOP;
        CLOSE cur_type;

    END LOOP;
    CLOSE cur_month;

    IF v_rows = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No completed orders found for month ' || p_month || '.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_separator);

EXCEPTION
    WHEN OTHERS THEN
        IF cur_type%ISOPEN THEN
            CLOSE cur_type;
        END IF;
        RAISE_APPLICATION_ERROR(-20001, 'Unexpected error: ' || SQLERRM);
END rpt_halal_monthly_sales;
/