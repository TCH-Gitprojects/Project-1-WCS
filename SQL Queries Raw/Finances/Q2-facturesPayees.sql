SELECT numero_client, montant_commande, numero_commande, statut_commande, amount AS paiement_recu
FROM(
SELECT orders.customerNumber as numero_client, SUM(quantityOrdered*priceEach) AS montant_commande, orders.orderNumber AS numero_commande, orders.status AS statut_commande, orders.orderDate AS date_commande
FROM orders
RIGHT JOIN orderdetails ON orders.orderNumber=orderdetails.orderNumber
WHERE orders.status = "Shipped" OR orders.status = "Resolved" 
GROUP BY orders.orderNumber
ORDER BY customerNumber) AS new_order
JOIN payments ON payments.amount=montant_commande;