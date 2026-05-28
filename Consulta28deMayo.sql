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