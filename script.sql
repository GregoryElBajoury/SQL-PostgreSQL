
---------------------------------------- QUESTIONS N1 CHAPITRE 1 ---------------------------------------------------

-- Q1 N1 Afficher le nom et l'email de tous les clients
select nom, email from clients;

-- Q2 N& Afficher tous les produits de la catégorie 'Electronique'
select * from produits where categorie = 'Electronique';

-- Q3 N& Afficher les produits dont le prix est superieur a 50 euros
select * from produits where prix > 50;

-- Q4 N1 Afficher les 5 produits les plus chers
select * from produits order by prix desc limit 5;

-- Q5 N1 Afficher les clients qui habitent a Paris ou Lyon
select * from clients where ville = 'Paris' or ville = 'Lyon';

-- Q6 N1 Afficher les commandes avec le status 'livre' ou 'expedie'
select * from commandes where statut = 'livre' or statut = 'expedie';

-- Q7 N1 Afficher les produits dont le nom contient le mot 'cable';
select * from produits where nom ilike '%cable%';

-- Q8 N1 Afficher les clients sans ville renseignée
select * from clients where ville is null;

-- Q9 N1 Afficher les produits dont le prix est compris entre 20 et 100e. Tri pa prix croissant
select * from produits where prix between 20.00 and 100.00 order by prix;

-- Q10 N1 Afficher la liste des categories distinctes de produits
select distinct categorie from produits;

-- Q11 N1 Afficher les commandes passées en 2023, tries du plus recent au plus ancien
select * from commandes where date_commande between '2023-01-01' and '2023-12-31' order by date_commande desc;

-- Q12 N1 Affiche le nom et le prix TTC (prix * 1.20) de tous les produits, avec l'alias prix_ttc
select nom, prix*1.20 as prix_ttc from produits;

-- Q13 N1 Afficher les 3 produits avec le moins de stock
select * from produits order by stock asc limit 3;

-- Q14 N1 Affiche les clients inscrits depuis janvier 2022
select * from clients where date_inscription >= '2022-01-01';

-- Q15 N1 Afficher les commandes dont le total est superieur a 200euros et le status 'livre'
select * from commandes where total > 200 and statut = 'livre';

--------------------------------------- QUESTIONS N1 CHAPITRE 2 -----------------------------------------------
-- Q16 N1 Compter le nombre total de clients
select count (*) as total_de_clients from clients;

-- Q17 N1 Calculer le prix moyen des produits
select avg(prix) as prix_moyen from produits;

-- Q18 N1 Afficher le produit le plus cher et le moins cher
select max(prix) as produit_le_plus_cher, min(prix) as le_moins_cher from produits;


-- Q19 N1 Calculer le chiffre d'affaires total ( somme des totaux de toutes les commandes)
select sum(total) as chiffre_daffaires_total from commandes;

-- Q20 N1 Compter le nombre de produits par categorie
select categorie, count(*) as nbre_produits_cate from produits group by categorie;

-- Q21 N1 Afficher le total des commandes par status
select statut, sum (total) as commandes_status from commandes group by statut;

---------------------------------------- QUESTIONS N2 CHAPITRE 1 ---------------------------------------------------

---------------------------------------- QUESTIONS N2 CHAPITRE 1 ---------------------------------------------------

-- Q22 N2 Calculer le panier moyen (total moyen d une commande) par mois
select
	date_trunc('month', date_commande) as mois,
	round(AVG(total)::numeric, 2) as panier_moyen 
from commandes group by date_trunc('month', date_commande)
order by mois asc;

-- Q23 N2 Afficher les categories avec un prix moyen superieur a 50e
select
	categorie,
	AVG(prix) as prix_moyen
from produits
group by categorie
having AVG(prix) > 50;

-- Q24 N2 Afficher le nombre de commandes par client (client_id + nombre de commandes)
select
	client_id,
	count(*) as nombre_de_commandes
from commandes
group by client_id;

-- Q25 N2 Afficher les client ayant passé plus de 3 commandes
select
	client_id,
	count(*) as nombre_de_commandes
from commandes
group by client_id
having count(*)> 3;


-- Q26 N2 Afficher le CA total par mois, trié chronologiquement
select
	date_trunc('month', date_commande) as mois,
	sum(total) as chiffre_daffaires_total
from commandes
group by date_trunc('month', date_commande)
order by mois asc


-- Q27 N2 Afficher les categories ayant au moins 3 produits en stock superieur a 0
select
	categorie,
	count(*) as nombre_produits_stocks
from produits
where stock > 0
group by categorie
having count(*) >= 3


--Q28 N2 Calculer la valeur totale du stock pour chaque categorie

select 
	categorie,
	sum(prix * stock) as valeur_total_stock
from produits
group by categorie 

-- Q29 N2 Afficher le nombre de clients par pays, uniquement les pays de plus de 10 clients
select
	pays,
	count(*) as nombre_clients_pays
from clients
group by pays
having count(*) > 10

-- Q30 Afficher le mois ayant generé le plus de commandes
select 
    date_trunc('month', date_commande) as mois, 
    count(*) as nombre_commandes 
