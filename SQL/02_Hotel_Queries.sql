-- Q1
SELECT user_id, room_no
FROM bookings b1
WHERE booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b1.user_id = b2.user_id
);

-- Q2
SELECT b.booking_id,
SUM(i.item_rate * bc.item_quantity) AS total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 11 AND YEAR(bc.bill_date) = 2021
GROUP BY b.booking_id;

-- Q3
SELECT bc.bill_id,
SUM(i.item_rate * bc.item_quantity) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10 AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING total_bill > 1000;

-- Q4
SELECT month, item_id, total_qty
FROM (
    SELECT MONTH(bill_date) AS month,
           item_id,
           SUM(item_quantity) AS total_qty,
           RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) DESC) rnk_desc,
           RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) ASC) rnk_asc
    FROM booking_commercials
    GROUP BY MONTH(bill_date), item_id
) t
WHERE rnk_desc = 1 OR rnk_asc = 1;

-- Q5
SELECT *
FROM (
    SELECT MONTH(bill_date) AS month,
           bill_id,
           SUM(item_quantity) AS total,
           DENSE_RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) DESC) rnk
    FROM booking_commercials
    GROUP BY MONTH(bill_date), bill_id
) t
WHERE rnk = 2;
