# Cargar los archivos RDS
matriz_correlacion <- readRDS("output/minsa/matriz_correlacion.rds")
modelo_regresion <- readRDS("output/minsa/modelo_regresion.rds")

# Visualizar matrices de correlación
matriz_correlacion

# Visualizar resultados de regresión
modelo_regresion