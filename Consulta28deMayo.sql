/* Crear una base de datos llamada UniversidadDB la cual maneja dos modulos:
   academico y seguridad 
   
   Modulo Academico: Carrera y Estudiante.
   Modulo Seguridad: Cargo y usuario.
*/

use master
go

if exists (select * from sys.databases where name = 'UniversidadDB')
begin
	drop database UniversidadDB
end 
go

create database UniversidadDB
go

use UniversidadDB
go

--Schema: Es un contenedor logico que sirve para organizar objetos dentro de una base de datos.

create schema Academico
go

create schema Seguridad
go

create table Academico.Carrera(
	id int primary key identity(1,1),
	nombre nvarchar(100) not null,
	precio decimal(10,2),
	created_at datetime default getdate(),
	update_at datetime null,
	delete_at datetime
)
go

create table Academico.Estudiante(
	id int identity(1,1) primary key,
	cif varchar(8) unique not null,
	nombres nvarchar(60) not null,
	apellidos nvarchar(60) not null,
	fechaNac datetime null,
	email nvarchar(120) null,
	idCarrera int foreign key references Academico.Carrera(id)
)
go

create table Seguridad.Cargo(
	idCargo int identity(1,1) primary key,
	nombre nvarchar(60),
	created_at datetime default getdate(),
	update_at datetime null,
	delete_at datetime
)
go

create table Seguridad.Usuario(
	idUsuario int identity(1,1) primary key,
	cif varchar(8) unique not null,
	nombres nvarchar(60) not null,
	apellidos nvarchar(60) not null,
	fechaNac datetime null,
	pw varbinary (64) not null,
	email nvarchar(120) null,
	created_at datetime default getdate(),
	update_at datetime null,
	delete_at datetime
)
go

-- ================================
--      Aplicacion de cambios
-- ================================

-- Modulo Academico

--Restricciones para Academico.Carrera

alter table Academico.Carrera add constraint PK_Academico_Carrera primary key (id)
alter table Academico.Carrera add constraint UQ_Academico_Carrera_Nombre unique (nombre)
alter table Academico.Carrera add constraint DF_Academico_Carrera_created_at default getdate() for created_at
alter table Academico.Carrera add constraint CK_Academico_Carrera_Precio check (precio>0) --Validacion: Precio mayor a cero

--Restricciones para Academico.Estudiante

alter table Academico.Estudiante add constraint PK_Academico_Estudiante primary key (id)
alter table Academico.Estudiante add constraint UQ_Academico_Estudiante_CIF unique (cif)
alter table Academico.Estudiante add constraint UQ_Academico_Estudiante_Email unique (email)
alter table Academico.Estudiante add constraint FK_Academico_Estudiante_Carrera foreign key (idCarrera) references Academico.Carrera(id)
alter table Academico.Estudiante add constraint CK_Academico_Estudiante_Email check (email like '%_@__%.__%') --Validacion: Formato correo
alter table Academico.Estudiante add constraint CK_Academico_Estudiante_FechaNac check (fechaNac < getdate()) --Validacion: Fecha Pasada

--Modulo Seguridad

--Restricciones para Seguridad.Cargo

alter table Seguridad.Cargo add constraint PK_Seguridad_Cargo primary key (id)
alter table Seguridad.Cargo add	constraint UQ_Seguridad_Cargo_Nombre unique (nombre)
alter table Seguridad.Cargo add	constraint DF_Seguridad_Cargo_created_at default getdate() for created_at

--Restricciones para Seguridad.Usuario

alter table Seguridad.Usuario add constraint PK_Seguridad_Usuario primary key (id)
alter table Seguridad.Usuario add constraint UQ_Seguridad_Usuario_CIF unique(cif)
alter table Seguridad.Usuario add constraint UQ_Seguridad_Usuario_Email unique (email)
alter table Seguridad.Usuario add constraint DF_Seguridad_Usuario_created_at default getdate() for created_at
alter table Seguridad.Usuario add constraint CK_Seguridad_Usuario_Email check (email like '%_@__%.__%') --Validacion: Formato correo
alter table Seguridad.Usuario add constraint CK_Seguridad_Usuario_FechaNac check (fechaNac < getdate()) --Validacion: Fecha Pasada
alter table Seguridad.Usuario add constraint CK_Seguridad_Usuario_pw_Length check (datalength(pw) >= 32) --Validacion: Tamaño minimo

--Modificacion de la tabla Academico.Estudiante
alter table Academico.Estudiante add
	created_at datetime not null,
		constraint DF_Academico_Estudiante_created_at default getdate(),
	update_at datetime null,
	delete_at datetime null

--Relacion entre usuario y cargo
alter table Seguridad.Usuario add
	constraint FK_Seguridad_Usuario_Cargo foreign key (idCargo) references Seguridad.Cargo(id)
go

-- =======================================
--   Pruebas de insercion y verificación
-- =======================================

insert into Academico.Carrera (nombre, precio) values
('Licenciatura en Marketing', 1100),
('Ingenieria industrial', 1500)

--Modificar el precio de una carrera
update Academico.Carrera set precio = 2000.99, update_at = getdate() where id = 1
