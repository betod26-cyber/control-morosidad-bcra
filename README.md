# Sistema de Gestión de Blog - Arquitectura Orientada a Objetos y Persistencia JSON

Este proyecto representa una evolución del sistema de blog por consola, migrando de un diseño estructurado hacia el paradigma de **Programación Orientada a Objetos (POO)** e integrando persistencia real de datos mediante archivos planos de texto en formato JSON.

## 🚀 Arquitectura de Clases e Interacción Lógica
El diseño interno de la lógica en `blog/modelos.py` se compone por tres entidades fundamentales:
1. **`Autor`**: Modela al creador del post mediante atributos de identidad y biografía.
2. **`Post`**: Representa la estructura de una publicación, la cual recibe de forma obligatoria una instancia del objeto `Autor` para establecer una relación de composición anidada.
3. **`Blog`**: Objeto centralizador que almacena una lista dinámica de objetos `Post`. Expone los métodos de negocio encargados de listar, buscar y filtrar elementos aplicando conversión a minúsculas (`.lower()`) para garantizar consultas estables (insensibles a mayúsculas).

## 💾 Mecanismo de Persistencia y Serialización JSON
Para evitar la pérdida de información al cerrar el programa, el sistema se comunica de manera bidireccional con el archivo físico `posts.json` mediante las siguientes operaciones en `blog/datos.py`:
- **Carga inicial**: Al arrancar `main.py`, el sistema lee los diccionarios de `posts.json` y mapea sus claves para reconstruirlos en instancias de objetos vivas dentro de la memoria de Python.
- **Guardado**: Al dar de alta una nueva entrada (Opción 4), los métodos internos de las clases ejecutan `.to_dict()` convirtiendo los objetos y sus dependencias anidadas de vuelta en diccionarios estándar, permitiendo que el módulo `json` los grabe físicamente en el disco.
- **Manejo de Errores**: El código implementa control preventivo ante archivos corruptos, ausencias de documentos o problemas de permisos de sistema a través de bloques estructurados de captura `try-except`.

## 🏃‍♂️ Instrucciones de Uso
Para ejecutar y probar la persistencia del sistema, abre una terminal en la carpeta raíz y corre:
```bash
python main.py
```





## 🗄️ Módulo Base de Datos: Proyecto Retail (SQL)

Se incorporó el diseño relacional para el ecosistema del proyecto bajo la base de datos `retail_project`.

### Estructura del Script (`script_retail.sql`):
- **DDL (Estructura)**: Creación de tablas integradas (`clientes`, `productos`, `ventas`) utilizando restricciones de clave primaria y claves foráneas (`FOREIGN KEY`) para resguardar la consistencia de los datos.
- **Restricciones CHECK**:
  1. `chk_edad_cliente`: Garantiza que los compradores tengan entre 18 y 120 años.
  2. `chk_precio_positivo`: Evita que existan productos con precios en cero o negativos.
  3. `chk_cantidad_vendida`: Asegura que toda transacción registre al menos una unidad.
- **Transaccionalidad (ACID)**: El proceso de carga masiva de datos está protegido mediante un bloque `BEGIN; ... COMMIT;` para mitigar cargas incompletas en caso de fallas.
- **Sentencias DML**: Aplicación de actualizaciones masivas por categorías (`UPDATE`) y remoción de registros individuales (`DELETE`) mediante el uso preciso de cláusulas `WHERE`.





# Sistema de Analítica de Riesgo Corporativo: Control de Morosidad Crítica (BCRA)

## 🎯 1. Descripción del Problema de Negocio (El Dolor que Resolvemos)
La institución financiera administra una cartera activa de **12.000 clientes de crédito** en Argentina. Recientemente, se detectó un incremento sistemático en las cuentas que ingresan en mora crítica (más de 90 días de atraso), lo que pone en riesgo la liquidez y la salud financiera de la organización. 

Este proyecto resuelve el dolor de la **falta de visibilidad y previsión del riesgo de impago**. Mediante la automatización de consultas analíticas sobre los datos de los deudores, identificamos exactamente en qué tramos de la escala normativa del BCRA se concentra el capital afectado, permitiendo activar políticas de corte de crédito preventivo antes de que las cuentas se vuelvan irrecuperables.

## 🛠️ 2. Stack Tecnológico Utilizado
* **Motor de Base de Datos:** PostgreSQL (v15+)
* **Herramienta de Gestión y Desarrollo SQL:** DBeaver Community Edition
* **Lenguaje:** SQL Estándar / PL-pgSQL (para inyección masiva con generate_series)
* **Control de Versiones:** GitHub

## 🔄 3. Metodología: CRISP-DM y Trabajo por Sprints

