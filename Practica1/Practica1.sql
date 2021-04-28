/*Version de DBMS*/
select * from v$version; 

/*Creando las entidades*/

CREATE TABLE establo (
    id_establo                  INTEGER,
    nombre                      VARCHAR2(100),
    direcion                    VARCHAR2(500),
    PRIMARY KEY (id_establo)
);

CREATE TABLE tipo_empleado (
    id_tipo_empleado            INTEGER,
    descripcion                 VARCHAR2(100),
    PRIMARY KEY (id_tipo_empleado)
);

CREATE TABLE empleado (
    id_empleado                 INTEGER,
    nombre                      VARCHAR2(100),
    direccion                   VARCHAR2(500),
    no_telefono                 VARCHAR2(25),
    id_establo                  INTEGER REFERENCES establo (id_establo),
    id_tipo                     INTEGER REFERENCES tipo_empleado (id_tipo_empleado),
    PRIMARY KEY (id_empleado)
);

CREATE TABLE peso_jinete (
    id_peso_jinete              INTEGER,
    peso                        DECIMAL(7,2),
    fecha                       TIMESTAMP,
    id_jinete                   INTEGER REFERENCES empleado (id_empleado)
);

CREATE TABLE propietario (
    id_propietario              INTEGER,
    nombre                      VARCHAR2(100),
    apellido                    VARCHAR2(100),
    PRIMARY KEY (id_propietario)
);

CREATE TABLE tipo_caballo (
    id_tipo_caballo             INTEGER,
    descripcion                 VARCHAR2(100),
    PRIMARY KEY (id_tipo_caballo)
);

CREATE TABLE caballo (
    reg_caballo                 INTEGER,
    nombre                      VARCHAR2(200),
    genero                      VARCHAR2(2),
    id_tipo_caballo             INTEGER REFERENCES tipo_caballo (id_tipo_caballo),
    id_madre                    INTEGER NULL REFERENCES caballo (reg_caballo),
    id_padre                    INTEGER NULL REFERENCES caballo (reg_caballo),
    id_entrenador               INTEGER REFERENCES empleado (id_empleado),
    PRIMARY KEY (reg_caballo)
);

CREATE TABLE propietario_actual (
    reg_caballo                 INTEGER REFERENCES caballo (reg_caballo),
    id_propietario              INTEGER REFERENCES propietario (id_propietario),
    precio_compra               DECIMAL(7,2),
    porcentaje_propiedad        INTEGER,
    PRIMARY KEY (reg_caballo,id_propietario)
);

CREATE TABLE pistas (
    id_pista                   INTEGER,
    nombre_pista                VARCHAR2(100),
    PRIMARY KEY (id_pista)
);

CREATE TABLE carrera (
    id_carrera                  INTEGER,
    fecha                       TIMESTAMP,
    id_pista                    INTEGER REFERENCES pistas (id_pista),
    PRIMARY KEY (id_carrera)
);

CREATE TABLE lista_carrera_dia (
    id_lista                    INTEGER,
    carrera_numero              INTEGER,
    id_carrera 					INTEGER REFERENCES carrera (id_carrera),
    PRIMARY KEY (id_lista)
);

CREATE TABLE cartera (
    id_lista                    INTEGER,
    reg_caballo                 INTEGER REFERENCES caballo (reg_caballo),
    dinero_ganado               DECIMAL(7,2),
    PRIMARY KEY (id_lista)
);

CREATE TABLE entradas (
    id_entrada                  INTEGER,
    id_lista                    INTEGER REFERENCES lista_carrera_dia (id_lista),
    reg_caballo                 INTEGER REFERENCES caballo (reg_caballo),
    id_jinete                   INTEGER REFERENCES empleado (id_empleado),
    posicion_puerta             INTEGER,
    pos_fin_carrera             INTEGER,
    PRIMARY KEY (id_entrada)
);

