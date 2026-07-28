-- ==================================================================================================
-- FICHIER D'ADMINISTRATION : GESTION DES RÔLES ET UTILISATEURS (PostgreSQL)
-- ==================================================================================================

-- Q1 — Créer un rôle ecommerce_readonly qui ne peut que lire les données
create role ecommerce_readonly;

-- Q2 — Créer un rôle ecommerce_engineer qui peut lire et modifier les données
create role ecommerce_engineer;

-- Q3 — Créer un utilisateur analyste_user avec le mot de passe analyste123 et
-- lui assigner le rôle ecommerce_readonly
create user analyste_user with password 'analyste123';
grant ecommerce_readonly to analyste_user;

-- Q4 — Créer un utilisateur engineer_user avec le mot de passe engineer123 et 
-- lui assigner le rôle ecommerce_engineer
create user engineer_user with password 'engineer123';
grant ecommerce_engineer to engineer_user;

-- ==================================================================================================
-- ATTRIBUTION DES PRIVILÈGES ASSOCIÉS (Nécessaire pour que les rôles agissent)
-- ==================================================================================================

-- Q5 — Donner accès à la base de données aux deux rôles
grant connect on database postgres to ecommerce_readonly, ecommerce_engineer;

-- Q6 — Donner accès au schéma public aux deux rôles
grant usage on schema public to ecommerce_readonly, ecommerce_engineer;

-- Q7 — Accorder le privilège SELECT sur toutes les tables au rôle ecommerce_readonly
grant select on all tables in schema public to ecommerce_readonly;

-- Q8 — Accorder les privilèges SELECT, INSERT, UPDATE, DELETE sur toutes les tables 
-- au rôle ecommerce_engineer
grant select, insert, update, delete on all tables in schema public to ecommerce_engineer;

-- Q9 — Faire en sorte que ces privilèges s'appliquent automatiquement aux futures tables
alter default privileges in schema public grant select on tables to ecommerce_readonly;
alter default privileges in schema public grant select, insert, update, delete on tables to ecommerce_engineer;

-- Q10 — Révoquer tous les accès publics sur les tables
revoke all privileges on all tables in schema public from public;
revoke all privileges on schema public from public;

-- ==================================================================================================
--                                       INDEX
-- ==================================================================================================

-- Q11 — Créer un index sur la colonne client_id de la table commandes
create index if not exists idx_commandes_client_id on commandes(client_id);

-- Q12 — Créer un index sur la colonne date_commande de la table commandes
create index if not exists idx_commandes_date_commande on commandes(date_commande);

-- Q13 — Créer un index sur la colonne statut de la table commandes
create index if not exists idx_commandes_status on commandes(statut);

-- Q14 — Créer un index sur la colonne commande_id de la table ligne_commande
create index if not exists idx_ligne_commandes_commande_id on ligne_commandes(commande_id);

-- Q15 — Créer un index sur la colonne produit_id de la table ligne_commande
create index if not exists idx_ligne_commandes_produit_id on ligne_commandes(produit_id);

-- Q16 — Créer un index sur la colonne categorie de la table produits
create index if not exists idx_produits_categorie on produits(categorie);

-- Q17 — Créer un index partiel sur date_commande uniquement pour les commandes avec statut 'livre'
create index if not exists idx_commandes_livre_date on commandes(date_commande) where statut = 'livre';

-- Q18 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index sur une requête filtrée par statut
explain analyse select * from commandes where statut = 'livre';

-- Q19 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index sur une requête filtrée par date
--set enable_seqscan = off;
explain analyse select * from  commandes where date_commande = '2023-01-05';

-- ======================================================================================================================
--                                       CONTRAINTES
-- ======================================================================================================================
-- NOTE TECHNIQUE : 
-- L'utilisation des blocs procéduraux anonymes (DO $$ ... BEGIN ... EXCEPTION WHEN duplicate_object THEN NULL END $$;) 
-- permet de rendre ce script entièrement idempotent. Cela signifie qu'on peut exécuter le fichier plusieurs fois 
-- d'affilée sans blocage : si une contrainte existe déjà dans la base, PostgreSQL intercepte l'erreur 'duplicate_object' 
-- et l'ignore proprement au lieu d'interrompre l'exécution.
-------------------------------------------------------------------------------------------------------------------------
-- Q20 — Ajouter une contrainte : prix d'un produit toujours positif
do $$ 
begin
    alter table produits add constraint chk_produit_prix_positif check (prix > 0);
