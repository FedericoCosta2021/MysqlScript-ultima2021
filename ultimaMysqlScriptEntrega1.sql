DROP DATABASE IF EXISTS ultimaDB;
CREATE DATABASE ultimaDB;
USE ultimaDB;

drop user if exists alumnoLogin@"localhost";
drop user if exists docenteLogin@"localhost";
drop user if exists adminLogin@"localhost";
drop user if exists alumnoDB@"localhost";
drop user if exists docenteDB@"localhost";
drop user if exists adminDB@"localhost";
/*
CREATE TABLE checker_hack ( 
    i tinyint,
    test varchar(23),
    i_must_be_between_7_and_12 BOOLEAN 
         GENERATED ALWAYS AS (IF(i BETWEEN 7 AND 12, true, NULL)) 
         VIRTUAL NOT NULL
);

select * from checker_hack;
INSERT INTO checker_hack (i) VALUES (12);


delimiter $$
CREATE TRIGGER emptyString BEFORE INSERT ON Persona
       FOR EACH ROW
       chk: Begin 
       IF(Persona.nombre = '   ') THEN
       SET NEW.nombre=null;
       END IF; 
       IF(Persona.apellido = '   ') THEN
       SET NEW.apellido=null;
       END IF;
       
       END $$
       
delimiter ;
       
INSERT INTO persona VALUES(111111,'asd','sddd','clave1',0,NULL,NULL, TRUE);

select * from persona;
*/

CREATE TABLE Grupo (
idGrupo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreGrupo VARCHAR(10) NOT NULL
);

CREATE TABLE Materia(
idMateria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombreMateria VARCHAR(25) NOT NULL
);

CREATE TABLE Grupo_tiene_Materia (
    idGrupo INT NOT NULL,
    idMateria INT NOT NULL,
    PRIMARY KEY (idGrupo , idMateria),
    FOREIGN KEY (idGrupo)
        REFERENCES Grupo (idGrupo),
    FOREIGN KEY (idMateria)
        REFERENCES Materia (idMateria)
); 

CREATE TABLE Orientacion(
idOrientacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombreOrientacion VARCHAR(25) NOT NULL
);

CREATE TABLE Orientacion_tiene_Grupo (
idOrientacion INT NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (idGrupo),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
FOREIGN KEY (idOrientacion) REFERENCES Orientacion(idOrientacion)
);

CREATE TABLE Persona (
    ci INT(8) PRIMARY KEY NOT NULL,
    nombre VARCHAR(26) NOT NULL,
    apellido VARCHAR(26) NOT NULL,
    clave VARCHAR(32) NOT NULL ,
    isDeleted BOOL NOT NULL,
    foto BLOB  NULL,
    avatar BLOB  NULL,
    enLinea BOOL NOT NULL,
    CONSTRAINT notIn5point7 CHECK (ci between 10000000 AND 99999999),
    CONSTRAINT notIn5point72 CHECK (nombre regexp "^[a-zA-Z]+$"),
    CONSTRAINT notIn5point713 CHECK (apellido regexp "^[a-zA-Z]+$")
);

/* 
       IF(NEW.nombre not REGEXP '[:alpha:]') THEN
DECLARE start  INT unsigned DEFAULT 1; 

drop trigger emptyString;
delimiter $$
CREATE TRIGGER emptyString BEFORE INSERT ON Persona
       FOR EACH ROW
       Begin 
       IF(NEW.nombre not like '[a-z]') THEN
			SET NEW.nombre=null;
       END IF; 
       IF(NEW.apellido  REGEXP '[0-9]') THEN
       SET NEW.apellido=null;
       END IF;
       END $$
delimiter ;
INSERT INTO Persona Values (111,"abcdefghijklmnopqrstuvwxyz","ab","clave1",false,null,null,false);
numbers OR symbols
*/

CREATE TABLE Administrador (
    ci INT NOT NULL UNIQUE,
    idAdmin INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idAdmin , ci),
    FOREIGN KEY (ci)
        REFERENCES persona (ci)
);
CREATE TABLE Docente (
	ci INT NOT NULL UNIQUE,
    idDocente INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idDocente,ci),
    FOREIGN KEY (ci)
        REFERENCES Persona (ci)
);

/*grupos will be stored as a string and filtered with regular expression*/
CREATE TABLE AlumnoTemp(
ci INT(8) PRIMARY KEY NOT NULL ,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    clave VARCHAR(32) NOT NULL,
    foto BLOB  NULL,
    avatar BLOB  NULL,
    apodo VARCHAR(20) UNIQUE,
    grupos VARCHAR(30) NOT NULL,
	CONSTRAINT d CHECK (ci between 10000000 AND 99999999),
    CONSTRAINT adsa CHECK (nombre regexp "^[a-zA-Z]+$"),
    CONSTRAINT sadddas CHECK (apellido regexp "^[a-zA-Z]+$"));
    
