INSERT INTO "public".users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 1, 'admin', 'admin@gmail.com', null, '$2y$12$LqVfgHNYrlZ8DQE94W7eY.oqSYs3c86xaiCx5TpLtkl9mUOmzqbCu', 'admin', null, '2024-06-01 06:10:18 AM', '2024-06-01 06:10:18 AM');

INSERT INTO "public".users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 2, 'admin2', 'henintsoa1901@gmail.com', null, '$2y$12$LqVfgHNYrlZ8DQE94W7eY.oqSYs3c86xaiCx5TpLtkl9mUOmzqbCu', 'admin', null, '2024-06-01 06:10:18 AM', '2024-06-01 06:10:18 AM');

CREATE TABLE ville (
    idVille  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL
);

CREATE TABLE Nationalite (
    idNationalite  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL
);

CREATE TABLE structureJuridique (
    idStructureJuridique  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL
);
INSERT INTO structureJuridique(nom) VALUES ('Entreprise Individuelle');
INSERT INTO structureJuridique(nom) VALUES ('SARLU');
INSERT INTO structureJuridique(nom) VALUES ('SARL');


CREATE TABLE operateur (
    idOperateur  SERIAL PRIMARY KEY,
    id int NOT NULL,
    nom VARCHAR(200),
    FOREIGN KEY (id) REFERENCES users(id)
);

CREATE TABLE operateurInformation (
    idOperateurInformation  SERIAL PRIMARY KEY,
    idOperateur int,
    adresse VARCHAR(200),
    idVille int,
    telephone VARCHAR(200),
    telecopie VARCHAR(200),
    email VARCHAR(200),
    idStructureJuridique int,
    FOREIGN KEY (idOperateur) REFERENCES operateur(idOperateur),
    FOREIGN KEY (idVille) REFERENCES ville(idVille),
    FOREIGN KEY (idStructureJuridique) REFERENCES structureJuridique(idStructureJuridique)
)

CREATE TABLE typeFormulaire (
    idTypeFormulaire  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    description VARCHAR(200) NOT NULL,
    status int default 0,
    image VARCHAR(500),
    anneeValidite int,
    idregime int,
    FOREIGN KEY (idregime) REFERENCES regime(idregime)

);
INSERT INTO typeFormulaire(nom, description) VALUES ('Formulaire pour équipement terminaux ou services auxiliaires', 'Formulaire de déclaration fourniture au public d''équipement terminaux ou de service auxiliaires aux télécommunications');
INSERT INTO typeFormulaire(nom, description) VALUES ('Formulaire pour service d''installation et de maintenance', 'Formulaire de déclaration fourniture de service d''installation et de maintenance d''équipement des télécommunications et tic');

CREATE TABLE formulaire (
    idFormulaire  SERIAL PRIMARY KEY,
    idTypeFormulaire int,
    nom VARCHAR(200) NOT NULL,
    datecreation timestamp NOT NULL,
    FOREIGN KEY (idTypeFormulaire) REFERENCES typeFormulaire(idTypeFormulaire)
);
INSERT INTO formulaire(idTypeFormulaire, nom) VALUES (1, 'Formulaire pour équipement terminaux ou services auxiliaires');

CREATE TABLE typeQuestion (
    idTypeQuestion  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    designation VARCHAR(200) NOT NULL
);
INSERT INTO typeQuestion(nom, designation) VALUES ('text', 'text');
INSERT INTO typeQuestion(nom, designation) VALUES ('number', 'number');
INSERT INTO typeQuestion(nom, designation) VALUES ('file', 'file');
INSERT INTO typeQuestion(nom, designation) VALUES ('nationalite', 'nationalite');

CREATE TABLE categorieQuestion (
    idCategorieQuestion SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL
);
ALTER TABLE categorieQuestion ADD COLUMN nombreReponses INT DEFAULT 1;

INSERT INTO categorieQuestion(nom, nombreReponses) VALUES ('Documents', 1);
INSERT INTO categorieQuestion(nom, nombreReponses) VALUES ('Renseignements sur l''operateur', 1);
INSERT INTO categorieQuestion(nom, nombreReponses) VALUES ('Personne ayant qualité pour engager l''operateur', 3); -- Exemple avec 3 réponses possibles



