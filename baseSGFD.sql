CREATE SCHEMA IF NOT EXISTS "public";

CREATE SEQUENCE categoriequestion_idcategoriequestion_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE demande_iddemande_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE documentsupplementaire_iddocumentsupplementaire_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE failed_jobs_id_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE formulaire_idformulaire_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE migrations_id_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE notifications_idnotification_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE operateur_idoperateur_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE operateurcible_idoperateurcible_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE operateurinformation_idoperateurinformation_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE personal_access_tokens_id_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE question_idquestion_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE regime_idregime_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE renouvellement_idrenouvellement_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE reponseformulaire_idreponseformulaire_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sensibilisation_idsensibilisation_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE structurejuridique_idstructurejuridique_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE typeformulaire_idtypeformulaire_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE typequestion_idtypequestion_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE users_id_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE ville_idville_seq AS integer START WITH 1 INCREMENT BY 1;

CREATE  TABLE categoriequestion (
	idcategoriequestion  serial  NOT NULL  ,
	nom                  varchar(200)  NOT NULL  ,
	nombrereponses       integer DEFAULT 1   ,
	CONSTRAINT categoriequestion_pkey PRIMARY KEY ( idcategoriequestion )
 );

CREATE  TABLE failed_jobs (
	id                   bigserial  NOT NULL  ,
	uuid                 varchar(255)  NOT NULL  ,
	"connection"         text  NOT NULL  ,
	queue                text  NOT NULL  ,
	payload              text  NOT NULL  ,
	"exception"          text  NOT NULL  ,
	failed_at            timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	CONSTRAINT failed_jobs_pkey PRIMARY KEY ( id ),
	CONSTRAINT failed_jobs_uuid_unique UNIQUE ( uuid )
 );

CREATE  TABLE migrations (
	id                   serial  NOT NULL  ,
	migration            varchar(255)  NOT NULL  ,
	batch                integer  NOT NULL  ,
	CONSTRAINT migrations_pkey PRIMARY KEY ( id )
 );

CREATE  TABLE password_reset_tokens (
	email                varchar(255)  NOT NULL  ,
	token                varchar(255)  NOT NULL  ,
	created_at           timestamp(0)    ,
	CONSTRAINT password_reset_tokens_pkey PRIMARY KEY ( email )
 );

CREATE  TABLE personal_access_tokens (
	id                   bigserial  NOT NULL  ,
	tokenable_type       varchar(255)  NOT NULL  ,
	tokenable_id         bigint  NOT NULL  ,
	name                 varchar(255)  NOT NULL  ,
	token                varchar(64)  NOT NULL  ,
	abilities            text    ,
	last_used_at         timestamp(0)    ,
	expires_at           timestamp(0)    ,
	created_at           timestamp(0)    ,
	updated_at           timestamp(0)    ,
	CONSTRAINT personal_access_tokens_pkey PRIMARY KEY ( id ),
	CONSTRAINT personal_access_tokens_token_unique UNIQUE ( token )
 );

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON personal_access_tokens USING  btree ( tokenable_type, tokenable_id );

CREATE  TABLE regime (
	idregime             serial  NOT NULL  ,
	nom                  varchar(200)  NOT NULL  ,
	CONSTRAINT regime_pkey PRIMARY KEY ( idregime )
 );

CREATE  TABLE structurejuridique (
	idstructurejuridique serial  NOT NULL  ,
	nom                  varchar(200)  NOT NULL  ,
	CONSTRAINT structurejuridique_pkey PRIMARY KEY ( idstructurejuridique )
 );

CREATE  TABLE typeformulaire (
	idtypeformulaire     serial  NOT NULL  ,
	nom                  varchar(200)  NOT NULL  ,
	description          varchar(200)  NOT NULL  ,
	status               integer DEFAULT 0   ,
	image                varchar    ,
	anneevalidite        integer    ,
	idregime             integer    ,
	CONSTRAINT typeformulaire_pkey PRIMARY KEY ( idtypeformulaire )
 );

CREATE  TABLE typequestion (
	idtypequestion       serial  NOT NULL  ,
	nom                  varchar(200)  NOT NULL  ,
	designation          varchar(200)  NOT NULL  ,
	CONSTRAINT typequestion_pkey PRIMARY KEY ( idtypequestion )
 );

CREATE  TABLE users (
	id                   bigserial  NOT NULL  ,
	name                 varchar(255)  NOT NULL  ,
	email                varchar(255)  NOT NULL  ,
	email_verified_at    timestamp(0)    ,
	"password"           varchar(255)  NOT NULL  ,
	status               varchar DEFAULT 'user'::character varying NOT NULL  ,
	remember_token       varchar(100)    ,
	created_at           timestamp(0)    ,
	updated_at           timestamp(0)    ,
	CONSTRAINT users_pkey PRIMARY KEY ( id ),
	CONSTRAINT users_email_unique UNIQUE ( email )
 );
ALTER TABLE users ADD CONSTRAINT users_status_check CHECK ( ((status)::text = ANY ((ARRAY['admin'::character varying, 'user'::character varying])::text[])) );

CREATE  TABLE ville (
	idville              serial  NOT NULL  ,
	nom                  varchar(200)  NOT NULL  ,
	CONSTRAINT ville_pkey PRIMARY KEY ( idville )
 );

CREATE  TABLE formulaire (
	idformulaire         serial  NOT NULL  ,
	idtypeformulaire     integer    ,
	nom                  varchar(200)  NOT NULL  ,
	datecreation         date DEFAULT CURRENT_DATE   ,
	CONSTRAINT formulaire_pkey PRIMARY KEY ( idformulaire )
 );

CREATE  TABLE operateur (
	idoperateur          serial  NOT NULL  ,
	id                   integer  NOT NULL  ,
	nom                  varchar(200)    ,
	CONSTRAINT operateur_pkey PRIMARY KEY ( idoperateur )
 );

CREATE  TABLE operateurcible (
	idoperateurcible     serial  NOT NULL  ,
	nom                  varchar(200)  NOT NULL  ,
	email                varchar(200)  NOT NULL  ,
	idville              integer  NOT NULL  ,
	status               integer DEFAULT 0   ,
	adresse              varchar(200)    ,
	idregime             integer    ,
	CONSTRAINT operateurcible_pkey PRIMARY KEY ( idoperateurcible )
 );

CREATE  TABLE operateurinformation (
	idoperateurinformation serial  NOT NULL  ,
	idoperateur          integer    ,
	adresse              varchar(200)    ,
	idville              integer    ,
	telephone            varchar(200)    ,
	telecopie            varchar(200)    ,
	email                varchar(200)    ,
	idstructurejuridique integer    ,
	CONSTRAINT operateurinformation_pkey PRIMARY KEY ( idoperateurinformation )
 );

CREATE  TABLE question (
	idquestion           serial  NOT NULL  ,
	idformulaire         integer    ,
	textquestion         varchar(300)  NOT NULL  ,
	idtypequestion       integer    ,
	idcategoriequestion  integer    ,
	questionobligatoire  boolean DEFAULT false   ,
	CONSTRAINT question_pkey PRIMARY KEY ( idquestion )
 );

