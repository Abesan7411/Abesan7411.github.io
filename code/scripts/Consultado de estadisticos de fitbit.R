# Cargar los archivos RDS
correlation_matrices <- readRDS("output/fitbit/correlation_matrices.rds")
regression_results <- readRDS("output/fitbit/regression_results.rds")

# Visualizar matrices de correlación
correlation_matrices

# Visualizar resultados de regresión
regression_results