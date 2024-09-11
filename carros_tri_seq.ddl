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

--  TRIGGERS AND SEQUENCES
-- tabela combustíveis
CREATE SEQUENCE seq_com
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TRIGGER tri_com_id
    BEFORE INSERT ON combustiveis
    FOR EACH ROW
    BEGIN
        :NEW.com_id := seq_com.nextval;
    END;
/

-- tabela marcas

CREATE SEQUENCE seq_mar
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TRIGGER tri_mar_id
    BEFORE INSERT ON marcas
    FOR EACH ROW
    BEGIN
        :NEW.mar_id := seq_mar.nextval;
    END;
/
-- tipos_cambio

CREATE SEQUENCE seq_cam
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TRIGGER tri_cam_id
    BEFORE INSERT ON tipos_cambio
    FOR EACH ROW
    BEGIN
        :NEW.cam_id := seq_cam.nextval;
    END;
/
-- tipos_motor

CREATE SEQUENCE seq_mot
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TRIGGER tri_mot_id
    BEFORE INSERT ON tipos_motor
    FOR EACH ROW
    BEGIN
        :NEW.mot_id := seq_mot.nextval;
    END;
/
-- tabela modelos

CREATE SEQUENCE seq_mod
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TRIGGER tri_mod_id
    BEFORE INSERT ON modelos
    FOR EACH ROW
    BEGIN
        :NEW.mod_id := seq_mod.nextval;
    END;
/

-- tabela veiculos
CREATE SEQUENCE seq_vei
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TRIGGER tri_vei_id
    BEFORE INSERT ON veiculos_preco
    FOR EACH ROW
    BEGIN
        :NEW.vei_id := seq_vei.nextval;
    END;
/