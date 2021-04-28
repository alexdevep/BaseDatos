-- 1. Mostrar la cantidad de copias que existen en el inventario para la película “Sugar Wonka”.

SELECT t.nombre,i.cantidad
	FROM pelicula p 
	INNER JOIN Inventario i
	ON p.id_pelicula=i.id_pelicula
	INNER JOIN Tienda t
	ON i.id_tienda=t.id_tienda
	WHERE p.titulo='SUGAR WONKA';
-- CORREGIDO: En la consulta #1 deben mostrar la cantidad de copias por tienda.
-- ****************************************************************************	
	
-- 2. Mostrar el nombre, apellido y pago total de todos los clientes que han
-- rentado películas por lo menos 40 veces.

SELECT c.nombre,c.apellido,SUM(dr.precio) AS pago_total
	FROM clientes c
	INNER JOIN Renta r
	ON c.id_cliente=r.id_cliente
	INNER JOIN Detalle_renta dr
	ON r.id_renta=dr.id_renta
	GROUP BY c.nombre,c.apellido
	HAVING COUNT(dr.id_pelicula) >= 40
	ORDER BY c.nombre,c.apellido ASC;

-- 3. Mostrar el nombre y apellido del actor que más veces a aparecido en una película. 
-- Debe mostrar la cantidad de veces que apareció. Si esa cantidad coincide 
-- también para otros actores, debe mostrarlos todos.

SELECT a.id_actor,a.nombre,a.apellido,COUNT(p.titulo) AS cant_pelis -- Hacemos un count de pelis por actor y 
	FROM Actores a													-- comparamos con el max de peliculas por actor
	INNER JOIN Reparto r
	ON a.id_actor=r.id_actor
	INNER JOIN Pelicula p
	ON r.id_pelicula=p.id_pelicula
	GROUP BY a.id_actor,a.nombre,a.apellido
	HAVING COUNT(p.titulo)=( -- << Tenido el maximo de peliculas de un actor lo comparo con mi cant_pelis 
							-- para obtener la lista de actores que tienen esa cant_pelis

							SELECT MAX(ax2.cant)-- Obtiene el numero maximo de un actor en peliculas
								FROM (
										SELECT ax1.id_actor,COUNT(ax1.id_pelicula) as cant
											FROM Reparto ax1
											WHERE id_actor IS NOT NULL
											GROUP BY ax1.id_actor 
										) ax2
							);
							
-- 4. Mostrar el nombre y apellido (en una sola columna) de los actores que
-- contienen la palabra “SON” en su apellido, ordenados por su primer nombre.

SELECT CONCAT(a.nombre,' ',a.apellido) AS actor
	FROM Actores a
	WHERE a.apellido LIKE '%Son%'
	OR a.apellido LIKE '%son%'
	ORDER BY a.nombre;
	
-- 5. Mostrar el apellido de todos los actores y la
-- cantidad de actores que tienen ese apellido.

SELECT a.apellido,COUNT(a.nombre) AS cantidad_actores
	FROM Actores a
	GROUP BY a.apellido
	ORDER BY a.apellido ASC;

-- 6. Mostrar el nombre y apellido de los actores que participaron en una película
-- que involucra un “Cocodrilo” y un “Tiburón” junto con el año de lanzamiento
-- de la película, ordenados por el apellido del actor en forma ascendente.

SELECT a.nombre,a.apellido,p.anio_lanzamiento
	FROM Actores a
	INNER JOIN Reparto r
	ON a.id_actor=r.id_actor
	INNER JOIN Pelicula p
	ON r.id_pelicula=p.id_pelicula
	WHERE descripcion LIKE '%rocodile%' AND descripcion LIKE '%hark%' -- Crocodile && Shark
	ORDER BY a.apellido ASC;

SELECT descripcion 
	FROM pelicula
	WHERE descripcion LIKE '%rocodile%' AND descripcion LIKE '%hark%' -- Crocodile && Shark;
	
-- 7. Mostrar el nombre de la categoría y el número de películas por categoría de
-- todas las categorías de películas en las que hay entre 55 y 65 películas.
-- Ordenar el resultado por número de películas de forma descendente.

