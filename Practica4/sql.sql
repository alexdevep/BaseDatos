
-- MODELO RELACIONAL
CREATE TABLE Departamento(
	cod_depto SERIAL,
	nombre VARCHAR(25) UNIQUE NOT NULL,
	PRIMARY KEY (cod_depto)
);

CREATE TABLE Municipio(
	cod_municipio SERIAL,
	nombre VARCHAR(50) NOT NULL,
	cod_depto INTEGER REFERENCES Departamento(cod_depto) NOT NULL,
	PRIMARY KEY (cod_municipio)
);

CREATE TABLE Estado_civil(
	id_estado_civil SERIAL,
	nombre VARCHAR(20) UNIQUE NOT NULL, --Soltero,casado,viudo...
	PRIMARY KEY (id_estado_civil)
);

CREATE TABLE Persona(
	cui_persona NUMERIC UNIQUE NOT NULL,
	acta_nacimiento INTEGER,
	nombre1 VARCHAR(25) NOT NULL,
	nombre2 VARCHAR(25),
	nombre3 VARCHAR(25),
	apellido1 VARCHAR(25) NOT NULL,
	apellido2 VARCHAR(25),
	cui_padre NUMERIC,
	cui_madre NUMERIC,
	fecha_nacimiento DATE NOT NULL,
	genero CHAR NOT NULL,
	cod_municipio INTEGER REFERENCES Municipio(cod_municipio) NOT NULL,
	estado_civil INTEGER REFERENCES Estado_civil(id_estado_civil),
	PRIMARY KEY (cui_persona)
);

ALTER TABLE Persona 
	ADD CONSTRAINT ck_genero
	CHECK (genero IN ('M', 'F'));

ALTER TABLE Persona
	ADD CONSTRAINT fk_cui_padre
	FOREIGN KEY (cui_padre) 
	REFERENCES Persona(cui_persona);
	
ALTER TABLE Persona
	ADD CONSTRAINT fk_cui_madre
	FOREIGN KEY (cui_madre) 
	REFERENCES Persona(cui_persona);

CREATE TABLE Rep_dpi(
	id_correlativo SERIAL,
	fecha_emision DATE NOT NULL,
	municipio_reside INTEGER REFERENCES Municipio(cod_municipio) NOT NULL,
	cui_persona NUMERIC REFERENCES Persona(cui_persona) NOT NULL,
	PRIMARY KEY(id_correlativo)
);

CREATE TABLE Acta_defuncion(
	no_acta SERIAL,
	fecha_fallecio DATE NOT NULL,
	motivo VARCHAR(200),
	cui_difunto NUMERIC REFERENCES Persona(cui_persona) UNIQUE NOT NULL,
	PRIMARY KEY(no_acta)
);

CREATE TABLE Acta_matrimonio(
	no_acta SERIAL,
	dpi_esposo NUMERIC REFERENCES Persona(cui_persona) NOT NULL,
	dpi_esposa NUMERIC REFERENCES Persona(cui_persona) NOT NULL,
	fecha DATE NOT NULL,
	PRIMARY KEY(no_acta)
);

CREATE TABLE Acta_divorcio(
	no_acta SERIAL,
	dpi_esposo NUMERIC REFERENCES Persona(cui_persona) NOT NULL,
	dpi_esposa NUMERIC REFERENCES Persona(cui_persona) NOT NULL,
	acta_matrimonio INTEGER REFERENCES Acta_matrimonio(no_acta) NOT NULL,
	fecha DATE NOT NULL,
	PRIMARY KEY(no_acta)
);

CREATE TABLE Tipo_licencia(
	tipo CHAR UNIQUE NOT NULL, --A,B,C,M,E
	descripcion VARCHAR(400),
	PRIMARY KEY (tipo)
);

ALTER TABLE Tipo_licencia 
	ADD CONSTRAINT ck_tipo_licencia
	CHECK (tipo IN ('A','B','C','M','E'));

CREATE TABLE Licencia(
	id_licencia SERIAL,
	cui_persona NUMERIC REFERENCES Persona(cui_persona) NOT NULL,
	licencia_tipo CHAR REFERENCES Tipo_licencia(tipo) NOT NULL,
	licencia_activa BOOLEAN,
	licencia_suspendida BOOLEAN,
	PRIMARY KEY(id_licencia)
);

CREATE TABLE Renovar_licencia(
	correlativo SERIAL,
	id_licencia INTEGER REFERENCES Licencia(id_licencia) NOT NULL,
	fecha_renovacion DATE,
	fecha_caduca DATE,
	tiempo_en_anios INTEGER, --Acepta entre 1 y 5 años
	fecha_inicia_anulacion VARCHAR(25),
	fecha_fin_anulacion VARCHAR(25),
	licencia_tipo CHAR REFERENCES Tipo_licencia(tipo) NOT NULL,
	renovacion_activa BOOLEAN NOT NULL,
	PRIMARY KEY(correlativo)
);

ALTER TABLE Renovar_licencia 
	ADD CONSTRAINT ck_renovacion
	CHECK (tiempo_en_anios>=1 AND tiempo_en_anios<=5);


-- ELIMINAR TODA LA ER
DROP TABLE Renovar_licencia;
DROP TABLE Licencia;
DROP TABLE Tipo_licencia;
DROP TABLE Acta_divorcio;
DROP TABLE Acta_matrimonio;
DROP TABLE Acta_defuncion;
DROP TABLE Rep_dpi;
DROP TABLE Persona;
DROP TABLE Estado_civil;
DROP TABLE Municipio;
DROP TABLE Departamento;

-- INSERTANDO DATOS NECESARIOS PARA OPERAR
INSERT INTO Estado_civil(nombre)
	VALUES ('Solter@'),
			('Casad@'),
			('Viud@'),
			('Divorciad@');

INSERT INTO Tipo_licencia(tipo,descripcion)
	VALUES ('A','La licencia tipo A es aquella que permite conducir vehículos de transporte que tenga una carga de más de 3.5 toneladas métricas, incluyendo transporte escolar, colectivo, urbano y extraurbano. Para obtener este tipo de licencia, se tiene que ser mayor de 25 años y haber tenido licencia tipo B o C por más de 3 años.'),
			('B','La licencia tipo B es aquella que permite al conductor manejar toda clase de automóviles de hasta 3.5 toneladas métricas de peso bruto y pueden recibir remuneración o pago por conducir. Para obtener esta licencia, es necesario ser mayor de 23 años y haber tenido 2 años la licencia tipo C.'),
			('C','Este tipo de licencia es la más común y es la que se otorga al sacar la primera licencia. No necesita ninguna edad mínima ni haber tenido otro tipo de licencia. Permite, sin recibir remuneración o pago, manejar todo tipo de automóviles, páneles, pick-ups con o sin remolques que tengan un peso máximo de 3.5 toneladas métricas de peso.'),
			('M','Este tipo de licencia únicamente permite manejar motocicletas o moto bicicletas.'),
			('E','La licencia tipo E permite a la persona conducir maquinaria agrícola e industrial, únicamente. Con este tipo de licencia, no se puede manejar cualquier otro vehículo.');

INSERT INTO Departamento(nombre)
	VALUES ('Alta Verapaz'),
			('Baja Verapaz'),
			('Chimaltenango'),
			('Chiquimula'),
			('El Progreso'),
			('Escuintla'),
			('Guatemala'),
			('Huehuetenango'),
			('Izabal'),
			('Jalapa'),
			('Jutiapa'),
			('Petén'),
			('Quetzaltenango'),
			('Quiché'),
			('Retalhuleu'),
			('Sacatepéquez'),
			('San Marcos'),
			('Santa Rosa'),
			('Sololá'),
			('Suchitepéquez'),
			('Totonicapán'),
			('Zacapa');

