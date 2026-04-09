-- Q1
SELECT sales_channel, SUM(amount) AS revenue
FROM clinic_sales
GROUP BY sales_channel;

-- Q2
SELECT uid, SUM(amount) AS total_spent
FROM clinic_sales
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- Q3
SELECT s.month,
       s.revenue,
       e.expense,
       (s.revenue - e.expense) AS profit,
       CASE 
           WHEN (s.revenue - e.expense) > 0 THEN 'Profit'
           ELSE 'Loss'
       END AS status
FROM
(
    SELECT MONTH(datetime) AS month, SUM(amount) AS revenue
    FROM clinic_sales
    GROUP BY MONTH(datetime)
) s
JOIN
(
    SELECT MONTH(datetime) AS month, SUM(amount) AS expense
    FROM expenses
    GROUP BY MONTH(datetime)
) e
ON s.month = e.month;

-- Q4
SELECT *
FROM (
    SELECT c.city, cs.cid,
           SUM(cs.amount) AS revenue,
           RANK() OVER (PARTITION BY c.city ORDER BY SUM(cs.amount) DESC) rnk
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    GROUP BY c.city, cs.cid
) t
WHERE rnk = 1;

-- Q5
SELECT *
FROM (
    SELECT c.state, cs.cid,
           SUM(cs.amount) AS revenue,
           DENSE_RANK() OVER (PARTITION BY c.state ORDER BY SUM(cs.amount) ASC) rnk
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    GROUP BY c.state, cs.cid
) t
WHERE rnk = 2;
