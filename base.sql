INSERT INTO "public".users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 1, 'admin', 'admin@gmail.com', null, '$2y$12$LqVfgHNYrlZ8DQE94W7eY.oqSYs3c86xaiCx5TpLtkl9mUOmzqbCu', 'admin', null, '2024-06-01 06:10:18 AM', '2024-06-01 06:10:18 AM');

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
    adresse VARCHAR(200),
    idVille int,
    telephone VARCHAR(200),
    telecopie VARCHAR(200),
    email VARCHAR(200),
    idStructureJuridique int,
    FOREIGN KEY (id) REFERENCES users(id),
    FOREIGN KEY (idVille) REFERENCES ville(idVille),
    FOREIGN KEY (idStructureJuridique) REFERENCES structureJuridique(idStructureJuridique)
);



CREATE TABLE typeFormulaire (
    idTypeFormulaire  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    description VARCHAR(200) NOT NULL,
    status int default 0,

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
    idOperateur int,
    idFormulaire int,
    dateDeclaration timestamp NOT NULL,
    dateExpiration timestamp NOT NULL,
    status int,
    FOREIGN KEY (idOperateur) REFERENCES operateur(idOperateur),
    FOREIGN KEY (idFormulaire) REFERENCES formulaire(idFormulaire)
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

CREATE TABLE operateurCible (
    idOperateurCible  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    idVille int NOT NULL,
    FOREIGN KEY (idVille) REFERENCES ville(idVille)
);

CREATE TABLE sensibilisation (
    idSensibilisation  SERIAL PRIMARY KEY,
    idOperateurCible int,
    status int,
    idOperateur int,
    dateSensibilisation timestamp NOT NULL,
    dateConversion timestamp,
    FOREIGN KEY (idOperateurCible) REFERENCES operateurCible(idOperateurCible)
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
    q.idQuestion,
    q.textQuestion,
    tq.idtypequestion AS idtypequestion,
    tq.nom AS typeQuestion,
    tq.designation AS designationTypeQuestion,
    q.questionobligatoire,
    cq.nom AS categorieQuestion,
    cq.nombrereponses AS nombreReponses
FROM
    formulaire f
JOIN
    typeFormulaire tf ON f.idTypeFormulaire = tf.idTypeFormulaire
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
    tf.status AS status
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
    typeFormulaire tf ON f.idTypeFormulaire = tf.idTypeFormulaire;