INSERT INTO Municipio(nombre,cod_depto)
	VALUES ('Cobán',1),
			('Santa Cruz Verapaz',1),
			('San Cristóbal Verapaz',1),
			('Tactic',1),
			('Tamahú',1),
			('Salamá',2),
			('San Miguel Chicaj',2),
			('Rabinal',2),
			('Cubulco',2),
			('Chimaltenango',3),
			('San José Poaquil',3),
			('San Martín Jilotepeque',3),
			('San Juan Comalapa',3),
			('Tecpán',3),
			('Chiquimula',4),
			('Jocotán',4),
			('Esquipulas',4),
			('Camotán',4),
			('Quezaltepeque',4),
			('Ipala',4),
			('Guastatoya',5),
			('Morazán',5),
			('San Agustín Acasaguastlán',5),
			('San Antonio La Paz',5),
			('Sanarate',5),
			('Escuintla',6),
			('Santa Lucía Cotzumalguapa',6),
			('La Democracia',6),
			('Siquinalá',6),
			('Tiquisate',6),
			('La Gomera',6),
			('Guatemala',7),
			('Amatitlán',7),
			('Villa Nueva',7),
			('Villa Canales',7),
			('San Juan Sacatepéquez',7),
			('San Miguel Petapa',7),
			('Huehuetenango',8),
			('Santa Bárbara',8),
			('San Juan Atitlán',8),
			('Aguacatán',8),
			('Colotenango',8),
			('Puerto Barrios',9),
			('Morales',9),
			('Livingston',9),
			('Los Amates',9),
			('Jalapa',10),
			('San Pedro Pinula',10),
			('San Luis Jilotepeque',10),
			('Mataquescuintla',10),
			('Jutiapa',11),
			('El Progreso',11),
			('Comapa',11),
			('Pasaco',11),
			('Zapotitlán',11),
			('Flores',12),
			('San José',12),
			('San Francisco',12),
			('Poptún',12),
			('Santa Ana',12),
			('Quetzaltenango',13),
			('Almolonga',13),
			('San Martín Sacatepéquez',13),
			('El Palmar',13),
			('Santa Cruz del Quiché',14),
			('San Pedro Jocopilas',14),
			('San Juan Cotzal',14),
			('Retalhuleu',15),
			('San Sebastián',15),
			('San Felipe',15),
			('Antigua Guatemala',16),
			('Jocotenango',16),
			('San Lucas Sacatepéquez',16),
			('San Marcos',17),
			('El Tumblador',17),
			('Malacatán',17),
			('Cuilapa ',18),
			('Chiquimulilla',18),
			('Taxisco',18),
			('Sololá',19),
			('Concepción',19),
			('Panajachel',19),
			('Mazatenango',20),
			('San Antonio Suchitépequez',20),
			('Samayac',20),
			('Totonicapán',21),
			('San Cristóbal Totonicapán',21),
			('Momostenango',21),
			('Zacapa',22),
			('Cabañas',22),
			('San Jorge',22);


--==========================================================================================--
--                        PROCEDIMIENTO PARA GENERAR EL CUI                                 --
--==========================================================================================--
CREATE OR REPLACE FUNCTION Registro_random(low NUMERIC ,high NUMERIC,cod_busca INT) RETURNS VARCHAR AS $$
DECLARE 
	departamento INT;
	cui_reg VARCHAR;
BEGIN
	departamento := (SELECT cod_depto FROM Municipio WHERE cod_municipio=cod_busca);
	
	IF departamento IS NULL THEN
		RETURN NULL;
	END IF;
	
	IF cod_busca < 10 THEN
		cui_reg := CONCAT('0',cod_busca);	
	ELSE
		cui_reg := CONCAT(cod_busca);
	END IF;
	
	IF departamento < 10 THEN
		cui_reg := CONCAT('0',departamento,cui_reg);
	ELSE
		cui_reg := CONCAT(departamento,cui_reg);
	END IF;
	
   	RETURN CONCAT(floor(random()* (high-low + 1) + low),cui_reg);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION Registro_random;

SELECT Registro_random(100000000,999999999,6);


--==========================================================================================--
--                     PROCEDIMIENTO PARA REGISTRAR NACIMIENTO                              --
--==========================================================================================--
CREATE OR REPLACE FUNCTION AddNacimiento(dpi_p NUMERIC,
										 	dpi_m NUMERIC,
											primer_n VARCHAR,
											segundo_n VARCHAR,
											tercer_n VARCHAR,
											fecha_n DATE,
											codigo_m INT,
											genero_ CHAR) RETURNS TABLE (j json) AS $$
DECLARE
	cui VARCHAR; 
	apellido_1 VARCHAR;
	apellido_2 VARCHAR;
BEGIN
	cui := (SELECT Registro_random(100000000,999999999,codigo_m));
	
	IF LENGTH(cui) < 14 AND cui IS NOT NULL THEN
		
		IF (SELECT COUNT(cui_persona) FROM Persona WHERE cui_persona=CAST(cui AS NUMERIC)) = 0 THEN
			
			
			IF dpi_p IS NOT NULL OR dpi_m IS NOT NULL THEN
								
				IF dpi_p IS NOT NULL THEN
					
					apellido_1 :=(SELECT apellido1 FROM Persona WHERE cui_persona=dpi_p AND genero='M');
					apellido_2 :=(SELECT apellido1 FROM Persona WHERE cui_persona=dpi_m AND genero='F');
					
					IF apellido_1 IS NOT NULL THEN
						
						IF apellido_2 IS NOT NULL THEN
							INSERT INTO Persona(cui_persona,nombre1,nombre2,nombre3,apellido1,apellido2,cui_padre,cui_madre,fecha_nacimiento,genero,cod_municipio,estado_civil)
								VALUES (CAST(cui AS NUMERIC),primer_n,segundo_n,tercer_n,apellido_1,apellido_2,dpi_p,dpi_m,fecha_n,genero_,codigo_m,NULL);

							--RETURN CONCAT('{ estado: 200, mensaje: "La operación se realizó con éxito" }');
							RETURN QUERY SELECT json_build_object('estado',200,'mensaje','La operación se realizó con éxito');
						ELSIF dpi_m IS NULL THEN
							INSERT INTO Persona(cui_persona,nombre1,nombre2,nombre3,apellido1,apellido2,cui_padre,cui_madre,fecha_nacimiento,genero,cod_municipio,estado_civil)
								VALUES (CAST(cui AS NUMERIC),primer_n,segundo_n,tercer_n,apellido_1,apellido_2,dpi_p,NULL,fecha_n,genero_,codigo_m,NULL);

							--RETURN CONCAT('{ estado: 200, mensaje: "La operación se realizó con éxito" }');
							RETURN QUERY SELECT json_build_object('estado',200,'mensaje','La operación se realizó con éxito');
						ELSE 
							--RETURN CONCAT('{ estado: 404, mensaje: "Error: DPI de la madre es incorrecto" }');
							RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: DPI de la madre es incorrecto');
						END IF;	
					ELSE 
						--RETURN CONCAT('{ estado: 404, mensaje: "Error: DPI del padre es incorrecto" }');
						RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: DPI del padre es incorrecto');
					END IF;						
				ELSE
					apellido_1 :=(SELECT apellido1 FROM Persona WHERE cui_persona=dpi_m AND genero='F');
					
					IF apellido_1 IS NOT NULL THEN
						INSERT INTO Persona(cui_persona,nombre1,nombre2,nombre3,apellido1,apellido2,cui_padre,cui_madre,fecha_nacimiento,genero,cod_municipio,estado_civil)
							VALUES (CAST(cui AS NUMERIC),primer_n,segundo_n,tercer_n,apellido_1,NULL,NULL,dpi_m,fecha_n,genero_,codigo_m,NULL);	
						
						--RETURN CONCAT('{ estado: 200, mensaje: "La operación se realizó con éxito" }');
						RETURN QUERY SELECT json_build_object('estado',200,'mensaje','La operación se realizó con éxito');
					ELSE 
						--RETURN CONCAT('{ estado: 404, mensaje: "Error: DPI de la madre es incorrecto" }');
						RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: DPI de la madre es incorrecto');
					END IF;
				END IF;				
			ELSE
				--RETURN CONCAT('{ estado: 500, mensaje: "Error agregar nacimiento: debe ingresar al menos un dpi padre o madre" }');
				RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error agregar nacimiento: debe ingresar al menos un dpi padre o madre');
			END IF;
		ELSE
			--RETURN CONCAT('{ estado: 404, mensaje: "Error: el CUI generado ya existe" }');
			RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: el CUI generado ya existe');
		END IF;		
	ELSE
		--RETURN CONCAT('{ estado: 500, mensaje: "Error al generar CUI: el codigo del municipio no existe" }');
		RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error al generar CUI: el codigo del municipio no existe');
	END IF;		
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION AddNacimiento;

					--****************************
					-- CREANDO PRIMERA GENERACION
					--****************************
