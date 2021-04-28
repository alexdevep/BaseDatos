
-- Modelo Relacional

CREATE TABLE Pais (
	id_pais SERIAL,
	nombre VARCHAR(60) UNIQUE NOT NULL,
	PRIMARY KEY (id_pais)
);

CREATE TABLE Ciudad (
	id_ciudad SERIAL,
	nombre VARCHAR(60) NOT NULL,
	id_pais INTEGER REFERENCES Pais(id_pais),
	PRIMARY KEY (id_ciudad)
);

CREATE TABLE Distrito (
	id_distrito SERIAL,
	direccion VARCHAR(150),
	cod_postal VARCHAR(15),
	id_ciudad INTEGER REFERENCES Ciudad(id_ciudad),
	PRIMARY KEY (id_distrito)
);

CREATE TABLE Clientes (
	id_cliente SERIAL,
	nombre VARCHAR(25),
	apellido VARCHAR(25),
	correo VARCHAR(50),
	fecha_registro VARCHAR(25),
	estado VARCHAR(5),
	id_distrito INTEGER REFERENCES Distrito(id_distrito),
	PRIMARY KEY (id_cliente)
);

CREATE TABLE Empleados (
	id_empleado SERIAL,
	nombre VARCHAR(50),
	apellido VARCHAR(50),
	correo VARCHAR(50),
	estado VARCHAR(5),
	id_distrito INTEGER REFERENCES Distrito(id_distrito),
	PRIMARY KEY (id_empleado)
);

CREATE TABLE Clasificacion (
	id_clasificacion SERIAL,
	descripcion VARCHAR(15) UNIQUE,
	PRIMARY KEY (id_clasificacion)
);

CREATE TABLE Pelicula (
	id_pelicula SERIAL,
	titulo VARCHAR(50),
	descripcion VARCHAR(300),
	anio_lanzamiento VARCHAR(10),
	duracion INTEGER,
	cant_dias_renta INTEGER,
	precio_renta NUMERIC(7,2),
	cargo_estado NUMERIC(7,2),
	costo_por_anio NUMERIC(7,2),
	id_clasificacion INTEGER REFERENCES Clasificacion(id_clasificacion),
	PRIMARY KEY (id_pelicula)
);

CREATE TABLE Lenguaje (
	id_lenguaje SERIAL,
	descripcion VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_lenguaje)
);

CREATE TABLE Actores (
	id_actor SERIAL,
	nombre VARCHAR(25),
	apellido VARCHAR(25),
	PRIMARY KEY (id_actor)
);

CREATE TABLE Categorias (
	id_categoria SERIAL,
	descripcion VARCHAR(50),
	PRIMARY KEY (id_categoria)
);

CREATE TABLE Traducciones (
	id_lenguaje INTEGER REFERENCES Lenguaje(id_lenguaje),
	id_pelicula INTEGER REFERENCES Pelicula(id_pelicula),
	PRIMARY KEY (id_lenguaje,id_pelicula)
);

CREATE TABLE Reparto (
	id_reparto SERIAL,
	id_actor INTEGER REFERENCES Actores(id_actor),
	id_pelicula INTEGER REFERENCES Pelicula(id_pelicula),
	PRIMARY KEY (id_reparto)
);

CREATE TABLE Det_peli_cat (
	id_categoria INTEGER REFERENCES Categorias(id_categoria),
	id_pelicula INTEGER REFERENCES Pelicula(id_pelicula),
	PRIMARY KEY (id_categoria,id_pelicula)
);

CREATE TABLE Tienda (
	id_tienda SERIAL,
	nombre VARCHAR(25) NOT NULL,
	id_distrito INTEGER REFERENCES Distrito(id_distrito),
	id_jefe INTEGER REFERENCES Empleados(id_empleado) NOT NULL,
	PRIMARY KEY (id_tienda)
);

CREATE TABLE Inventario (
	id_pelicula INTEGER REFERENCES Pelicula(id_pelicula),
	id_tienda INTEGER REFERENCES Tienda(id_tienda),
	cantidad INTEGER,
	PRIMARY KEY (id_pelicula,id_tienda)
);

CREATE TABLE Autorizacion (
	id_autorizacion SERIAL,
	usuario VARCHAR(50) UNIQUE,
	contrasenia VARCHAR(100) NOT NULL,
	id_tienda INTEGER REFERENCES Tienda(id_tienda),
	id_empleado INTEGER REFERENCES Empleados(id_empleado),
	PRIMARY KEY (id_autorizacion)
);

CREATE TABLE Renta (
	id_renta SERIAL,
	fecha_renta VARCHAR(50),
	fecha_devuelta VARCHAR(50),
	fecha_pago VARCHAR(50),
	id_autorizacion INTEGER REFERENCES Autorizacion(id_autorizacion) NOT NULL,
	id_tienda INTEGER REFERENCES Tienda(id_tienda) NOT NULL,
	id_cliente INTEGER REFERENCES Clientes(id_cliente) NOT NULL,
	PRIMARY KEY (id_renta)
);

CREATE TABLE Detalle_renta (
	id_detalle_renta SERIAL,
	cantidad INTEGER,
	precio NUMERIC(7,2),
	id_renta INTEGER REFERENCES Renta(id_renta) NOT NULL,
	id_pelicula INTEGER REFERENCES Pelicula(id_pelicula) NOT NULL,
	PRIMARY KEY (id_detalle_renta)
);

