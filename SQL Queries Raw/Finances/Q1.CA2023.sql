SELECT 
  country AS Pays, 
  SUM(CASE WHEN MONTH(paymentDate) = 1 THEN amount ELSE 0 END) AS CA_janv23,
  SUM(CASE WHEN MONTH(paymentDate) = 2 THEN amount ELSE 0 END) AS CA_fev23,
  SUM(amount) AS CA_2derniersmois23
FROM payments
JOIN customers ON customers.customerNumber=payments.customerNumber
WHERE MONTH(paymentDate) IN (1, 2) AND YEAR(paymentDate)=YEAR(NOW())
GROUP BY country;