CREATE  TABLE sensibilisation (
	idsensibilisation    serial  NOT NULL  ,
	idoperateurcible     integer    ,
	status               integer    ,
	idoperateur          integer    ,
	datesensibilisation  timestamp  NOT NULL  ,
	dateconversion       timestamp    ,
	CONSTRAINT sensibilisation_pkey PRIMARY KEY ( idsensibilisation )
 );

CREATE  TABLE demande (
	iddemande            serial  NOT NULL  ,
	datedeclaration      timestamp    ,
	dateexpiration       timestamp    ,
	status               integer    ,
	idoperateurinformation integer    ,
	idformulaire         integer    ,
	datedemande          timestamp DEFAULT CURRENT_TIMESTAMP   ,
	idrenouvellement     integer    ,
	CONSTRAINT demande_pkey PRIMARY KEY ( iddemande )
 );

CREATE  TABLE documentsupplementaire (
	iddocumentsupplementaire serial  NOT NULL  ,
	iddemande            integer    ,
	filereponse          varchar(300)    ,
	nom                  varchar(200)    ,
	CONSTRAINT documentsupplementaire_pkey PRIMARY KEY ( iddocumentsupplementaire )
 );

CREATE  TABLE notifications (
	idnotification       serial  NOT NULL  ,
	id                   integer  NOT NULL  ,
	message              text  NOT NULL  ,
	"type"               varchar(255)    ,
	lue                  boolean DEFAULT false   ,
	created_at           timestamp DEFAULT CURRENT_TIMESTAMP   ,
	updated_at           timestamp DEFAULT CURRENT_TIMESTAMP   ,
	iddemande            integer    ,
	renouvellement       boolean DEFAULT false   ,
	CONSTRAINT notifications_pkey PRIMARY KEY ( idnotification )
 );

CREATE  TABLE renouvellement (
	idrenouvellement     serial  NOT NULL  ,
	idtypeformulaire     integer  NOT NULL  ,
	created_at           timestamp DEFAULT CURRENT_TIMESTAMP   ,
	iddemande            integer    ,
	idoperateur          integer    ,
	datenotification     timestamp    ,
	CONSTRAINT renouvellement_pkey PRIMARY KEY ( idrenouvellement )
 );

CREATE  TABLE reponseformulaire (
	idreponseformulaire  serial  NOT NULL  ,
	idquestion           integer    ,
	iddemande            integer    ,
	textereponse         varchar(300)    ,
	nombrereponse        numeric(20)    ,
	filereponse          varchar(300)    ,
	CONSTRAINT reponseformulaire_pkey PRIMARY KEY ( idreponseformulaire )
 );

ALTER TABLE demande ADD CONSTRAINT fk_demande_renouvellement FOREIGN KEY ( idrenouvellement ) REFERENCES renouvellement( idrenouvellement );

ALTER TABLE demande ADD CONSTRAINT fk_demande_formulaire FOREIGN KEY ( idformulaire ) REFERENCES formulaire( idformulaire );

ALTER TABLE demande ADD CONSTRAINT fk_demande_operateurinformation FOREIGN KEY ( idoperateurinformation ) REFERENCES operateurinformation( idoperateurinformation );

ALTER TABLE documentsupplementaire ADD CONSTRAINT documentsupplementaire_iddemande_fkey FOREIGN KEY ( iddemande ) REFERENCES demande( iddemande );

ALTER TABLE formulaire ADD CONSTRAINT formulaire_idtypeformulaire_fkey FOREIGN KEY ( idtypeformulaire ) REFERENCES typeformulaire( idtypeformulaire );

ALTER TABLE notifications ADD CONSTRAINT fk_notifications_demande FOREIGN KEY ( iddemande ) REFERENCES demande( iddemande );

ALTER TABLE notifications ADD CONSTRAINT notifications_id_fkey FOREIGN KEY ( id ) REFERENCES users( id );

ALTER TABLE operateur ADD CONSTRAINT operateur_id_fkey FOREIGN KEY ( id ) REFERENCES users( id );

ALTER TABLE operateurcible ADD CONSTRAINT fk_operateurcible_regime FOREIGN KEY ( idregime ) REFERENCES regime( idregime ) ON DELETE SET NULL;

ALTER TABLE operateurcible ADD CONSTRAINT operateurcible_idville_fkey FOREIGN KEY ( idville ) REFERENCES ville( idville );

ALTER TABLE operateurinformation ADD CONSTRAINT operateurinformation_idstructurejuridique_fkey FOREIGN KEY ( idstructurejuridique ) REFERENCES structurejuridique( idstructurejuridique );

ALTER TABLE operateurinformation ADD CONSTRAINT operateurinformation_idville_fkey FOREIGN KEY ( idville ) REFERENCES ville( idville );

ALTER TABLE operateurinformation ADD CONSTRAINT operateurinformation_idoperateur_fkey FOREIGN KEY ( idoperateur ) REFERENCES operateur( idoperateur );

ALTER TABLE question ADD CONSTRAINT fk_question_categoriequestion FOREIGN KEY ( idcategoriequestion ) REFERENCES categoriequestion( idcategoriequestion );

ALTER TABLE question ADD CONSTRAINT question_idformulaire_fkey FOREIGN KEY ( idformulaire ) REFERENCES formulaire( idformulaire );

ALTER TABLE question ADD CONSTRAINT question_idtypequestion_fkey FOREIGN KEY ( idtypequestion ) REFERENCES typequestion( idtypequestion );

ALTER TABLE renouvellement ADD CONSTRAINT fk_renouvellement_demande FOREIGN KEY ( iddemande ) REFERENCES demande( iddemande );

ALTER TABLE renouvellement ADD CONSTRAINT fk_renouvellement_operateur FOREIGN KEY ( idoperateur ) REFERENCES operateur( idoperateur );

ALTER TABLE renouvellement ADD CONSTRAINT renouvellement_idtypeformulaire_fkey FOREIGN KEY ( idtypeformulaire ) REFERENCES typeformulaire( idtypeformulaire );

ALTER TABLE reponseformulaire ADD CONSTRAINT reponseformulaire_idquestion_fkey FOREIGN KEY ( idquestion ) REFERENCES question( idquestion );

ALTER TABLE reponseformulaire ADD CONSTRAINT reponseformulaire_iddemande_fkey FOREIGN KEY ( iddemande ) REFERENCES demande( iddemande );

ALTER TABLE sensibilisation ADD CONSTRAINT fk_sensibilisation_operateur FOREIGN KEY ( idoperateur ) REFERENCES operateur( idoperateur );

ALTER TABLE typeformulaire ADD CONSTRAINT fk_typeformulaire_regime FOREIGN KEY ( idregime ) REFERENCES regime( idregime );

CREATE VIEW demandeDetails AS
SELECT
    d.iddemande,
    d.datedemande,
    d.datedeclaration,
    d.dateexpiration,
    d.status,
    d.idoperateurinformation,
    d.idrenouvellement,
    oi.email,
    o.idoperateur AS idoperateur,
    o.nom AS nomoperateur,
    t.idtypeformulaire AS idtypeformulaire,
    t.anneevalidite AS anneevalidite,
    t.nom AS nomTypeFormulaire,
    t.description AS descriptionTypeFormulaire,
    v.nom AS nomVille,
    r.nom AS nomRegime,
    CASE
        WHEN d.idrenouvellement IS NOT NULL THEN 'Renouvellement'
        ELSE 'Déclaration'
    END AS typedemande
