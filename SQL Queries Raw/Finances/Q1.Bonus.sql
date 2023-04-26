SELECT *
FROM 
(SELECT customers.country, DATE_FORMAT(payments.paymentDate, "%Y-%m") AS yearMonth, SUM(payments.amount) AS monthlyTurnover
FROM payments
LEFT JOIN customers ON customers.customerNumber=payments.customerNumber
GROUP BY country, yearMonth
ORDER BY yearMonth, monthlyTurnover DESC
) AS month_by_month;