# Project 1 - Toys Co. :

Projet de groupe réalisé dans le cadre de la formation de DATA ANALYST à la Wild Code School de Nantes. A partir d'une base de données issue d'une entreprise de modèles réduits, nous devions extraire et traiter des informations pertinentes afin de répondre aux besoins du client.

## 4 thématiques pour notre étude de cas :

Finances , HR, Logistics, Sales

De ces 4 thèmes nous avons crées 6 user stories ->

#### FINANCES: 

- Je souhaite obtenir mon CA pour mes commandes par pays pour les 2 derniers mois -Je souhaite un point sur les commandes impayés

#### HR: 

- Je souhaite connaitre les 2 meilleurs vendeurs par CA, par mois

#### LOGISTICS: 

- Je souhaite connaître le stock des 5 meilleures ventes de mes produits toutes catégories confondues.

#### SALES: 

- Je souhaite connaître le nombre de produits vendus par catégorie et par mois.
- Je souhaite comparer les ventes avec les ventes de l'année dernière. (Comparaison : Même mois mais N-1)

# Schéma de notre réflexion pour la réalisation de notre livrable client :

Pour la réalisation de notre projet nous avons utilisé ->

1. MySQL pour la connexion au serveur de l'entreprise et faire nos requêtes.
2. Export des résultats sous forme de fichiers CSV
3. PowerBI et Tableau Software pour la création des dashboards

Les KPIs ainsi déterminés ont été représentés sous la forme de Dataviz via PowerBI / Tableau et présenté lors d'un entretien en présence de notre formateur et du reste de la promo.

# La base de données et nos requêtes :

La base de donnée pour notre étude de cas ce présente ainsi ->

<img width="795" alt="20230426094757" src="https://user-images.githubusercontent.com/127731574/234506340-d27574d9-09b4-4576-a3b6-763d9a95f53b.png">

Nous avons donc fait nos reqûetes par rapport à ce fichier afin d'apporter une réponse à chacune de nos user stories ->
```bash
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