from commandes 
group by date_trunc('month', date_commande) 
order by nombre_commandes desc 
limit 1;

-- Q31 N1 Afficher toutes les commandes avec le nom et l'email du client associé
select 
    c.commande_id,
    c.date_commande,
    c.total,
    cl.nom,
    cl.email 
from commandes c
join clients cl on c.client_id = cl.client_id;

-- Q32 N1 Afficher les lignes de commandes avec le nom du produit et la quantité commandée
select 
    lc.ligne_id,
    p.nom as nom_produit,
    lc.quantite
from ligne_commandes lc
join produits p on lc.produit_id = p.produit_id;

-- Q33 N2 Afficher les clients qui n'ont jamais passé de commandes
select 
    cl.client_id,
    cl.nom,
    cl.email
from clients cl
left join commandes c on cl.client_id = c.client_id
where c.commande_id is null;


-- Q34 N2 Afficher le detail complet des commandes client produit quantité soustotal
select 
    cl.nom as nom_client,
    c.commande_id,
    c.date_commande,
    p.nom as nom_produit,
    lc.quantite,
    (lc.quantite * lc.prix_unitaire) AS sous_total
from clients cl
join commandes c ON cl.client_id = c.client_id
join ligne_commandes lc on c.commande_id = lc.commande_id
join produits p on lc.produit_id = p.produit_id;

-- Q35 N2 Afficher le CA total generé par chaque client (nom + total_CA), trie par CA croissant
select 
    cl.nom,
    sum(c.total) as total_CA
from clients cl
join commandes c on cl.client_id = c.client_id
group by cl.client_id, cl.nom
order by total_CA asc;

-- Q36 N2 Afficher le nombre de fois que chaque produit a été commandé
select 
    p.nom as nom_produit,
    SUM(lc.quantite) as total_commande
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
group by p.produit_id, p.nom
order by total_commande desc;

-- Q37 N2 Afficher les produits qui n ont jamais été commandés
select 
    p.produit_id,
    p.nom,
    p.categorie
from produits p
left join ligne_commandes lc on p.produit_id = lc.produit_id
where lc.ligne_id is null;

-- Q38 N2 Afficher le CA total par categorie de produit
select 
    p.categorie,
    sum(lc.quantite * lc.prix_unitaire) as ca_total
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
group by p.categorie
order by ca_total desc;

-- Q39 N2 Afficher les 5 clients ayant le CA le plus élevé
select 
    cl.client_id,
    cl.nom,
    cl.email,
    sum(c.total) as ca_total
from clients cl
join commandes c on cl.client_id = c.client_id
group by cl.client_id, cl.nom, cl.email
order by ca_total desc
limit 5;

-- Q40 N2 Afficher le produit le plus vendu (en quantité totale)
select 
    p.produit_id, 
    p.nom,
    sum(lc.quantite) as quantite_totale
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
group by p.produit_id, p.nom
order by quantite_totale desc
limit 1;

-- Q41 N2 Afficher pour chaque commande : nom client, nombre d articles, total commande
select 
    c.commande_id,
    cl.nom as nom_client,
    sum(lc.quantite) as nombre_articles,
    c.total as total_commande
from commandes c
join clients cl on c.client_id = cl.client_id
join ligne_commandes lc on c.commande_id = lc.commande_id
group by c.commande_id, cl.nom, c.total;

-- Q42 N2 Afficher les clients ayant commandé des produits de la catégorie 'Electronique'
select distinct
    cl.client_id,
    cl.nom,
    cl.email
from clients cl
join commandes c on cl.client_id = c.client_id
join ligne_commandes lc on c.commande_id = lc.commande_id
join produits p on lc.produit_id = p.produit_id
where p.categorie = 'Electronique';

-- Q43 N2 Afficher le CA moyen par commande pour chaque client
select 
    cl.client_id,
    cl.nom,
    round(avg(c.total)::numeric, 2) as ca_moyen_commande
from clients cl
join commandes c on cl.client_id = c.client_id
group by cl.client_id, cl.nom
order by cl.client_id asc;

-- Q44 N2 Afficher les produits vendus en 2023 avec leur categorie et quantité totale
select 
    p.produit_id,
    p.nom,
    p.categorie,
    sum(lc.quantite) as quantite_totale
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
join commandes c on lc.commande_id = c.commande_id
where extract(year from c.date_commande) = 2023
group by p.produit_id, p.nom, p.categorie;

-- Q45 N2 Afficher les clients et le montant total de leurs commandes livrées uniquement

select
	cl.client_id,
	cl.nom,
	sum(c.total) as montant_total_livre
from clients cl
join commandes c on cl.client_id = c.commande_id
group by cl.client_id, cl.nom;

-- Q23 N2 Afficher les categories avec un prix moyen superieur a 50e
select
	categorie,
	AVG(prix) as prix_moyen
from produits
group by categorie
having AVG(prix) > 50;

-- Q24 N2 Afficher le nombre de commandes par client (client_id + nombre de commandes)
select
	client_id,
	count(*) as nombre_de_commandes
from commandes
group by client_id;

-- Q25 N2 Afficher les client ayant passé plus de 3 commandes
select
	client_id,
	count(*) as nombre_de_commandes
