# Configurar el directorio de trabajo
if (.Platform$OS.type == "windows") {
  setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")
} else {
  setwd("~/Portafolio/Bellabeat_2016")
}

# Limpiar el entorno
rm(list = ls())  # Elimina todos los objetos del entorno
gc()  # Libera memoria no utilizada

# Instalar las librerías necesarias
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("data.table", quietly = TRUE)) install.packages("data.table")

# Cargar las librerías
library(tidyverse)
library(data.table)

# Definir función para procesar archivos
process_files <- function(file_path) {
  print(paste("Procesando archivo:", file_path))
  
  # Cargar archivo
  data <- fread(file_path)
  
  # Verificar si la segunda columna tiene formato de fecha
  if (inherits(data[[2]], "character")) {
    print(paste("Convirtiendo formato de fecha en:", file_path))
    
    # Convertir la segunda columna a formato de fecha YYYY-MM-DD
    data[[2]] <- as.Date(data[[2]], format = "%m/%d/%Y")
  }
  
  # Cambiar el nombre de la segunda columna a "Date_time"
  names(data)[2] <- "Date_time"
  
  # Guardar el archivo procesado
  fwrite(data, file_path, row.names = FALSE)
  
  # Verificar si los cambios se guardaron correctamente
  data_check <- fread(file_path)
  if (names(data_check)[2] == "Date_time") {
    print(paste("Archivo procesado y guardado correctamente:", file_path))
  } else {
    print(paste("Error al guardar el archivo:", file_path))
  }
  
  # Devolver el nombre del archivo procesado
  return(basename(file_path))
}

# Definir las rutas relativas de los archivos
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

# Verificar la existencia de los archivos
file_verification <- lapply(paths, function(path) {
  # Verificar que el directorio existe
  if (!dir.exists(path)) {
    print(paste("El directorio no existe:", path))
    return(NULL)
  }
  
  # Listar archivos en la carpeta
  files <- list.files(path)
  
  # Imprimir los archivos encontrados
  print(paste("Archivos encontrados en", path, ":", paste(files, collapse = ", ")))
  
  # Verificar cada archivo
  results <- lapply(files, function(file) {
    file_path <- file.path(path, file)
    if (file %in% archivos_ambas) {
      # Si el archivo está en la lista de archivos comunes, procesarlo
      process_files(file_path)
    } else {
      # Si el archivo no está en la lista, imprimir un mensaje de archivo no encontrado
      print(paste("Archivo no encontrado en la lista de archivos comunes:", file_path))
      NULL
    }
  })
  
  # Devolver los resultados de la verificación
  return(results)
})

# Mostrar los resultados de la verificación
print(file_verification)
