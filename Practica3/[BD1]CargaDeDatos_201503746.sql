
-- SCRIPTS DE TRASLADO DE TEMPORAL A RELACIONAL

-- PAIS
INSERT INTO Pais(nombre)
	SELECT t3.pais_cliente 
	FROM 
		(
			SELECT t.pais_cliente
				FROM Temporal t
				WHERE t.pais_cliente!='-'
				GROUP BY t.pais_cliente
			UNION
			SELECT t2.pais_empleado
				FROM Temporal t2
				WHERE t2.ciudad_empleado!='-'
				GROUP BY t2.pais_empleado
			UNION
			SELECT t4.pais_tienda
				FROM Temporal t4
				WHERE t4.ciudad_tienda!='-'
				GROUP BY t4.pais_tienda
		) t3
		GROUP BY t3.pais_cliente;


-- CIUDAD
INSERT INTO Ciudad(nombre,id_pais)
	SELECT t3.ciudad_cliente,(SELECT id_pais FROM Pais WHERE nombre=t3.pais_cliente )
		FROM 
		(
			SELECT t.ciudad_cliente,t.pais_cliente
				FROM Temporal t
				WHERE t.ciudad_cliente!='-' 
				GROUP BY t.ciudad_cliente,t.pais_cliente
			UNION
			SELECT t2.ciudad_empleado,t2.pais_empleado
				FROM Temporal t2
				WHERE t2.ciudad_empleado!='-'
				GROUP BY t2.ciudad_empleado,t2.pais_empleado
			UNION
			SELECT t4.ciudad_tienda,t4.pais_tienda
				FROM Temporal t4
				WHERE t4.ciudad_tienda!='-'
				GROUP BY t4.ciudad_tienda,t4.pais_tienda
		) t3
		GROUP BY t3.ciudad_cliente,t3.pais_cliente;


-- DISTRITO
INSERT INTO Distrito(direccion,cod_postal,id_ciudad)
	SELECT t3.direccion_cliente,t3.codigo_postal_cliente,
					(SELECT c.id_ciudad
						FROM Ciudad c
						INNER JOIN Pais p
						ON c.id_pais=p.id_pais
						WHERE c.nombre=t3.ciudad_cliente AND p.nombre=t3.pais_cliente)
		FROM 
		(
			SELECT t.direccion_cliente,t.codigo_postal_cliente,t.ciudad_cliente,t.pais_cliente
				FROM Temporal t
				WHERE t.direccion_cliente!='-'
				GROUP BY t.direccion_cliente,t.codigo_postal_cliente,t.ciudad_cliente,t.pais_cliente
			UNION
			SELECT t2.direccion_empleado,t2.codigo_postal_empleado,t2.ciudad_empleado,t2.pais_empleado
				FROM Temporal t2
				WHERE t2.direccion_empleado!='-'
				GROUP BY t2.direccion_empleado,t2.codigo_postal_empleado,t2.ciudad_empleado,t2.pais_empleado
			UNION
			SELECT t4.direccion_tienda,t4.codigo_postal_tienda,t4.ciudad_tienda,t4.pais_tienda
				FROM Temporal t4
				WHERE t4.direccion_tienda!='-'
				GROUP BY t4.direccion_tienda,t4.codigo_postal_tienda,t4.ciudad_tienda,t4.pais_tienda
		) t3
		GROUP BY t3.direccion_cliente,t3.codigo_postal_cliente,t3.ciudad_cliente,t3.pais_cliente;


INSERT INTO Clientes(nombre,apellido,correo,fecha_registro,estado,id_distrito)
	SELECT split_part(t.nombre_cliente, ' ', 1) AS nombre,
			split_part(t.nombre_cliente, ' ', 2) AS apellido,
			t.correo_cliente,t.fecha_creacion,t.cliente_activo,
			(SELECT d.id_distrito
				FROM Distrito d
				INNER JOIN Ciudad c
				ON d.id_ciudad=c.id_ciudad
				INNER JOIN Pais p
				ON c.id_pais=p.id_pais
				WHERE d.direccion=t.direccion_cliente AND c.nombre=t.ciudad_cliente AND p.nombre=t.pais_cliente)
		FROM Temporal t
		WHERE t.nombre_cliente!='-'
		GROUP BY t.nombre_cliente,t.correo_cliente,t.fecha_creacion,t.cliente_activo,t.direccion_cliente,t.ciudad_cliente,t.pais_cliente;
		

