<div align="center">
  <center><h1>Project 1 - Toys Co. :</h1></center>
</div>


Projet de groupe réalisé dans le cadre de la formation de DATA ANALYST à la Wild Code School de Nantes. A partir d'une base de données issue d'une entreprise de modèles réduits, nous devions extraire et traiter des informations pertinentes afin de répondre aux besoins du client.

## Accès à la présentation (sans les visu Tableau Software) :
https://github.com/TCH-Gitprojects/Project-1-WCS/blob/f3797f2464226110f674fa7b53794598dcd4c89e/pr%C3%A9sentation_Toys_CIE_WCS_03_2023.pdf

## 4 thématiques pour notre étude de cas :

Finances , HR, Logistics, Sales

De ces 4 thèmes nous avons crées 6 user stories ->

#### LOGISTICS: 

- Je souhaite connaître le stock des 5 meilleures ventes de mes produits toutes catégories confondues.

#### SALES: 

- Je souhaite connaître le nombre de produits vendus par catégorie et par mois.
- Je souhaite comparer les ventes avec les ventes de l'année dernière. (Comparaison : Même mois mais N-1).

#### HR: 

- Je souhaite connaitre les 2 meilleurs vendeurs par CA, par mois.

#### FINANCES: 

- Je souhaite obtenir mon CA pour mes commandes par pays pour les 2 derniers mois. 
- Je souhaite un point sur les commandes impayés.

# Schéma de notre réflexion pour la réalisation de notre livrable client :

Pour la réalisation de notre projet nous avons utilisé ->

1. MySQL pour la connexion au serveur de l'entreprise et faire nos requêtes.
2. Export des résultats sous forme de fichiers CSV.
3. PowerBI et Tableau Software pour la création des dashboards.

Les KPIs ainsi déterminés ont été représentés sous la forme de Dataviz via PowerBI / Tableau et présenté lors d'un entretien en présence de notre formateur et du reste de la promo.

# La base de données et nos requêtes :

La base de donnée pour notre étude de cas ce présente ainsi ->

<img width="795" alt="20230426094757" src="https://user-images.githubusercontent.com/127731574/234506340-d27574d9-09b4-4576-a3b6-763d9a95f53b.png">

Nous avons donc fait nos reqûetes par rapport à ce fichier afin d'apporter une réponse à chacune de nos user stories :

## LOGISTICS ->

```sql
/* USER STORY - LOGISTICS - Je souhaite connaitre le stock des 5 meilleures ventes de mes produits toutes catégories confondues. */
USE toys_and_models;

/*  ETAPE 1: établir le total des ventes pour chaque produit */ 
SELECT productCode,  SUM(quantityOrdered) AS total_des_ventes	-- addition des produits vendus (total_des_ventes) sélectionnés par ID
FROM orderdetails			-- Colonne du détail des ventes
GROUP BY productCode;

/* ETAPE 2: déterminer les 5 meilleures ventes */
SELECT productCode, SUM(quantityOrdered) AS total_des_ventes, orderDate
FROM orderdetails
INNER JOIN orders ON orderdetails.orderNumber=orders.orderNumber
GROUP BY productCode, orderDate
ORDER BY total_des_ventes DESC					-- classement du total_des_ventes par ordre décroissant
LIMIT 5;										-- utilisation de la limite pour sélectionner les 5 premiers

/* ETAPE 3: établir le stock actuel des 5 meilleures ventes */ 
SELECT  products.productCode, productName,productLine, total_des_ventes,quantityInStock
FROM products
INNER JOIN (
  SELECT productCode, SUM(quantityOrdered) AS total_des_ventes		-- JOINTURE  DE LA TABLE products AVEC LA REQUETE ETAPE 2
  FROM orderdetails													 
  GROUP BY productCode
  ORDER BY total_des_ventes DESC
  LIMIT 5
) orderdetails ON products.productCode = orderdetails.productCode;
```
## SALES ->

```sql
SELECT SUM(orderdetails.quantityOrdered) as NbProdV,  -- NOMBRE PRODUIT COMMANDE = VOLUMES DE VENTES
DATE_FORMAT(orderDate, '%Y-%m') as Date_commande, 
productLine as Category

FROM products

INNER JOIN orderdetails ON products.productCode=orderdetails.productCode  -- JOINTURE INNER POUR DONNEES CORRESPONDANTES ENTRE LES TABLES
INNER JOIN orders ON orderdetails.orderNumber=orders.orderNumber

GROUP BY DATE_FORMAT(orderDate, '%Y-%m'), productLine  -- REGROUPEMENT PAR DATE

ORDER BY Date_commande DESC, Category ASC;  -- ORDRE DECROISSANT POUR 2023 FIRST
```

## HR ->

```sql
SELECT *
FROM
(SELECT employees.lastName, employees.firstName, salesRepEmployeeNumber, DATE_FORMAT(paymentDate, '%Y-%m') as payment_month, 
SUM(amount) as CA, RANK() OVER(PARTITION BY DATE_FORMAT(paymentDate, '%Y-%m') ORDER BY SUM(amount) DESC) AS ranking

FROM customers

INNER JOIN employees ON customers.salesRepEmployeeNumber=employees.employeeNumber
INNER JOIN payments ON payments.customerNumber=customers.customerNumber

GROUP BY salesRepEmployeeNumber, payment_month) AS best_sell

ORDER BY payment_month DESC, CA DESC;
```

## FINANCES ->

```sql
/* Point sur factures */
SELECT orders.customerNumber as numero_client, SUM(quantityOrdered*priceEach) AS montant_commande, orders.orderNumber AS numero_commande, orders.status AS statut_commande, orders.orderDate AS date_commande

FROM orders

RIGHT JOIN orderdetails ON orders.orderNumber=orderdetails.orderNumber
WHERE orders.status = "Shipped" OR orders.status = "Resolved" 

GROUP BY orders.orderNumber

ORDER BY customerNumber
```

```sql
/* Point sur CA 2 derniers mois */
SELECT 
  country AS Pays, 
  SUM(CASE WHEN MONTH(paymentDate) = 1 THEN amount ELSE 0 END) AS CA_janv23,
  SUM(CASE WHEN MONTH(paymentDate) = 2 THEN amount ELSE 0 END) AS CA_fev23,
  SUM(amount) AS CA_2derniersmois23

FROM payments

JOIN customers ON customers.customerNumber=payments.customerNumber
WHERE MONTH(paymentDate) IN (1, 2) AND YEAR(paymentDate)=YEAR(NOW())

GROUP BY country;
```

Les KPIs ainsi déterminés ont été représentés sous la forme de Dataviz via PowerBI / Tableau et présenté lors d'un entretien en présence de notre formateur et du reste de la promo.

# Examples de Data viz réalisées pour ce projet :

![20230426103635](https://user-images.githubusercontent.com/127731574/234518896-27aa95a6-74c8-4ef0-b4a3-aabfd091e951.png)

![20230426103241](https://user-images.githubusercontent.com/127731574/234517837-274b1386-e92e-4160-8753-f3f0cefc1e37.png)

# L'équipe ayant réalisé ce projet :

<p>https://www.linkedin.com/in/tonychatri/<br>
https://www.linkedin.com/in/simonvauthier/ https://github.com/SimonVauthier<br>
https://www.linkedin.com/in/nicolas-rayjal-2927741a/<br>
https://www.linkedin.com/in/emmanuellele-gal/</p>

<div align="center">
  <center><h1>Merci à tous</h1></center>
</div>
