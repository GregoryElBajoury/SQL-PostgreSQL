--
-- PostgreSQL database dump
--

\restrict Lmei2spMH9p1FtpR8YyOoLN4NCdNau9zkCDVK6QtQnDhpoOhDnFqyuR23ZNA7OZ

-- Dumped from database version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

-- Started on 2026-07-28 19:10:13 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16827)
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    client_id integer NOT NULL,
    nom character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    ville character varying(100),
    pays character varying(50) DEFAULT 'France'::character varying,
    date_inscription date
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16826)
-- Name: clients_client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_client_id_seq OWNER TO postgres;

--
-- TOC entry 3473 (class 0 OID 0)
-- Dependencies: 215
-- Name: clients_client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_client_id_seq OWNED BY public.clients.client_id;


--
-- TOC entry 218 (class 1259 OID 16837)
-- Name: commandes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commandes (
    commande_id integer NOT NULL,
    client_id integer,
    date_commande date NOT NULL,
    statut character varying(50) DEFAULT 'en_attente'::character varying,
    total numeric(10,2),
    CONSTRAINT chk_commande_statut CHECK (((statut)::text = ANY ((ARRAY['en_attente'::character varying, 'expedie'::character varying, 'livre'::character varying, 'annule'::character varying])::text[])))
);


ALTER TABLE public.commandes OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16836)
-- Name: commandes_commande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commandes_commande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commandes_commande_id_seq OWNER TO postgres;

--
-- TOC entry 3475 (class 0 OID 0)
-- Dependencies: 217
-- Name: commandes_commande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commandes_commande_id_seq OWNED BY public.commandes.commande_id;


--
-- TOC entry 222 (class 1259 OID 16858)
-- Name: ligne_commandes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ligne_commandes (
    ligne_id integer NOT NULL,
    commande_id integer,
    produit_id integer,
    quantite integer NOT NULL,
    prix_unitaire numeric(10,2) NOT NULL,
    CONSTRAINT chk_ligne_commande_prix_positif CHECK ((prix_unitaire > (0)::numeric)),
    CONSTRAINT chk_ligne_commandes_quantite_positive CHECK ((quantite > 0))
);


ALTER TABLE public.ligne_commandes OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16857)
-- Name: ligne_commandes_ligne_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ligne_commandes_ligne_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ligne_commandes_ligne_id_seq OWNER TO postgres;

--
-- TOC entry 3477 (class 0 OID 0)
-- Dependencies: 221
-- Name: ligne_commandes_ligne_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ligne_commandes_ligne_id_seq OWNED BY public.ligne_commandes.ligne_id;


--
-- TOC entry 220 (class 1259 OID 16850)
-- Name: produits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produits (
    produit_id integer NOT NULL,
    nom character varying(150) NOT NULL,
    categorie character varying(100),
    prix numeric(10,2) NOT NULL,
    stock integer DEFAULT 0,
    CONSTRAINT chk_produit_prix_positif CHECK ((prix > (0)::numeric)),
    CONSTRAINT chk_produit_stock_positif CHECK ((stock >= 0))
);


ALTER TABLE public.produits OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16849)
-- Name: produits_produit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produits_produit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produits_produit_id_seq OWNER TO postgres;

--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 219
-- Name: produits_produit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produits_produit_id_seq OWNED BY public.produits.produit_id;


--
-- TOC entry 223 (class 1259 OID 16876)
-- Name: v_catalogue; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_catalogue AS
 SELECT nom,
    categorie,
    prix,
    stock
   FROM public.produits
  WHERE (stock > 0);


ALTER VIEW public.v_catalogue OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16880)
-- Name: v_top_clients; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_top_clients AS
 SELECT c.client_id,
    c.nom,
    c.email,
    count(co.commande_id) AS nombre_commandes
   FROM (public.clients c
     JOIN public.commandes co ON ((c.client_id = co.client_id)))
  GROUP BY c.client_id, c.nom, c.email
  ORDER BY (count(co.commande_id)) DESC
 LIMIT 10;


ALTER VIEW public.v_top_clients OWNER TO postgres;

