CREATE TABLE IF NOT EXISTS empleados (
    id       SERIAL PRIMARY KEY,
    nombre   VARCHAR(100),
    email    VARCHAR(100),
    rol      VARCHAR(50),
    salario  INTEGER
);

INSERT INTO empleados (nombre, email, rol, salario) VALUES
    ('Ana García',    'ana.garcia@empresa.local',    'Directora IT',  85000),
    ('Luis Martínez', 'luis.martinez@empresa.local', 'Desarrollador', 52000),
    ('Sara López',    'sara.lopez@empresa.local',    'RRHH',          48000);