from commandes
group by client_id
having count(*)> 3;


-- Q26 N2 Afficher le CA total par mois, trié chronologiquement
select
	date_trunc('month', date_commande) as mois,
	sum(total) as chiffre_daffaires_total
from commandes
group by date_trunc('month', date_commande)
order by mois asc


-- Q27 N2 Afficher les categories ayant au moins 3 produits en stock superieur a 0
select
	categorie,
	count(*) as nombre_produits_stocks
from produits
where stock > 0
group by categorie
having count(*) >= 3


--Q28 N2 Calculer la valeur totale du stock pour chaque categorie

select 
	categorie,
	sum(prix * stock) as valeur_total_stock
from produits
group by categorie 

-- Q29 N2 Afficher le nombre de clients par pays, uniquement les pays de plus de 10 clients
select
	pays,
	count(*) as nombre_clients_pays
from clients
group by pays
having count(*) > 10

-- Q30 Afficher le mois ayant generé le plus de commandes
select 
    date_trunc('month', date_commande) as mois, 
    count(*) as nombre_commandes 
from commandes 
group by date_trunc('month', date_commande) 
order by nombre_commandes desc 
limit 1;

-- Q31 N1 Afficher toutes les commandes avec le nom et l'email du client associé
select 
    c.commande_id,
    c.date_commande,
    c.total,
    cl.nom,
    cl.email 
from commandes c
join clients cl on c.client_id = cl.client_id;

-- Q32 N1 Afficher les lignes de commandes avec le nom du produit et la quantité commandée
select 
    lc.ligne_id,
    p.nom as nom_produit,
    lc.quantite
from ligne_commandes lc
join produits p on lc.produit_id = p.produit_id;

-- Q33 N2 Afficher les clients qui n'ont jamais passé de commandes
select 
    cl.client_id,
    cl.nom,
    cl.email
from clients cl
left join commandes c on cl.client_id = c.client_id
where c.commande_id is null;


-- Q34 N2 Afficher le detail complet des commandes client produit quantité soustotal
select 
    cl.nom as nom_client,
    c.commande_id,
    c.date_commande,
    p.nom as nom_produit,
    lc.quantite,
    (lc.quantite * lc.prix_unitaire) AS sous_total
from clients cl
join commandes c ON cl.client_id = c.client_id
join ligne_commandes lc on c.commande_id = lc.commande_id
join produits p on lc.produit_id = p.produit_id;

-- Q35 N2 Afficher le CA total generé par chaque client (nom + total_CA), trie par CA croissant
select 
    cl.nom,
    sum(c.total) as total_CA
from clients cl
join commandes c on cl.client_id = c.client_id
group by cl.client_id, cl.nom
order by total_CA asc;

-- Q36 N2 Afficher le nombre de fois que chaque produit a été commandé
select 
    p.nom as nom_produit,
    SUM(lc.quantite) as total_commande
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
group by p.produit_id, p.nom
order by total_commande desc;

-- Q37 N2 Afficher les produits qui n ont jamais été commandés
select 
    p.produit_id,
    p.nom,
    p.categorie
from produits p
left join ligne_commandes lc on p.produit_id = lc.produit_id
where lc.ligne_id is null;

-- Q38 N2 Afficher le CA total par categorie de produit
select 
    p.categorie,
    sum(lc.quantite * lc.prix_unitaire) as ca_total
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
group by p.categorie
order by ca_total desc;

-- Q39 N2 Afficher les 5 clients ayant le CA le plus élevé
select 
    cl.client_id,
    cl.nom,
    cl.email,
    sum(c.total) as ca_total
from clients cl
join commandes c on cl.client_id = c.client_id
group by cl.client_id, cl.nom, cl.email
order by ca_total desc
limit 5;

-- Q40 N2 Afficher le produit le plus vendu (en quantité totale)
select 
    p.produit_id, 
    p.nom,
    sum(lc.quantite) as quantite_totale
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
group by p.produit_id, p.nom
order by quantite_totale desc
limit 1;

-- Q41 N2 Afficher pour chaque commande : nom client, nombre d articles, total commande
select 
    c.commande_id,
    cl.nom as nom_client,
    sum(lc.quantite) as nombre_articles,
    c.total as total_commande
from commandes c
join clients cl on c.client_id = cl.client_id
join ligne_commandes lc on c.commande_id = lc.commande_id
group by c.commande_id, cl.nom, c.total;

-- Q42 N2 Afficher les clients ayant commandé des produits de la catégorie 'Electronique'
select distinct
    cl.client_id,
    cl.nom,
    cl.email
from clients cl
join commandes c on cl.client_id = c.client_id
join ligne_commandes lc on c.commande_id = lc.commande_id
join produits p on lc.produit_id = p.produit_id
where p.categorie = 'Electronique';

-- Q43 N2 Afficher le CA moyen par commande pour chaque client
select 
    cl.client_id,
    cl.nom,
    round(avg(c.total)::numeric, 2) as ca_moyen_commande
from clients cl
join commandes c on cl.client_id = c.client_id
group by cl.client_id, cl.nom
order by cl.client_id asc;