INSERT INTO Persona
	VALUES (1234567890123,NULL,'Torrhen',NULL,NULL,'Stark','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890124,NULL,'Leia',NULL,NULL,'Ashford','Unknow',NULL,NULL,'10-10-1810','F',1,2);
INSERT INTO Persona
	VALUES (1234567890125,NULL,'Aegon',NULL,NULL,'Targaryen','Unknow',NULL,NULL,'10-10-1810','M',1,1);
INSERT INTO Persona
	VALUES (1234567890126,NULL,'Raenys',NULL,NULL,'Targaryen','Unknow',NULL,NULL,'10-10-1810','F',1,1);
INSERT INTO Persona
	VALUES (1234567890127,NULL,'Visenya',NULL,NULL,'Targaryen','Unknow',NULL,NULL,'10-10-1810','F',1,1);
INSERT INTO Persona
	VALUES (1234567890128,NULL,'Morgan',NULL,NULL,'Martell','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890129,NULL,'Nymeria',NULL,NULL,'Dayne','Unknow',NULL,NULL,'10-10-1810','F',1,2);
INSERT INTO Persona
	VALUES (1234567890110,NULL,'Lann',NULL,NULL,'Lannister','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890111,NULL,'Melissa',NULL,NULL,'Blackwood','Unknow',NULL,NULL,'10-10-1810','F',1,2);
INSERT INTO Persona
	VALUES (1234567890112,NULL,'Jeor',NULL,NULL,'Mormont','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890113,NULL,'Lynesse',NULL,NULL,'Bracken','Unknow',NULL,NULL,'10-10-1810','F',1,2);
INSERT INTO Persona
	VALUES (1234567890114,NULL,'Orys',NULL,NULL,'Baratheon','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890115,NULL,'Melisandre',NULL,NULL,'Florent','Unknow',NULL,NULL,'10-10-1810','F',1,2);
INSERT INTO Persona
	VALUES (1234567890116,NULL,'Harlen',NULL,NULL,'Tyrell','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890117,NULL,'Leonette',NULL,NULL,'Fossoway','Unknow',NULL,NULL,'10-10-1810','F',1,2);
INSERT INTO Persona
	VALUES (1234567890118,NULL,'Artys',NULL,NULL,'Arryn','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890119,NULL,'Lysa',NULL,NULL,'Royce','Unknow',NULL,NULL,'10-10-1810','F',1,2);
INSERT INTO Persona
	VALUES (1234567890120,NULL,'Alleras',NULL,NULL,'Tully','Unknow',NULL,NULL,'10-10-1810','M',1,2);
INSERT INTO Persona
	VALUES (1234567890121,NULL,'Alyce',NULL,NULL,'Stermont','Unknow',NULL,NULL,'10-10-1810','F',1,2);

SELECT * FROM Persona;
DELETE FROM Persona;

					--****************************
					-- CREANDO SEGUNDA GENERACION
					--****************************
--Stark
SELECT AddNacimiento(1234567890123,1234567890124,'Rickard',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890124,'Mya',NULL,NULL,'05-12-1900',25,'F');
--Targaryen
SELECT AddNacimiento(1234567890125,1234567890126,'Aerys',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(1234567890125,1234567890127,'Rhaena',NULL,NULL,'05-12-1900',25,'F');
--Martell
SELECT AddNacimiento(1234567890128,1234567890129,'Doran',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890129,'Obara',NULL,NULL,'05-12-1900',25,'F');
--Lannister
SELECT AddNacimiento(1234567890110,1234567890111,'Twinn',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890111,'Joanna',NULL,NULL,'05-12-1900',25,'F');
--Mormot
SELECT AddNacimiento(1234567890112,1234567890113,'Jorah',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890113,'Daella',NULL,NULL,'05-12-1900',25,'F');
--Baratheon
SELECT AddNacimiento(1234567890114,1234567890115,'Steffon',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890115,'Cassana',NULL,NULL,'05-12-1900',25,'F');
--Tyrell
SELECT AddNacimiento(1234567890116,1234567890117,'Mace',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890117,'Olenna',NULL,NULL,'05-12-1900',25,'F');
--Arryn
SELECT AddNacimiento(1234567890118,1234567890119,'Jasper',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890119,'Emilia',NULL,NULL,'05-12-1900',25,'F');
--Tully
SELECT AddNacimiento(1234567890120,1234567890121,'Hoster',NULL,NULL,'05-12-1900',25,'M');
SELECT AddNacimiento(NULL,1234567890121,'Alysanne',NULL,NULL,'05-12-1900',25,'F');

					--****************************
					-- CREANDO TERCERA GENERACION
					--****************************
					SELECT AddMatrimonio(,'05-12-1925');
SELECT AddMatrimonio(,'25-05-1925');
SELECT AddMatrimonio(,'12-05-1925');
SELECT AddMatrimonio(,'05-07-1925');
SELECT AddMatrimonio(,'09-01-1925');
SELECT AddMatrimonio(,'11-02-1925');
SELECT AddMatrimonio(,'16-04-1925');
SELECT AddMatrimonio(,'18-04-1925');
SELECT AddMatrimonio(,'15-07-1925');
--Stark
SELECT AddNacimiento(3162324670525,1398726130525,'Eddard',NULL,NULL,'05-12-1930',25,'M');
SELECT AddNacimiento(3162324670525,1398726130525,'Lyanna',NULL,NULL,'05-12-1925',25,'F');
SELECT AddNacimiento(3162324670525,1398726130525,'Benjen',NULL,NULL,'05-12-1927',25,'M');
SELECT AddNacimiento(3162324670525,1398726130525,'Brandon',NULL,NULL,'05-12-1928',25,'M');
--Targaryen
SELECT AddNacimiento(8467680630525,6353320980525,'Rhaegar',NULL,NULL,'05-12-1925',25,'M');
SELECT AddNacimiento(8467680630525,6353320980525,'Viserys',NULL,NULL,'05-12-1930',25,'M');
SELECT AddNacimiento(8467680630525,6353320980525,'Daenerys',NULL,NULL,'05-12-1935',25,'F');
--Martell
SELECT AddNacimiento(5757502160525,9495949510525,'Arianne',NULL,NULL,'05-12-1930',25,'M');
SELECT AddNacimiento(5757502160525,9495949510525,'Quentyn',NULL,NULL,'05-12-1932',25,'M');
SELECT AddNacimiento(5757502160525,9495949510525,'Trystane',NULL,NULL,'05-12-1935',25,'M');
SELECT AddNacimiento(1234567890128,NULL,'Elia',NULL,NULL,'05-12-1900',25,'F');
--Lannister
SELECT AddNacimiento(2671870760525,9070282710525,'Cercei',NULL,NULL,'05-12-1930',25,'F');
SELECT AddNacimiento(2671870760525,9070282710525,'Jaime',NULL,NULL,'05-12-1930',25,'M');
SELECT AddNacimiento(2671870760525,9070282710525,'Tyrion',NULL,NULL,'05-12-1935',25,'M');
--Baratheon
SELECT AddNacimiento(2089245670525,8274316970525,'Robert',NULL,NULL,'05-12-1922',25,'M');
SELECT AddNacimiento(2089245670525,8274316970525,'Stannis',NULL,NULL,'05-12-1925',25,'M');
SELECT AddNacimiento(2089245670525,8274316970525,'Renly',NULL,NULL,'05-12-1928',25,'M');
--Tyrell
SELECT AddNacimiento(8778349580525,1578435430525,'Willas',NULL,NULL,'05-12-1922',25,'M');
SELECT AddNacimiento(8778349580525,1578435430525,'Garlan',NULL,NULL,'05-12-1925',25,'M');
SELECT AddNacimiento(8778349580525,1578435430525,'Loras',NULL,NULL,'05-12-1927',25,'M');
SELECT AddNacimiento(8778349580525,1578435430525,'Margaery',NULL,NULL,'05-12-1935',25,'F');
--Arryn
SELECT AddNacimiento(7163412370525,3649096370525,'Jhon',NULL,NULL,'05-12-1930',25,'M');
--Tully
SELECT AddNacimiento(7677334400525,3568792760525,'Edmure',NULL,NULL,'05-12-1925',25,'M');
SELECT AddNacimiento(7677334400525,3568792760525,'Lysa',NULL,NULL,'05-12-1930',25,'F');
SELECT AddNacimiento(7677334400525,3568792760525,'Catelyn',NULL,NULL,'05-12-1935',25,'F');
SELECT AddNacimiento(7677334400525,3568792760525,'Brynden',NULL,NULL,'05-12-1920',25,'M');

					--****************************
					-- CREANDO CUARTA GENERACION
					--****************************
--Stark
SELECT AddNacimiento(5700730740525,5642843370525,'Rob',NULL,NULL,'05-12-1960',25,'M');
SELECT AddNacimiento(5700730740525,5642843370525,'Jon',NULL,NULL,'05-12-1960',25,'M');
SELECT AddNacimiento(5700730740525,5642843370525,'Sansa',NULL,NULL,'05-12-1965',25,'F');
SELECT AddNacimiento(5700730740525,5642843370525,'Aria',NULL,NULL,'05-12-1968',25,'F');
SELECT AddNacimiento(5700730740525,5642843370525,'Bran',NULL,NULL,'05-12-1970',25,'M');
SELECT AddNacimiento(5700730740525,5642843370525,'Rickon',NULL,NULL,'05-12-1973',25,'M');
--Targaryen
SELECT AddNacimiento(2432044070525,7354023080525,'Eagon',NULL,NULL,'05-12-1960',25,'M');
SELECT AddNacimiento(2432044070525,7354023080525,'Raenys',NULL,NULL,'05-12-1965',25,'F');
--Baratheon
SELECT AddNacimiento(2363523650525,NULL,'Edric',NULL,NULL,'05-12-1968',25,'M');
SELECT AddNacimiento(2363523650525,4812565320525,'Joffrey',NULL,NULL,'05-12-1960',25,'M');
SELECT AddNacimiento(2363523650525,4812565320525,'Tommen',NULL,NULL,'05-12-1965',25,'M');
SELECT AddNacimiento(2363523650525,4812565320525,'Myrcela',NULL,NULL,'05-12-1970',25,'F');
--Arryn
SELECT AddNacimiento(2465146940525,5381543880525,'Robert',NULL,NULL,'05-12-1960',25,'M');
--Tully
SELECT AddNacimiento(7677334400525,3568792760525,'Edmure',NULL,NULL,'05-12-1960',25,'M');
SELECT AddNacimiento(7677334400525,3568792760525,'Lysa',NULL,NULL,'05-12-1960',25,'F');
SELECT AddNacimiento(7677334400525,3568792760525,'Catelyn',NULL,NULL,'05-12-1960',25,'F');
SELECT AddNacimiento(7677334400525,3568792760525,'Brynden',NULL,NULL,'05-12-1960',25,'M');

					
SELECT cui_persona,nombre1,apellido1 FROM Persona;
SELECT cui_persona,nombre1,estado_civil FROM Persona WHERE cui_padre=7677334400525 AND cui_madre=3568792760525;


--==========================================================================================--
--           PROCEDIMIENTO PARA SABER SI CUMPLE UN TIEMPO A PARTIR DE DOS FECHAS            --
--==========================================================================================--
CREATE OR REPLACE FUNCTION getTiempo(fecha_inicio_ DATE,
										fecha_fin_ DATE,
										tiempo_	INTEGER
									   		) RETURNS VARCHAR AS $$
		--**********************************************************
		-- Cumple todas las condiciones retorna 1
		-- No cumple con las condiciones de dia,mes,anio retorna -1
		--**********************************************************
DECLARE
	dpi_persona NUMERIC;
	dia INTEGER;
	mes INTEGER;
	anio INTEGER;
BEGIN
	
	SELECT date_part('day',fecha_fin_) - date_part('day',fecha_inicio_),
			date_part('month',fecha_fin_) - date_part('month',fecha_inicio_),
			date_part('year',fecha_fin_) - date_part('year',fecha_inicio_)
				INTO dia,mes,anio;
		
	IF (anio > tiempo_) THEN
		--RETURN CONCAT('{ estado: 200, mensaje: "SI ES MAYOR AL TIEMPO ESTIMADO" }');
		RETURN 1;
	ELSE 
		IF (anio >= tiempo_) THEN
			IF (mes >= 0) THEN
				IF (dia >= 0) THEN

					--RETURN CONCAT('dia: ',dia,' mes: ',mes,' anio: ',anio);
					--RETURN CONCAT('{ estado: 200, mensaje: "SI ES MAYOR AL TIEMPO ESTIMADO" }');
					RETURN 1;
				END IF;
				--RETURN CONCAT('{ estado: 404, mensaje: "Dia, No llega al tiempo solititado, es menor" }');	
				RETURN -1;
			END IF;
			--RETURN CONCAT('dia: ',dia,' mes: ',mes,' anio: ',anio);
			--RETURN CONCAT('{ estado: 404, mensaje: "Mes, No llega al tiempo solititado, es menor" }');	
			RETURN -1;
		END IF;
		--RETURN CONCAT('dia: ',dia,' mes: ',mes,' anio: ',anio);
		--RETURN CONCAT('{ estado: 404, mensaje: "Anio, No llega al tiempo solititado, es menor" }');	
		RETURN -1;
	END IF;
	--RETURN CONCAT('{ estado: 404, mensaje: "Anio, No llega al tiempo solititado, es menor" }');		
	RETURN -1;
	
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION getTiempo;

SELECT getTiempo('13-05-2004',NOW()::DATE,16); --(fecha_inicio,fecha_fin,tiempo_a_cumplir)
SELECT getTiempo('14-05-2004',NOW()::DATE,16); --(fecha_inicio,fecha_fin,tiempo_a_cumplir)
SELECT getTiempo('15-05-2004',NOW()::DATE,16); --(fecha_inicio,fecha_fin,tiempo_a_cumplir)
SELECT getTiempo('12-05-1930'::DATE,'12-02-1967'::DATE,1);
SELECT getTiempo('05-12-1920','06-12-1936',16)
--==========================================================================================--
--                          PROCEDIMIENTO PARA GENERAR DPI                                  --
--==========================================================================================--
CREATE OR REPLACE FUNCTION GenerarDPI(cui_ NUMERIC,
										fecha_emision_ DATE,
										municipio_ INTEGER
									   		) RETURNS VARCHAR AS $$
DECLARE
	dpi NUMERIC;
	fecha_nacio DATE;
	aceptable INTEGER;
BEGIN
	SELECT cui_persona,fecha_nacimiento INTO dpi,fecha_nacio 
		FROM Persona WHERE cui_persona=cui_;
	
	IF dpi IS NOT NULL THEN
		
		aceptable := (SELECT getTiempo(fecha_nacio,fecha_emision_,18));
		
		IF aceptable = 1 THEN
			SELECT cui_persona INTO dpi FROM Rep_dpi WHERE cui_persona=cui_;
		
			IF dpi IS NULL THEN
				--Registrando a la persona como mayor de edad
				INSERT INTO Rep_dpi(fecha_emision,municipio_reside,cui_persona)
					VALUES(fecha_emision_,municipio_,cui_);
				--Cambiando el estado civil de la persona a Solter@
				Update Persona 
					SET estado_civil=1 
					WHERE cui_persona=cui_;

				RETURN CONCAT('{ estado: 200, mensaje: "La operación se realizó con éxito" }');
			END IF;
			
			RETURN CONCAT('{ estado: 404, mensaje: "La persona ya posee dpi" }');
		END IF;
		
		RETURN CONCAT('{ estado: 404, mensaje: "La persona aun no es mayor de edad (18 años)" }');
	END IF;
	
	RETURN CONCAT('{ estado: 404, mensaje: "Error: el CUI ingresado no existe" }');	
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION GenerarDPI;

SELECT GenerarDPI(3162324670525,'05-12-1920',5); 
SELECT GenerarDPI(1398726130525,'05-12-1920',11); 
SELECT GenerarDPI(8467680630525,'05-12-1920',83); 
SELECT GenerarDPI(6353320980525,'05-12-1920',26); 
SELECT GenerarDPI(5757502160525,'05-12-1920',27); 
SELECT GenerarDPI(9495949510525,'05-12-1920',28); 
SELECT GenerarDPI(2671870760525,'05-12-1920',29); 
SELECT GenerarDPI(9070282710525,'05-12-1920',30); 
SELECT GenerarDPI(4697109760525,'05-12-1920',31); 
SELECT GenerarDPI(9419468150525,'05-12-1920',32); 
SELECT GenerarDPI(2089245670525,'05-12-1920',33); 
SELECT GenerarDPI(8274316970525,'05-12-1920',34); 
SELECT GenerarDPI(8778349580525,'05-12-1920',34); 
SELECT GenerarDPI(1578435430525,'05-12-1920',36); 
SELECT GenerarDPI(7163412370525,'05-12-1920',37); 
SELECT GenerarDPI(3649096370525,'05-12-1920',38); 
SELECT GenerarDPI(7677334400525,'05-12-1920',39); 
SELECT GenerarDPI(3568792760525,'05-12-1920',40); 

SELECT GenerarDPI(5700730740525,'12-11-1967',2);
SELECT GenerarDPI(4902644620525,'12-02-1957',21);
SELECT GenerarDPI(9152597170525,'12-02-1957',23);
SELECT GenerarDPI(2166194080525,'12-02-1957',24);
SELECT GenerarDPI(2432044070525,'12-02-1957',25);
SELECT GenerarDPI(4690389310525,'12-02-1957',26);
SELECT GenerarDPI(6000404930525,'12-02-1957',27);
SELECT GenerarDPI(1087968820525,'12-02-1957',28);
SELECT GenerarDPI(1977114610525,'12-02-1957',29);
SELECT GenerarDPI(9994602770525,'12-02-1957',28);
SELECT GenerarDPI(4812565320525,'12-02-1957',23);
SELECT GenerarDPI(1747726950525,'12-02-1957',23);
SELECT GenerarDPI(9795359550525,'12-02-1957',22);
SELECT GenerarDPI(2363523650525,'12-02-1957',23);
SELECT GenerarDPI(3318771140525,'12-02-1957',23);
SELECT GenerarDPI(2278169400525,'12-02-1957',53);
SELECT GenerarDPI(9774419030525,'12-02-1957',24);
SELECT GenerarDPI(2886829500525,'12-02-1957',45);
SELECT GenerarDPI(4144818380525,'12-02-1957',26);
SELECT GenerarDPI(1647979610525,'12-02-1957',29);
SELECT GenerarDPI(2465146940525,'12-02-1957',20);
SELECT GenerarDPI(3365723080525,'12-02-1957',20);
SELECT GenerarDPI(5381543880525,'12-02-1957',12);
SELECT GenerarDPI(5642843370525,'12-02-1957',12);
SELECT GenerarDPI(2728150170525,'12-02-1957',32);
SELECT GenerarDPI(7354023080525,'12-02-1937',32);


SELECT cui_persona,nombre1,apellido1,fecha_nacimiento FROM Persona WHERE cui_persona=5700730740525;
SELECT cui_persona,nombre1,apellido1,estado_civil FROM Persona;
SELECT * FROM Rep_dpi;
DELETE FROM Rep_dpi;


--==========================================================================================--
--                      PROCEDIMIENTO PARA ACTA DE MATRIMONIO                               --
--==========================================================================================--
CREATE OR REPLACE FUNCTION AddMatrimonio(esposo_ NUMERIC,
										 	esposa_ NUMERIC,
											fecha_ DATE
									   		) RETURNS VARCHAR AS $$
DECLARE
	dpi_esposo NUMERIC;
	estado_esposo INTEGER;
	death_esposo DATE;
	dpi_esposa NUMERIC;
	estado_esposa INTEGER;
	death_esposa DATE;
BEGIN
	SELECT cui_persona,estado_civil,fecha_fallecio INTO dpi_esposo,estado_esposo,death_esposo
		FROM Persona 
		LEFT JOIN Acta_defuncion
		ON cui_persona=cui_difunto
		WHERE cui_persona=esposo_ AND genero='M'; --Estado civil este en solter@,viud@ o Divorciad@
		
	SELECT cui_persona,estado_civil,fecha_fallecio INTO dpi_esposa,estado_esposa,death_esposa
		FROM Persona 
		LEFT JOIN Acta_defuncion
		ON cui_persona=cui_difunto
		WHERE cui_persona=esposa_ AND genero='F'; --Estado civil este en solter@,viud@ o Divorciad@
	
	IF dpi_esposo IS NOT NULL AND dpi_esposa IS NOT NULL THEN
		IF estado_esposo=1 OR estado_esposo=3 OR estado_esposo=4 THEN --Se evalua si estado civil hombre es Solter@:=1
			IF estado_esposa=1 OR estado_esposa=3 OR estado_esposa=4 THEN --Se evalua si estado civil mujer es Solter@:=1
				
				IF death_esposo IS NULL THEN
					IF death_esposa IS NULL THEN
					
						INSERT INTO Acta_matrimonio(dpi_esposo,dpi_esposa,fecha)
							VALUES(esposo_,esposa_,fecha_);
						--Se aplica el estado civil 2 que es casad@, a las personas con el CUI de esposos
						UPDATE Persona SET estado_civil=2 WHERE cui_persona=esposo_ OR cui_persona=esposa_; 
						RETURN CONCAT('{ estado: 200, mensaje: "La operación se realizó con éxito" }');
						
					END IF;
					RETURN CONCAT('{ estado: 404, mensaje: "Error: mujer ya fallecio" }');
				END IF;
				RETURN CONCAT('{ estado: 404, mensaje: "Error: hombre ya fallecio" }');
			END IF;
			RETURN CONCAT('{ estado: 404, mensaje: "Error: mujer no es mayor de edad o ya esta casado" }');
		END IF;
		RETURN CONCAT('{ estado: 404, mensaje: "Error: hombre no es mayor de edad o ya esta casado" }');
	END IF;
	RETURN CONCAT('{ estado: 404, mensaje: "Error: el CUI de alguno de los esposos no existe" }');
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION AddMatrimonio;

--Nota: No se pueden casar personas del mismo sexo, aqui no se ha permitido :v
SELECT AddMatrimonio(3162324670525,1398726130525,'05-12-1925');
SELECT AddMatrimonio(8467680630525,6353320980525,'25-05-1925');
SELECT AddMatrimonio(5757502160525,9495949510525,'12-05-1925');
SELECT AddMatrimonio(2671870760525,9070282710525,'05-07-1925');
SELECT AddMatrimonio(4697109760525,9419468150525,'09-01-1925');
SELECT AddMatrimonio(2089245670525,8274316970525,'11-02-1925');
SELECT AddMatrimonio(8778349580525,1578435430525,'16-04-1925');
SELECT AddMatrimonio(7163412370525,3649096370525,'18-04-1925');
SELECT AddMatrimonio(7677334400525,3568792760525,'15-07-1925');

SELECT AddMatrimonio(5700730740525,5642843370525,'15-07-1960');
SELECT AddMatrimonio(2432044070525,7354023080525,'15-07-1960');
SELECT AddMatrimonio(2363523650525,4812565320525,'15-07-1960');
SELECT AddMatrimonio(2465146940525,5381543880525,'15-07-1960');


SELECT AddMatrimonio(xxxxxxx,xxxxxxxxxxx,'15-07-1960');
SELECT AddMatrimonio(xxxxxxx,xxxxxxxxxxx,'15-07-1960');
SELECT AddMatrimonio(xxxxxxx,xxxxxxxxxxx,'15-07-1960');
SELECT AddMatrimonio(xxxxxxx,xxxxxxxxxxx,'15-07-1960');

SELECT cui_persona,nombre1,apellido1,fecha_nacimiento FROM Persona;
SELECT * FROM Acta_matrimonio;
SELECT * FROM Estado_civil;
SELECT * FROM Acta_defuncion;


--==========================================================================================--
--                       PROCEDIMIENTO PARA ACTA DE DIVORCIO                                --
--==========================================================================================--
CREATE OR REPLACE FUNCTION AddDivorcio(esposo_ NUMERIC,
										 	esposa_ NUMERIC,
											fecha_ DATE
									   		) RETURNS VARCHAR AS $$
DECLARE
	dpi NUMERIC;
	nomb VARCHAR;
	acta_m INTEGER;
BEGIN
	--Verifica si hay acta de matrimonio de esas dos personas
	IF (SELECT COUNT(no_acta) FROM Acta_matrimonio WHERE dpi_esposo=esposo_ AND dpi_esposa=esposa_) > 0 THEN
		
		--Trae el acta matrimonio no anulada(no divorciad@)
		SELECT ma.no_acta INTO acta_m
			FROM Acta_matrimonio ma
			LEFT JOIN Acta_divorcio di
			ON ma.no_acta=di.acta_matrimonio
			WHERE di.acta_matrimonio IS NULL AND ma.dpi_esposo=esposo_ AND ma.dpi_esposa=esposa_;
		
		IF acta_m IS NOT NULL THEN --Si es null, quiere decir que no estan casados
		
			--Anular matrimonio despues de un dia de la boda
			SELECT ma.no_acta INTO acta_m
				FROM Acta_matrimonio ma
				LEFT JOIN Acta_divorcio di
				ON ma.no_acta=di.acta_matrimonio
				WHERE di.acta_matrimonio IS NULL 
				AND ma.dpi_esposo=esposo_ 
				AND ma.dpi_esposa=esposa_ 
				AND ma.fecha<fecha_;
				
			IF acta_m IS NOT NULL THEN
			
				INSERT INTO Acta_divorcio(dpi_esposo,dpi_esposa,acta_matrimonio,fecha)
					VALUES(esposo_,esposa_,acta_m,fecha_);
			
				--Se aplica el estado civil 4 que es divorciad@, a las personas con el CUI de esposos
				UPDATE Persona SET estado_civil=4 WHERE cui_persona=esposo_ OR cui_persona=esposa_; 

				RETURN CONCAT('{ estado: 200, mensaje: "La operación se realizó con éxito" }');

			END IF;
			
			RETURN CONCAT('{ estado: 404, mensaje: "Error: Verificar fecha divorcio" }');
		END IF;
		RETURN CONCAT('{ estado: 404, mensaje: "Error: no se pueden divorciar ya que no estan casados" }');
	END IF;	
	RETURN CONCAT('{ estado: 404, mensaje: "Error: no existe acta de matrimonio entre estas personas" }');
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION AddDivorcio;

SELECT AddDivorcio(1234567890125,7802633712084,'15-05-2020'); --Divorcio despues del matrimonio
SELECT AddDivorcio(1234567890125,7802633712084,'12-05-2020'); --Divorcio mismo dia del matrimonio
SELECT AddDivorcio(1234567890125,7802633712084,'10-05-2020'); --Divorcio antes del matrimonio
SELECT AddDivorcio(1576218422084,7566801932084,'13-08-2020');

SELECT * FROM Persona;
SELECT * FROM Estado_civil;
SELECT * FROM Acta_divorcio;
SELECT * FROM Acta_matrimonio;
DELETE FROM Acta_divorcio;


--==========================================================================================--
--                       PROCEDIMIENTO PARA ACTA DE DEFUNCION                               --
--==========================================================================================--
CREATE OR REPLACE FUNCTION AddDefuncion(cui_ NUMERIC,
										 	fecha_fallecio_ DATE,
											motivo_ VARCHAR
									   		) RETURNS VARCHAR AS $$
DECLARE
	acta_mat INTEGER;
	difunto_h NUMERIC;
	difunto_m NUMERIC;
	acta_div INTEGER;
	dpi_vivito NUMERIC;
BEGIN
	
	IF (SELECT cui_persona FROM Persona WHERE cui_persona=cui_) IS NOT NULL THEN
	
		--Trae el acta matrimonio no anulada(no divorciad@)
		SELECT ma.no_acta,ma.dpi_esposo,ma.dpi_esposa,di.no_acta INTO acta_mat,difunto_h,difunto_m,acta_div
			FROM Acta_matrimonio ma
			LEFT JOIN Acta_divorcio di
			ON ma.no_acta=di.acta_matrimonio
			WHERE di.acta_matrimonio IS NULL AND ma.dpi_esposo=cui_ OR ma.dpi_esposa=cui_;
		
		IF acta_div IS NULL THEN --Si estaba casado actualmente
		
			IF difunto_h=cui_ THEN --Fallecio esposo
				dpi_vivito := difunto_m;
			ELSE --Fallecio esposa
				dpi_vivito := difunto_h;
			END IF;
			
			--Se establece estado civil de viud@ del conyuge del difunto
			UPDATE Persona SET estado_civil=3 WHERE cui_persona=dpi_vivito;
			--Se realiza el acta de divorcio del fallecido con su conyuge
			INSERT INTO Acta_divorcio(dpi_esposo,dpi_esposa,acta_matrimonio,fecha)
					VALUES(difunto_h,difunto_m,acta_mat,fecha_fallecio_);
			
		END IF;
		
		--Se establece estado civil de solter@ al difunto
		UPDATE Persona SET estado_civil=1 WHERE cui_persona=cui_;
		--Se da de baja la licencia de conducir del difunto
		UPDATE Licencia SET licencia_activa=FALSE WHERE cui_persona=cui_;
		--Se establece la fecha de muerte y motivo en el acta de defuncion
		INSERT INTO Acta_defuncion(fecha_fallecio,motivo,cui_difunto)
			VALUES(fecha_fallecio_,motivo_,cui_);
		
		--RETURN CONCAT('{ estado: 200, mensaje: "NO CASADO" }');
		RETURN CONCAT('{ estado: 200, mensaje: "La operación se realizó con éxito" }');
		
	END IF;
	RETURN CONCAT('{ estado: 500, mensaje: "Error: el CUI ingresado no existe" }');	
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION AddDefuncion;

SELECT AddDefuncion(8274316970525,'15-07-2019','Se hizo la automorision'); --Anula la licencia, y si esta casad@ pasa a ser viudo/soltero
SELECT AddDefuncion(3162324670525,'15-02-2019','Se hizo la automorision');
SELECT AddDefuncion(6353320980525,'15-02-2019','Se hizo la automorision');


SELECT * FROM Persona WHERE cui_persona=6353320980525;
SELECT * FROM Acta_defuncion;
SELECT * FROM Acta_divorcio;
SELECT * FROM Licencia;


--==========================================================================================--
--                          PROCEDIMIENTO PARA REGISTRAR LICENCIA                           --
--==========================================================================================--
CREATE OR REPLACE FUNCTION AddLicencia(cui_ NUMERIC,
										 	fecha_emision_ DATE,
											licencia_tipo_ VARCHAR
									   		) RETURNS TABLE (j json) AS $$
DECLARE
	dpi_persona NUMERIC;
	date_fallecio DATE;
	date_nacimiento DATE;
	aceptado INTEGER;
	no_licencia INTEGER;
	date_cad DATE;
BEGIN
	SELECT pe.cui_persona,def.fecha_fallecio,pe.fecha_nacimiento
			INTO dpi_persona,date_fallecio,date_nacimiento
		FROM Persona pe
		LEFT JOIN Acta_defuncion def
		ON pe.cui_persona=def.cui_difunto
		WHERE pe.cui_persona=cui_; 
		
	IF dpi_persona IS NOT NULL THEN
	
		IF licencia_tipo_='E' OR licencia_tipo_='C' OR licencia_tipo_='M' THEN
			IF date_fallecio IS NULL THEN
				--Evalua que la persona tenga mas de 16 anios
				aceptado := (SELECT getTiempo(date_nacimiento,fecha_emision_,16)); --(fecha_inicio,fecha_fin,tiempo_a_cumplir)

				IF aceptado = 1 THEN
					--Devuelve el dpi si esa persona no tiene actualmente una licencia del mismo tipo que se ingreso
					dpi_persona := (SELECT cui_persona FROM Licencia WHERE cui_persona=cui_ AND licencia_tipo=licencia_tipo_);

					IF dpi_persona IS NULL THEN
						--Creando la licencia
						INSERT INTO Licencia(cui_persona,licencia_tipo,licencia_activa,licencia_suspendida)
							VALUES(cui_,licencia_tipo_,TRUE,FALSE);

						--Obteniendo el id de la licencia que he creado
						SELECT id_licencia INTO no_licencia
							FROM Licencia
							WHERE cui_persona=cui_ AND licencia_tipo=licencia_tipo_;
						--Estableciendo la fecha en la que caduca la licencia
						SELECT (fecha_emision_ + INTERVAL'1 year')::DATE
								INTO date_cad;

						--Creando renovacion de la licencia, primera licencia vigencia de 1 anio
						INSERT INTO Renovar_licencia(id_licencia,fecha_renovacion,fecha_caduca,tiempo_en_anios,licencia_tipo,renovacion_activa)
							VALUES(no_licencia,fecha_emision_,date_cad,1,licencia_tipo_,TRUE);

						RETURN QUERY SELECT json_build_object('estado',200,'mensaje','La operación se realizó con éxito');

					END IF;
					RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: el CUI ingresado ya posee dpi');

				END IF;
				RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: la persona debe tener 16 años para solicitar licencia');

			END IF;
			RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: el CUI ingresado pertenece a una persona fallecida');
		END IF;
		RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: la primera licencia solo puede ser tipo E,C o M');	
	END IF;
	RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: el CUI ingresado no existe');
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION AddLicencia;

SELECT AddLicencia(7576218422084,'17-02-2000','C');
SELECT AddLicencia(5642843370525,'17-05-2019','M');
SELECT AddLicencia(7354023080525,'17-02-2000','M');


SELECT AddLicencia(7354023080525,'17-02-2000','C');
SELECT AddLicencia(2728150170525,'05-12-1936','C');
SELECT AddLicencia(2728150170525,'05-12-1946','M');
SELECT AddLicencia(2728150170525,'05-12-1946','E');


SELECT AddLicencia(2605664730525,'05-01-2020','C');
SELECT AddLicencia(2605664730525,'05-01-2020','M');
SELECT AddLicencia(2605664730525,'05-01-2020','E');

SELECT AddLicencia(5616057470525,'05-01-2020','C');
SELECT AddLicencia(5616057470525,'05-01-2020','M');
SELECT AddLicencia(5616057470525,'05-01-2020','E');


'1920-12-05'
SELECT getTiempo('05-12-1920','05-12-1930',16);

SELECT * FROM Licencia;
SELECT * FROM Renovar_licencia;
SELECT * FROM Persona WHERE cui_persona=5642843370525;


--==========================================================================================--
--                           PROCEDIMIENTO PARA RENOVAR LICENCIA                            --
--==========================================================================================--
CREATE OR REPLACE FUNCTION RenewLicencia(id_licencia_ INTEGER,
										 	fecha_renovacion_ DATE,
											licencia_tipo_ VARCHAR,
										 	tiempo_ INTEGER
									   		) RETURNS TABLE (j json) AS $$
DECLARE
	dpi_persona NUMERIC;
	licencia_ti	CHAR;
	licencia_act BOOLEAN;
	licencia_susp BOOLEAN;
	
	no_licencia INTEGER;
	date_cad DATE;
BEGIN
	SELECT cui_persona,licencia_activa 
			INTO dpi_persona,licencia_act
		FROM Licencia WHERE id_licencia=id_licencia_ LIMIT 1;
		
	IF dpi_persona IS NOT NULL THEN
	
		IF licencia_act=TRUE THEN
			
			IF licencia_tipo_='E' OR licencia_tipo_='M' THEN
			
				---
				
			ELSIF licencia_tipo_='C' OR licencia_tipo_='B' OR licencia_tipo_='A' THEN
			
			END IF;
			RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: tipo de licencia ingresada es incorrecta');
		END IF;
		RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: no es posible renovar licencia de fallecidos');
		
	END IF;
	RETURN QUERY SELECT json_build_object('estado',404,'mensaje','Error: el numero de licencia ingresado no existe');
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION RenewLicencia;

SELECT RenewLicencia(2,'12-05-2020','X',1);



SELECT DATEADD('year',3, NOW()::DATE);
SELECT ('12-01-1996'::DATE + INTERVAL'1 year')::DATE;

-- CONSULTAS DE PRUEBA
SELECT * FROM Persona WHERE cui_persona=7354023080525;
SELECT apellido1 FROM Persona WHERE cui_persona='1234567890123';
SELECT * FROM Municipio WHERE cod_municipio=6;
SELECT COUNT(cui_persona) FROM Persona WHERE cui_persona='4654987987';
SELECT * FROM Estado_civil;
SELECT * FROM Persona;

DELETE FROM Licencia;
DELETE FROM Renovar_licencia;


INSERT INTO Persona
	VALUES ('1234567890129','Madre','De','Todo','Bastet','Egipt',NULL,NULL,'10-10-1810',NULL,'F',1,'',2);
	

DELETE FROM Acta_defuncion;

SELECT nombre1,fecha_nacimiento,age(fecha_nacimiento),date_part('day',age(fecha_nacimiento)),date_part('month',age(fecha_nacimiento)),date_part('year',age(fecha_nacimiento))
	FROM Persona;
	
SELECT nombre1,fecha_nacimiento,cui_persona,
		date_part('day',NOW()::DATE) - date_part('day',fecha_nacimiento),
		date_part('month',NOW()::DATE) - date_part('month',fecha_nacimiento),
		date_part('year',NOW()::DATE) - date_part('year',fecha_nacimiento)
	FROM Persona;
SELECT date_part('day',NOW()::DATE),
		date_part('month',NOW()::DATE),
		date_part('year',NOW()::DATE)
	
SELECT nombre1,fecha_nacimiento,(NOW()::DATE - fecha_nacimiento)
	FROM Persona;
	
SELECT cui_persona,
			date_part('day',NOW()::DATE) - date_part('day',fecha_nacimiento),
			date_part('month',NOW()::DATE) - date_part('month',fecha_nacimiento),
			date_part('year',NOW()::DATE) - date_part('year',fecha_nacimiento)
				INTO dpi_persona,dia,mes,anio
		FROM Persona
		WHERE cui_persona=cui_;
		
SELECT date_part('day','12-05-2020'::DATE) - date_part('day','13-05-2020'::DATE),
			date_part('month','12-05-2020'::DATE) - date_part('month','13-05-2020'::DATE),
			date_part('year','12-05-2020'::DATE) - date_part('year','13-05-2020'::DATE)
		
--==========================================================================================--
--                 PROCEDIMIENTO PARA OBTENER ACTA DE NACIMIENTO                            --
--==========================================================================================--
CREATE OR REPLACE FUNCTION getNacimiento(cui_ NUMERIC) RETURNS TABLE (j json) AS $$
BEGIN
    RETURN QUERY  
		-- https://www.postgresql.org/docs/9.5/functions-json.html
		SELECT json_build_object('estado',200,'mensaje',info)
		FROM (
				SELECT p.cui_persona,
						CONCAT(p.apellido1,' ',p.apellido2) AS Apellidos,
						CONCAT(p.nombre1,' ',p.nombre2,' ',p.nombre3) AS Nombres,
						p.cui_padre AS DpiPadre,
						CONCAT(pa.nombre1,' ',pa.nombre2,' ',pa.nombre3) AS NombrePadre,
						CONCAT(pa.apellido1,' ',pa.apellido2) AS ApellidoPadre,
						p.cui_madre AS Dpimadre,
						CONCAT(ma.nombre1,' ',ma.nombre2,' ',ma.nombre3) AS NombreMadre,
						CONCAT(ma.apellido1,' ',ma.apellido2) AS ApellidoMadre,
						p.fecha_nacimiento,
						d.nombre AS Departamento,
						m.nombre AS Municipio,
						(CASE
							WHEN p.genero = 'M' THEN
								'MASCULINO'
							ELSE
								'FEMENINO'
						END)
					FROM Persona p
					LEFT JOIN Persona pa
					ON p.cui_padre=pa.cui_persona
					LEFT JOIN Persona ma
					ON p.cui_madre=ma.cui_persona
					INNER JOIN Municipio m
					ON p.cod_municipio=m.cod_municipio
					INNER JOIN Departamento d
					ON m.cod_depto=d.cod_depto
					WHERE p.cui_persona=cui_
				) info;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION getNacimiento;

SELECT getNacimiento(9190743672188);

--==========================================================================================--
--                         PROCEDIMIENTO PARA OBTENER DPI                                   --
--==========================================================================================--
CREATE OR REPLACE FUNCTION getDPI(cui_ NUMERIC) RETURNS TABLE (j json) AS $$
BEGIN
    RETURN QUERY  
		-- https://www.postgresql.org/docs/9.5/functions-json.html
		SELECT json_build_object('estado',200,'mensaje',info)
		FROM (
				SELECT r.cui_persona,
						CONCAT(p.apellido1,' ',p.apellido2) AS Apellidos,
						CONCAT(p.nombre1,' ',p.nombre2,' ',p.nombre3) AS Nombres,
						p.fecha_nacimiento,
						d.nombre AS Departamento,
						m.nombre AS Municipio,
						d2.nombre AS DeptVecindad,
						m2.nombre AS MuniVecindad,
						(CASE
							WHEN p.genero = 'M' THEN
								'MASCULINO'
							ELSE
								'FEMENINO'
						END)
					FROM Persona p
					INNER JOIN Rep_dpi r
					ON p.cui_persona=r.cui_persona
					INNER JOIN Municipio m2
					ON r.municipio_reside=m2.cod_municipio
					INNER JOIN Departamento d2
					ON m2.cod_depto=d2.cod_depto
					INNER JOIN Municipio m
					ON p.cod_municipio=m.cod_municipio
					INNER JOIN Departamento d
					ON m.cod_depto=d.cod_depto
					WHERE p.cui_persona=cui_
				) info;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION getDPI;

SELECT getDPI(3682468312084);


--==========================================================================================--
--                       PROCEDIMIENTO PARA OBTENER DIVORCIO                                --
--==========================================================================================--
CREATE OR REPLACE FUNCTION getDivorcio(no_acta_ INTEGER) RETURNS TABLE (j json) AS $$
BEGIN
    RETURN QUERY  
		-- https://www.postgresql.org/docs/9.5/functions-json.html
		SELECT json_build_object('estado',200,'mensaje',info)
		FROM (
				SELECT di.no_acta AS NoDivorcio,
						di.dpi_esposo AS DPIHombre,
						(SELECT CONCAT(p.nombre1,' ',p.nombre2,' ',p.nombre3,' ',p.apellido1,' ',p.apellido2) 
							FROM Persona p WHERE p.cui_persona=di.dpi_esposo) AS NombreHombre,
						di.dpi_esposa AS DPIMujer,
						(SELECT CONCAT(p.nombre1,' ',p.nombre2,' ',p.nombre3,' ',p.apellido1,' ',p.apellido2) 
							FROM Persona p WHERE p.cui_persona=di.dpi_esposa) AS NombreMujer,
						di.fecha
					FROM Acta_divorcio di
					WHERE di.no_acta=no_acta_
				) info;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION getDivorcio;

SELECT getDivorcio(10);


--==========================================================================================--
--                   PROCEDIMIENTO PARA OBTENER ACTA DE DEFUNCION                           --
--==========================================================================================--
CREATE OR REPLACE FUNCTION getDefuncion(cui_ NUMERIC) RETURNS TABLE (j json) AS $$
BEGIN
    RETURN QUERY  
		-- https://www.postgresql.org/docs/9.5/functions-json.html
		SELECT json_build_object('estado',200,'mensaje',info)
		FROM (
				SELECT de.no_acta AS NoActa,
						p.cui_persona AS CUI,
						CONCAT(p.apellido1,' ',p.apellido2) AS Apellidos,
						CONCAT(p.nombre1,' ',p.nombre2,' ',p.nombre3) AS Nombres,
						de.fecha_fallecio AS FechaFallecimiento,
						d.nombre AS Departamento,
						m.nombre AS Municipio,
						de.motivo
					FROM Persona p
					INNER JOIN Acta_defuncion de
					ON p.cui_persona=de.cui_difunto
					INNER JOIN Municipio m
					ON p.cod_municipio=m.cod_municipio
					INNER JOIN Departamento d
					ON m.cod_depto=d.cod_depto
					WHERE de.cui_difunto=cui_
				) info;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION getDefuncion;

SELECT getDefuncion(1576218422084);


--==========================================================================================--
--                   PROCEDIMIENTO PARA OBTENER ACTA DE MATRIMONIO                          --
--==========================================================================================--
CREATE OR REPLACE FUNCTION getMatrimonio(no_acta_ INTEGER) RETURNS TABLE (j json) AS $$
BEGIN
    RETURN QUERY  
		-- https://www.postgresql.org/docs/9.5/functions-json.html
		SELECT json_build_object('estado',200,'mensaje',info)
		FROM (
				SELECT ma.no_acta AS NoDivorcio,
						ma.dpi_esposo AS DPIHombre,
						(SELECT CONCAT(p.nombre1,' ',p.nombre2,' ',p.nombre3,' ',p.apellido1,' ',p.apellido2) 
							FROM Persona p WHERE p.cui_persona=ma.dpi_esposo) AS NombreHombre,
						ma.dpi_esposa AS DPIMujer,
						(SELECT CONCAT(p.nombre1,' ',p.nombre2,' ',p.nombre3,' ',p.apellido1,' ',p.apellido2) 
							FROM Persona p WHERE p.cui_persona=ma.dpi_esposa) AS NombreMujer,
						ma.fecha
					FROM acta_matrimonio ma
					WHERE ma.no_acta=no_acta_
				) info;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION getMatrimonio;

SELECT getMatrimonio(3);
SELECT * FROM acta_matrimonio;
