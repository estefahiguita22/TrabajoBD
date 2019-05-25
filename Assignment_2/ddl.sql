--TABLAS SIN FK

create table departamentos (
id number primary key not null,
nombre_depto varchar2(255)
);

create table clientes (
cedula_nit number primary key not null,
nombre varchar2(255),
telefono varchar2(255)
);

create table plan_mtto (
id number primary key not null,
nombre varchar2(255),
kilometraje number
);

create table items (
id number primary key not null,
nombre varchar2(255)
);

--TABLAS CON FK

create table municipios (
id number primary key not null,
nombre_mpio varchar2(255),
id_depto number
);

create table codigo_postales (
id number primary key not null,
zona_postal number,
codigo_postal number,
limite_norte varchar2(255),
limite_sur varchar2(255),
limite_este varchar2(255),
limite_oeste varchar2(255),
tipo varchar2(255),
barrios_contenidos_en_el_codigo_postal varchar2(300),
veredas_contenidas_en_el_codigo_postal varchar2(300),
id_mpio number not null
);


create table centro_recibos(
id number primary key not null,
tipo varchar2(255),
check (tipo in ('Convencionales','Terminal_Carga')),
direccion varchar2(255),
telefono varchar2(255),
id_codigo_postal number not null,
id_mpio number not null
);

create table vehiculos (
id number primary key not null,
marca varchar2(255),
modelo varchar2(255),
linea varchar2(255),
tipo_combustible varchar2(255),
kilometraje number,
capacidad varchar2(255),
id_centror number not null
);

create table empleados (
id number primary key not null,
nombre varchar2(255),
cod_empleado varchar2(255),
direccion varchar2(255),
telefono varchar2(255),
salario varchar2(255),
jefe_directo number null,
cargo varchar2(255),
id_centror number not null
);

create table programacion_mtto(
id number primary key not null,
id_vehiculo number not null,
fecha date,
id_empleado number not null,
id_plan_mtto number not null,
estado varchar2(255),
observaciones varchar2(255)
);

create table detalle_prog_mtto(
id number primary key not null,
id_programacion number not null,
id_detalle number not null,
estado varchar2(255),
observaciones varchar2(255)
);

create table detalle_mtto(
id number primary key not null,
id_plan_mtto number not null,
id_item number not null
);

create table guia (
id number primary key not null,
peso_real number,
ancho number,
largo number,
alto number,
peso_volumen number,
cedula_nit_remitente number not null,
cedula_nit_destinatario number not null,
fecha_despacho date,
hora_despacho date,
fecha_entrega date,
hora_entrega date,
observaciones varchar2(255),
id_mpio_origen number not null,
id_mpio_destino number not null,
id_cod_postal_origen number not null,
id_cod_postal_desti number not null,
unidades number,
flete_fijo number,
flete_variable number,
otros_valores number,
valor_servicio number,
estado varchar2(255),
check (estado in ('A_recibir', 'En_Terminal_Origen', 'En_Transporte', 'En_Terminal_Destino', 'En_Reparto', 'Entregada')),
tipo_servicio varchar2(255),
check (tipo_servicio in ('Carga', 'Aerea', 'Mercancia', 'Firma_Documentos', 'Radicacion_Documentos'))
);


create table rastreo_guia(
id number primary key not null,
--estado_guia varchar2(255),
--check (estado_guia in ('A_recibir', 'En_Terminal_Origen', 'En_Transporte', 'En_Terminal_Destino', 'En_Reparto', 'Entregada')),
fecha date,
hora date,
id_guia number not null
);


--FOREIGNG KEYS

alter table vehiculos
add (
constraint id_centror_CENTRO_RECIBOS
foreign key (id_centror) references CENTRO_RECIBOS (ID)
);

alter table municipios
add (
constraint id_depto_DEPARTAMENTOS
foreign key (id_depto) references DEPARTAMENTOS (ID)
);

alter table codigo_postales
add (
constraint id_mpio_MUNICIPIOS
foreign key (id_mpio) references MUNICIPIOS (ID)
);


alter table centro_recibos
add (
constraint id_mpio_MUNICIPIOS_id_codigo_postal_CODIGO_POSTALES
foreign key (id_mpio) references MUNICIPIOS (ID)
);

alter table empleados
add (
constraint jefe_directo_EMPLEADOS_id_centror_CENTRO_RECIBOS
foreign key (jefe_directo) references EMPLEADOS (ID),
foreign key (id_centror) references CENTRO_RECIBOS (ID)
);

alter table programacion_mtto
add (
constraint id_vehiculo_VEHICULOS_id_empleado_EMPLEADOS_id_plan_mtto_PLAN_MTTO
foreign key (id_vehiculo) references VEHICULOS (ID),
foreign key (id_empleado) references EMPLEADOS (ID),
foreign key (id_plan_mtto) references PLAN_MTTO (ID)
);

alter table detalle_prog_mtto
add (
constraint id_detalle_DETALLE_MTTO_id_programacion_PROGRAMACION_MTTO
foreign key (id_detalle) references DETALLE_MTTO (ID),
foreign key (id_programacion) references PROGRAMACION_MTTO (ID)
);

alter table detalle_mtto
add (
constraint id_plan_mtto_PLAN_MTTO_id_item_ITEMS
foreign key (id_plan_mtto) references PLAN_MTTO (ID),
foreign key (id_item) references ITEMS (ID)
);

alter table guia
add (
constraint cedula_nit_remitente_CLIENTES_cedula_nit_destinatario_CLIENTES_id_mpio_origen_MUNICIPIOS_id_mpio_destino_MUNICIPIOS
foreign key (cedula_nit_remitente) references CLIENTES (CEDULA_NIT),
foreign key (cedula_nit_destinatario) references CLIENTES (CEDULA_NIT),
foreign key (id_mpio_origen) references MUNICIPIOS (ID),
foreign key (id_mpio_destino) references MUNICIPIOS (ID)
);

alter table rastreo_guia
add (
constraint id_guia_GUIA
foreign key (id_guia) references GUIA (ID)
);


--DEPARTAMENTOS (1-99)
--MUNICPIOS (5001-99800)
--CODIGO_POSTALES (100-3790)
--CLIENTES (YA DEFINIDOS)
--EMPLEADOS (1-99)
--VEHICULOS (4000-4050)
--ITEMS (100.000-100.049)
--PLAN_MTTO (100.050-100.059)
--CENTROS DE RECIBO (100.060-100.099)
--DETALLE_MTTO (100.100-100.499)
--PROGRAMACION_MTTO (100.500-100.999)
--GUIA (101.000-101.499)
--DETALLE_PROG_MTTO (101.500-101.999)
--ID_RASTREO (102.000-102.499)



/* DECLARE
FECHAA DATE;
BEGIN
FECHAA := SYSDATE + 2;
DBMS_OUTPUT.put_line (FECHAA);
END;


CREATE SEQUENCE PROG_MTTO_SEQ
START WITH 1056
INCREMENT BY 1
MAXVALUE 1099 */

/* centro de recibo lo puedo asociar a codigo postal ok
ignorar municipio postal ok
vehivulo asociado a centros de recibos ok
tipo de servicios sobraria, puedo manejarlo como check ok
agregar campo kilometraje (numerico) ok
agregar estado y obsv detalle_prog_mtto ok
agregar estado programacion_mtto ok
asociar cargo mecanico*/