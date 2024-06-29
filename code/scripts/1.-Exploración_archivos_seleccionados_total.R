# Configurar el directorio de trabajo
if (.Platform$OS.type == "windows") {
  setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")
} else {
  setwd("~/Portafolio/Bellabeat_2016")
}

# Limpiar el entorno
rm(list = ls())
gc()

# Instalar las librerías necesarias
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("data.table", quietly = TRUE)) install.packages("data.table")

# Cargar las librerías
library(tidyverse)
library(data.table)

# Definir las rutas de los archivos
paths <- list(
  "data/Fitbit/raw/Fitbit_12.03.16_to_11.04.16/",
  "data/Fitbit/raw/Fitbit_12.04.16_to_12.05.16/"
)

# Archivos a procesar en ambas carpetas
archivos_ambas <- c(
  "dailyActivity_merged.csv",
  "heartrate_seconds_merged.csv",
  "weightLogInfo_merged.csv",
  "hourlyCalories_merged.csv",
  "hourlyIntensities_merged.csv",
  "hourlySteps_merged.csv"
)


# Crear una lista para almacenar los resultados
resultados <- list()

# Función para procesar cada archivo en cada ruta
procesar_archivos <- function(ruta, file_path) {
  # Crear una lista para almacenar el resumen
  resumen <- list()
  
  # Leer el archivo
  tryCatch({
    datos <- fread(file.path(ruta, file_path))
    
    # Encadenar las consultas para obtener un resumen completo
    resumen <- list(
      cabecera = head(datos),
      tamaño = object.size(datos),
      formatos = capture.output(str(datos)),
      total_caracteres = sapply(datos, function(x) sum(nchar(as.character(x)))),
      total_lineas = nrow(datos)
    )
  }, error = function(e) {
    resumen <- list(
      error = paste("Error leyendo archivo:", e$message)
    )
  })
  
  return(resumen)
}

# Procesar archivos en ambas carpetas
for (ruta in paths) {
  for (file_path in archivos_ambas) {
    resultados[[paste(basename(ruta), file_path, sep = "_")]] <- procesar_archivos(ruta, file_path)
  }
}

# Mostrar los resultados
print(resultados)