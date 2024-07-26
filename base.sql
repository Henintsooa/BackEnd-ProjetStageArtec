INSERT INTO "public".users( id, name, email, email_verified_at, "password", status, remember_token, created_at, updated_at ) VALUES ( 1, 'admin', 'admin@gmail.com', null, '$2y$12$LqVfgHNYrlZ8DQE94W7eY.oqSYs3c86xaiCx5TpLtkl9mUOmzqbCu', 'admin', null, '2024-06-01 06:10:18 AM', '2024-06-01 06:10:18 AM');

CREATE TABLE ville (
    idVille  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL
);

CREATE TABLE operateur (
    idOperateur  SERIAL PRIMARY KEY,
    id int,
    nom VARCHAR(200) NOT NULL,
    adresse VARCHAR(200) NOT NULL,
    idVille int,
    telephone VARCHAR(200) NOT NULL,
    telecopie VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    FOREIGN KEY (id) REFERENCES users(id),
    FOREIGN KEY (idVille) REFERENCES ville(idVille)
);



CREATE TABLE typeFormulaire (
    idTypeFormulaire  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    description VARCHAR(200) NOT NULL
);

CREATE TABLE typeQuestion (
    idTypeQuestion  SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    designation VARCHAR(200) NOT NULL
);

CREATE TABLE formulaire (
    idFormulaire  SERIAL PRIMARY KEY,
    idTypeFormulaire int,
    nom VARCHAR(200) NOT NULL,
    FOREIGN KEY (idTypeFormulaire) REFERENCES typeFormulaire(idTypeFormulaire)
);

CREATE TABLE question (
    idQuestion  SERIAL PRIMARY KEY,
    idFormulaire int,
    textQuestion VARCHAR(300) NOT NULL,
    idTypeQuestion int,
    FOREIGN KEY (idTypeQuestion) REFERENCES typeQuestion(idTypeQuestion),
    FOREIGN KEY (idFormulaire) REFERENCES formulaire(idFormulaire)
);

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
