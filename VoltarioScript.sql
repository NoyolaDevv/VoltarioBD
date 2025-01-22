create table public.categorias
(
    id_categoria serial
        primary key,
    nombre       varchar(100) not null,
    descripcion  text,
    status       status_type  not null
);

alter table public.categorias
    owner to postgres;

create table public.marcas
(
    id_marca    serial
        primary key,
    nombre      varchar(50) not null,
    descripcion text,
    status      status_type not null
);

alter table public.marcas
    owner to postgres;

create table public.condiciones
(
    id_condicion serial
        primary key,
    descripcion  varchar(20) not null,
    status       status_type not null
);

alter table public.condiciones
    owner to postgres;

create table public.roles
(
    id_rol      serial
        primary key,
    nombre_rol  varchar(50) not null,
    descripcion text,
    status      status_type not null
);

alter table public.roles
    owner to postgres;

create table public.usuarios
(
    id_usuario       serial
        primary key,
    id_rol           serial
        constraint fk_usuarios_id_rol
            references public.roles,
    nombre           varchar(40)  not null,
    segundo_nombre   varchar(40),
    apellido_paterno varchar(40)  not null,
    apellido_materno varchar(40),
    matricula        varchar(30)  not null,
    correo           varchar(50)  not null,
    contrasena       varchar(256) not null,
    fecha_creacion   timestamp    not null,
    ultima_sesion    timestamp,
    status           status_type  not null,
    unique (matricula, correo)
);

alter table public.usuarios
    owner to postgres;

create table public.inicio_sesion
(
    id_sesion  serial
        primary key,
    id_usuario serial
        constraint fk_inicio_sesion_id_usuario
            references public.usuarios,
    ip         varchar(20) not null,
    token      text,
    fecha_hora timestamp   not null
);

alter table public.inicio_sesion
    owner to postgres;

create table public.herramientas
(
    id_herramienta serial
        primary key,
    id_categoria   serial
        constraint fk_herramientas_id_categoria
            references public.categorias,
    id_marca       serial
        constraint fk_herramientas_id_marca
            references public.marcas,
    id_condicion   serial
        constraint fk_herramientas_id_condicion
            references public.condiciones,
    nombre         varchar(50) not null,
    numero_serie   varchar(60) not null,
    status         status_type not null,
    fecha_alta     timestamp   not null,
    descripcion    text        not null,
    url_imagen     varchar(50),
    datos_tecnicos varchar(100)
);

alter table public.herramientas
    owner to postgres;

create table public.vale_status
(
    id_vale_status serial
        primary key,
    descripcion    text,
    status         status_type not null
);

alter table public.vale_status
    owner to postgres;

create table public.vales
(
    id_vale             serial
        primary key,
    id_usuario_solicito serial
        constraint fk_vales_id_usuario_solicito
            references public.usuarios,
    id_vale_status      serial
        constraint fk_vales_id_vale_status
            references public.vale_status,
    fecha_emision       timestamp   not null,
    cantidad_prestada   integer     not null,
    status              status_type not null,
    descripcion         text        not null,
    observaciones       text        not null
);

alter table public.vales
    owner to postgres;

create table public.detalle_vale
(
    id_detalle       serial
        primary key,
    id_vale          serial
        constraint fk_detalle_vale_id_vale
            references public.vales,
    id_herramienta   serial
        constraint fk_detalle_vale_id_herramienta
            references public.herramientas,
    fecha_prestamo   timestamp not null,
    fecha_devolucion timestamp not null,
    devuelto         boolean   not null,
    observacion      text      not null
);

alter table public.detalle_vale
    owner to postgres;

create table public.historial_condicion_herramientas
(
    id_histori_condi_herramienta integer default nextval('historial_condicion_herramient_id_histori_condi_herramienta_seq'::regclass) not null
        primary key,
    id_condicion                 serial
        constraint fk_historial_condicion_herramientas_id_condicion
            references public.condiciones,
    id_herramienta               serial
        constraint fk_historial_condicion_herramientas_id_herramienta
            references public.herramientas,
    usuario_cambio               serial
        constraint fk_historial_condicion_herramientas_id_usuario_cambio
            references public.usuarios,
    ultima_condicion             boolean                                                                                              not null,
    fecha_registro               timestamp                                                                                            not null
);

alter table public.historial_condicion_herramientas
    owner to postgres;

