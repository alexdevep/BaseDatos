

CREATE TABLE paisanas (
	id_ciudad INTEGER,
	nombre VARCHAR(60) UNIQUE NOT NULL,
	id_pais INTEGER REFERENCES Pais(id_pais),
	PRIMARY KEY (id_ciudad)
);