exception
    when duplicate_object then 
        null;
end $$;


-- Q21 — Ajouter une contrainte : stock d'un produit toujours positif ou nul
do $$ 
begin
    alter table produits add constraint chk_produit_stock_positif check (stock >= 0);
exception
    when duplicate_object then 
        null;
end $$;	


-- Q22 — Ajouter une contrainte : statut d'une commande uniquement 'en_attente', 'expedie', 'livre' ou 'annule'
do $$ 
begin
    alter table commandes add constraint chk_commande_statut check (statut in ('en_attente', 'expedie', 'livre', 'annule'));
exception
    when duplicate_object then 
        null;
end $$;

-- Q23 — Ajouter une contrainte : quantité dans ligne_commande toujours positive
do $$ 
begin
    alter table ligne_commandes add constraint chk_ligne_commandes_quantite_positive check (quantite > 0);
exception
    when duplicate_object then 
        null;
end $$;

-- Q24 — Ajouter une contrainte : prix_unitaire dans lignes_commande toujours positif
do $$ 
begin
    alter table ligne_commandes add constraint chk_ligne_commande_prix_positif check (prix_unitaire > 0);
exception
    when duplicate_object then 
        null;
end $$;

-- Q25 — Tester qu'une contrainte fonctionne en essayant d'insérer une valeur invalide (doit retourner une erreur)
--insert into ligne_commandes (ligne_id, commande_id, produit_id, quantite, prix_unitaire) 
--values (999, 1, 1, -5, 10.00);



-- ===============================================================================================================
--                                       VERIFICATIONS
-- ===============================================================================================================

-- Q26 — Lister tous les index créés sur les tables du schéma public
select 
    schemaname,
    tablename,
    indexname,
    indexdef
from 
    pg_indexes
where 
    schemaname = 'public'
order by 
    tablename, 
    indexname;

-- Q27 — Lister toutes les contraintes sur les 4 tables
select 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
from 
    information_schema.table_constraints tc
left join 
    information_schema.key_column_usage kcu 
    on tc.constraint_name = kcu.constraint_name 
    and tc.table_schema = kcu.table_schema
where 
    tc.table_schema = 'public'
    and tc.table_name in ('clients', 'commandes', 'ligne_commandes', 'produits')
order by 
    tc.table_name, 
    tc.constraint_type;

-- Q28 — Vérifier les privilèges accordés aux rôles ecommerce_readonly et ecommerce_engineer
select 
    grantee as role_name,
    table_schema,
    table_name,
    privilege_type
from 
    information_schema.role_table_grants
where 
    table_schema = 'public'
    and grantee in ('ecommerce_readonly', 'ecommerce_engineer')
order by 
    grantee, 
    table_name, 
    privilege_type;
-- ===============================================================================================================
--                                       SAUVEGARDE (A EXECUTER DANS LE TERMINAL)
-- ===============================================================================================================
 

-- Q29 — Faire un dump compressé de la base de données
-- Commande à exécuter dans le terminal :
	pg_dump -U postgres -F c -b -v -f backup_ecommerce.dump postgres


-- Q30 — Faire un dump SQL lisible de la base de données
-- Commande à exécuter dans le terminal :
	pg_dump -U postgres -F p -v -f backup_ecommerce.sql postgres


-- Q31 — Créer une nouvelle base ecommerce_restauree et y restaurer le dump compressé
-- Commandes à exécuter dans le terminal :
create database ecommerce_restauree;
	pg_restore -U postgres -d ecommerce_restauree -v backup_ecommerce.dump

		
-- Q32 — Vérifier que les 4 tables et leurs données sont bien présentes
--        dans la base restaurée (doit retourner les mêmes chiffres qu'avant)
SELECT 'clients' AS table_name, COUNT(*) FROM clients
UNION ALL
SELECT 'commandes', COUNT(*) FROM commandes
UNION ALL
SELECT 'ligne_commandes', COUNT(*) FROM ligne_commandes
UNION ALL
SELECT 'produits', COUNT(*) FROM produits;



-- ===============================================================================================================
--                                                   FIN DES EXERCICES
-- ===============================================================================================================


