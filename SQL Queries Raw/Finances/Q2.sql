SELECT * 
FROM (SELECT orders.customerNumber as numero_client, SUM(quantityOrdered*priceEach) AS montant_commande, orders.orderNumber AS numero_commande, orders.status AS statut_commande, orders.orderDate AS date_commande
FROM orders
RIGHT JOIN orderdetails ON orders.orderNumber=orderdetails.orderNumber
WHERE orders.status = "Shipped" OR orders.status = "Resolved" 
GROUP BY orders.orderNumber
ORDER BY customerNumber) as new_order
WHERE (numero_client, montant_commande) NOT IN (SELECT customerNumber, amount FROM payments)