CREATE TABLE question (
    idQuestion  SERIAL PRIMARY KEY,
    idFormulaire int,
    textQuestion VARCHAR(300) NOT NULL,
    idTypeQuestion int,
    questionObligatoire boolean DEFAULT false,
    idCategorieQuestion int,
    FOREIGN KEY (idTypeQuestion) REFERENCES typeQuestion(idTypeQuestion),
    FOREIGN KEY (idFormulaire) REFERENCES formulaire(idFormulaire),
    FOREIGN KEY (idCategorieQuestion) REFERENCES categorieQuestion(idCategorieQuestion)
);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Carte d''immatriculation Fiscale (CIF)', 3,true,1);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Carte d''immatriculation du Contribuable (NIF)', 3,true,1);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Carte d''identification d''Etablissement (Carte Statique)', 3,true,1);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Statut (pour les sociétés)', 3,true,1);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Extrait du Registre du commerce et des sociétés', 3,true,1);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Certificat d''existence', 3,true,1);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Certificat de résidence', 3,true,1);

-- INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Nom ou Raison sociale', 2,true,2);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Numéro d''identification fiscale',2,true,2);
-- INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Structure juridique', 2,true,2);
-- INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Adresse du siège social', 2,true,2);
-- INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Ville', 2,true,2);
-- INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Téléphone', 2,true,2);
-- INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Télécopie', 2,false,2);
-- INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Email', 2,true,2);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Adresse des ateliers et magasins', 2,true,2);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Nature et description du service', 2,true,2);

INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Nom et prénom', 2,true,3);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Fonction', 2,true,3);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Nationalité', 4,true,3);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Adresse(Domicile)', 2,true,3);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Téléphone', 2,true,3);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Télécopie', 2,false,3);
INSERT INTO question(idFormulaire, textQuestion, idTypeQuestion,questionObligatoire,idCategorieQuestion) VALUES (1, 'Email', 2,true,3);


CREATE TABLE demande (
    idDemande  SERIAL PRIMARY KEY,
    idOperateurInformation int,
    idFormulaire int,
    dateDemande timestamp,
    dateDeclaration timestamp,
    dateExpiration timestamp,
    idrenouvellement int,
    status int,
    FOREIGN KEY (idOperateurInformation) REFERENCES operateurInformation(idOperateurInformation),
    FOREIGN KEY (idFormulaire) REFERENCES formulaire(idFormulaire),
    FOREIGN KEY (idrenouvellement) REFERENCES renouvellement(idrenouvellement)
);

CREATE TABLE reponseFormulaire (
    idReponseFormulaire  SERIAL PRIMARY KEY,
    idQuestion int,
    idDemande int,
    texteReponse VARCHAR(300) NOT NULL,
    nombreReponse NUMERIC(20,2),
    fileReponse VARCHAR(300),
    FOREIGN KEY (idDemande) REFERENCES demande(idDemande),
    FOREIGN KEY (idQuestion) REFERENCES question(idQuestion)
);

CREATE TABLE documentSupplementaire (
    idDocumentSupplementaire  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    idDemande int,
    fileReponse VARCHAR(300),
    FOREIGN KEY (idDemande) REFERENCES demande(idDemande)
);

CREATE TABLE operateurCible (
    idOperateurCible  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    idVille int NOT NULL,
    FOREIGN KEY (idVille) REFERENCES ville(idVille)
);
ALTER TABLE operateurCible ADD COLUMN status INT DEFAULT 0;
ALTER TABLE operateurCible ADD COLUMN idregime INT;
ALTER TABLE operateurCible ADD COLUMN adresse VARCHAR(200);
ALTER TABLE operateurCible
ADD CONSTRAINT fk_operateurcible_regime
FOREIGN KEY (idregime)
REFERENCES regime(idregime)
ON DELETE SET NULL;  -- Cette option est facultative, elle définit ce qui se passe lorsque la clé étrangère est supprimée dans la table de référence

INSERT INTO operateurCible (nom, email, idVille) VALUES
('Operateur1', 'henintsoarjtv@gmail.com', 1),
('Operateur2', 'henintsoa1901@gmail.com', 2);

CREATE TABLE regime (
    idregime  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL
);
INSERT INTO regime (nom) VALUES
('Libre'),
('Declaration');

CREATE TABLE sensibilisation (
    idSensibilisation  SERIAL PRIMARY KEY,
    idOperateurCible int,
    status int,
    idOperateur int,
    dateSensibilisation timestamp NOT NULL,
    dateConversion timestamp,
    FOREIGN KEY (idOperateurCible) REFERENCES operateurCible(idOperateurCible)
    FOREIGN KEY (idOperateur) REFERENCES operateurCible(idOperateur)
);

CREATE TABLE notifications (
    idNotification SERIAL PRIMARY KEY,
    id INT NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(255),
    lue BOOLEAN DEFAULT FALSE,
    iddemande INT,
    renouvellement BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    FOREIGN KEY (id) REFERENCES users(id),
    FOREIGN KEY (iddemande) REFERENCES demande(iddemande)
);
-- ALTER TABLE notifications ADD COLUMN renouvellement BOOLEAN DEFAULT FALSE;

