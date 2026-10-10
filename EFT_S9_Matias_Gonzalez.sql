CREATE SEQUENCE SEQ_CLUB_FUTBOL
    START WITH 703
    INCREMENT BY 4
    NOCACHE
    NOCYCLE;

CREATE TABLE REGION (
    id_region   NUMBER(2),
    nombre_region VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_region PRIMARY KEY (id_region)
);

CREATE TABLE ASOCIACION (
    id_asociacion   NUMBER(4),
    nombre_asociacion VARCHAR2(100) NOT NULL,
    fecha_creacion  DATE NOT NULL,
    tipo_asociacion VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_asociacion PRIMARY KEY (id_asociacion),
 
    CONSTRAINT ck_asoc_fecha CHECK (fecha_creacion >= TO_DATE('1980-12-31', 'YYYY-MM-DD')),
    CONSTRAINT ck_asoc_tipo CHECK (tipo_asociacion IN ('Profesional', 'Amateur'))
);

CREATE TABLE NACIONALIDAD (

    id_nacionalidad NUMBER(6) GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 2),
    nombre_pais     VARCHAR2(60) NOT NULL,
    CONSTRAINT pk_nacionalidad PRIMARY KEY (id_nacionalidad)
);

CREATE TABLE ESCUELAS_FUTBOL (
    id_escuela      NUMBER(6),
    nombre_escuela  VARCHAR2(100) NOT NULL,
    capacidad       NUMBER(5) NOT NULL,
    fecha_fundacion DATE NOT NULL,
    CONSTRAINT pk_escuelas_futbol PRIMARY KEY (id_escuela),
    CONSTRAINT ck_escuela_capacidad CHECK (capacidad > 0)
);

CREATE TABLE IDIOMAS (
    id_idioma     NUMBER(3),
    nombre_idioma VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_idiomas PRIMARY KEY (id_idioma),
    CONSTRAINT un_idioma_nombre UNIQUE (nombre_idioma)
);


CREATE TABLE COMUNA (
    id_comuna     NUMBER(4),
    nombre_comuna VARCHAR2(100) NOT NULL,
    id_region     NUMBER(2) NOT NULL,
    CONSTRAINT pk_comuna PRIMARY KEY (id_comuna),
    CONSTRAINT fk_comuna_region FOREIGN KEY (id_region) REFERENCES REGION(id_region)
);

CREATE TABLE CLUB_FUTBOL (
    id_club       NUMBER(6),
    nombre_club   VARCHAR2(100) NOT NULL,
    patrimonio    NUMBER(15,2) NOT NULL,
    direccion     VARCHAR2(150) NOT NULL,
    CONSTRAINT pk_club_futbol PRIMARY KEY (id_club),

    CONSTRAINT un_club_nombre UNIQUE (nombre_club),
    CONSTRAINT ck_club_patrimonio CHECK (patrimonio >= 0)
);

CREATE TABLE TRABAJADORES (
    id_trabajador    NUMBER(8),
    rut              NUMBER(9) NOT NULL,
    dv               CHAR(1) NOT NULL,
    nombres          VARCHAR2(100) NOT NULL,
    apellidos        VARCHAR2(100) NOT NULL,
    sueldo_base      NUMBER(12,2) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero           CHAR(1) NOT NULL,
    estado_civil     VARCHAR2(20) NOT NULL,
    telefono_movil   VARCHAR2(15) NOT NULL,
    direccion        VARCHAR2(150) NOT NULL,
    id_comuna        NUMBER(4) NOT NULL,
    id_nacionalidad  NUMBER(6) NOT NULL,
    CONSTRAINT pk_trabajadores PRIMARY KEY (id_trabajador),
    CONSTRAINT un_trabajador_rut UNIQUE (rut),
    CONSTRAINT fk_trabajador_comuna FOREIGN KEY (id_comuna) REFERENCES COMUNA(id_comuna),
    CONSTRAINT fk_trabajador_nac FOREIGN KEY (id_nacionalidad) REFERENCES NACIONALIDAD(id_nacionalidad),
    CONSTRAINT ck_trab_genero CHECK (genero IN ('M', 'F')),
    CONSTRAINT ck_trab_sueldo CHECK (sueldo_base > 0)
);