SELECT c.descripcion AS categoria_,COUNT(p.id_pelicula) AS cantidad_peliculas
	FROM Categorias c
	INNER JOIN Det_peli_cat dpc
	ON c.id_categoria=dpc.id_categoria
	INNER JOIN Pelicula p
	ON dpc.id_pelicula=p.id_pelicula
	GROUP BY c.descripcion
	HAVING COUNT(p.id_pelicula) >= 55 AND COUNT(p.id_pelicula) <= 65;

-- 8. Mostrar todas las categorías de películas en las que la diferencia promedio
-- entre el costo de reemplazo de la película y el precio de alquiler sea superior
-- a 17.
-- *****************************************************************
SELECT c.descripcion 
	FROM Categorias c;

-- 9. Mostrar el título de la película, el nombre y apellido del actor de todas
-- aquellas películas en las que uno o más actores actuaron en dos o más
-- películas.

SELECT p.titulo,a.nombre,a.apellido
	FROM Pelicula p
	INNER JOIN Reparto r
	ON p.id_pelicula=r.id_pelicula
	INNER JOIN Actores a
	ON r.id_actor=a.id_actor
	WHERE a.id_actor IN(
						SELECT r1.id_actor -- Actores que salieron en dos o mas peliculas
							FROM Reparto r1
							GROUP BY r1.id_actor
							HAVING COUNT(r1.id_pelicula)>=2
						);

-- 10.Mostrar el nombre y apellido (en una sola columna) de todos los actores y
-- clientes cuyo primer nombre sea el mismo que el primer nombre del actor
-- con ID igual a 8. No debe retornar el nombre del actor con ID igual a 8
-- dentro de la consulta. No puede utilizar el nombre del actor como una
-- constante, únicamente el ID proporcionado.
-- CORREGIDO: En la consulta #10 en lugar de utilizar la condicion del ID 8 
-- utilizar el ID de la persona con el nombre de "MATTHEW JOHANSSON"
-- *****************************************************************
SELECT ax1.actor
	FROM (
			SELECT CONCAT(a.nombre,' ',a.apellido) AS actor
					FROM Actores a
					WHERE a.nombre!='-' -- No toma en cuenta el NULO
				UNION ALL
				SELECT CONCAT(c.nombre,' ',c.apellido) AS cliente
					FROM Clientes c
			) ax1						-- En esta consulta se repite 'Jennifer Davis' con UNION ALL
	WHERE ax1.actor='Matthew Johansson'

-- 11.Mostrar el país y el nombre(completo) del cliente que más películas rentó así como
-- también el porcentaje que representa la cantidad de películas que rentó con
-- respecto al resto de clientes del país.

SELECT a1.nombre AS pais,a1.cliente,
					CONCAT(((a1.cant_rentas/(
				-- Cantidad de rentas que han hecho clientes de un determinado pais
						SELECT COUNT(dr.id_pelicula) AS cant_rentas
							FROM Pais p
							INNER JOIN Ciudad ci
							ON p.id_pais=ci.id_pais
							INNER JOIN Distrito d
							ON ci.id_ciudad=d.id_ciudad
							INNER JOIN Clientes cl
							ON d.id_distrito=cl.id_distrito
							INNER JOIN Renta r
							ON cl.id_cliente=r.id_cliente
							INNER JOIN Detalle_renta dr
							ON r.id_renta=dr.id_renta
							WHERE p.id_pais=a1.id_pais 	-- id_pais
							GROUP BY p.id_pais
					))*100),' %') AS Porcentaje 				-- Como le agrego el signo '%' a mi cadena
	FROM (
		-- Obtiene el pais,cliente y la cantidad de rentas que tiene cada cliente
			SELECT p.id_pais,p.nombre,CONCAT(cl.nombre,' ',cl.apellido) AS cliente,COUNT(dr.id_pelicula) AS cant_rentas
				FROM Pais p
				INNER JOIN Ciudad ci
				ON p.id_pais=ci.id_pais
				INNER JOIN Distrito d
				ON ci.id_ciudad=d.id_ciudad
				INNER JOIN Clientes cl
				ON d.id_distrito=cl.id_distrito
				INNER JOIN Renta r
				ON cl.id_cliente=r.id_cliente
				INNER JOIN Detalle_renta dr
				ON r.id_renta=dr.id_renta
				GROUP BY p.id_pais,p.nombre,cl.nombre,cl.apellido
			) a1
		ORDER BY a1.cant_rentas DESC
		LIMIT 1; -- Con limit 1 obtenemos el cliente que mas rentas tubo, ya que esta ordenado de mayor a menor