CREATE TABLE Docente_dicta_G_M (
idGrupo INT NOT NULL,
idMateria INT NOT NULL,
docenteCi INT,
PRIMARY KEY (idGrupo,idMateria),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
FOREIGN KEY (idMateria) REFERENCES Materia(idMateria),
FOREIGN KEY (docenteCi) REFERENCES Docente (ci)
);

CREATE TABLE Alumno (
  ci INT(8) NOT NULL,
    idAlumno INT NOT NULL AUTO_INCREMENT,
    apodo VARCHAR(20) UNIQUE,
    PRIMARY KEY(idAlumno,ci),
    FOREIGN KEY (ci)
        REFERENCES Persona (ci)
);
CREATE TABLE Alumno_tiene_Grupo(
alumnoCi INT NOT NULL,
idGrupo INT NOT NULL,
PRIMARY KEY (alumnoCi,idGrupo),
FOREIGN KEY (alumnoCi) REFERENCES Alumno(ci),
FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo)
);

CREATE TABLE ConsultaPrivada (
    idConsultaPrivada INT NOT NULL,
    docenteCi INT,
    alumnoCi INT,
    titulo VARCHAR(50) NOT NULL,
    cpStatus ENUM('pendiente', 'resuelta') NOT NULL,
    cpFechaHora DATETIME NOT NULL,
    PRIMARY KEY (idConsultaPrivada,docenteCi, alumnoCi),
    FOREIGN KEY (docenteCi)
        REFERENCES Docente (ci),
    FOREIGN KEY (alumnoCi)
        REFERENCES Alumno (ci));
        
CREATE TABLE CP_mensaje(
idCp_mensaje INT NOT NULL,
idConsultaPrivada INT NOT NULL,
ciAlumno INT NOT NULL,
ciDocente INT NOT NULL,
contenido VARCHAR(10000) NOT NULL,
attachment MEDIUMBLOB,
cp_mensajeFechaHora DATETIME NOT NULL,
cp_mensajeStatus ENUM('recibido','leido'),
ciDestinatario INT NOT NULL,
PRIMARY KEY(idCp_mensaje,idConsultaPrivada,ciAlumno,ciDocente),
FOREIGN KEY (idConsultaPrivada) REFERENCES ConsultaPrivada (idConsultaPrivada),
FOREIGN KEY (ciAlumno) REFERENCES Alumno (ci),
FOREIGN KEY (ciDocente) REFERENCES Docente (ci),
FOREIGN KEY (ciDestinatario) REFERENCES Persona (ci));

/*******************************************USUARIOS PARA LA FORM DE LOGIN/REGISTRO**************************************************/

create user "alumnoLogin"@"localhost" identified by "alumnoLogin";
grant select (ci) on ultimaDB.Alumno to "alumnoLogin"@"localhost";
grant select on ultimaDB.Persona to "alumnoLogin"@"localhost";
grant select on ultimaDB.Grupo to "alumnoLogin"@"localhost";
grant insert on ultimaDB.AlumnoTemp to "alumnoLogin"@"localhost";

create user "docenteLogin"@"localhost" identified by "docenteLogin";
grant select (ci) on ultimaDB.Docente to "docenteLogin"@"localhost";
grant select on ultimaDB.Persona to "docenteLogin"@"localhost";

create user "adminLogin"@"localhost" identified by "adminLogin";
grant select (ci) on ultimaDB.Administrador to "adminLogin"@"localhost";
grant select on ultimaDB.Persona to "adminLogin"@"localhost";

/****************************************USUARIOS NORMALES DE LA APP*******************************************************************/

create user "alumnoDB"@"localhost" identified by "alumnoclave";
grant all privileges on ultimaDB.* to "alumnoDB"@"localhost";

create user "docenteDB"@"localhost" identified by "docenteclave";
grant all privileges on ultimaDB.* to "docenteDB"@"localhost";

create user "adminDB"@"localhost" identified by "adminclave";
grant all privileges on ultimaDB.* to "adminDB"@"localhost";



/********************************DEMO***********************************************/
INSERT INTO Grupo (nombreGrupo) VALUES 
('1BB'),('2BB'),('3BB'),('3BA'),('3BC');

INSERT INTO Materia(nombreMateria) VALUES
('mat1'),('geo1'),('prog1'),('SO1'),('taller1'),
('mat2'),('geo2'),('prog2'),('SO2'),('taller2'),
('mat3'),('prog3'),('SO3'),('redes y soporte'),('disenio web'),('unity');

