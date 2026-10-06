-- ============================================================================
-- REBANADA FUNCIONAL: CONTROL DE MOROSIDAD CRÍTICA
-- ============================================================================

-- 1. Estructura física real
CREATE TABLE public.deudores_sinteticos (
    cliente_id SERIAL PRIMARY KEY,
    situacion_bcra INT NOT NULL,
    monto_deuda NUMERIC(12, 2) NOT NULL,
    dias_atraso INT NOT NULL
);

-- 2. Inyección masiva de los 12.000 registros
INSERT INTO public.deudores_sinteticos (situacion_bcra, monto_deuda, dias_atraso)
SELECT 
    CASE WHEN id <= 8450 THEN 1 WHEN id <= 9650 THEN 2 WHEN id <= 10600 THEN 3 WHEN id <= 11420 THEN 4 WHEN id <= 11850 THEN 5 ELSE 6 END,
    CASE WHEN id <= 8450 THEN 5000.00 WHEN id <= 9650 THEN 8000.00 WHEN id <= 10600 THEN 12000.00 WHEN id <= 11420 THEN 18000.00 WHEN id <= 11850 THEN 25000.00 ELSE 30000.00 END,
    CASE WHEN id <= 8450 THEN 0 WHEN id > 8450 AND id <= 9650 THEN CASE WHEN id <= 9275 THEN 95 ELSE 15 END WHEN id > 9650 AND id <= 10600 THEN CASE WHEN id <= 9750 THEN 110 ELSE 45 END WHEN id > 10600 AND id <= 11420 THEN CASE WHEN id <= 11100 THEN 150 ELSE 65 END WHEN id > 11420 AND id <= 11850 THEN CASE WHEN id <= 11828 THEN 210 ELSE 75 END ELSE CASE WHEN id <= 11950 THEN 365 ELSE 0 END END
FROM generate_series(1, 12000) AS id;

-- 3. Consulta Analítica Core (La que va a la Página 2 del PDF)
SELECT
    situacion_bcra,
    COUNT(cliente_id) AS cantidad_clientes,
    SUM(monto_deuda) AS saldo_adeudado_total,
    ROUND(AVG(monto_deuda), 2) AS deud_promedio,
    ROUND(SUM(CASE WHEN dias_atraso > 90 THEN monto_deuda ELSE 0 END) * 100.0 / SUM(monto_deuda), 2) AS tasa_morosidad_porcentaje
FROM public.deudores_sinteticos
GROUP BY situacion_bcra
ORDER BY situacion_bcra;