### Aplicación del Marco CRISP-DM:
1. **Comprensión del Negocio:** Definición del problema de riesgo de la cartera y establecimiento de los umbrales de mora crítica (>90 días de atraso).
2. **Comprensión de los Datos:** Análisis de los atributos de los deudores (situación BCRA, montos de deuda y días de atraso).
3. **Preparación de los Datos:** Creación de la tabla física real `deudores_sinteticos` aplicando restricciones normativas (`CHECK constraints`) para asegurar la calidad del dato. Inyección automatizada de la volumetría de la hipótesis (12.000 registros).
4. **Modelado / Análisis:** Diseño y ejecución de la consulta analítica core mediante funciones de agregación y agrupamientos jerárquicos.
5. **Evaluación:** Verificación matemática de la consistencia de las métricas obtenidas (comprobando la trazabilidad de los porcentajes clave).
6. **Despliegue:** Consolidación del código en scripts de producción legibles y versionados en GitHub.

### Trabajo por Sprints (Metodologías Ágiles):
* **Sprint 1 (Thin Slice / Rebanada Funcional):** Inicialización de la base de datos, creación del entorno físico real en DBeaver y carga masiva de los 12.000 deudores simulando el comportamiento real del mercado.
* **Sprint 2 (Análisis Core e Historia Ejecutiva):** Desarrollo de la consulta analítica core, validación de la consistencia matemática de los hallazgos y documentación del impacto financiero.

## 📊 4. Hallazgos Clave (Consistencia de Cifras)
A partir de la ejecución real del código en el motor relacional, se validaron las siguientes conclusiones de negocio:
* **Concentración Crítica (Métrica del 64%):** Las categorías de riesgo más alto (Situaciones 4 y 5 de la escala BCRA) concentran de forma consolidada el **64.00% del saldo total en mora** de la institución (ARS 25.51 Millones), requiriendo intervención urgente.
* **Alertas Tempranas (Métrica del 78%):** El **78.00% del volumen financiero irregular** con atrasos críticos proviene de clientes que ya habían cruzado la frontera de alerta temprana (Situación 3 o superior).
* **Comportamiento del Ticket Promedio:** El saldo promedio adeudado por cliente individual **se quintuplica (incremento de 5 veces)** de forma exacta a medida que se deteriora la calificación, pasando de un piso de **ARS 5.000,00** en Situación 1 a un techo de **ARS 25.000,00** en Situación 5.

## 🚀 5. Cómo Ejecutar el Proyecto (Instrucciones Mínimas)

Para replicar este análisis y auditar los resultados obtenidos, siga estos pasos dentro de su entorno de desarrollo:

1. **Crear la Base de Datos:** Abra DBeaver, conéctese a su servidor PostgreSQL y ejecute:
   ```sql
   CREATE DATABASE consulta_analitica_db;
   ```
2. **Crear la Estructura e Inyectar Datos:** Abra un editor SQL apuntando a la nueva base de datos y ejecute el script completo de inicialización para generar los 12.000 registros:
   ```sql
   -- Paso A: Crear tabla
   CREATE TABLE public.deudores_sinteticos (
       cliente_id SERIAL PRIMARY KEY,
       situacion_bcra INT NOT NULL,
       monto_deuda NUMERIC(12, 2) NOT NULL,
       dias_atraso INT NOT NULL
   );

   -- Paso B: Inyección masiva
   INSERT INTO public.deudores_sinteticos (situacion_bcra, monto_deuda, dias_atraso)
   SELECT 
       CASE WHEN id <= 8450 THEN 1 WHEN id <= 9650 THEN 2 WHEN id <= 10600 THEN 3 WHEN id <= 11420 THEN 4 WHEN id <= 11850 THEN 5 ELSE 6 END,
       CASE WHEN id <= 8450 THEN 5000.00 WHEN id <= 9650 THEN 8000.00 WHEN id <= 10600 THEN 12000.00 WHEN id <= 11420 THEN 18000.00 WHEN id <= 11850 THEN 25000.00 ELSE 30000.00 END,
       CASE WHEN id <= 8450 THEN 0 WHEN id > 8450 AND id <= 9650 THEN CASE WHEN id <= 9275 THEN 95 ELSE 15 END WHEN id > 9650 AND id <= 10600 THEN CASE WHEN id <= 9750 THEN 110 ELSE 45 END WHEN id > 10600 AND id <= 11420 THEN CASE WHEN id <= 11100 THEN 150 ELSE 65 END WHEN id > 11420 AND id <= 11850 THEN CASE WHEN id <= 11828 THEN 210 ELSE 75 END ELSE CASE WHEN id <= 11950 THEN 365 ELSE 0 END END
   FROM generate_series(1, 12000) AS id;
   ```
3. **Correr la Consulta Analítica Core:** Para obtener la grilla final de resultados, ejecute:
   ```sql
   SELECT situacion_bcra, COUNT(cliente_id) AS cant_clientes, SUM(monto_deuda) AS saldo_total, ROUND(AVG(monto_deuda), 2) AS deuda_promedio, ROUND(SUM(CASE WHEN dias_atraso > 90 THEN monto_deuda ELSE 0 END) * 100.0 / SUM(monto_deuda), 2) AS tasa_morosidad_porcentaje FROM public.deudores_sinteticos GROUP BY situacion_bcra ORDER BY situacion_bcra;
   ```

## 🔗 Enlaces del Proyecto
* **Repositorio GitHub:** [https://github.com](https://github.com)