-- Cantidad de rentas que han hecho clientes de un determinado pais
SELECT p.id_pais,COUNT(dr.id_pelicula) AS cant_rentas
	FROM Pais p
	INNER JOIN Ciudad ci
	ON p.id_pais=ci.id_pais
	INNER JOIN Distrito d
	ON ci.id_ciudad=d.id_ciudad
	INNER JOIN Clientes cl
	ON d.id_distrito=cl.id_distrito
	INNER JOIN Renta r
	ON cl.id_cliente=r.id_cliente
	INNER JOIN Detalle_renta dr
	ON r.id_renta=dr.id_renta
	WHERE p.id_pais=70			-- id_pais
	GROUP BY p.id_pais;

-- 12.Mostrar el total de clientes y porcentaje de clientes por ciudad y
-- país. El ciento por ciento es el total de clientes por país. (Tip: Todos los
-- porcentajes por ciudad de un país deben sumar el 100%).

-- Cantidad clientes agrupados por ciudad y pais
SELECT a1.ciudad_,a1.pais_,
			CAST((a1.cant_cliente*100/(
					-- Cuantos clientes hay por pais
					SELECT CAST(COUNT(cl.id_cliente) AS NUMERIC(7,2)) AS cliente_x_pais
						FROM Clientes cl
						INNER JOIN Distrito d
						ON cl.id_distrito=d.id_distrito
						INNER JOIN Ciudad ci
						ON d.id_ciudad=ci.id_ciudad
						INNER JOIN Pais p
						ON ci.id_pais=p.id_pais
						WHERE p.id_pais=a1.id_pais	 -- id_pais
						GROUP BY p.id_pais
						ORDER BY p.id_pais ASC
				)) AS NUMERIC(7,2)) AS Porcentaje
	FROM (
			SELECT ci.nombre AS ciudad_,p.id_pais, p.nombre AS pais_, 
						CAST(COUNT(cl.id_cliente) AS NUMERIC(7,2)) AS cant_cliente
				FROM Clientes cl
				INNER JOIN Distrito d
				ON cl.id_distrito=d.id_distrito
				INNER JOIN Ciudad ci
				ON d.id_ciudad=ci.id_ciudad
				INNER JOIN Pais p
				ON ci.id_pais=p.id_pais
				GROUP BY ci.nombre,p.id_pais,p.nombre
				ORDER BY p.nombre ASC, ci.nombre ASC
		) a1
	GROUP BY a1.ciudad_,a1.pais_,a1.cant_cliente,a1.id_pais
	ORDER BY a1.pais_,a1.ciudad_;

-- 13.Mostrar el nombre del país, nombre del cliente y número de películas
-- rentadas de todos los clientes que rentaron más películas por país. Si el
-- número de películas máximo se repite, mostrar todos los valores que
-- representa el máximo.