--
-- TOC entry 3281 (class 2604 OID 16830)
-- Name: clients client_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN client_id SET DEFAULT nextval('public.clients_client_id_seq'::regclass);


--
-- TOC entry 3283 (class 2604 OID 16840)
-- Name: commandes commande_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commandes ALTER COLUMN commande_id SET DEFAULT nextval('public.commandes_commande_id_seq'::regclass);


--
-- TOC entry 3287 (class 2604 OID 16861)
-- Name: ligne_commandes ligne_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commandes ALTER COLUMN ligne_id SET DEFAULT nextval('public.ligne_commandes_ligne_id_seq'::regclass);


--
-- TOC entry 3285 (class 2604 OID 16853)
-- Name: produits produit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produits ALTER COLUMN produit_id SET DEFAULT nextval('public.produits_produit_id_seq'::regclass);


--
-- TOC entry 3459 (class 0 OID 16827)
-- Dependencies: 216
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (client_id, nom, email, ville, pays, date_inscription) FROM stdin;
1	Alice Martin	alice.martin@gmail.com	Paris	France	2021-03-15
2	Bob Dupont	bob.dupont@yahoo.fr	Lyon	France	2021-07-22
3	Claire Moreau	claire.moreau@gmail.com	Marseille	France	2022-01-10
4	David Bernard	david.bernard@outlook.com	Paris	France	2022-04-05
5	Emma Petit	emma.petit@gmail.com	Bordeaux	France	2022-06-18
6	François Leroy	francois.leroy@free.fr	Nantes	France	2022-09-30
7	Grace Roux	grace.roux@gmail.com	Lille	France	2023-01-12
8	Hugo Simon	hugo.simon@hotmail.com	Paris	France	2023-02-28
9	Isabelle Faure	isabelle.faure@gmail.com	\N	France	2023-05-14
10	Jules Garcia	jules.garcia@gmail.com	Toulouse	France	2023-07-01
11	Karla Muller	karla.muller@gmail.com	Strasbourg	France	2023-08-20
12	Luc Bonnet	luc.bonnet@yahoo.fr	Lyon	France	2021-11-03
13	Marie Chevalier	marie.chevalier@gmail.com	Nantes	France	2022-12-25
14	Nicolas Morel	nicolas.morel@outlook.com	\N	France	2023-03-17
15	Olivia Laurent	olivia.laurent@gmail.com	Paris	France	2021-05-09
16	Paul Mercier	paul.mercier@free.fr	Bordeaux	France	2022-08-14
17	Quentin Blanc	quentin.blanc@gmail.com	Marseille	France	2023-09-05
18	Rachel Guerin	rachel.guerin@hotmail.com	Lyon	France	2021-12-31
19	Samuel Robin	samuel.robin@gmail.com	Paris	France	2022-03-22
20	Théa Fontaine	thea.fontaine@gmail.com	Lille	France	2023-10-08
\.


--
-- TOC entry 3461 (class 0 OID 16837)
-- Dependencies: 218
-- Data for Name: commandes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commandes (commande_id, client_id, date_commande, statut, total) FROM stdin;
1	1	2023-01-05	livre	358.98
2	1	2023-04-20	livre	89.99
3	2	2023-01-15	livre	54.98
4	2	2023-06-10	expedie	119.98
5	3	2023-02-01	livre	29.99
6	4	2023-02-14	livre	139.98
7	4	2023-07-22	livre	49.99
8	5	2023-03-08	annule	79.99
9	6	2023-03-15	livre	34.99
10	7	2023-04-01	livre	94.97
11	8	2023-04-18	expedie	59.99
12	9	2023-05-02	en_attente	22.99
13	10	2023-05-20	livre	169.97
14	11	2023-06-05	livre	44.99
15	12	2023-06-25	livre	89.98
16	13	2023-07-10	livre	34.99
17	14	2023-07-30	expedie	109.98
18	15	2023-08-12	livre	79.99
19	16	2023-08-28	livre	54.97
20	17	2023-09-05	annule	89.99
21	18	2023-09-22	livre	129.98
22	19	2023-10-08	livre	39.99
23	20	2023-10-25	expedie	69.98
24	1	2023-11-11	livre	199.97
25	3	2023-11-20	livre	74.98
26	5	2023-12-01	livre	124.98
27	7	2023-12-15	en_attente	44.99
28	10	2022-11-05	livre	59.99
29	12	2022-12-20	livre	34.98
30	15	2022-08-14	livre	89.99
\.