-- Q44 N2 Afficher les produits vendus en 2023 avec leur categorie et quantité totale
select 
    p.produit_id,
    p.nom,
    p.categorie,
    sum(lc.quantite) as quantite_totale
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
join commandes c on lc.commande_id = c.commande_id
where extract(year from c.date_commande) = 2023
group by p.produit_id, p.nom, p.categorie;

-- Q45 N2 Afficher les clients et le montant total de leurs commandes livrées uniquement

select
	cl.client_id,
	cl.nom,
	sum(c.total) as montant_total_livre
from clients cl
join commandes c on cl.client_id = c.commande_id
group by cl.client_id, cl.nom;

----------------------------------------------- CHAPITRE 4, 5 et 6 -----------------------------------------------------------------------

-- Q46 N2 Afficher les produits dont le prix est superieur au prix moyen de leur categorie (sous requete correlée)
select
	p1.produit_id,
	p1.nom,
	p1.categorie,
	p1.prix
from produits p1
where p1.prix > (
	select AVG(p2.prix)
	from produits p2
	where p2.categorie = p1.categorie
);

-- Q47 N2 Afficher les clients qui n'ont passé aucune commande depuis 2022
select 
    cl.client_id,
    cl.nom
from clients cl
where not exists (
    select 1
    from commandes c
    where c.client_id = cl.client_id
      and c.date_commande >= '2022-01-01'
);

-- Q48 Avec une CTE , calculer le CA par client puis afficher ceux dont le CA dépasse 1000euros
with ca_clients as (
    select 
        c.client_id,
        sum(lc.quantite * lc.prix_unitaire) as chiffre_affaires
    from commandes c
    join ligne_commandes lc on c.commande_id = lc.commande_id
    group by c.client_id
)
select 
    cl.client_id, --
    cl.nom,
    cc.chiffre_affaires
from clients cl
join ca_clients cc on cl.client_id = cc.client_id
where cc.chiffre_affaires > 1000;

-- Q49 Créer une vue v_catalogue affichant nom, categorie, prix et stock de tous les produits en stock 
create or replace view v_catalogue as
select
	nom,
	categorie,
	prix,
	stock
from produits
where stock > 0

-- Q50 Avec une CTE, trouver le mois avec le plus de CA
with ca_par_mois as (
	select
		to_char(date_commande, 'YYYY-MM') as mois,
		sum(total) as chiffre_daffaires
	from commandes
	group by to_char(date_commande, 'YYYY-MM')
)
select
	mois,
	chiffre_daffaires
from ca_par_mois 
order by chiffre_daffaires desc 
limit 1


-- Q51 Afficher les produits commandés par au moins trois clients differents indice COUNT(DISTINCT client_id)
select 
    p.produit_id,
    p.nom,
    count(distinct c.client_id) as nb_clients
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
join commandes c on lc.commande_id = c.commande_id 
group by p.produit_id, p.nom
having count(distinct c.client_id) >= 3;

-- Q52 Avec 2 CTEs CA par categorie, puis afficher uniquement les categories dans le top 3
with ca_par_categorie as (
    select 
        p.categorie,
        sum(lc.quantite * lc.prix_unitaire) as chiffre_affaires
    from produits p
    join ligne_commandes lc on p.produit_id = lc.produit_id
    group by p.categorie
),
top_categories as (
    select 
        categorie,
        chiffre_affaires,
        rank() over (order by chiffre_affaires desc) as rang
    from ca_par_categorie
)
select 
    categorie,
    chiffre_affaires
from top_categories
where rang <= 3;

-- Q53 Créer une vue v_top_clients affichant les 10 clients avec le plus grand nombre de commandes
create or replace view v_top_clients as
	select
		c.client_id,
		c.nom,
		c.email,
		count(co.commande_id) as nombre_commandes
from clients c
join commandes co on c.client_id = co.client_id
group by c.client_id, c.nom, c.email
order by nombre_commandes desc
limit 10;

-- Q54 Afficher les commandes dont le total est superieur a la moyenne des commandes du meme mois INDIC sous requete corelée avec DATE_TRUNC
select 
	commande_id,
	client_id,
	date_commande,
	total
from commandes c1
where total > (
	select AVG(total)
	from commandes c2
	where date_trunc('month', c2.date_commande ) = date_trunc('month', c1.date_commande )
);

-- Q55 Avec une CTE recursive (optionnel avancé) generer une suite de nombre de 1 a 10
with recursive suite as (
	select 1 as n
	
	union all
	
	select n + 1
	from suite
	where n < 10
)
select n
from suite;

-- Q56 afficher les emails des clients en majuscules
select 
    nom,
    upper(email) as email_majuscules
from clients;

-- Q57 Afficher le nom du produit et le domaine de l'email du client dans la meme requete ( join + split part)
select distinct
    p.nom as nom_produit,
    split_part(c.email, '@', 2) as domaine_email
from produits p
join ligne_commandes lc on p.produit_id = lc.produit_id
join commandes co on lc.commande_id = co.commande_id
join clients c on co.client_id = c.client_id;

-- Q58 Afficher les commandes passées un lundi
select 
    commande_id,
    client_id,
    date_commande,
    total