SELECT (
		SELECT x1.nombre FROM Pais x1 WHERE x1.id_pais=p.id_pais
			) AS Pais_,
			(
				SELECT CONCAT(x2.nombre,' ',x2.apellido) FROM Clientes x2 WHERE x2.id_cliente=cl.id_cliente
			) AS nombre_cliente,
			COUNT(dr.id_pelicula) AS cant_rentas
	FROM Pais p
	INNER JOIN Ciudad ci
	ON p.id_pais=ci.id_pais
	INNER JOIN Distrito d
	ON ci.id_ciudad=d.id_ciudad
	INNER JOIN Clientes cl
	ON d.id_distrito=cl.id_distrito
	INNER JOIN Renta r
	ON cl.id_cliente=r.id_cliente
	INNER JOIN Detalle_renta dr
	ON r.id_renta=dr.id_renta
	--WHERE p.id_pais=6 OR p.id_pais=9	-- id_pais
	GROUP BY p.id_pais,cl.id_cliente
	HAVING COUNT(dr.id_pelicula)=(
							-- Esta consulta retorna el MAX de rentas que tubo un cliente de un pais
							-- de modo que si hay dos personas con lamisma cantidad de rentas se toma
							-- en cuenta en el script superior
									SELECT MAX(b1.cant_rentas)
										FROM (
												SELECT p3.id_pais,cl3.id_cliente,COUNT(dr3.id_pelicula) AS cant_rentas
													FROM Pais p3
													INNER JOIN Ciudad ci3
													ON p3.id_pais=ci3.id_pais
													INNER JOIN Distrito d3
													ON ci3.id_ciudad=d3.id_ciudad
													INNER JOIN Clientes cl3
													ON d3.id_distrito=cl3.id_distrito
													INNER JOIN Renta r3
													ON cl3.id_cliente=r3.id_cliente
													INNER JOIN Detalle_renta dr3
													ON r3.id_renta=dr3.id_renta
													WHERE p3.id_pais=p.id_pais	-- id_pais
													GROUP BY p3.id_pais,cl3.id_cliente
													ORDER BY p3.id_pais,cl3.id_cliente ASC
											) b1)
	ORDER BY p.id_pais ASC,COUNT(dr.id_pelicula) DESC;

-- 14.Mostrar todas las ciudades por país en las que predomina la renta de
-- películas de la categoría “Horror”. Es decir, hay más rentas que las otras
-- categorías.

SELECT p.id_pais,ci.id_ciudad,COUNT(dr.id_pelicula)
	FROM Pais p
	INNER JOIN Ciudad ci
	ON p.id_pais=ci.id_pais
	INNER JOIN Distrito d
	ON ci.id_ciudad=d.id_ciudad
	INNER JOIN Clientes cl
	ON d.id_distrito=cl.id_distrito
	INNER JOIN Renta r
	ON cl.id_cliente=r.id_cliente
	INNER JOIN Detalle_renta dr
	ON r.id_renta=dr.id_renta
	INNER JOIN Pelicula pe
	ON dr.id_pelicula=pe.id_pelicula
	INNER JOIN Det_peli_cat dpc
	ON pe.id_pelicula=dpc.id_pelicula
	INNER JOIN Categorias ca
	ON dpc.id_categoria=ca.id_categoria
	WHERE ca.descripcion='Horror'
	GROUP BY p.id_pais,ci.id_ciudad
	ORDER BY p.id_pais,ci.id_ciudad ASC

-- 15.Mostrar el nombre del país, la ciudad y el promedio de rentas por ciudad.
-- Por ejemplo: si el país tiene 3 ciudades, se deben sumar todas las rentas de
-- la ciudad y dividirlo dentro de tres (número de ciudades del país).
-- CORREGIDO: Para la consulta #15 dice que si un país tiene 3 ciudades, entonces suman 
-- todas las rentas de esa ciudad y lo dividen dentro de 3. Ese promedio resultante es la 
-- respuesta a "promedio de rentas por ciudad". Mostrar el campo de ciudad se me paso por 
-- alto y está de más, en realidad, lo que deben mostrar es el país y ese promedio que calcularon.