FROM
    demande d
JOIN
    operateurinformation oi ON d.idoperateurinformation = oi.idoperateurinformation
JOIN ville v ON oi.idville = v.idville
JOIN
    operateur o ON oi.idoperateur = o.idoperateur
JOIN formulaire f ON d.idformulaire = f.idformulaire
JOIN typeFormulaire t ON f.idTypeFormulaire = t.idTypeFormulaire
JOIN regime r ON t.idRegime = r.idregime;



CREATE OR REPLACE VIEW FormulaireDetails AS
SELECT
    f.idFormulaire,
    f.nom AS nomFormulaire,
	f.datecreation AS datecreation,
    f.idtypeformulaire,
    tf.nom AS nomTypeFormulaire,
    tf.description AS descriptionTypeFormulaire,
    tf.image AS image,
    tf.anneeValidite AS anneeValidite,
    r.idregime AS idregime,
    r.nom AS nomRegime,
    q.idQuestion,
    q.textQuestion,
    tq.idtypequestion AS idtypequestion,
    tq.nom AS typeQuestion,
    tq.designation AS designationTypeQuestion,
    q.questionobligatoire,
    cq.idcategoriequestion AS idcategoriequestion,
    cq.nom AS categorieQuestion,
    cq.nombrereponses AS nombreReponses
FROM
    formulaire f
JOIN
    typeFormulaire tf ON f.idTypeFormulaire = tf.idTypeFormulaire
JOIN
    regime r ON tf.idRegime = r.idregime
JOIN
    question q ON q.idFormulaire = f.idFormulaire
JOIN
    typeQuestion tq ON q.idTypeQuestion = tq.idTypeQuestion
JOIN
    categorieQuestion cq ON q.idCategorieQuestion = cq.idCategorieQuestion;



CREATE VIEW kpiDeclarationSensibilisation AS
SELECT
    COUNT(DISTINCT CASE WHEN d.iddemande IS NOT NULL THEN s.idSensibilisation END) AS nombreSensibilisationsAvecDemandes,
    COUNT(DISTINCT s.idSensibilisation) AS nombreTotalSensibilisations,
    CASE
        WHEN COUNT(DISTINCT s.idSensibilisation) = 0 THEN 0
        ELSE ROUND(
            (COUNT(DISTINCT CASE WHEN d.iddemande IS NOT NULL THEN s.idSensibilisation END)
            / COUNT(DISTINCT s.idOperateurCible)::decimal) * 100,
            2
        )
    END AS tauxConversion
FROM
    sensibilisation s
LEFT JOIN
    demandedetails d ON s.idOperateur = d.idoperateur
WHERE
    s.dateSensibilisation IS NOT NULL;


CREATE OR REPLACE VIEW operateurCibleDetails AS
SELECT
    o.idOperateurCible,
    o.nom AS nom,
    o.email AS email,
    o.adresse AS adresse,
    r.idregime AS idregime,
    r.nom AS nomregime,
    v.idville AS idville,
    v.nom AS ville,
    o.status AS status,
    s.idSensibilisation AS idSensibilisation,
    s.idOperateur AS idOperateur,
    s.dateSensibilisation AS dateSensibilisation,
    s.dateConversion AS dateConversion,
    s.status AS sensibilisationStatus
FROM
    operateurCible o
JOIN
    regime r ON o.idRegime = r.idRegime
JOIN
    ville v ON o.idVille = v.idVille
LEFT JOIN
    sensibilisation s ON o.idOperateurCible = s.idOperateurCible AND o.status = 0;


CREATE OR REPLACE VIEW OperateurCiblesConvertir AS
SELECT o.*,s.datesensibilisation,s.dateconversion
FROM operateurcible o
LEFT JOIN sensibilisation s ON o.idOperateurCible = s.idOperateurCible
WHERE s.status <> 1 or s.status is null  and o.status = 0;

CREATE OR REPLACE VIEW OperateurConvertir AS
SELECT o.*,s.dateconversion, s.status AS sensibilisationStatus , d.status AS demandeStatus
FROM operateur o
LEFT JOIN sensibilisation s ON o.idOperateur = s.idOperateur
LEFT JOIN demandedetails d on o.idOperateur = d.idOperateur
WHERE s.status IS NULL and d.status = 2;

CREATE OR REPLACE VIEW renouvellementdetails AS
SELECT
    d.*,
    r.idrenouvellement AS renouvellement_id,
    r.datenotification
FROM
    renouvellement r
JOIN
    demandedetails d ON r.iddemande = d.iddemande;

CREATE VIEW reponseDetails AS
    SELECT
        d.iddemande,
        d.datedemande,
        d.datedeclaration,
        d.dateexpiration,
        d.status,
        d.idoperateurinformation,
        JSON_AGG(json_build_object('nomdocument', ds.nom, 'filesupplementaire', ds.filereponse)) AS documentsSupplementaires,
        oi.email,
        oi.telephone,
        oi.telecopie,
        oi.adresse,
        v.nom AS nomVille,
        s.nom AS nomStructureJuridique,
        o.nom AS nomoperateur,
        t.nom AS nomTypeFormulaire,
        t.description AS descriptiontypeformulaire,
        q.textQuestion,
		r.idreponseformulaire,
        r.texteReponse,
        r.nombreReponse,
        r.fileReponse,
        tq.nom AS typeQuestion,
        cq.idCategorieQuestion AS idcategoriequestion,
        cq.nom AS nomCategorieQuestion
    FROM
        demande d
    LEFT JOIN documentsupplementaire ds ON d.iddemande = ds.iddemande
    JOIN
        operateurinformation oi ON d.idoperateurinformation = oi.idoperateurinformation
    JOIN
        ville v ON oi.idville = v.idville
    JOIN
        structureJuridique s ON oi.idstructurejuridique = s.idstructurejuridique
    JOIN
        operateur o ON oi.idoperateur = o.idoperateur
    JOIN
        formulaire f ON d.idformulaire = f.idformulaire
    JOIN
        typeFormulaire t ON f.idTypeFormulaire = t.idTypeFormulaire
    JOIN
        question q ON f.idformulaire = q.idformulaire
    JOIN
        reponseFormulaire r ON q.idquestion = r.idquestion AND r.iddemande = d.iddemande  -- Correction ici pour lier les réponses à la demande spécifique
    JOIN
        typequestion tq ON q.idTypeQuestion = tq.idTypeQuestion
    JOIN
        categorieQuestion cq ON q.idCategorieQuestion = cq.idCategorieQuestion

    GROUP BY d.iddemande, oi.idoperateurinformation, q.idquestion, r.idreponseformulaire,v.nom, s.nom, o.nom, t.nom,t.description, tq.nom,cq.idCategorieQuestion ,cq.nom;

