# Configurar el directorio de trabajo
if (.Platform$OS.type == "windows") {
  setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")
} else {
  setwd("~/Portafolio/Bellabeat_2016")
}

# Limpiar el entorno
rm(list = ls())
gc()

#Cargar librerias
library(readxl)
library(tidyverse)
library(janitor)

# Definir la ruta del archivo Excel
file_path <- "data/minsa/raw/datos_ense2017_resumen.xls"

# Leer el archivo Excel y seleccionar el rango de datos
enfermedad_cronica <- read_excel(file_path, sheet = "T1025_enfermedades_cronicas", range = "A1:AF9", col_types = "text")

# Limpiar nombres de columnas
enfermedad_cronica_clean <- enfermedad_cronica %>%
  janitor::clean_names()

# Convertir las columnas seleccionadas a numéricas y reemplazar comas por puntos
enfermedad_cronica_clean <- enfermedad_cronica_clean %>%
  mutate(across(tension_alta:colesterol_alto, ~ as.numeric(str_replace_all(., ",", "."))))

# Inspeccionar la estructura de los datos limpiados
str(enfermedad_cronica_clean)
head(enfermedad_cronica_clean)
summary(enfermedad_cronica_clean)

# Seleccionar las columnas de interés
enfermedad_cronica_clean_subset <- enfermedad_cronica_clean %>%
  select(mujeres, tension_alta, artrosis, dolor_espalda_cervical, dolor_espalda_lumbar, diabetes, colesterol_alto)

# Reorganizar los datos en un formato adecuado para graficar
enfermedad_cronica_mujeres_melted <- enfermedad_cronica_clean_subset %>%
  pivot_longer(cols = tension_alta:colesterol_alto, names_to = "enfermedad", values_to = "porcentaje")

# Normalizar los datos dentro de cada grupo etario
enfermedad_cronica_mujeres_melted <- enfermedad_cronica_mujeres_melted %>%
  group_by(mujeres) %>%
  mutate(porcentaje = porcentaje / sum(porcentaje, na.rm = TRUE) * 100) %>%
  ungroup()

# Crear el gráfico de barras
enfermedad_cronica_mujeres_melted %>%
  ggplot(aes(x = mujeres, y = porcentaje, fill = enfermedad)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Prevalencia de enfermedades relacionadas con la falta de actividad física por grupo etario",
       x = "Grupo Etareo",
       y = "Porcentaje",
       fill = "Enfermedad") +
  theme_minimal()

