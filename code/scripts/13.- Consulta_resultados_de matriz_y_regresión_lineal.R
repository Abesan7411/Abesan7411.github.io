# Configurar el directorio de trabajo
if (.Platform$OS.type == "windows") {
  setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")
} else {
  setwd("~/Portafolio/Bellabeat_2016")
}

# Cargar la matriz de correlación desde el archivo .rds
matriz_correlacion <- readRDS(file.path("output/minsa", "matriz_correlacion.rds"))

# Visualizar la matriz de correlación
print(matriz_correlacion)

# Cargar el resumen del modelo de regresión lineal desde el archivo .rds
resumen_modelo <- readRDS(file.path("output/minsa", "modelo_regresion.rds"))

# Visualizar el resumen del modelo de regresión lineal
print(resumen_modelo)