CREATE TABLE renouvellement (
    idRenouvellement SERIAL PRIMARY KEY,
    idoperateur INT NOT NULL,
    iddemande INT NOT NULL,
    idtypeformulaire INT NOT NULL,
    dateEnvoi timestamp,
    dateRenouvellement timestamp,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idoperateur) REFERENCES operateur(idoperateur),
    FOREIGN KEY (iddemande) REFERENCES demande(iddemande),
    FOREIGN KEY (idtypeformulaire) REFERENCES typeformulaire(ididtypeformulaire)
);


php artisan make:controller Api/AuthController


--------------------View

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


CREATE OR REPLACE VIEW OperateurConvertir AS
SELECT o.*,s.dateconversion, s.status AS sensibilisationStatus , d.status AS demandeStatus
FROM operateur o
LEFT JOIN sensibilisation s ON o.idOperateur = s.idOperateur
LEFT JOIN demandedetails d on o.idOperateur = d.idOperateur
WHERE s.status IS NULL and d.status = 2

-- CREATE OR REPLACE VIEW OperateurCiblesConvertir AS
-- SELECT o.*,s.dateconversion, s.status
-- FROM operateurcible o
-- LEFT JOIN sensibilisation s ON o.idOperateurCible = s.idOperateurCible
-- WHERE s.status <> 1 or s.status is null  and o.status = 0

-- CREATE OR REPLACE VIEW OperateurCiblesConvertir AS
-- SELECT o.*
-- FROM operateurcible o
-- LEFT JOIN sensibilisation s ON o.idOperateurCible = s.idOperateurCible
-- WHERE s.status IS NULL and o.status = 0

CREATE OR REPLACE VIEW OperateurCiblesConvertir AS
SELECT o.*,s.datesensibilisation,s.dateconversion
FROM operateurcible o
LEFT JOIN sensibilisation s ON o.idOperateurCible = s.idOperateurCible
WHERE s.status <> 1 or s.status is null  and o.status = 0

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
        q.textQuestion,
		r.idreponseformulaire,
        r.texteReponse,
        r.nombreReponse,
        r.fileReponse,
        tq.designation AS typeQuestion,
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

    GROUP BY d.iddemande, oi.idoperateurinformation, q.idquestion, r.idreponseformulaire,v.nom, s.nom, o.nom, t.nom, tq.designation, cq.nom;

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

CREATE OR REPLACE VIEW renouvellementdetails AS
SELECT
    d.*,
    r.idrenouvellement AS renouvellement_id, -- Utilisez un alias pour cette colonne
    r.datenotification
FROM
    renouvellement r
JOIN
    demandedetails d ON r.iddemande = d.iddemande;


-- CREATE VIEW reponseDetails AS
--     SELECT
--         d.iddemande,
--         d.datedemande,
--         d.datedeclaration,
--         d.dateexpiration,
--         d.status,
--         d.idoperateurinformation,
--         oi.email,
--         oi.telephone,
--         oi.telecopie,
--         oi.adresse,
--         v.nom AS nomVille,
--         s.nom AS nomStructureJuridique,
--         o.nom AS nomoperateur,
--         t.nom AS nomTypeFormulaire,
--         q.textQuestion,
--         r.texteReponse,
--         r.nombreReponse,
--         r.fileReponse,
--         tq.designation AS typeQuestion,
--         cq.nom AS nomCategorieQuestion
--     FROM
--         demande d

--     JOIN
--         operateurinformation oi ON d.idoperateurinformation = oi.idoperateurinformation
--     JOIN
--         ville v ON oi.idville = v.idville
--     JOIN
--         structureJuridique s ON oi.idstructurejuridique = s.idstructurejuridique
--     JOIN
--         operateur o ON oi.idoperateur = o.idoperateur
--     JOIN
--         formulaire f ON d.idformulaire = f.idformulaire
--     JOIN
--         typeFormulaire t ON f.idTypeFormulaire = t.idTypeFormulaire
--     JOIN
--         question q ON f.idformulaire = q.idformulaire
--     JOIN
--         reponseFormulaire r ON q.idquestion = r.idquestion AND r.iddemande = d.iddemande  -- Correction ici pour lier les réponses à la demande spécifique
--     JOIN
--         typequestion tq ON q.idTypeQuestion = tq.idTypeQuestion
--     JOIN
--         categorieQuestion cq ON q.idCategorieQuestion = cq.idCategorieQuestion;
