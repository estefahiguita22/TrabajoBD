select g.id_guia, g.cedula_nit_remitente as Remitente, g.cedula_nit_destinatario as Destinatario
from guia g
inner join clientes c on c.cedula_nit=g.id_guia

select estado
from rastreo_guia r
inner join guia g on g.id_guia = r.id_guiauno

/* 2 .Crear una vista llamada "plan_mantenimiento_detallado" el cu�l deber� mostrar que cosas se realizan en ese plan de mantenimiento. 
La idea es invocarlo de esta manera "select * from plan_mantenimiento_detallado where kilometraje = 5000" 
(Ya usted decide si quiere crear una columna num�rica o si quiere manejarlo usando LIKE en el campo del nombre del mantenimiento)*/

create or replace view plan_mantenimiento_detallado as
select p.nombre as Nombre_Plan, i.nombre as Nombre_Item
from plan_mtto p
inner join detalle_mtto d on d.id_plan_mtto=p.id
inner join items i on i.id=d.id_item

--Ejecuci�n Vista
select * from plan_mantenimiento_detallado where Nombre_Plan LIKE '%10.000%'

/*3. Crear un procedimiento almacenado llamado "Programar_mantenimiento" el cu�l debe recibir el id de un veh�culo. 
El procedimiento deber� calcular cu�ntos kil�metros faltan para el pr�ximo mantenimiento, 
si faltan menos de 200 kil�metros deber� programar el mantenimiento con fecha prevista de mantenimiento 
2 dias despu�s de la fecha en la cual se invoque el procedimiento el mantenimiento y 
debera tener sus respectivos items con estado pendiente. 
El procedimiento deber� tener una excepci�n si el id que se pase como par�metro es negativo o igual a cero.
El mantenimiento debe hacerse en el centro de recibo que est� asignado para ese veh�culo y deber� asignar un mec�nico del mismo lugar.
Ejemplo: Un veh�culo tiene 14900 km y se invoca el procedimiento, 
deber� crear y programar el siguiente mantenimiento que es de 15.000km con todos sus items en estado pendiente.*/

--create or replace procedure Programar_mantenimiento as

declare
total_registros integer;
idvehiculo vehiculos.id_vehiculo%type;
kilometraje vehiculos.kilometraje%type;
invalid exception;
plan1 number := 5000;
plan2 number := 10000;
plan3 number := 20000;
plan4 number := 40000;
plan5 number := 50000;
plan6 number := 100000;
comparacion number := 0;
fecha := date;
begin
idvehiculo :=&Valor_1;
if idvehiculo <= 0 then
    raise invalid;
end if; 
    select v.id_vehiculo, v.kilometraje into idvehiculo, kilometraje from vehiculos v where v.id_vehiculo = idvehiculo;
       if kilometraje <= plan1 then
            comparacion := plan1 - kilometraje;
                if comparacion <= 200 then
                    --dbms_output.put_line('Validacion correcta');
                    fecha := SYSDATE + 2;
                    insert into programacion_mtto values (PROG_MTTO_SEQ.NEXTVAL,idvehiculo,)
                end if;    
       end if;
    total_registros := sql%ROWCOUNT;
    dbms_output.put_line('El numero de registros es: ' || total_registros);
    dbms_output.put_line('El vehiculo : ' || idvehiculo || ' Tiene un total de ' || kilometraje || ' Kilometros');
    exception
when invalid then
    dbms_output.put_line('El valor ingresado debe ser mayor a 0'); 
end;

select * from vehiculos

/*4. Crear un trigger sobre la tabla de los veh�culos, cuando cambie el kilometraje de veh�culo deber� invocar el procedimiento 
"Programar_mantenimiento"*/



/*5. La junta directiva desea realizar un cotizador de precios de los env�os, para esto es necesario crear una matriz de precios 
similar a la que se maneja en la realidad (Ver secci�n Tarifas de mensajer�a y paquetes hasta 5 kilos). 
Para esto se decide crear una nueva tabla que tendr� las siguientes columnas: centro_recib_id (Clave for�nea con la tabla 
de centros de recibo), destino_id (Clave for�nea a la tabla c�digos postales o ciudades), precio_kilo (decimal).

Para llenar esta tabla usted crear� una procedimiento llamado "recalcular_tarifas", este procedimiento lo que har� es los siguiente:

Borrar todos los datos de la tabla donde se guardan los precios.
Leer todos los centros de recibo y empezar a recorrerlos uno a uno.
Por cada centro de recibo deber� leer todas las ciudades o c�digos postales.
Deber� generar un decimal aleatorio entre 400 y 1500
Luego insertar� en la tabla el id del centro de recibo, el id de la ciudad o del c�digo postal y el valor generado.*/


/*6, Crear una vista la cual traiga todos los precios por kilo de todas las ciudades destino y como ciudad origen recibir� 
un string "Barranquilla, Medell�n, Cali". Es importante recordar que la liquidaci�n de precios solo se hizo teniendo 
como base las ciudades de cada centro de recibo. 
Ejemplo SELECT * FROM PRECIOS WHERE ORIGEN = 'BARRANQUILLA'. (Observe que no se est� pasando el id del centro de recibo, 
se est� pasando la ciudad a la que pertenece el centro de recibo, por ende hay que hacer los JOINS correspondientes para 
obtener el listado de precios.

Origen	Destino	Nombre Destino	Precio
BARRANQUILLA	234	Acac�as	300
BARRANQUILLA	235	Armenia	500
BARRANQUILLA	236	Marinilla	1200*/