INSERT INTO Empleados(nombre,apellido,correo,estado,id_distrito)
	SELECT split_part(t.nombre_empleado, ' ', 1) AS nombre,
			split_part(t.nombre_empleado, ' ', 2) AS apellido,
			t.correo_empleado,t.empleado_activo,
			(SELECT d.id_distrito
				FROM Distrito d
				INNER JOIN Ciudad c
				ON d.id_ciudad=c.id_ciudad
				INNER JOIN Pais p
				ON c.id_pais=p.id_pais
				WHERE d.direccion=t.direccion_empleado AND c.nombre=t.ciudad_empleado AND p.nombre=t.pais_empleado)
		FROM Temporal t
		WHERE t.nombre_empleado!='-'
		GROUP BY t.nombre_empleado,t.correo_empleado,t.empleado_activo,t.direccion_empleado,t.ciudad_empleado,t.pais_empleado;


INSERT INTO Clasificacion(descripcion)
	SELECT clasificacion
		FROM Temporal
		WHERE clasificacion!='-'
		GROUP BY clasificacion;


INSERT INTO Pelicula(titulo,descripcion,anio_lanzamiento,duracion,cant_dias_renta,precio_renta,costo_por_anio,id_clasificacion)
	SELECT t.nombre_pelicula,t.descripcion_pelicula,
			t.anio_lanzamiento,CAST (t.duracion AS INTEGER),CAST (t.dias_renta AS INTEGER),
			CAST (t.costo_renta AS NUMERIC(7,2)),CAST (t.costo_por_anio AS NUMERIC(7,2)),
			(SELECT id_clasificacion FROM Clasificacion WHERE descripcion=t.clasificacion)
		FROM Temporal t
		WHERE t.nombre_pelicula!='-'
		GROUP BY t.nombre_pelicula,t.descripcion_pelicula,t.anio_lanzamiento,t.duracion,t.dias_renta,t.costo_renta,t.costo_por_anio,t.clasificacion
		ORDER BY t.nombre_pelicula ASC;


INSERT INTO Lenguaje(descripcion)
	SELECT lenguaje_pelicula
		FROM Temporal
		WHERE lenguaje_pelicula!='-'
		GROUP BY lenguaje_pelicula;


INSERT INTO Actores(nombre,apellido)
	SELECT split_part(actor_pelicula, ' ', 1) AS nombre,
			split_part(actor_pelicula, ' ', 2) AS apellido
		FROM Temporal
		WHERE actor_pelicula!='-'
		GROUP BY actor_pelicula;
		

INSERT INTO Categorias(descripcion)
	SELECT categoria_pelicula
		FROM Temporal
		WHERE categoria_pelicula!='-'
		GROUP BY categoria_pelicula;


INSERT INTO Traducciones(id_pelicula,id_lenguaje)
	SELECT (
			SELECT p.id_pelicula
				FROM Pelicula p
				WHERE p.titulo=t.nombre_pelicula
				AND p.anio_lanzamiento=t.anio_lanzamiento
				AND p.duracion=CAST (t.duracion AS INTEGER)
			),
			(
			SELECT l.id_lenguaje
				FROM Lenguaje l
				WHERE l.descripcion=t.lenguaje_pelicula
			)
		FROM Temporal t
		WHERE t.nombre_pelicula!='-'
		GROUP BY t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.lenguaje_pelicula;


INSERT INTO Reparto(id_pelicula,id_actor)
	SELECT (
			SELECT p.id_pelicula
				FROM Pelicula p
				WHERE p.titulo=t.nombre_pelicula
				AND p.anio_lanzamiento=t.anio_lanzamiento
				AND p.duracion=CAST (t.duracion AS INTEGER)
			),
			(
			SELECT id_actor
				FROM Actores a
				WHERE a.nombre=split_part(t.actor_pelicula, ' ', 1)
				AND a.apellido=split_part(t.actor_pelicula, ' ', 2)
			)
		FROM Temporal t
		WHERE t.nombre_pelicula!='-'
		GROUP BY t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.actor_pelicula
		ORDER BY t.actor_pelicula ASC;


