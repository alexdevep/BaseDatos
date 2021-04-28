/*Version de DBMS*/
select * from v$version; 

/*Creando las entidades*/

CREATE TABLE profesion (
    id_profesion                INTEGER,
    descripcion                 VARCHAR2(100),
    PRIMARY KEY (id_profesion)
);

CREATE TABLE duenio (
    id_duenio                   INTEGER,
    nombre                      VARCHAR2(100),
    telefono                    VARCHAR2(25),
    edad                        INTEGER,
    id_profesion                INTEGER REFERENCES profesion (id_profesion),
    PRIMARY KEY (id_duenio)
);

CREATE TABLE estado_mental (
    id_estado_mental            INTEGER,
    descripcion                 VARCHAR2(100),
    PRIMARY KEY (id_estado_mental)
);

CREATE TABLE raza (
    id_raza                     INTEGER,
    descripcion                 VARCHAR2(100),
    PRIMARY KEY (id_raza)
);

CREATE TABLE perro (
    no_registro                 INTEGER,
    nombre                      VARCHAR2(100),
    edad                        INTEGER,
    id_raza                     INTEGER REFERENCES raza (id_raza),
    id_estado_mental            INTEGER REFERENCES estado_mental (id_estado_mental),
    id_duenio                   INTEGER REFERENCES duenio (id_duenio),
    PRIMARY KEY (no_registro)
);

CREATE TABLE visita (
    id_visita                   INTEGER,
    fecha                       TIMESTAMP,
    costo_evaluacion            DECIMAL(7,2),
    id_duenio                   INTEGER REFERENCES duenio (id_duenio),
    PRIMARY KEY (id_visita)
);

CREATE TABLE problemas (
    id_problema                 INTEGER,
    descripcion                 VARCHAR2(200),
    PRIMARY KEY (id_problema)
);

CREATE TABLE tratamientos (
    id_tratamiento              INTEGER,
    descripcion                 VARCHAR2(200),
    PRIMARY KEY (id_tratamiento)
);

CREATE TABLE solucion (
    id_solucion                 INTEGER,
    no_perro                    INTEGER REFERENCES perro (no_registro),
    id_problema                 INTEGER REFERENCES problemas (id_problema),
    id_tratamiento              INTEGER REFERENCES tratamientos (id_tratamiento),
    id_visita                   INTEGER REFERENCES visita (id_visita),
    fecha                       TIMESTAMP,
    PRIMARY KEY (id_solucion)
);

CREATE TABLE pais (
    id_pais                     INTEGER,
    nombre                      VARCHAR2(100),
    capital                     VARCHAR2(100),
    PRIMARY KEY (id_pais)
);

CREATE TABLE estacion_televisiva (
    id_estacion                 INTEGER,
    nombre                      VARCHAR2(100),
    descripcion                 VARCHAR2(100),
    canal                       NUMBER,
    id_pais                     INTEGER REFERENCES pais(id_pais),
    PRIMARY KEY (id_estacion)
);

CREATE TABLE transmision (
    id_transmision              INTEGER,
    fecha_transmision           TIMESTAMP,
    audiencia                   INTEGER,
    ganancia                    DECIMAL(7,2),
    id_cliente                  INTEGER REFERENCES duenio (id_duenio),
    id_estacion                 INTEGER REFERENCES estacion_televisiva (id_estacion),
    PRIMARY KEY (id_transmision)
);