CREATE TABLE JUGADORES (
    id_trabajador           NUMBER(8),
    puesto_campo            VARCHAR2(30) NOT NULL,
    monto_premios_acumulado NUMBER(12,2) DEFAULT 0 NOT NULL,
    id_asociacion           NUMBER(4) NOT NULL,
    id_escuela              NUMBER(6) NULL,
    anio_termino_amateur    NUMBER(4) NULL,
    CONSTRAINT pk_jugadores PRIMARY KEY (id_trabajador),
    CONSTRAINT fk_jugador_trabajador FOREIGN KEY (id_trabajador) REFERENCES TRABAJADORES(id_trabajador) ON DELETE CASCADE,
    CONSTRAINT fk_jugador_asociacion FOREIGN KEY (id_asociacion) REFERENCES ASOCIACION(id_asociacion),
    CONSTRAINT fk_jugador_escuela FOREIGN KEY (id_escuela) REFERENCES ESCUELAS_FUTBOL(id_escuela),
    CONSTRAINT ck_jug_premios CHECK (monto_premios_acumulado >= 0)
);

CREATE TABLE PERSONAL_PLANTA (
    id_trabajador             NUMBER(8),
    cantidad_horas_trabajadas NUMBER(3) NULL,
    valor_hora_extra          NUMBER(10,2) NULL,
    CONSTRAINT pk_personal_planta PRIMARY KEY (id_trabajador),
    CONSTRAINT fk_planta_trabajador FOREIGN KEY (id_trabajador) REFERENCES TRABAJADORES(id_trabajador) ON DELETE CASCADE,
    CONSTRAINT ck_planta_horas CHECK (cantidad_horas_trabajadas >= 0),
    CONSTRAINT ck_planta_v_hora CHECK (valor_hora_extra >= 0)
);



CREATE TABLE JUGADORES_IDIOMAS (
    id_trabajador NUMBER(8),
    id_idioma     NUMBER(3),
    nivel_dominio VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_jugadores_idiomas PRIMARY KEY (id_trabajador, id_idioma),
    CONSTRAINT fk_jugid_jugador FOREIGN KEY (id_trabajador) REFERENCES JUGADORES(id_trabajador) ON DELETE CASCADE,
    CONSTRAINT fk_jugid_idioma FOREIGN KEY (id_idioma) REFERENCES IDIOMAS(id_idioma),
    CONSTRAINT ck_jugid_nivel CHECK (nivel_dominio IN ('Básico', 'Medio', 'Avanzado', 'Nativo'))
);

CREATE TABLE HISTORIAL_CONTRATOS (
    id_trabajador NUMBER(8),
    id_club       NUMBER(6),
    fecha_inicio  DATE,
    fecha_termino DATE NULL,
    CONSTRAINT pk_historial_contratos PRIMARY KEY (id_trabajador, id_club, fecha_inicio),
    CONSTRAINT fk_hist_jugador FOREIGN KEY (id_trabajador) REFERENCES JUGADORES(id_trabajador) ON DELETE CASCADE,
    CONSTRAINT fk_hist_club FOREIGN KEY (id_club) REFERENCES CLUB_FUTBOL(id_club),
    CONSTRAINT ck_hist_fechas CHECK (fecha_termino IS NULL OR fecha_termino > fecha_inicio)
);

INSERT INTO REGION (id_region, nombre_region) VALUES (13, 'Región Metropolitana de Santiago');
INSERT INTO REGION (id_region, nombre_region) VALUES (6, 'Región del Libertador General Bernardo O''Higgins');
INSERT INTO REGION (id_region, nombre_region) VALUES (5, 'Región de Valparaíso');


INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region) VALUES (1301, 'Santiago', 13);
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region) VALUES (1302, 'Macul', 13);
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region) VALUES (601, 'Rancagua', 6);
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region) VALUES (501, 'Viña del Mar', 5);


INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (1001, 'Asociación Nacional de Fútbol Profesional (ANFP)', TO_DATE('1982-10-23', 'YYYY-MM-DD'), 'Profesional');

INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion) 
VALUES (1002, 'Asociación Nacional de Fútbol Amateur (ANFA)', TO_DATE('1981-05-15', 'YYYY-MM-DD'), 'Amateur');


INSERT INTO NACIONALIDAD (nombre_pais) VALUES ('Chile');
INSERT INTO NACIONALIDAD (nombre_pais) VALUES ('Argentina');
INSERT INTO NACIONALIDAD (nombre_pais) VALUES ('Uruguay');


INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Colo-Colo', 25000000.00, 'Maratón 5300, Macul');

INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Universidad de Chile', 18500000.00, 'Avenida El Parrón 0939, La Cisterna');

INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion) 
VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'O''Higgins de Rancagua', 8900000.00, 'Ruta 5 Sur Km 90, Requínoa');

COMMIT;
