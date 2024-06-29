# Configurar el directorio de trabajo
if (.Platform$OS.type == "windows") {
  setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")
} else {
  setwd("~/Portafolio/Bellabeat_2016")
}

# Configurar el directorio de trabajo
setwd("output/fitbit")

# Cargar los archivos RDS
correlation_matrices <- readRDS("correlation_matrices.rds")
regression_results <- readRDS("regression_results.rds")

# Visualizar matrices de correlación
print(correlation_matrices)

# Visualizar una matriz de correlación específica
print(correlation_matrices[["Low Activity"]])

# Visualizar resultados de regresión
print(regression_results)

# Visualizar los resultados de una regresión específica
print(regression_results[["Low Activity"]])