from commandes
where extract(isodow from date_commande) = 1;


-- Q59 Categoriser les produits en 'Pas cher' (<20), 'Raisonnable' (<100) et le reste Cher avec CASE WHEN
select 
    produit_id,
    nom,
    prix,
    case 
        when prix < 20 then 'Pas cher'
        when prix < 100 then 'Raisonnable'
        else 'Cher'
    end as categorie_prix
from produits;



-- Q60 Afficher les clients avec leur ville en remplacant les NULL par ville inconnue
select 
    client_id,
    nom,
    coalesce(ville, 'ville inconnue') as ville
from clients;

-- Q61 Afficher le CA par année et par mois sous le format 'YYYY-MM' indice TO_CHAR
select 
    to_char(date_commande, 'YYYY-MM') as annee_mois,
    sum(total) as chiffre_affaires
from commandes
group by to_char(date_commande, 'YYYY-MM')
order by annee_mois;

-- Q62 Afficher le nombre de jours ecoulés depuis chaque commande indice CURRENT_DATE - date_commande
select 
    commande_id,
    date_commande,
    current_date - date_commande as jours_ecoules
from commandes;

-- Q63 Afficher les produits dont le nom contient un chiffre indice SIMILAR TO ou regexp_match
select 
    produit_id,
    nom,
    prix
from produits
where nom similar to '%[0-9]%';


-- Q64 Afficher le CA total pour les commandes du dernier trimestre Indice DATE_TRUNC et INTERVAL
select 
    sum(total) as ca_dernier_trimestre
from commandes
where date_commande >= (
    select date_trunc('quarter', max(date_commande)) - interval '3 month'
    from commandes
)
  and date_commande < (
    select date_trunc('quarter', max(date_commande))
    from commandes
);

-- Q65 Afficher les initiales de chaque client (premiere lettre du prenom et premiere lettre du nom indice split_part et left)
select 
    client_id,
    nom,
    upper(
        concat(
            left(nom, 1), -- 
            left(split_part(nom, ' ', 2), 1) 
        )
    ) as initiales
from clients;

----------------------------------------------------------- BONUS -------------------------------------------------------

-- B1 — Afficher les produits dont le prix est supérieur au prix moyen de TOUS les produits. Colonnes attendues : nom, categorie, prix
 select 
    nom,
    categorie,
    prix
from produits
where prix > (
    select avg(prix)
    from produits
);

/* B2 — Afficher les clients qui ont passé au moins une commande dont le total est supérieur à 200€.
       Utiliser une sous-requête avec IN. Colonnes attendues : nom, email
*/
select 
    nom,
    email
from clients
where client_id in (
    select client_id
    from commandes
    where total > 200
);

/*
 B3 — Afficher les produits qui n'ont JAMAIS été commandés.
    -  Utiliser une sous-requête avec NOT IN.
    -  Colonnes attendues : nom, categorie, prix
 */

select 
    nom,
    categorie,
    prix
from produits
where produit_id not in (
    select produit_id
    from ligne_commandes
);

-- B4 — Afficher les clients ayant passé plus de commandes que la moyenne du nombre de commandes par client.
--       Utiliser une sous-requête dans le FROM. Colonnes attendues : client_id, nb_commandes
  
select c.client_id, c.nb_commandes
from (
	select client_id, count(*) as nb_commandes
	from commandes
	group by client_id
) c,
(
	select avg(nb_cmd) as moyenne
	from (
		select count(*) as nb_cmd
		from commandes
		group by client_id
	) t
) m
where c.nb_commandes > m.moyenne 





-- B5 — Afficher pour chaque produit son nom, son prix
--       et le nombre de fois qu'il a été commandé.
--       Utiliser une sous-requête dans le SELECT.
--       Colonnes attendues : nom, prix, nb_fois_commande
select
  	nom,
  	prix,
  	(
  		select count(*)
  		from ligne_commandes lc
  		where lc.produit_id = p.produit_id
  	)as nb_fois_commande
from produits p;


-- B6 — Afficher les produits dont le prix est supérieur
--       au prix moyen de leur propre catégorie.
--       (Sous-requête corrélée)
--       Colonnes attendues : nom, categorie, prix
select nom, categorie, prix
from produits p1
where prix > (
	select avg(prix)
	from produits p2
	where p2.categorie  = p1.categorie 

);


-- B7 — Afficher les clients dont le total cumulé de commandes
--       est supérieur au total moyen de tous les clients.
--       Utiliser une sous-requête dans le HAVING.
--       Colonnes attendues : client_id, total_ca

-- Moyenne de tous les clients :
select AVG(total_client)
from (
    select SUM(total) as total_client
    from commandes
    group by client_id
) ;

select 
	client_id,
	sum(total) as total_ca
from commandes
group by client_id 
having sum(total) > (
	select AVG(total_client)
	from (
		select SUM(total) as total_client
		from commandes
		group by client_id
		
	)
);


-- B8 — Avec une CTE, calculer le CA total par client
--       puis afficher uniquement les clients dont le CA dépasse 100€.
--       Colonnes attendues : nom, email, ca_total