--
-- TOC entry 3465 (class 0 OID 16858)
-- Dependencies: 222
-- Data for Name: ligne_commandes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ligne_commandes (ligne_id, commande_id, produit_id, quantite, prix_unitaire) FROM stdin;
1	1	1	1	349.99
2	1	2	1	8.99
3	2	3	1	79.99
4	3	2	2	8.99
5	3	15	1	9.99
6	4	3	1	79.99
7	4	4	1	34.99
8	5	21	1	29.99
9	6	7	1	29.99
10	6	8	1	89.99
11	7	12	1	49.99
12	8	3	1	79.99
13	9	4	1	34.99
14	10	5	1	19.99
15	10	17	1	24.99
16	10	19	1	12.99
17	11	9	1	59.99
18	12	22	1	22.99
19	13	3	1	79.99
20	13	4	1	34.99
21	13	5	1	19.99
22	14	23	1	44.99
23	15	11	2	19.99
24	15	15	1	9.99
25	16	16	1	34.99
26	17	10	1	24.99
27	17	9	1	59.99
28	18	14	1	79.99
29	19	20	2	7.99
30	19	15	1	9.99
31	19	22	1	22.99
32	20	13	1	89.99
33	21	7	1	29.99
34	21	10	1	24.99
35	22	18	1	39.99
36	23	4	1	34.99
37	23	5	1	19.99
38	24	6	1	45.99
39	24	3	1	79.99
40	24	20	2	7.99
41	25	24	1	35.99
42	25	25	1	19.99
43	26	13	1	89.99
44	26	15	1	9.99
45	27	19	1	12.99
46	28	9	1	59.99
47	29	2	2	8.99
48	30	3	1	79.99
\.


--
-- TOC entry 3463 (class 0 OID 16850)
-- Dependencies: 220
-- Data for Name: produits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produits (produit_id, nom, categorie, prix, stock) FROM stdin;
1	Smartphone Galaxy A54	Electronique	349.99	25
2	Cable USB-C 2m	Electronique	8.99	150
3	Casque Bluetooth Pro	Electronique	79.99	40
4	Chargeur rapide 65W	Electronique	34.99	80
5	Clé USB 128Go	Electronique	19.99	60
6	Laptop Stand aluminium	Informatique	45.99	35
7	Souris ergonomique sans fil	Informatique	29.99	55
8	Clavier mécanique RGB	Informatique	89.99	20
9	Webcam HD 1080p	Informatique	59.99	30
10	Hub USB 7 ports	Informatique	24.99	45
11	T-shirt coton bio	Vetements	19.99	100
12	Jean slim stretch	Vetements	49.99	60
13	Veste imperméable	Vetements	89.99	25
14	Baskets running	Vetements	79.99	40
15	Chaussettes lot x5	Vetements	9.99	200
16	Livre Python avancé	Livres	34.99	15
17	Livre SQL pour débutants	Livres	24.99	20
18	Livre Data Engineering	Livres	39.99	10
19	Agenda 2024	Livres	12.99	50
20	Cahier A5 lot x3	Livres	7.99	80
21	Cafetière à piston	Maison	29.99	30
22	Gourde isotherme 500ml	Maison	22.99	70
23	Lampe de bureau LED	Maison	44.99	25
24	Coussin ergonomique	Maison	35.99	20
25	Tapis de bureau XL	Maison	19.99	40
\.


--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 215
-- Name: clients_client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_client_id_seq', 20, true);


--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 217
-- Name: commandes_commande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commandes_commande_id_seq', 30, true);


--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 221
-- Name: ligne_commandes_ligne_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ligne_commandes_ligne_id_seq', 48, true);