-- Cantidad de rentas que han hecho clientes de un determinado pais
SELECT (SELECT pai.nombre FROM Pais pai WHERE pai.id_pais=a1.Pais_),
		(SUM(a1.Cant_rentas_por_ciudad)/(
				-- Cantidad de ciudades por pais
				SELECT COUNT(ci2.id_ciudad) AS cant_ciudades
					FROM Pais pa2
					INNER JOIN Ciudad ci2
					ON pa2.id_pais=ci2.id_pais
					WHERE pa2.id_pais=a1.Pais_ -- id_pais
					GROUP BY pa2.id_pais
			)) AS Promedio_rentas_por_ciudad
	FROM (
			SELECT p.id_pais AS Pais_,ci.nombre AS Ciudad_,COUNT(dr.id_pelicula)AS Cant_rentas_por_ciudad
				FROM Pais p
				INNER JOIN Ciudad ci
				ON p.id_pais=ci.id_pais
				INNER JOIN Distrito d
				ON ci.id_ciudad=d.id_ciudad
				INNER JOIN Clientes cl
				ON d.id_distrito=cl.id_distrito
				INNER JOIN Renta r
				ON cl.id_cliente=r.id_cliente
				INNER JOIN Detalle_renta dr
				ON r.id_renta=dr.id_renta
				GROUP BY p.id_pais,ci.nombre
				ORDER BY p.id_pais,ci.nombre ASC
			) a1
	GROUP BY a1.Pais_;

-- Cantidad de ciudades por pais
SELECT COUNT(ci2.id_ciudad) AS cant_ciudades
	FROM Pais pa2
	INNER JOIN Ciudad ci2
	ON pa2.id_pais=ci2.id_pais
	WHERE pa2.id_pais=2
	GROUP BY pa2.id_pais
	

-- 16.Mostrar el nombre del país y el porcentaje de rentas de películas de la
-- categoría “Sports”.

SELECT (SELECT pai.nombre FROM Pais pai WHERE pai.id_pais=a1.id_pais),
		(a1.cant_pelis*100/(
			-- Cantidad de rentas que han hecho clientes de un determinado pais
				SELECT CAST(COUNT(dr.id_pelicula) AS NUMERIC(7,3)) AS cant_rentas
					FROM Pais p
					INNER JOIN Ciudad ci
					ON p.id_pais=ci.id_pais
					INNER JOIN Distrito d
					ON ci.id_ciudad=d.id_ciudad
					INNER JOIN Clientes cl
					ON d.id_distrito=cl.id_distrito
					INNER JOIN Renta r
					ON cl.id_cliente=r.id_cliente
					INNER JOIN Detalle_renta dr
					ON r.id_renta=dr.id_renta
					WHERE p.id_pais=a1.id_pais			-- id_pais
					GROUP BY p.id_pais
			)) AS Porcentaje
	FROM (
			SELECT p.id_pais,CAST(COUNT(dr.id_pelicula) AS NUMERIC(7,3)) as cant_pelis
				FROM Pais p
				INNER JOIN Ciudad ci
				ON p.id_pais=ci.id_pais
				INNER JOIN Distrito d
				ON ci.id_ciudad=d.id_ciudad
				INNER JOIN Clientes cl
				ON d.id_distrito=cl.id_distrito
				INNER JOIN Renta r
				ON cl.id_cliente=r.id_cliente
				INNER JOIN Detalle_renta dr
				ON r.id_renta=dr.id_renta
				INNER JOIN Pelicula pe
				ON dr.id_pelicula=pe.id_pelicula
				INNER JOIN Det_peli_cat dpc
				ON pe.id_pelicula=dpc.id_pelicula
				INNER JOIN Categorias ca
				ON dpc.id_categoria=ca.id_categoria
				WHERE ca.descripcion='Sports'
				GROUP BY p.id_pais
				ORDER BY p.id_pais ASC
			) a1;

-- 17.Mostrar la lista de ciudades de Estados Unidos y el número de rentas de
-- películas para las ciudades que obtuvieron más rentas que la ciudad
-- “Dayton”.