-- B9 — Avec deux CTEs enchaînées :
--       CTE 1 : CA total par catégorie
--       CTE 2 : filtrer les catégories avec CA > 200€
--       Afficher les résultats triés par CA décroissant.
--       Colonnes attendues : categorie, ca_total



-- B10 — Avec une CTE, trouver le produit le plus vendu
--        (en quantité totale commandée).
--        Colonnes attendues : nom, categorie, quantite_totale



-- B11 — Avec une CTE, afficher pour chaque mois
--        le CA total et le nombre de commandes.
--        Trier par mois chronologiquement.
--        Colonnes attendues : mois, ca_mensuel, nb_commandes



-- B12 — Avec deux CTEs :
--        CTE 1 : nombre de commandes par client
--        CTE 2 : CA total par client
--        Afficher les clients avec leur nb de commandes ET leur CA total.
--        Trier par CA décroissant.
--        Colonnes attendues : nom, nb_commandes, ca_total
  


-- B13 — Créer une vue v_commandes_details qui affiche pour chaque commande :
--        commande_id, nom du client, date, statut, total, nombre d'articles.
--        Puis l'utiliser pour afficher uniquement les commandes livrées
--        avec plus de 1 article.




-- B14 — Créer une vue v_produits_vendus qui affiche pour chaque produit :
--        nom, categorie, prix, quantite_totale_vendue, ca_genere.
--        Inclure les produits jamais vendus (quantite = 0).
--        Puis afficher les 5 produits ayant généré le plus de CA.



-- B15 — Afficher pour chaque client :
--        son nom en majuscules,
--        son domaine email (partie après le @),
--        le nombre de caractères de son nom.
--        Colonnes attendues : nom_majuscule, domaine_email, longueur_nom




-- B16 — Afficher les clients dont l'email se termine par 'gmail.com',
--        en affichant leur nom en title case (première lettre majuscule)
--        et leur ville avec les espaces de début/fin supprimés.
--        Colonnes attendues : nom_formate, email, ville_nettoyee



-- B17 — Afficher pour chaque commande :
--        la date de commande formatée en 'JJ/MM/AAAA',
--        le jour de la semaine en texte (Lundi, Mardi...),
--        le nombre de jours écoulés depuis la commande.
--        Colonnes attendues : date_formatee, jour_semaine, jours_ecoules
-- Indice pour le jour en texte : TO_CHAR(date_commande, 'Day')






-- B18 — Afficher le CA total par trimestre et par année.
--        Colonnes attendues : annee, trimestre, ca_trimestriel
--        Trier par année et trimestre.
-- Indice : EXTRACT(QUARTER FROM ...) et EXTRACT(YEAR FROM ...)






-- B19 — Afficher chaque produit avec une colonne 'segment' :
--        'Entrée de gamme'  si prix < 20
--        'Milieu de gamme'  si prix entre 20 et 80
--        'Haut de gamme'    si prix > 80
--        Et une colonne 'disponibilite' :
--        'En stock'         si stock > 0
--        'Rupture'          si stock = 0
--        Colonnes attendues : nom, prix, segment, disponibilite





-- B20 — Afficher chaque client avec :
--        sa ville (remplacer NULL par 'Ville non renseignée'),
--        son statut :
--        'Client actif'   s'il a au moins une commande
--        'Sans commande'  sinon
--        Utiliser COALESCE pour la ville et une sous-requête pour le statut.
--        Colonnes attendues : nom, ville_affichee, statut_client


------------------------------------------------------- CHAPITRE 6 WINDOW FUNCTIONS --------------------------------------------------------------

-- EXERCICES — Chapitre 6 : Window Functions


-- Q1 — Classer tous les produits par prix décroissant avec ROW_NUMBER().
--       Colonnes attendues : nom, categorie, prix, rang
select 
    nom, 
    categorie, 
    prix, 
    row_number() over (order by prix desc) as rang
from produits;

-- Q2 — Pour chaque catégorie, classer les produits par prix décroissant
--       avec RANK(). Le classement doit repartir à 1 pour chaque catégorie.
--       Colonnes attendues : nom, categorie, prix, rang_dans_categorie
select 
    nom, 
    categorie, 
    prix, 
    rank() over (partition by categorie order by prix desc) as rang_dans_categorie
from produits;

-- Q3 — Même chose qu'en Q2 mais avec DENSE_RANK() au lieu de RANK().
--       Observer la différence en cas d'ex-aequo.
--       Colonnes attendues : nom, categorie, prix, rang_dense
select
	nom,
	categorie,
	prix,
	dense_rank() over (partition by categorie order by prix desc) as rang_dense
from produits;


-- Q4 — Afficher uniquement le produit le plus cher de chaque catégorie.
--       Utiliser ROW_NUMBER() dans une CTE puis filtrer rang = 1.
--       Colonnes attendues : categorie, nom, prix
-- Indice : WITH cte AS (SELECT ..., ROW_NUMBER() ...) SELECT ... FROM cte WHERE rang = 1
 
with classement_produits as (
	select
		categorie,
		nom,
		prix,
		row_number() over (partition by categorie order by prix desc) as rang
	from produits
)
select
	categorie,
	nom,
	prix