INSERT INTO det_peli_cat(id_pelicula,id_categoria)
	SELECT (
			SELECT p.id_pelicula
				FROM Pelicula p
				WHERE p.titulo=t.nombre_pelicula
				AND p.anio_lanzamiento=t.anio_lanzamiento
				AND p.duracion=CAST (t.duracion AS INTEGER)
			),
			(
			SELECT id_categoria
				FROM Categorias c
				WHERE c.descripcion=t.categoria_pelicula
			)
		FROM Temporal t
		WHERE t.nombre_pelicula!='-'
		GROUP BY t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.categoria_pelicula;


INSERT INTO Tienda(nombre,id_distrito,id_jefe)
	SELECT t.nombre_tienda,
			(
			SELECT d.id_distrito
				FROM Distrito d
				INNER JOIN Ciudad c
				ON d.id_ciudad=c.id_ciudad
				INNER JOIN Pais p
				ON c.id_pais=p.id_pais
				WHERE d.direccion=t.direccion_tienda
				AND c.nombre=t.ciudad_tienda
				AND p.nombre=t.pais_tienda
			),
			(
			SELECT e.id_empleado
				FROM Empleados e
				WHERE e.nombre=split_part(t.encargado_tienda, ' ', 1)
				AND e.apellido=split_part(t.encargado_tienda, ' ', 2)
			)			
		FROM Temporal t
		WHERE t.nombre_tienda!='-'
		GROUP BY t.nombre_tienda,t.direccion_tienda,t.ciudad_tienda,t.pais_tienda,t.encargado_tienda;
	

INSERT INTO Autorizacion(usuario,contrasenia,id_empleado,id_tienda)
	SELECT t.usuario_empleado,t.contrasenia_empleado,
		(
			SELECT e.id_empleado
				FROM Empleados e
				WHERE e.nombre=split_part(t.nombre_empleado, ' ', 1)
				AND e.apellido=split_part(t.nombre_empleado, ' ', 2)
		),
		(
			SELECT ti.id_tienda
				FROM Tienda ti
				WHERE ti.nombre=t.nombre_tienda
		)
		FROM Temporal t
		WHERE t.usuario_empleado!='-'
		GROUP BY t.usuario_empleado,t.contrasenia_empleado,t.nombre_empleado,t.nombre_tienda;
	

INSERT INTO Renta(fecha_renta,fecha_devuelta,fecha_pago,id_autorizacion,id_tienda,id_cliente)
	SELECT t.fecha_renta,t.fecha_retorno,t.fecha_pago,
			(
				SELECT e.id_empleado
				FROM Empleados e
				WHERE e.nombre=split_part(t.nombre_empleado, ' ', 1)
				AND e.apellido=split_part(t.nombre_empleado, ' ', 2)
			),
			(
				SELECT ti.id_tienda
				FROM Tienda ti
				WHERE ti.nombre=t.nombre_tienda
			),
			(
				SELECT c.id_cliente
				FROM Clientes c
				WHERE c.nombre=split_part(t.nombre_cliente, ' ', 1)
				AND c.apellido=split_part(t.nombre_cliente, ' ', 2)
			)
		FROM Temporal t
		WHERE t.nombre_cliente!='-' -- Si No hay cliente no hay renta
		GROUP BY t.fecha_renta,t.fecha_retorno,t.fecha_pago,t.nombre_empleado,t.nombre_tienda,t.nombre_cliente;


