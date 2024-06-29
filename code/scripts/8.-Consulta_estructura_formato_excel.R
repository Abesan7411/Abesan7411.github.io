# Configurar el directorio de trabajo
if (.Platform$OS.type == "windows") {
  setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")
} else {
  setwd("~/Portafolio/Bellabeat_2016")
}

#Cargar librerias
library(readxl)
library(tidyverse)
library(janitor)

# Definir la ruta del archivo Excel
file_path <- "data/minsa/raw/datos_ense2017_resumen.xls"

# Leer el archivo Excel y seleccionar el rango de datos
percepcion_salud <- read_excel(file_path, sheet = "T1001_estado_de_salud", range = "A1:F9", col_types = "text")
enfermedades_cronicas <- read_excel(file_path, sheet = "T1025_enfermedades_cronicas", range = "A1:AF9", col_types = "text")
actividad_fisica <- read_excel(file_path, sheet = "T3066_nivel_actividad_fisica", range = "A1:D9", col_types = "text")

# Inspeccionar la estructura de los datos
str(percepcion_salud)
head(percepcion_salud)
summary(percepcion_salud)
str(enfermedades_cronicas)
head(enfermedades_cronicas)
summary(enfermedades_cronicas)
str(actividad_fisica)
head(actividad_fisica)
summary(actividad_fisica)