from classement_produits
where rang = 1;



-- Q5 — Classer les commandes par total décroissant avec les trois fonctions
--       ROW_NUMBER(), RANK() et DENSE_RANK() dans la même requête.
--       Observer les différences en cas d'ex-aequo.
--       Colonnes attendues : commande_id, total, rn, rk, dr
select 
    commande_id, 
    total, 
    row_number() over (order by total desc) as rn,
    rank() over (order by total desc) as rk,
    dense_rank() over (order by total desc) as dr
from commandes;	 



  
-- Q6 — Pour chaque commande, afficher le total de la commande précédente
--       (dans l'ordre chronologique).
--       La première ligne doit afficher NULL pour le total précédent.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent
 select 
 	commande_id,
 	date_commande,
 	total,
 	lag(total) over (order by date_commande asc) as total_precedent
 from commandes;	


-- Q7 — Calculer l'évolution en euros entre chaque commande et la précédente.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent, evolution_euros
-- Indice : total - LAG(total) OVER (ORDER BY date_commande)
 select 
 	commande_id,
 	date_commande,
 	total,
 	lag(total) over (order by date_commande asc) as total_precedent,
 	total - lag(total) over (order by date_commande asc) as evolution_euros
from commandes;


-- Q8 — Pour chaque commande, afficher le total de la commande suivante.
--       La dernière ligne doit afficher NULL pour le total suivant.
--       Colonnes attendues : commande_id, date_commande, total, total_suivant
select 
    commande_id, 
    date_commande, 
    total, 
    lead(total) over (order by date_commande asc) as total_suivant
from commandes;



-- Q9 — Pour chaque client, afficher ses commandes avec le total de
--       SA commande précédente (pas celle d'un autre client).
--       Utiliser PARTITION BY client_id.
--       Colonnes attendues : client_id, commande_id, date_commande, total, commande_prec_client
 select 
    client_id, 
    commande_id, 
    date_commande, 
    total, 
    lag(total) over (partition by client_id order by date_commande asc) as commande_prec_client
from commandes;


-- Q10 — Calculer la variation en % entre chaque commande et la précédente.
--        Arrondir à 1 décimale. Remplacer NULL par 0 pour la première ligne.
--        Colonnes attendues : commande_id, date_commande, total, variation_pct
-- Indice : ROUND((total - LAG(total)...) / NULLIF(LAG(total)..., 0) * 100, 1)
--          LAG(total, 1, total) OVER (...) pour éviter le NULL
select 
    commande_id, 
    date_commande, 
    total, 
    coalesce(
        round(
            (total - lag(total) over (order by date_commande asc)) 
            / nullif(lag(total) over (order by date_commande asc), 0) * 100, 
        1), 
        0
    ) as variation_pct
from commandes;



  
-- Q11 — Afficher pour chaque commande son total ET le CA global de toutes
--        les commandes sur la même ligne.
--        Colonnes attendues : commande_id, total, ca_global
 select 
    commande_id, 
    total, 
    sum(total) over () as ca_global
from commandes;


-- Q12 — Calculer le pourcentage que représente chaque commande
--        dans le CA total. Arrondir à 2 décimales.
--        Colonnes attendues : commande_id, total, ca_global, pct_du_total
 select 
    commande_id, 
    total, 
    sum(total) over () as ca_global,
    round(total / sum(total) over () * 100, 2) as pct_du_total
from commandes;


-- Q13 — Pour chaque client, afficher chaque commande avec le CA total
--        de CE client (PARTITION BY client_id).
--        Colonnes attendues : client_id, commande_id, total, ca_total_client
select 
    client_id, 
    commande_id, 
    total, 
    sum(total) over (partition by client_id) as ca_total_client
from commandes;


-- Q14 — Pour chaque commande d'un client, calculer le pourcentage
--        qu'elle représente dans le CA total de ce client.
--        Colonnes attendues : client_id, commande_id, total, ca_total_client, pct_du_client
select 
    client_id, 
    commande_id, 
    total, 
    sum(total) over (partition by client_id) as ca_total_client,
    round(total / sum(total) over (partition by client_id) * 100, 2) as pct_du_client
from commandes;


-- Q15 — Calculer le CA cumulé de toutes les commandes par ordre chronologique.
--        Chaque ligne doit afficher la somme de toutes les commandes
--        depuis la première jusqu'à elle-même.
--        Colonnes attendues : commande_id, date_commande, total, ca_cumule
select 
    commande_id, 
    date_commande, 
    total, 
    sum(total) over (order by date_commande asc) as ca_cumule
from commandes;


-- Q16 — Calculer le CA cumulé PAR CLIENT et par date.
--        Le cumul repart à 0 pour chaque nouveau client.
--        Colonnes attendues : client_id, commande_id, date_commande, total, ca_cumule_client
-- Indice : SUM(total) OVER (PARTITION BY client_id ORDER BY date_commande)
select 
    client_id, 
    commande_id, 
    date_commande, 
    total, 
    sum(total) over (partition by client_id order by date_commande asc) as ca_cumule_client
from commandes; 




-- Q17 — Pour chaque commande, afficher aussi la date de la toute première
--        commande passée (tous clients confondus).
--        Colonnes attendues : commande_id, date_commande, total, premiere_commande_globale
 select 
    commande_id, 
    date_commande, 
    total, 
    min(date_commande) over () as premiere_commande_globale
from commandes;


-- Q18 — Pour chaque client, afficher sur chaque commande
--        la date de sa première commande et la date de sa dernière commande.
--        Colonnes attendues : client_id, commande_id, date_commande, premiere, derniere
-- Indice : LAST_VALUE nécessite ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
select 
    client_id, 
    commande_id, 
    date_commande, 
    min(date_commande) over (partition by client_id) as premiere,
    last_value(date_commande) over (
        partition by client_id 
        order by date_commande asc 
        rows between unbounded preceding and unbounded following
    ) as derniere
from commandes; 


-- Q19 — Diviser les produits en 4 quartiles selon leur prix.
--        Quartile 1 = produits les moins chers, 4 = les plus chers.
--        Colonnes attendues : nom, categorie, prix, quartile
 select 
    nom, 
    categorie, 
    prix, 
    ntile(4) over (order by prix asc) as quartile
from produits;


-- Q20 — Diviser les commandes en 3 groupes égaux selon leur total.
--        Groupe 1 = commandes les moins élevées, 3 = les plus élevées.
--        Colonnes attendues : commande_id, total, groupe
 select 
    commande_id, 
    total, 
    ntile(3) over (order by total asc) as groupe
from commandes;

  
-- Q21 — Classer les clients par CA total décroissant avec DENSE_RANK().
--        Utiliser une CTE pour calculer d'abord le CA par client.
--        Colonnes attendues : nom, ca_total, rang
with ca_par_client as (
    select 
        c.nom, 
        sum(cmd.total) as ca_total
    from clients c
    join commandes cmd on c.client_id = cmd.client_id
    group by c.client_id, c.nom
)
select 
    nom, 
    ca_total, 
    dense_rank() over (order by ca_total desc) as rang
from ca_par_client;


-- Q22 — Calculer le CA mensuel et la variation en % par rapport
--        au mois précédent. Utiliser une CTE + LAG.
--        Colonnes attendues : mois, ca_mensuel, ca_precedent, variation_pct
-- Indice : DATE_TRUNC('month', date_commande) pour grouper par mois
with ca_mensuel as (
    select 
        date_trunc('month', date_commande) as mois,
        sum(total) as ca_mensuel
    from commandes
    group by date_trunc('month', date_commande)
)
select 
    mois, 
    ca_mensuel, 
    lag(ca_mensuel) over (order by mois asc) as ca_precedent,
    round(
        (ca_mensuel - lag(ca_mensuel) over (order by mois asc)) 
        / nullif(lag(ca_mensuel) over (order by mois asc), 0) * 100, 
        2
    ) as variation_pct
from ca_mensuel;


-- Q23 — Pour chaque produit vendu, afficher la quantité commandée
--        et la quantité cumulée depuis le début (par produit).
--        Jointure lignes_commande + produits + commandes nécessaire.
--        Colonnes attendues : produit, date_commande, quantite, quantite_cumulee
with ventes_produits as (
    select 
        p.nom as produit,
        cmd.date_commande,
        lc.quantite
    from produits p
    join ligne_commandes lc on p.produit_id = lc.produit_id
    join commandes cmd on lc.commande_id = cmd.commande_id
)
select 
    produit, 
    date_commande, 
    quantite, 
    sum(quantite) over (partition by produit order by date_commande asc) as quantite_cumulee
from ventes_produits;


-- Q24 — Identifier la première et la dernière commande de chaque client
--        en une seule requête. Afficher une ligne par client.
--        Colonnes attendues : nom, premiere_commande, derniere_commande, nb_commandes
-- Indice : DISTINCT + FIRST_VALUE + LAST_VALUE + COUNT OVER (PARTITION BY)
select distinct 
    c.nom,
    first_value(cmd.commande_id) over (
        partition by c.client_id 
        order by cmd.date_commande asc 
        rows between unbounded preceding and unbounded following
    ) as premiere_commande,
    last_value(cmd.commande_id) over (
        partition by c.client_id 
        order by cmd.date_commande asc 
        rows between unbounded preceding and unbounded following
    ) as derniere_commande,
    count(cmd.commande_id) over (
        partition by c.client_id
    ) as nb_commandes
from clients c
join commandes cmd on c.client_id = cmd.client_id;


-- Q25 — Pour chaque commande, afficher :
--        - son total
--        - le total de la commande précédente (LAG)
--        - le CA cumulé jusqu'à cette commande (SUM OVER ORDER BY)
--        - son rang parmi toutes les commandes (RANK par total décroissant)
--        Colonnes attendues : commande_id, date_commande, total,
--                             total_prec, ca_cumule, rang_total
select 
    commande_id as commande_id, 
    date_commande, 
    total, 
    lag(total) over (order by date_commande asc) as total_prec,
    sum(total) over (order by date_commande asc) as ca_cumule,
    rank() over (order by total desc) as rang_total
from commandes;