CREATE OR REPLACE VIEW TypeFormulaireDetails AS
SELECT
    f.idFormulaire,
    f.nom AS nomFormulaire,
    f.datecreation AS dateCreationFormulaire,
    tf.idTypeFormulaire,
    tf.nom AS nomTypeFormulaire,
    tf.description AS descriptionTypeFormulaire,
    tf.status AS status,
    tf.image AS image,
    r.idregime AS idregime,
    r.nom AS nomRegime
FROM
    (SELECT DISTINCT ON (idTypeFormulaire)
            idFormulaire,
            nom,
            datecreation,
            idTypeFormulaire
     FROM formulaire
     ORDER BY idTypeFormulaire, datecreation DESC
    ) f
RIGHT JOIN
    typeFormulaire tf ON f.idTypeFormulaire = tf.idTypeFormulaire
LEFT JOIN
    regime r ON tf.idRegime = r.idregime;

INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 2, 'Renseignements supplémentaires sur l''operateur', 1);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 1, 'Documents PDF', 1);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 3, 'Personne ayant qualité pour engager l''operateur', 3);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 38, 'Personne ayant qualité pour engager la société', 2);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 39, 'Renseignements sur les activités de l''opérateur dans le  domaine des  télécommunications', 1);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 40, 'Description du service que l''opérateur se propose d''exploiter', 1);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 41, 'Description des équipements de télécommunication utilisés et référence de leur agrément', 20);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 42, 'Le cas échéant, Description des fréquences radioélectriques nécessaires à l''exploitation du service et référence de l''autorisation d''utilisation de ces fréquences', 10);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 43, 'Description du service que l''opérateur se propose d''exploiter', 1);
INSERT INTO categoriequestion( idcategoriequestion, nom, nombrereponses ) VALUES ( 44, 'new categorie', 2);
INSERT INTO migrations( id, migration, batch ) VALUES ( 1, '2014_10_12_000000_create_users_table', 1);
INSERT INTO migrations( id, migration, batch ) VALUES ( 2, '2014_10_12_100000_create_password_reset_tokens_table', 1);
INSERT INTO migrations( id, migration, batch ) VALUES ( 3, '2019_08_19_000000_create_failed_jobs_table', 1);
INSERT INTO migrations( id, migration, batch ) VALUES ( 4, '2019_12_14_000001_create_personal_access_tokens_table', 1);
INSERT INTO regime( idregime, nom ) VALUES ( 1, 'Libre');
INSERT INTO regime( idregime, nom ) VALUES ( 2, 'Déclaration');
INSERT INTO structurejuridique( idstructurejuridique, nom ) VALUES ( 1, 'Entreprise Individuelle');
INSERT INTO structurejuridique( idstructurejuridique, nom ) VALUES ( 2, 'SARLU');
INSERT INTO structurejuridique( idstructurejuridique, nom ) VALUES ( 3, 'SARL');
INSERT INTO typeformulaire( idtypeformulaire, nom, description, status, image, anneevalidite, idregime ) VALUES ( 29, 'Fourniture au public d''équipement terminaux ou de service auxiliaires aux télécommunications', 'Formulaire de déclaration de fourniture au public d''équipement terminaux ou de services auxiliaires aux Télécommunications', 0, 'storage/img/pexels-field-engineer-147254-442152.jpg', null, 1);
INSERT INTO typeformulaire( idtypeformulaire, nom, description, status, image, anneevalidite, idregime ) VALUES ( 30, 'Fourniture de service d''installation et de maintenance d''équipements des télécommunication et tics', 'Formulaire de déclaration de fourniture de service d''installation et de maintenance d''équipements des télécommunication et tics', 0, 'storage/img/photo1.jpg', null, 1);
INSERT INTO typeformulaire( idtypeformulaire, nom, description, status, image, anneevalidite, idregime ) VALUES ( 31, 'Fourniture de service en installation et en gestion d''infrastructures fondamentales', 'Formulaire de déclaration de fourniture de service en installation et en gestion d''infrastructures fondamentales', 0, 'storage/img/pexels-field-engineer-147254-442150.jpg', 10, 2);
INSERT INTO typeformulaire( idtypeformulaire, nom, description, status, image, anneevalidite, idregime ) VALUES ( 32, 'Fourniture de service de télécommunication', 'Formulaire de déclaration d''intention de fourniture de service de télécommunication', 0, 'storage/img/pexels-field-engineer-147254-442158.jpg', 5, 2);
INSERT INTO typeformulaire( idtypeformulaire, nom, description, status, image, anneevalidite, idregime ) VALUES ( 33, 'test', 'test', 1, 'storage/img/pexels-field-engineer-147254-442150.jpg', null, 1);
INSERT INTO typequestion( idtypequestion, nom, designation ) VALUES ( 3, 'file', 'fichier PDF');
INSERT INTO typequestion( idtypequestion, nom, designation ) VALUES ( 2, 'text', 'texte');
INSERT INTO typequestion( idtypequestion, nom, designation ) VALUES ( 1, 'number', 'nombres');
INSERT INTO users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 2, 'admin2', 'henintsoa1901@gmail.com', null, '$2y$12$LqVfgHNYrlZ8DQE94W7eY.oqSYs3c86xaiCx5TpLtkl9mUOmzqbCu', 'admin', null, '2024-06-01 06:10:18 AM', '2024-06-01 06:10:18 AM');
INSERT INTO users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 1, 'admin', 'admin@gmail.com', null, '$2y$12$LqVfgHNYrlZ8DQE94W7eY.oqSYs3c86xaiCx5TpLtkl9mUOmzqbCu', 'admin', null, '2024-06-01 06:10:18 AM', '2024-06-01 06:10:18 AM');
INSERT INTO users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 44, 'Henintsoa', 'henintsoarjtv@gmail.com', null, '$2y$10$rvh8zowZKabVySVajyy7/ur8kkz2b9BJdyYa.EV/Y8a3tdQq2bLVu', 'user', null, '2024-09-19 01:11:33 AM', '2024-09-19 01:11:33 AM');
INSERT INTO users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 45, 'test', 'tahiry.rakotoheriniaina@gmail.com', null, '$2y$10$pSceAK0zqS3L4y4YD0V/JuwuxAkQvluTXoT0/sltkNTRk7uddXRLi', 'user', null, '2024-09-20 11:08:13 AM', '2024-09-20 11:08:13 AM');
INSERT INTO ville( idville, nom ) VALUES ( 1, 'Analamanga');
INSERT INTO ville( idville, nom ) VALUES ( 2, 'Bongolava');
INSERT INTO ville( idville, nom ) VALUES ( 3, 'Itasy');
INSERT INTO ville( idville, nom ) VALUES ( 4, 'Vakinankaratra');
INSERT INTO ville( idville, nom ) VALUES ( 5, 'Diana');
INSERT INTO ville( idville, nom ) VALUES ( 6, 'Sava');
INSERT INTO ville( idville, nom ) VALUES ( 7, 'Amoron''i Mania');
INSERT INTO ville( idville, nom ) VALUES ( 8, 'Atsimo-Atsinanana');
INSERT INTO ville( idville, nom ) VALUES ( 9, 'Fitovinany');
INSERT INTO ville( idville, nom ) VALUES ( 10, 'Haute Matsiatra');
INSERT INTO ville( idville, nom ) VALUES ( 11, 'Ihorombe');
INSERT INTO ville( idville, nom ) VALUES ( 12, 'Vatovavy');
INSERT INTO ville( idville, nom ) VALUES ( 13, 'Betsiboka');
INSERT INTO ville( idville, nom ) VALUES ( 14, 'Boeny');
INSERT INTO ville( idville, nom ) VALUES ( 15, 'Melaky');
INSERT INTO ville( idville, nom ) VALUES ( 16, 'Sofia');
INSERT INTO ville( idville, nom ) VALUES ( 17, 'Alaotra-Mangoro');
INSERT INTO ville( idville, nom ) VALUES ( 18, 'Ambatosoa');
INSERT INTO ville( idville, nom ) VALUES ( 19, 'Analanjirofo');
INSERT INTO ville( idville, nom ) VALUES ( 20, 'Atsinanana');
INSERT INTO ville( idville, nom ) VALUES ( 21, 'Androy');
INSERT INTO ville( idville, nom ) VALUES ( 22, 'Anosy');
INSERT INTO ville( idville, nom ) VALUES ( 23, 'Atsimo-Andrefana');
INSERT INTO ville( idville, nom ) VALUES ( 24, 'Menabe');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 67, 29, 'Fourniture au public d''équipement terminaux ou de service auxiliaires aux télécommunications', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 68, 30, 'Fourniture de service d''installation et de maintenance d''équipements des télécommunication et tics', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 69, 29, 'Fourniture au public d''équipement terminaux ou de service auxiliaires aux télécommunications', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 70, 30, 'Fourniture de service d''installation et de maintenance d''équipements des télécommunication et tics', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 71, 30, 'Fourniture de service d''installation et de maintenance d''équipements des télécommunication et tics', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 72, 31, 'Fourniture de service en installation et en gestion d''infrastructures fondamentales', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 73, 31, 'Fourniture de service en installation et en gestion d''infrastructures fondamentales', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 74, 31, 'Fourniture de service en installation et en gestion d''infrastructures fondamentales', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 75, 31, 'Fourniture de service en installation et en gestion d''infrastructures fondamentales', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 76, 32, 'Fourniture de service de télécommunication', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 77, 32, 'Fourniture de service de télécommunication', '2024-09-19');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 78, 33, 'test', '2024-09-20');
INSERT INTO formulaire( idformulaire, idtypeformulaire, nom, datecreation ) VALUES ( 79, 33, 'test', '2024-09-20');
INSERT INTO operateur( idoperateur, id, nom ) VALUES ( 22, 44, 'Henintsoa');
INSERT INTO operateur( idoperateur, id, nom ) VALUES ( 23, 45, 'test');
INSERT INTO operateurcible( idoperateurcible, nom, email, idville, status, adresse, idregime ) VALUES ( 14, 'test', 'henintsoa1901@gmail.com', 1, 0, 'Andohatapenaka', 2);
INSERT INTO operateurinformation( idoperateurinformation, idoperateur, adresse, idville, telephone, telecopie, email, idstructurejuridique ) VALUES ( 52, 22, 'Andohatapenaka', 1, '0332021100', null, 'henintsoarjtv@gmail.com', 1);
INSERT INTO operateurinformation( idoperateurinformation, idoperateur, adresse, idville, telephone, telecopie, email, idstructurejuridique ) VALUES ( 53, 22, 'Andohatapenaka', 1, '0332021100', null, 'henintsoarjtv@gmail.com', 1);
INSERT INTO operateurinformation( idoperateurinformation, idoperateur, adresse, idville, telephone, telecopie, email, idstructurejuridique ) VALUES ( 54, 23, 'Andohatapenaka', 1, '0332021100', null, 'tahiry.rakotoheriniaina@gmail.com', 1);
INSERT INTO operateurinformation( idoperateurinformation, idoperateur, adresse, idville, telephone, telecopie, email, idstructurejuridique ) VALUES ( 55, 23, 'Andohatapenaka', 2, '0332021100', null, 'tahiry.rakotoheriniaina@gmail.com', 1);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 186, 67, 'Numéro d''identification Fiscale (CIF)', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 187, 67, 'Adresse des ateliers et magasins', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 188, 67, 'Nature et description du service', 2, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 189, 67, 'Carte d''immatriculation Fiscale (CIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 190, 67, 'Carte d''immatriculation du Contribuable (NIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 191, 67, 'Carte d''identification d''Etablissement (Carte statistique)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 192, 67, 'Statut (pour les sociétés)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 193, 67, 'Extrait du Registre du commerce et des sociétés', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 194, 67, 'Certificat d''existence', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 195, 67, 'Certificat de résidence', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 196, 67, 'Nom et Prénom', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 197, 67, 'Fonction', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 198, 67, 'Nationalité', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 199, 67, 'Adresse (Domicile)', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 200, 67, 'Tel', 1, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 201, 67, 'Télécopie', 1, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 202, 67, 'E-mail', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 203, 68, 'Numéro d''Identification Fiscale', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 204, 68, 'Nature et description du service', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 205, 68, 'Carte d''Immatriculation Fiscale (CIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 206, 68, 'Carte d''Immatriculation du Contribuable (NIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 207, 68, 'Carte d''Identification d''Etablissement (Carte statique)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 208, 68, 'Statut (pour les sociétés)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 209, 68, 'Extrait du Registre du commerce et des sociétés', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 210, 68, 'Certificat d''existence', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 211, 68, 'Certificat de résidence (Pour toute personne ayant pour qualité d''engager la société)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 212, 68, 'Nom et Prénom', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 213, 68, 'Fonction', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 214, 68, 'Nationalité', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 215, 68, 'Adresse (Domicile)', 2, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 216, 68, 'Tel', 1, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 217, 68, 'Télécopie', 1, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 218, 68, 'E-mail', 2, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 219, 69, 'Numéro d''identification Fiscale (CIF)', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 220, 69, 'Adresse des ateliers et magasins', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 221, 69, 'Nature et description du service', 2, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 222, 69, 'Carte d''immatriculation Fiscale (CIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 223, 69, 'Carte d''immatriculation du Contribuable (NIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 224, 69, 'Carte d''identification d''Etablissement (Carte statistique)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 225, 69, 'Statut (pour les sociétés)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 226, 69, 'Extrait du Registre du commerce et des sociétés', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 227, 69, 'Certificat d''existence', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 228, 69, 'Certificat de résidence', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 229, 69, 'Nom et Prénom', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 230, 69, 'Fonction', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 231, 69, 'Nationalité', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 232, 69, 'Adresse (Domicile)', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 233, 69, 'Tel', 1, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 234, 69, 'Télécopie', 1, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 235, 69, 'E-mail', 2, 3, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 236, 69, 'Effectif total du personnel: Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 237, 69, 'Effectif total du personnel: Hors télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 239, 69, 'Nombre des techniciens', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 240, 69, 'Nombres des employés', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 241, 69, 'Nombres des ingénieurs', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 242, 69, 'Nombre d''années d''expérience de l''opérateur dans le domaine de télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 243, 69, 'Les principaux types d''équipements de télécommunication par l''''activité d''installation et de maintenance', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 244, 69, 'Moyens logistiques (Bureaux, ateliers, véhicules, etc..', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 245, 70, 'Numéro d''Identification Fiscale', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 246, 70, 'Nature et description du service', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 247, 70, 'Carte d''Immatriculation Fiscale (CIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 248, 70, 'Carte d''Immatriculation du Contribuable (NIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 249, 70, 'Carte d''Identification d''Etablissement (Carte statique)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 250, 70, 'Statut (pour les sociétés)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 251, 70, 'Extrait du Registre du commerce et des sociétés', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 252, 70, 'Certificat d''existence', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 253, 70, 'Certificat de résidence (Pour toute personne ayant pour qualité d''engager la société)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 254, 70, 'Nom et Prénom', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 255, 70, 'Fonction', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 256, 70, 'Nationalité', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 257, 70, 'Adresse (Domicile)', 2, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 258, 70, 'Tel', 1, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 259, 70, 'Télécopie', 1, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 260, 70, 'E-mail', 2, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 261, 70, 'Effectif total du personnel: Télécommunication : Télécommunication', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 262, 70, 'Effectif total du personnel: Hors télécommunication: Hors Télécommunication', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 263, 70, 'Organisation générale du département chargé des télécommunications : Nombre des ouvriers', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 264, 70, 'Nombre des techniciens', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 265, 70, 'Nombres des employers', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 266, 70, 'Nombre des Ingénieurs', 1, 39, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 267, 70, 'Nombre d''années d''expérience de l''opérateur dans le domaine de télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 268, 70, 'Les principaux type d''équipements de télécommunication concernés par l''activité d''installation et de maintenance', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 269, 70, 'Moyens logistiques (Bureaux, ateliers, véhicules, etc ...', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 270, 71, 'Numéro d''Identification Fiscale', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 271, 71, 'Nature et description du service', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 272, 71, 'Carte d''Immatriculation Fiscale (CIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 273, 71, 'Carte d''Immatriculation du Contribuable (NIF)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 274, 71, 'Carte d''Identification d''Etablissement (Carte statique)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 275, 71, 'Statut (pour les sociétés)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 276, 71, 'Extrait du Registre du commerce et des sociétés', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 277, 71, 'Certificat d''existence', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 369, 76, 'Numéro statistique', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 278, 71, 'Certificat de résidence (Pour toute personne ayant pour qualité d''engager la société)', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 279, 71, 'Nom et Prénom', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 280, 71, 'Fonction', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 281, 71, 'Nationalité', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 282, 71, 'Adresse (Domicile)', 2, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 283, 71, 'Tel', 1, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 284, 71, 'Télécopie', 1, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 285, 71, 'E-mail', 2, 38, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 286, 71, 'Effectif total du personnel: Télécommunication', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 287, 71, 'Effectif total du personnel: Hors télécommunication', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 289, 71, 'Nombre des techniciens', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 290, 71, 'Nombres des employers', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 291, 71, 'Nombre des Ingénieurs', 1, 39, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 292, 71, 'Nombre d''années d''expérience de l''opérateur dans le domaine de télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 293, 71, 'Les principaux type d''équipements de télécommunication concernés par l''activité d''installation et de maintenance', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 294, 71, 'Moyens logistiques (Bureaux, ateliers, véhicules, etc ...)', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 295, 72, 'Structure du capital social', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 296, 72, 'CIF', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 297, 72, 'Numéro Statistique', 1, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 298, 72, 'Chiffres d''affaires global au cours du dernier exercice fiscal (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 299, 72, 'Chiffres d''affaires dans le domaine des télécommunications au cours du dernier exercice (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 300, 73, 'Structure du capital social', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 301, 73, 'CIF', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 302, 73, 'Numéro Statistique', 1, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 303, 73, 'Chiffres d''affaires global au cours du dernier exercice fiscal (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 304, 73, 'Chiffres d''affaires dans le domaine des télécommunications au cours du dernier exercice (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 305, 74, 'CIF', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 306, 74, 'Structure du capital social', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 307, 74, 'Chiffres d''affaires dans le domaine des télécommunications au cours du dernier exercice (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 308, 74, 'Chiffres d''affaires global au cours du dernier exercice fiscal (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 309, 74, 'Numéro Statistique', 1, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 310, 74, 'Modèle de contrat de service qui sera proposé aux clients', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 311, 74, 'Certificat d''inscription au Registre du commerce', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 312, 74, 'Statut de la société', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 313, 74, 'Nom et Prénoms', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 314, 74, 'Fonction', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 315, 74, 'Nationalité', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 316, 74, 'Activités de l''opérateur: Type d''activité:', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 317, 74, 'Effectif total du personnel: Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 318, 74, 'Effectif total du personnel: Hors Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 319, 74, 'Organisation  générale du département chargé des télécommunications : Nombre des ouvriers', 1, 39, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 320, 74, 'Nombres de techniciens', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 321, 74, 'Nombres des employés', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 322, 74, 'Nombre des ingénieurs', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 323, 74, 'Nombre d''années d''expérience de l''opérateur dans le domaine de télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 324, 74, 'Liste des matériels et équipements utilisés en matière de maintenance', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 325, 74, 'Moyens logistiques (Bureaux, ateliers, véhicules, etc ...)', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 326, 74, 'Nature du service', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 327, 74, 'Zone de couverture', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 328, 74, 'Clientèle potentielle', 2, 40, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 329, 74, 'Expérience sur l''exploitation de ce service', 2, 40, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 330, 74, 'Designation', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 331, 74, 'Marque', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 332, 74, 'Type', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 333, 74, 'Référence de l''agrément', 2, 41, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 334, 74, 'Référence de l''autorisation', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 335, 74, 'Fréquences ou bande de fréquences', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 336, 75, 'CIF', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 337, 75, 'Structure du capital social', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 338, 75, 'Chiffres d''affaires dans le domaine des télécommunications au cours du dernier exercice (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 339, 75, 'Chiffres d''affaires global au cours du dernier exercice fiscal (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 340, 75, 'Numéro Statistique', 1, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 341, 75, 'Modèle de contrat de service qui sera proposé aux clients', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 342, 75, 'Certificat d''inscription au Registre du commerce', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 343, 75, 'Statut de la société', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 344, 75, 'Nom et Prénoms', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 345, 75, 'Fonction', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 346, 75, 'Nationalité', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 347, 75, 'Activités de l''opérateur: Type d''activité:', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 348, 75, 'Effectif total du personnel: Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 349, 75, 'Effectif total du personnel: Hors Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 350, 75, 'Organisation  générale du département chargé des télécommunications : Nombre des ouvriers', 1, 39, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 351, 75, 'Nombres de techniciens', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 352, 75, 'Nombres des employés', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 353, 75, 'Nombre des ingénieurs', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 354, 75, 'Nombre d''années d''expérience de l''opérateur dans le domaine de télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 355, 75, 'Liste des matériels et équipements utilisés en matière de maintenance', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 356, 75, 'Moyens logistiques (Bureaux, ateliers, véhicules, etc ...)', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 357, 75, 'Nature du service', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 358, 75, 'Zone de couverture', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 359, 75, 'Clientèle potentielle', 2, 40, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 360, 75, 'Expérience sur l''exploitation de ce service', 2, 40, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 361, 75, 'Designation', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 362, 75, 'Marque', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 363, 75, 'Type', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 364, 75, 'Référence de l''agrément', 2, 41, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 365, 75, 'Référence de l''autorisation', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 366, 75, 'Fréquences ou bande de fréquences', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 367, 76, 'Structure du capital social', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 368, 76, 'CIF', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 370, 76, 'Chiffre d''affaires global au cours du dernier exercice fiscal (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 371, 76, 'Chiffre d''affaires dans le domaine des télécommunications au cours du dernier exercice (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 372, 76, 'Modèle de contrat de service qui sera proposé aux clients', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 373, 76, 'Certificat d''inscription au Registre du commerce', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 374, 76, 'Statut de la société', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 375, 76, 'Nom et Prénoms', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 376, 76, 'Fonction', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 377, 76, 'Nationalité', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 378, 76, 'Activité de l''opérateur: Type d''activités:', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 379, 76, 'Effectif total du personnel: Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 380, 76, 'Effectif total du personnel: Hors Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 382, 76, 'Nombre des techniciens', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 383, 76, 'Nombre des employés', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 384, 76, 'Nombre des ingénieurs', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 385, 76, 'Nombre d''années d''expérience de l''opérateur chargé des télécommunication', 1, 39, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 386, 76, 'Liste des matériels et équipements utilisés en matière de maintenance', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 387, 76, 'Moyens logistiques (Bureaux, ateliers, véhicules, etc ... )', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 388, 76, 'Nature du service', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 389, 76, 'Zone de couverture', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 390, 76, 'Clientèle potentielle', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 391, 76, 'Expériences sur exploitation de ce service', 2, 40, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 392, 76, 'Designation', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 393, 76, 'Marque', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 394, 76, 'Type', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 395, 76, 'Référence de l''agrément', 2, 41, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 396, 76, 'Référence de l''autorisation', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 397, 76, 'Fréquences ou Bande de fréquences', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 238, 69, 'Nombre des ouvriers', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 381, 76, 'Nombre des ouvriers', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 288, 71, 'Nombre des ouvriers', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 398, 77, 'Numéro statistique', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 399, 77, 'Structure du capital social', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 400, 77, 'CIF', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 401, 77, 'Chiffre d''affaires global au cours du dernier exercice fiscal (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 402, 77, 'Chiffre d''affaires dans le domaine des télécommunications au cours du dernier exercice (Ariary)', 1, 2, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 403, 77, 'Modèle de contrat de service qui sera proposé aux clients', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 404, 77, 'Certificat d''inscription au Registre du commerce', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 405, 77, 'Statut de la société', 3, 1, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 406, 77, 'Nom et Prénoms', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 407, 77, 'Fonction', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 408, 77, 'Nationalité', 2, 38, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 409, 77, 'Activité de l''opérateur: Type d''activités:', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 410, 77, 'Effectif total du personnel: Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 411, 77, 'Effectif total du personnel: Hors Télécommunication', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 412, 77, 'Nombre des techniciens', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 413, 77, 'Nombre des employés', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 414, 77, 'Nombre des ingénieurs', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 415, 77, 'Nombre d''années d''expérience de l''opérateur chargé des télécommunication', 1, 39, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 416, 77, 'Liste des matériels et équipements utilisés en matière de maintenance', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 417, 77, 'Moyens logistiques (Bureaux, ateliers, véhicules, etc ... )', 2, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 418, 77, 'Nombre des ouvriers', 1, 39, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 419, 77, 'Nature du service', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 420, 77, 'Zone de couverture', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 421, 77, 'Clientèle potentielle', 2, 40, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 422, 77, 'Expériences sur exploitation de ce service', 2, 40, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 423, 77, 'Designation', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 424, 77, 'Marque', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 425, 77, 'Type', 2, 41, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 426, 77, 'Référence de l''agrément', 2, 41, false);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 427, 77, 'Référence de l''autorisation', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 428, 77, 'Fréquences ou Bande de fréquences', 2, 42, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 429, 78, 'question 1', 3, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 430, 79, 'question 1', 2, 2, true);
INSERT INTO question( idquestion, idformulaire, textquestion, idtypequestion, idcategoriequestion, questionobligatoire ) VALUES ( 431, 79, 'question 2', 3, 2, false);
INSERT INTO sensibilisation( idsensibilisation, idoperateurcible, status, idoperateur, datesensibilisation, dateconversion ) VALUES ( 20, 14, 1, 23, '2024-09-20 11:04:43 AM', '2024-09-20 11:38:00 AM');
INSERT INTO demande( iddemande, datedeclaration, dateexpiration, status, idoperateurinformation, idformulaire, datedemande, idrenouvellement ) VALUES ( 50, '2024-09-20 12:00:00 AM', '2026-09-20 12:00:00 AM', 2, 54, 77, '2024-09-20 11:17:49 AM', null);
INSERT INTO demande( iddemande, datedeclaration, dateexpiration, status, idoperateurinformation, idformulaire, datedemande, idrenouvellement ) VALUES ( 48, '2024-09-20 12:00:00 AM', null, 2, 52, 71, '2024-09-19 08:24:48 AM', null);
INSERT INTO demande( iddemande, datedeclaration, dateexpiration, status, idoperateurinformation, idformulaire, datedemande, idrenouvellement ) VALUES ( 49, null, null, null, 53, 76, '2024-09-19 02:36:57 PM', null);
INSERT INTO demande( iddemande, datedeclaration, dateexpiration, status, idoperateurinformation, idformulaire, datedemande, idrenouvellement ) VALUES ( 51, null, null, 0, 55, 77, '2024-09-20 12:14:18 PM', null);
INSERT INTO documentsupplementaire( iddocumentsupplementaire, iddemande, filereponse, nom ) VALUES ( 11, 50, 'storage/documents_supplementaires/b45caaac-4c6e-4dd2-b5b4-8151b902b846.pdf', 'certificat de résidence');
INSERT INTO documentsupplementaire( iddocumentsupplementaire, iddemande, filereponse, nom ) VALUES ( 12, 48, 'storage/documents_supplementaires/decab7f5-07af-496e-8497-9eb9152c9006.pdf', 'certificat');
INSERT INTO documentsupplementaire( iddocumentsupplementaire, iddemande, filereponse, nom ) VALUES ( 13, 49, null, 'doc 1');
INSERT INTO documentsupplementaire( iddocumentsupplementaire, iddemande, filereponse, nom ) VALUES ( 14, 49, null, 'doc 2');
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 29, 2, 'demande de déclaration', 'Fourniture de service d''installation et de maintenance d''équipements des télécommunication et tics', false, '2024-09-19 08:24:49 AM', '2024-09-19 08:24:49 AM', 48, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 31, 2, 'demande de déclaration', 'Fourniture de service de télécommunication', false, '2024-09-19 02:36:58 PM', '2024-09-19 02:36:58 PM', 49, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 30, 1, 'demande de déclaration', 'Fourniture de service d''installation et de maintenance d''équipements des télécommunication et tics', true, '2024-09-19 08:24:49 AM', '2024-09-19 08:24:49 AM', 48, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 33, 2, 'demande de déclaration', 'Fourniture de service de télécommunication', false, '2024-09-20 11:17:49 AM', '2024-09-20 11:17:49 AM', 50, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 32, 1, 'demande de déclaration', 'Fourniture de service de télécommunication', true, '2024-09-19 02:36:58 PM', '2024-09-19 02:36:58 PM', 49, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 34, 1, 'demande de déclaration', 'Fourniture de service de télécommunication', true, '2024-09-20 11:17:49 AM', '2024-09-20 11:17:49 AM', 50, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 37, 2, 'demande de déclaration', 'Fourniture de service de télécommunication', false, '2024-09-20 12:14:18 PM', '2024-09-20 12:14:18 PM', 51, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 38, 1, 'demande de déclaration', 'Fourniture de service de télécommunication', true, '2024-09-20 12:14:18 PM', '2024-09-20 12:14:18 PM', 51, false);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 39, 2, 'L''opérateur test doit renouveler le formulaire ''Fourniture de service de télécommunication'' avant le 20/09/2026.', 'Renouvellement', false, '2024-09-20 02:12:11 PM', '2024-09-20 02:12:11 PM', 50, true);
INSERT INTO notifications( idnotification, id, message, "type", lue, created_at, updated_at, iddemande, renouvellement ) VALUES ( 40, 1, 'L''opérateur test doit renouveler le formulaire ''Fourniture de service de télécommunication'' avant le 20/09/2026.', 'Renouvellement', true, '2024-09-20 02:12:16 PM', '2024-09-20 02:12:16 PM', 50, true);
INSERT INTO renouvellement( idrenouvellement, idtypeformulaire, created_at, iddemande, idoperateur, datenotification ) VALUES ( 22, 32, '2024-09-20 02:12:11 PM', 50, 23, '2024-09-20 02:13:39 PM');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 269, 270, 48, '12345678901234', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 270, 271, 48, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 271, 272, 48, null, null, 'storage/reponses_fichiers/36226fd4-b24a-4f32-91d5-8f47f3721b9f.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 272, 273, 48, null, null, 'storage/reponses_fichiers/fc3569e1-51e3-4d71-a2d8-9c95fc22f745.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 273, 274, 48, null, null, 'storage/reponses_fichiers/30d3730c-5276-450a-bce0-e3ebbd86151c.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 274, 275, 48, null, null, 'storage/reponses_fichiers/340f19ce-1ab5-4594-ae53-a2760eae4baf.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 275, 276, 48, null, null, 'storage/reponses_fichiers/9f981b8f-582d-4bd3-867e-b3775e26c835.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 276, 277, 48, null, null, 'storage/reponses_fichiers/3e167cd4-a027-4e42-bf05-3007d6577633.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 277, 278, 48, null, null, 'storage/reponses_fichiers/ab40eb8c-ec4f-4d24-bb76-3ff574740ec0.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 278, 279, 48, 'Henintsoa', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 279, 280, 48, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 280, 281, 48, 'Malagasy', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 281, 282, 48, 'Andohatapenaka', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 282, 283, 48, null, 332021100, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 283, 285, 48, 'henintsoarjtv@gmail.com', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 284, 286, 48, '10', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 285, 287, 48, '5', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 286, 288, 48, null, 10, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 287, 289, 48, null, 5, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 288, 290, 48, null, 10, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 289, 291, 48, null, 10, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 290, 292, 48, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 291, 293, 48, 'test,test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 292, 294, 48, 'bureaux,ateliers', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 293, 369, 49, '123456789', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 294, 367, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 295, 368, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 296, 370, 49, null, 10000000, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 297, 371, 49, null, 500000, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 298, 372, 49, null, null, 'storage/reponses_fichiers/8d0ec2f9-c4dc-404d-9fe8-1e226eb9305e.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 299, 373, 49, null, null, 'storage/reponses_fichiers/5b755907-1134-4bd6-85bc-2ecfba6528d3.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 300, 374, 49, null, null, 'storage/reponses_fichiers/975dff2d-9df3-4fb5-8314-db246747748c.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 301, 375, 49, 'Henintsoa', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 302, 376, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 303, 377, 49, 'Malagasy', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 304, 378, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 305, 379, 49, null, 10, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 306, 380, 49, null, 10, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 307, 382, 49, null, 5, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 308, 383, 49, null, 30, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 309, 384, 49, null, 2, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 310, 385, 49, null, 2, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 311, 386, 49, 'test2,test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 312, 387, 49, 'voiture, bureaux', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 313, 381, 49, null, 8, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 314, 388, 49, 'service test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 315, 389, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 316, 390, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 317, 392, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 318, 392, 49, 'test21', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 319, 392, 49, 'test211', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 320, 393, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 321, 393, 49, 'test21', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 322, 393, 49, 'test211', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 323, 394, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 324, 394, 49, 'test21', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 325, 394, 49, 'test211', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 326, 396, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 327, 396, 49, 'test22', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 328, 397, 49, 'test2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 329, 397, 49, 'test22', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 330, 398, 50, '01234578', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 331, 399, 50, 'entreprise individuelle', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 332, 400, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 333, 403, 50, null, null, 'storage/reponses_fichiers/ea80f70e-0e12-4a18-97f6-5ce2f068a124.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 334, 404, 50, null, null, 'storage/reponses_fichiers/73e75605-b84a-45aa-8e47-1636d9a6ccc6.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 335, 405, 50, null, null, 'storage/reponses_fichiers/b9873c5c-6dbb-4544-9b5d-0bba061c9e80.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 336, 406, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 337, 407, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 338, 408, 50, 'Malagasy', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 339, 409, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 340, 410, 50, null, 10, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 341, 411, 50, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 342, 412, 50, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 343, 413, 50, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 344, 414, 50, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 345, 415, 50, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 346, 416, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 347, 417, 50, 'bureaux,ateliers', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 348, 418, 50, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 349, 419, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 350, 420, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 351, 421, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 352, 423, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 353, 424, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 354, 425, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 355, 427, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 356, 428, 50, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 357, 398, 51, '012345678', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 358, 399, 51, '123', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 359, 400, 51, '123132', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 360, 403, 51, null, null, 'storage/reponses_fichiers/549c241b-0d4d-4fc1-adea-9eccdc2c7b13.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 361, 404, 51, null, null, 'storage/reponses_fichiers/980fc817-0fa3-416d-8075-3b916eceafa6.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 362, 405, 51, null, null, 'storage/reponses_fichiers/90a50409-32f5-45a9-a5a4-7be97d26820d.pdf');
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 363, 406, 51, 'Opérateur2', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 364, 407, 51, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 365, 408, 51, 'malagasy', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 366, 409, 51, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 367, 410, 51, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 368, 411, 51, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 369, 412, 51, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 370, 413, 51, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 371, 414, 51, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 372, 416, 51, 'test', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 373, 417, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 374, 418, 51, null, 1, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 375, 419, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 376, 420, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 377, 421, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 378, 423, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 379, 424, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 380, 425, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 381, 427, 51, 'a', null, null);
INSERT INTO reponseformulaire( idreponseformulaire, idquestion, iddemande, textereponse, nombrereponse, filereponse ) VALUES ( 382, 428, 51, 'a', null, null);
