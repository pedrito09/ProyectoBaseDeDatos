CREATE DOMAIN MaximoPoblacionPlaneta AS BIGINT CHECK (VALUE <= 99999999);
CREATE DOMAIN MaximoNombreSistema AS VARCHAR(30);
CREATE DOMAIN MaximoIdPlaneta AS NUMERIC(16,0) CHECK (VALUE <=999999999999999);

CREATE TABLE SistemaSolar
(
  IdSistemaSolar NUMERIC(20,0) PRIMARY KEY,
  NombreSistema MaximoNombreSistema NOT NULL,
  PlanetasNoHabitables INT NOT NULL,
  Soles INT NOT NULL CHECK (Soles >= 1 and Soles <= 3)
);
ALTER TABLE SistemaSolar
ADD CONSTRAINT CHK_PlanetasNoHabitables CHECK (PlanetasNoHabitables >= 0 and PlanetasNoHabitables <=20);

CREATE TABLE Planeta
(
  IdPlaneta MaximoIdPlaneta PRIMARY KEY,
  NombreComun VARCHAR(30) NOT NULL,
  IdSistemaSolar NUMERIC(20,0) NOT NULL,
  FOREIGN KEY (IdSistemaSolar) REFERENCES SistemaSolar(IdSistemaSolar) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE EstacionEspacial
(
  IdEstacion NUMERIC(12,0) PRIMARY KEY,
  NombreComunEstacion VARCHAR(30) NOT NULL,
  CantidadPoblacion BIGINT NOT NULL,
  IdPlaneta NUMERIC(15,0) NOT NULL,
  FOREIGN KEY (IdPlaneta) REFERENCES Planeta(IdPlaneta) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE EstacionEspacial
ADD CONSTRAINT CHK_CantidadPoblacion CHECK (CantidadPoblacion >= 1 and CantidadPoblacion <=99999999);

CREATE TABLE Recurso
(
  NombreRecurso VARCHAR(30) NOT NULL,
  CantidadRecurso BIGINT NOT NULL CHECK (CantidadRecurso >= 1),
  IdPlaneta NUMERIC(15,0) NOT NULL,
  FOREIGN KEY (IdPlaneta) REFERENCES Planeta(IdPlaneta) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Caracteristicas
(
  Tamaño BIGINT NOT NULL CHECK (Tamaño>=1 and Tamaño <= 9999999999),
  CantidadPoblacion MaximoPoblacionPlaneta NOT NULL,
  CantidadAgua BIGINT NOT NULL CHECK (CantidadAgua >= 1),
  FechaLlegada DATE NOT NULL,
  Idioma VARCHAR(30) NOT NULL,
  IdPlaneta NUMERIC(15,0) PRIMARY KEY,
  FOREIGN KEY (IdPlaneta) REFERENCES Planeta(IdPlaneta) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Director
(
  Nombre VARCHAR(30) NOT NULL,
  IdDirector INT PRIMARY KEY,
  Edad INT NOT NULL,
  IdEstacion NUMERIC(12,0) NOT NULL,
  FOREIGN KEY (IdEstacion) REFERENCES EstacionEspacial(IdEstacion) ON DELETE NO ACTION ON UPDATE CASCADE
);
ALTER TABLE Director
ADD CONSTRAINT CHK_Edad CHECK (Edad >= 20 and Edad <=100);