INSERT INTO Grupo_tiene_Materia VALUES 
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,6),(2,7),(2,8),(2,9),(2,10),
(3,11),(3,12),(3,13),(3,14),
(4,11),(4,12),(4,13),(4,15),
(5,11),(5,12),(5,13),(5,16);

INSERT INTO Orientacion(nombreOrientacion) VALUES
('desarollo y soporte'),('disenio web'),('disenio de juegos');

INSERT INTO Orientacion_tiene_Grupo VALUES
(1,3),
(2,4),
(3,5);

INSERT INTO Persona VALUES
(11111111,'Penelope','cruz','clave1',0,NULL,NULL, TRUE),
(22222222,'pepe','red','clave2',0,NULL,NULL, TRUE),
(33333333,'coco','rock','clave3',0,NULL,NULL, TRUE),
(44444444,'lex','luther','clave4',0,NULL,NULL, TRUE),
(55555555,'arm','pit','clave5',0,NULL,NULL, TRUE),
(66666666,'amy','schumer','clave6',0,NULL,NULL, TRUE),
(77777777,'abel','sings','clave7',0,NULL,NULL, TRUE),
(88888888,'sal','gore','clave8',0,NULL,NULL, TRUE),
(99999999,'adam','sandler','adminclave',0,NULL,NULL,TRUE);

INSERT INTO Administrador(ci) VALUES (99999999);

INSERT INTO Docente (ci) VALUES
(77777777),
(88888888);


INSERT INTO Docente_dicta_G_M VALUES 
(1,1,77777777),
(1,2,NULL),
(1,4,NULL),
(1,5,NULL),
(2,6,77777777),
(2,7,NULL),
(2,8,NULL),
(2,9,NULL),
(2,10,NULL),
(3,13,NULL),
(3,14,NULL),
(4,11,NULL),
(4,12,NULL),
(4,13,NULL),
(4,15,NULL),
(5,11,NULL),
(5,12,NULL),
(5,13,NULL),
(5,16,NULL),
(3,11,77777777),
(1,3,88888888),
(3,12,88888888);

INSERT INTO Alumno (ci,apodo) VALUES
(11111111,'fefito'),
(22222222,'pRed'),
(33333333,'cRock'),
(44444444,'Lexy'),
(55555555,'pittt'),
(66666666,'ahumer');

INSERT INTO Alumno_tiene_Grupo VALUES 
(11111111,1),
(11111111,2),
(22222222,3),
(33333333,1),
(44444444,2),
(55555555,5),
(66666666,3),
(66666666,1),
(22222222,2),
(44444444,1);

INSERT INTO ConsultaPrivada(idConsultaPrivada,docenteCi,alumnoCi,titulo,cpStatus,cpFechaHora) VALUES
(1,77777777,11111111,'hola','pendiente',NOW()),
(1,77777777,22222222,'profe hello','pendiente',NOW()),
(1,77777777,33333333,'soy tu alumno','pendiente',NOW()),
(1,77777777,44444444,'prat1','pendiente',NOW()),
(1,88888888,11111111,'prat1 ej3','pendiente',NOW()),
(1,88888888,33333333,'prat4','pendiente',NOW()),
(1,88888888,55555555,'prat3','pendiente',NOW()),
(2,77777777,11111111,'HOLAAAA','pendiente',NOW()),
(3,77777777,11111111,'todobien?','pendiente',NOW()),
(4,77777777,11111111,'faltas hoy?','pendiente',NOW());

INSERT INTO CP_Mensaje (idCp_mensaje,idConsultaPrivada,ciDocente,ciAlumno,contenido,attachment,cp_mensajeFechaHora,cp_mensajeStatus, ciDestinatario)
VALUES 
(1,1,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,1,77777777,11111111,'asderererwasda',NULL,NOW(),'leido',11111111),
(1,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',77777777),
(2,1,77777777,22222222,'asdasda',NULL,NOW(),'recibido',22222222),
(1,1,77777777,33333333,'fsdfsdfsdfsd',NULL,NOW(),'leido',77777777),
(2,1,77777777,33333333,'gfgfdgdf',NULL,NOW(),'leido',77777777),
(1,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',77777777),
(2,1,77777777,44444444,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',44444444),
(1,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,11111111,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',11111111),
(1,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(2,1,88888888,33333333,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',33333333),
(1,1,88888888,55555555,'sdfsdsdssdsdsdsdsd',NULL,NOW(),'leido',88888888),
(1,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,2,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(1,3,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,3,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111),
(1,4,77777777,11111111,'asdasda',NULL,NOW(),'recibido',77777777),
(2,4,77777777,11111111,'asdasda',NULL,NOW(),'recibido',11111111);
