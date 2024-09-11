-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2024-09-06 14:12:25 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE combustiveis (
    com_id   NUMBER(10) NOT NULL,
    com_nome VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE combustiveis ADD CONSTRAINT pk_com PRIMARY KEY ( com_id );

CREATE TABLE marcas (
    mar_id   NUMBER(10) NOT NULL,
    mar_nome VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE marcas ADD CONSTRAINT pk_mar PRIMARY KEY ( mar_id );

CREATE TABLE modelos (
    mod_id       NUMBER(10) NOT NULL,
    mod_nome     VARCHAR2(50 CHAR) NOT NULL,
    mod_fipe_cod VARCHAR2(20 CHAR),
    mod_mar_id   NUMBER(10) NOT NULL,
    mod_cam_id   NUMBER(10) NOT NULL,
    mod_mot_id   NUMBER(10) NOT NULL,
    mod_com_id   NUMBER(10) NOT NULL
);

ALTER TABLE modelos ADD CONSTRAINT pk_mod PRIMARY KEY ( mod_id );

CREATE TABLE tipos_cambio (
    cam_id   NUMBER(10) NOT NULL,
    cam_nome VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE tipos_cambio ADD CONSTRAINT pk_cam PRIMARY KEY ( cam_id );

CREATE TABLE tipos_motor (
    mot_id        NUMBER(10) NOT NULL,
    mot_descricao NUMBER(2, 1) NOT NULL
);

ALTER TABLE tipos_motor ADD CONSTRAINT pk_mot PRIMARY KEY ( mot_id );

CREATE TABLE veiculos_preco (
    vei_id            NUMBER(10) NOT NULL,
    vei_autentica_cod VARCHAR2(50 CHAR),
    vei_media_preco   NUMBER(15),
    vei_ano_fab       NUMBER(4) NOT NULL,
    vei_anos_de_uso   NUMBER(2) NOT NULL,
    vei_mod_id        NUMBER(10) NOT NULL
);

ALTER TABLE veiculos_preco ADD CONSTRAINT pk_vei PRIMARY KEY ( vei_id );

ALTER TABLE modelos
    ADD CONSTRAINT fk_cam_mod FOREIGN KEY ( mod_cam_id )
        REFERENCES tipos_cambio ( cam_id );

ALTER TABLE modelos
    ADD CONSTRAINT fk_com_mod FOREIGN KEY ( mod_com_id )
        REFERENCES combustiveis ( com_id );

ALTER TABLE modelos
    ADD CONSTRAINT fk_mar_mod FOREIGN KEY ( mod_mar_id )
        REFERENCES marcas ( mar_id );

ALTER TABLE veiculos_preco
    ADD CONSTRAINT fk_mod_vei FOREIGN KEY ( vei_mod_id )
        REFERENCES modelos ( mod_id );

ALTER TABLE modelos
    ADD CONSTRAINT fk_mot_mod FOREIGN KEY ( mod_mot_id )
        REFERENCES tipos_motor ( mot_id );



-- Relat�rio do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             0
-- ALTER TABLE                             11
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