-- Cantidad de rentas que han hecho clientes en las ciudades de un determinado pais
SELECT ci.nombre as Ciudades,COUNT(dr.id_pelicula) AS cant_rentas
	FROM Pais p
	INNER JOIN Ciudad ci
	ON p.id_pais=ci.id_pais
	INNER JOIN Distrito d
	ON ci.id_ciudad=d.id_ciudad
	INNER JOIN Clientes cl
	ON d.id_distrito=cl.id_distrito
	INNER JOIN Renta r
	ON cl.id_cliente=r.id_cliente
	INNER JOIN Detalle_renta dr
	ON r.id_renta=dr.id_renta
	WHERE p.nombre='United States' 	-- nombre_pais
	GROUP BY ci.id_ciudad
	HAVING COUNT(dr.id_pelicula)>(
					-- Cantidad de rentas hechas por clientes de 'Dayton' estados unidos
									SELECT COUNT(dr.id_pelicula) AS cant_rentas
										FROM Pais p
										INNER JOIN Ciudad ci
										ON p.id_pais=ci.id_pais
										INNER JOIN Distrito d
										ON ci.id_ciudad=d.id_ciudad
										INNER JOIN Clientes cl
										ON d.id_distrito=cl.id_distrito
										INNER JOIN Renta r
										ON cl.id_cliente=r.id_cliente
										INNER JOIN Detalle_renta dr
										ON r.id_renta=dr.id_renta
										WHERE p.nombre='United States' 	-- nombre_pais
										AND ci.nombre='Dayton'
										GROUP BY ci.id_ciudad
									);

-- 18.Mostrar el nombre, apellido y fecha de retorno de película a la tienda de
-- todos los clientes que hayan rentado más de 2 películas que se encuentren
-- en lenguaje Inglés en donde el empleado que se las vendió ganará más de 15
-- dólares en sus rentas del día en la que el cliente rentó la película.

SELECT cl.id_cliente,r.fecha_devuelta
	FROM Clientes cl
	INNER JOIN Renta r
	ON cl.id_cliente=r.id_cliente
	INNER JOIN Detalle_renta dr
	ON r.id_renta=dr.id_renta
	GROUP BY cl.id_cliente
	ORDER BY p.id_pais ASC

-- Empleado gano mas de 15 dolares en rentas dado fecha renta de cliente
SELECT au3.id_empleado
	FROM Autorizacion au3
	INNER JOIN Renta r3
	ON au3.id_autorizacion=r3.id_autorizacion
	WHERE r3.id_fecha_renta='27/06/2005'
	AND r3.id_cliente=

-- 19.Mostrar el número de mes, de la fecha de renta de la película, nombre y
-- apellido de los clientes que más películas han rentado y las que menos en
-- una sola consulta.


-- 20.Mostrar el porcentaje de lenguajes de películas más rentadas de cada ciudad
-- durante el mes de julio del año 2005 de la siguiente manera: ciudad,
-- lenguaje, porcentaje de renta.

-- PRUEBAS
-- ○ A un trabajador le descuentan de su sueldo el 10% si su sueldo es menor o igual a Q.1,000.00, por
--	encima de Q.1,000.00 y hasta Q.2,000.00 el 5% del adicional, y por encima de Q.2,000.00 el 3% del
--	adicional. Crear una función que calcule el descuento y sueldo neto que recibe el trabajador dado
--	su sueldo. Exprese el resultado final como una cadena de la siguiente forma: '{ Descuento: XX,
--	Sueldo Neto: XX }'.

CREATE OR REPLACE FUNCTION Sueldazo(sueldo FLOAT) RETURNS VARCHAR AS $$
DECLARE
	descuento FLOAT; 
	sueldoDescontado FLOAT := 0;
BEGIN
	IF (sueldo <= 1000) THEN	
		descuento := 0.1; -- Descuento 10%
		sueldoDescontado := sueldo * descuento;
	ELSIF (sueldo > 1000 AND sueldo <= 2000) THEN
		descuento := 0.05; -- Descuento 5%
		sueldoDescontado := sueldo * descuento;
	ELSIF (sueldo > 2000) THEN
		descuento := 0.03; -- Descuento 3%
		sueldoDescontado := sueldo * descuento;
	ELSE
		sueldoDescontado := 0;
	END IF;	
	
	sueldo := sueldo - sueldoDescontado;
	RETURN CONCAT('{ Descuento: ',sueldoDescontado,', Sueldo Neto: ',sueldo ,' }');
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION Sueldazo;

SELECT Sueldazo(3000);