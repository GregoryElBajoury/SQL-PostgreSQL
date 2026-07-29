Brief SQL & PostgreSQL - E-commerce
===================================

Ce dépôt contient les scripts, les fichiers de configuration, les procédures de sauvegarde/restauration ainsi que le pipeline d'intégration continue (CI) réalisés dans le cadre du brief sur la gestion de bases de données avec PostgreSQL.

## Statut de la CI
[![SQL Validation CI](https://github.com/GregoryElBajoury/SQL-PostgreSQL/actions/workflows/sql-ci.yml/badge.svg)](https://github.com/GregoryElBajoury/SQL-PostgreSQL/actions)

Le projet est testé et validé automatiquement sur les versions **14**, **15** et **16** de PostgreSQL via GitHub Actions.


Structure du Projet
-------------------

Le projet s'organise autour des fichiers suivants :

*   `setup.sql` : Script de création de la structure initiale de la base de données (tables, contraintes, relations).
    
*   `script.sql` : Script contenant les requêtes d'insertion des données (dataset) et les requêtes d'analyse/manipulation.
    
*   `administration.sql` : Scripts liés aux opérations d'administration, de sauvegarde (pg\_dump) et de restauration (pg\_restore).
    
*   `backup_ecommerce.dump / backup_ecommerce.sql` : Fichiers de sauvegarde (dumps) de la base de données.
    

1\. Instructions de mise en place de l'environnement
----------------------------------------------------

Pour exécuter et tester ce projet localement, assurez vous d'avoir installé les outils suivants :

*   PostgreSQL (version 14, 15 ou 16 recommandée)
    
*   Un client SQL compatible comme DBeaver
    

Étapes d'installation :

1.  Clone le dépôt sur votre machine locale :

```
git clone [https://github.com/GregoryElBajoury/SQL-PostgreSQL.git](https://github.com/GregoryElBajoury/SQL-PostgreSQL.git)

cd SQL-PostgreSQl
```
    
4.  Ouvrez votre terminal ou votre client SQL connecté à votre serveur PostgreSQL local.
    

2\. Chargement du Dataset et de la structure
--------------------------------------------

Vous pouvez initialiser la base de données de deux manières différentes :

Option A : Via les scripts SQL (Création + Insertion)

1.  Exécutez le script de création de la structure : `psql -U postgres -f setup.sql`
    
2.  Exécutez le script de peuplement des données : `psql -U postgres -f script.sql`
    

Option B : Via la restauration d'un Dump (Recommandé)Si tu souhaites restaurer directement la base complète à partir du fichier compressé fourni :

1.  Créez une base de données vide : `createdb -U postgres ecommerce\_restauree`
    
2.  Restaurez le dump compressé : `pg\_restore -U postgres -d ecommerce\_restauree -v backup\_ecommerce.dump`
    

3\. Vérification de l'intégrité (Q32)
-------------------------------------

Pour t'assurer que les tables et les données sont correctement présentes, tu peux exécuter la requête de vérification suivante dans ton éditeur SQL (DBeaver) :

```sql
SELECT 'clients' AS table_name, COUNT(*) FROM clients
UNION ALL
SELECT 'commandes', COUNT(*) FROM commandes
UNION ALL
SELECT 'ligne_commandes', COUNT(*) FROM ligne_commandes
UNION ALL
SELECT 'produits', COUNT(*) FROM produits;
```