--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 219
-- Name: produits_produit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produits_produit_id_seq', 25, true);


--
-- TOC entry 3294 (class 2606 OID 16835)
-- Name: clients clients_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_email_key UNIQUE (email);


--
-- TOC entry 3296 (class 2606 OID 16833)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);


--
-- TOC entry 3298 (class 2606 OID 16843)
-- Name: commandes commandes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_pkey PRIMARY KEY (commande_id);


--
-- TOC entry 3309 (class 2606 OID 16863)
-- Name: ligne_commandes ligne_commandes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commandes
    ADD CONSTRAINT ligne_commandes_pkey PRIMARY KEY (ligne_id);


--
-- TOC entry 3305 (class 2606 OID 16856)
-- Name: produits produits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produits
    ADD CONSTRAINT produits_pkey PRIMARY KEY (produit_id);


--
-- TOC entry 3299 (class 1259 OID 16885)
-- Name: idx_commandes_client_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_commandes_client_id ON public.commandes USING btree (client_id);


--
-- TOC entry 3300 (class 1259 OID 16886)
-- Name: idx_commandes_date_commande; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_commandes_date_commande ON public.commandes USING btree (date_commande);


--
-- TOC entry 3301 (class 1259 OID 16891)
-- Name: idx_commandes_livre_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_commandes_livre_date ON public.commandes USING btree (date_commande) WHERE ((statut)::text = 'livre'::text);


--
-- TOC entry 3302 (class 1259 OID 16887)
-- Name: idx_commandes_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_commandes_status ON public.commandes USING btree (statut);


--
-- TOC entry 3306 (class 1259 OID 16889)
-- Name: idx_ligne_commandes_commande_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ligne_commandes_commande_id ON public.ligne_commandes USING btree (commande_id);


--
-- TOC entry 3307 (class 1259 OID 16888)
-- Name: idx_ligne_commandes_produit_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ligne_commandes_produit_id ON public.ligne_commandes USING btree (produit_id);


--
-- TOC entry 3303 (class 1259 OID 16890)
-- Name: idx_produits_categorie; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produits_categorie ON public.produits USING btree (categorie);


--
-- TOC entry 3310 (class 2606 OID 16844)
-- Name: commandes fk_client; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES public.clients(client_id);


--
-- TOC entry 3311 (class 2606 OID 16864)
-- Name: ligne_commandes fk_commande; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commandes
    ADD CONSTRAINT fk_commande FOREIGN KEY (commande_id) REFERENCES public.commandes(commande_id);


--
-- TOC entry 3312 (class 2606 OID 16869)
-- Name: ligne_commandes fk_produit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commandes
    ADD CONSTRAINT fk_produit FOREIGN KEY (produit_id) REFERENCES public.produits(produit_id);


--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO ecommerce_readonly;
GRANT USAGE ON SCHEMA public TO ecommerce_engineer;


--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE clients; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.clients TO ecommerce_readonly;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.clients TO ecommerce_engineer;


--
-- TOC entry 3474 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE commandes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.commandes TO ecommerce_readonly;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.commandes TO ecommerce_engineer;


--
-- TOC entry 3476 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE ligne_commandes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.ligne_commandes TO ecommerce_readonly;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ligne_commandes TO ecommerce_engineer;


--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE produits; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.produits TO ecommerce_readonly;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.produits TO ecommerce_engineer;


--
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE v_catalogue; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.v_catalogue TO ecommerce_readonly;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.v_catalogue TO ecommerce_engineer;


--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE v_top_clients; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.v_top_clients TO ecommerce_readonly;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.v_top_clients TO ecommerce_engineer;


--
-- TOC entry 2061 (class 826 OID 16715)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES TO ecommerce_readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO ecommerce_engineer;


-- Completed on 2026-07-28 19:10:13 CEST

--
-- PostgreSQL database dump complete
--

\unrestrict Lmei2spMH9p1FtpR8YyOoLN4NCdNau9zkCDVK6QtQnDhpoOhDnFqyuR23ZNA7OZ

