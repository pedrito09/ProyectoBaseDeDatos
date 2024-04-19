SELECT 
    ss.NombreSistema AS SistemaSolar,
    ss.PlanetasNoHabitables,
    p.IdPlaneta,
    p.NombreComun,
    c.Tamaño,
    c.CantidadPoblacion,
    c.CantidadAgua
FROM SistemaSolar ss
JOIN Planeta p ON ss.IdSistemaSolar = p.IdSistemaSolar
JOIN Caracteristicas c ON p.IdPlaneta = c.IdPlaneta
WHERE ss.IdSistemaSolar = 50531553963195521588;

SELECT 
    e.NombreComunEstacion AS EstacionEspacial,
    e.CantidadPoblacion,
    d.Nombre AS NombreDirector,
    d.Edad
FROM EstacionEspacial e
JOIN Director d ON e.IdEstacion = d.IdEstacion
ORDER BY e.CantidadPoblacion DESC;

SELECT 
    r.NombreRecurso,
    r.CantidadRecurso,
    p.NombreComun AS NombrePlaneta
FROM Recurso r
JOIN Planeta p ON r.IdPlaneta = p.IdPlaneta
JOIN SistemaSolar ss ON p.IdSistemaSolar = ss.IdSistemaSolar
WHERE ss.IdSistemaSolar = 43530544223289826019;



CREATE VIEW VistaPlanetasDetallada AS
SELECT 
    p.IdPlaneta,
    p.NombreComun,
    c.Tamaño,
    c.CantidadPoblacion,
    c.CantidadAgua,
    r.NombreRecurso,
    r.CantidadRecurso
FROM Planeta p
JOIN Caracteristicas c ON p.IdPlaneta = c.IdPlaneta
LEFT JOIN Recurso r ON p.IdPlaneta = r.IdPlaneta
ORDER BY c.CantidadPoblacion DESC;

-- Ejemplo
SELECT * FROM VistaPlanetasDetallada;

CREATE VIEW VistaSistemasSolaresConRecursos AS
SELECT 
    ss.IdSistemaSolar,
    ss.NombreSistema,
    SUM(CASE WHEN r.NombreRecurso = 'Diamante' THEN r.CantidadRecurso END) AS Diamante,
    SUM(CASE WHEN r.NombreRecurso = 'Azufre' THEN r.CantidadRecurso END) AS Azufre,
    SUM(CASE WHEN r.NombreRecurso = 'Carne' THEN r.CantidadRecurso END) AS Carne,
	SUM(CASE WHEN r.NombreRecurso = 'Hierro' THEN r.CantidadRecurso END) AS Hierro,
	SUM(CASE WHEN r.NombreRecurso = 'Madera' THEN r.CantidadRecurso END) AS Madera,
	SUM(CASE WHEN r.NombreRecurso = 'Platino' THEN r.CantidadRecurso END) AS Platino,
	SUM(CASE WHEN r.NombreRecurso = 'Titanio' THEN r.CantidadRecurso END) AS Titanio,
	SUM(CASE WHEN r.NombreRecurso = 'Arena' THEN r.CantidadRecurso END) AS Arena,
	SUM(CASE WHEN r.NombreRecurso = 'Carbon' THEN r.CantidadRecurso END) AS Carbon
FROM SistemaSolar ss
LEFT JOIN Planeta p ON ss.IdSistemaSolar = p.IdSistemaSolar
LEFT JOIN Recurso r ON p.IdPlaneta = r.IdPlaneta
GROUP BY ss.IdSistemaSolar, ss.NombreSistema;
--Ejemplo
SELECT * FROM VistaSistemasSolaresConRecursos;


CREATE VIEW VistaClasificacionPoblacion AS
SELECT 
    p.IdPlaneta,
    p.NombreComun,
    SUM(c.CantidadPoblacion) AS TotalPoblacion,
    CASE 
        WHEN SUM(c.CantidadPoblacion) < 1000000 THEN 'Poco Poblado'
        WHEN SUM(c.CantidadPoblacion) >= 1000000 AND SUM(c.CantidadPoblacion) < 10000000 THEN 'Moderadamente Poblado'
        WHEN SUM(c.CantidadPoblacion) >= 10000000 THEN 'Altamente Poblado'
    END AS ClasificacionPoblacion
FROM Planeta p
JOIN Caracteristicas c ON p.IdPlaneta = c.IdPlaneta
GROUP BY p.IdPlaneta, p.NombreComun;
-- Ejemplo
SELECT * FROM VistaClasificacionPoblacion;


--Mas Ejemplos 
-- Seleccionar los planetas, sus características y recursos en un sistema solar específico
SELECT *
FROM VistaPlanetasDetallada
WHERE IdPlaneta IN (SELECT IdPlaneta FROM Planeta WHERE IdSistemaSolar = (SELECT IdSistemaSolar FROM SistemaSolar WHERE NombreSistema = 'NfqmH1513Wm5aOyjFHmHEUuP8d4t8'));

-- Seleccionar planetas con clasificación de población 'Altamente Poblado'
SELECT *
FROM VistaClasificacionPoblacion
WHERE ClasificacionPoblacion = 'Altamente Poblado';

-- Seleccionar la clasificación de población y la cantidad total de recursos en cada sistema solar
SELECT vcp.IdPlaneta, vcp.NombreComun, vcp.ClasificacionPoblacion, vcsr.*
FROM VistaClasificacionPoblacion vcp
JOIN VistaSistemasSolaresConRecursos vcsr ON vcp.IdPlaneta = vcsr.IdPlaneta;