INSERT INTO Detalle_renta(id_renta,id_pelicula,precio)
	SELECT (
			SELECT r.id_renta
				FROM Renta r
				INNER JOIN Clientes c
				ON r.id_cliente=c.id_cliente
				INNER JOIN Tienda ti
				ON r.id_tienda=ti.id_tienda
				INNER JOIN Autorizacion a
				ON r.id_autorizacion=a.id_autorizacion
				INNER JOIN Empleados e
				ON a.id_empleado=e.id_empleado
				WHERE r.fecha_renta=t.fecha_renta
				AND r.fecha_devuelta=t.fecha_retorno
				AND r.fecha_pago=t.fecha_pago
				AND e.nombre=split_part(t.nombre_empleado, ' ', 1)
				AND e.apellido=split_part(t.nombre_empleado, ' ', 2)
				AND ti.nombre=t.nombre_tienda
				AND c.nombre=split_part(t.nombre_cliente, ' ', 1)
				AND c.apellido=split_part(t.nombre_cliente, ' ', 2)
			),
			(
				SELECT p.id_pelicula
					FROM Pelicula p
					WHERE p.titulo=t.nombre_pelicula
					AND p.anio_lanzamiento=t.anio_lanzamiento
					AND p.duracion=CAST (t.duracion AS INTEGER)
			),CAST (t.costo_renta AS NUMERIC(7,2))
		FROM Temporal t
		WHERE t.nombre_cliente!='-' -- Si No hay cliente no hay renta
		GROUP BY t.fecha_renta,t.fecha_retorno,t.fecha_pago,t.nombre_empleado,t.nombre_tienda,t.nombre_cliente,
					t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.costo_renta;



-- ******************* OPCION 1 (Exito) *******************
INSERT INTO Inventario(id_pelicula,id_tienda,cantidad)
	SELECT ax1.id_pelicula,ax1.id_tienda,COUNT(*) AS cantidad
		FROM
		(
			SELECT (
					SELECT p.id_pelicula
						FROM Pelicula p
						WHERE p.titulo=t.nombre_pelicula
						AND p.anio_lanzamiento=t.anio_lanzamiento
						AND p.duracion=CAST (t.duracion AS INTEGER)
					),
					(
					SELECT a.id_tienda
						FROM Tienda a
						WHERE a.nombre=t.nombre_tienda
					),
					t.nombre_cliente
				FROM Temporal t
				--WHERE t.nombre_pelicula!='-' 	-- No peliculas nulas
				--AND t.nombre_tienda!='-'		-- No tiendas nulas
				--AND t.nombre_cliente!='-'		-- No clientes nulos
				GROUP BY t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.nombre_tienda,t.nombre_cliente
				ORDER BY t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.nombre_tienda ASC
		) ax1
		GROUP BY ax1.id_pelicula,ax1.id_tienda; -- Se hace el conteo la pelicula a partir de la venta de la pelicula y el cliente, 
-- ******************* OPCION 2 *******************
INSERT INTO Inventario(id_pelicula,id_tienda,cantidad)
	SELECT ax1.id_tienda,ax1.id_cliente,COUNT(ax1.id_pelicula) AS cantidad
		FROM
		(
			SELECT (
					SELECT p.id_pelicula
						FROM Pelicula p
						WHERE p.titulo=t.nombre_pelicula
						AND p.anio_lanzamiento=t.anio_lanzamiento
						AND p.duracion=CAST (t.duracion AS INTEGER)
					),
					(
					SELECT a.id_tienda
						FROM Tienda a
						WHERE a.nombre=t.nombre_tienda
					),
					(
					SELECT c.id_cliente
						FROM Clientes c
						WHERE CONCAT(c.nombre,' ',c.apellido)=t.nombre_cliente
					)
				FROM Temporal t
				--WHERE t.nombre_pelicula!='-' 	-- No peliculas nulas
				--AND t.nombre_tienda!='-'		-- No tiendas nulas
				--AND t.nombre_cliente!='-'		-- No clientes nulos
				GROUP BY t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.nombre_tienda,t.nombre_cliente
				ORDER BY t.nombre_pelicula,t.anio_lanzamiento,t.duracion,t.nombre_tienda ASC
		) ax1
		GROUP BY ax1.id_tienda,ax1.id_cliente; -- Se hace el conteo la pelicula a partir de la venta de la pelicula y el cliente, 
		
SELECT t.nombre_pelicula,t.nombre_tienda,t.nombre_cliente
	FROM Temporal t
	WHERE t.nombre_pelicula!='-'
	AND t.nombre_tienda!='-'
	AND t.nombre_cliente!='-'
	GROUP BY t.nombre_pelicula,t.nombre_tienda,t.nombre_cliente;
	