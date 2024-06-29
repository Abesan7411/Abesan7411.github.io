# Configurar el directorio de trabajo
if (.Platform$OS.type == "windows") {
  setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")
} else {
  setwd("~/Portafolio/Bellabeat_2016")
}

# Limpiar el entorno
rm(list = ls())
gc()

# Cargar librerías necesarias
library(tidyverse)
library(corrplot)
library(lmtest)
library(gridExtra)

# Definir la ruta de los archivos
files_folder <- "data/Fitbit/Processed_Files"
output_folder <- "output/fitbit"

# Crear el directorio de salida si no existe
if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

# Lista de archivos y sus respectivas columnas
file_info <- list(
  list(name = "filtered_dailyActivity_merged.csv", columns = c("Date_time", "TotalSteps")),
  list(name = "filtered_heartrate_seconds_merged.csv", columns = c("Date_time", "Value")),
  list(name = "filtered_weightLogInfo_merged.csv", columns = c("Date_time", "WeightKg")),
  list(name = "filtered_hourlyCalories_merged.csv", columns = c("Date_time", "Calories"))
)

# Leer cada archivo por separado, seleccionar columnas relevantes y resumir para evitar duplicados
data_list <- lapply(file_info, function(info) {
  read_csv(file.path(files_folder, info$name)) %>%
    select(any_of(info$columns)) %>%
    filter(!is.na(Date_time)) %>%
    group_by(Date_time) %>%
    summarise(across(everything(), mean, na.rm = TRUE)) %>%
    ungroup()
})

# Eliminar elementos nulos de la lista de datos
data_list <- Filter(Negate(is.null), data_list)

# Verificar si hay datos en la lista
if (length(data_list) == 0) {
  stop("No se encontraron datos válidos para visualizar.")
}

# Fusionar los conjuntos de datos por Date_time
combined_data <- Reduce(function(x, y) full_join(x, y, by = "Date_time"), data_list)

# Verificar y eliminar filas con valores no finitos
combined_data <- combined_data %>%
  filter(across(everything(), is.finite))

# Normalización de los datos
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

combined_data <- combined_data %>%
  mutate(TotalSteps = normalize(TotalSteps),
         Calories = normalize(Calories),
         Value = normalize(Value),
         WeightKg = normalize(WeightKg))

# Segmentar datos por niveles de actividad de pasos
combined_data <- combined_data %>%
  mutate(ActivityLevel = case_when(
    TotalSteps < 0.33 ~ "Low Activity",
    TotalSteps >= 0.33 & TotalSteps < 0.66 ~ "Moderate Activity",
    TotalSteps >= 0.66 ~ "High Activity"
  ))

# Función para calcular correlación dentro de cada segmento
calculate_correlation <- function(data, segment) {
  segment_data <- data %>% filter(ActivityLevel == segment)
  return(cor(segment_data[, c("TotalSteps", "Calories", "Value", "WeightKg")], use = "complete.obs"))
}

# Calcular matriz de correlación para cada segmento
correlation_matrices <- lapply(unique(combined_data$ActivityLevel), function(segment) {
  calculate_correlation(combined_data, segment)
})

names(correlation_matrices) <- unique(combined_data$ActivityLevel)

# Imprimir matrices de correlación para cada segmento
print(correlation_matrices)

# Función para realizar regresión dentro de cada segmento
perform_regression <- function(data, segment) {
  segment_data <- data %>% filter(ActivityLevel == segment)
  lm_model <- lm(Calories ~ TotalSteps, data = segment_data)
  return(summary(lm_model))
}

# Realizar regresión para cada segmento
regression_results <- lapply(unique(combined_data$ActivityLevel), function(segment) {
  perform_regression(combined_data, segment)
})

names(regression_results) <- unique(combined_data$ActivityLevel)

# Imprimir resultados de regresión para cada segmento
print(regression_results)

# Guardar los resultados de correlación y regresión en archivos separados
saveRDS(correlation_matrices, file = file.path(output_folder, "correlation_matrices.rds"))
saveRDS(regression_results, file = file.path(output_folder, "regression_results.rds"))

# Graficar matriz de dispersión de las variables normalizadas
pairs(combined_data[, c("TotalSteps", "Calories", "Value", "WeightKg")])

# Graficar regresión lineal para cada segmento
plots <- lapply(unique(combined_data$ActivityLevel), function(segment) {
  segment_data <- combined_data %>% filter(ActivityLevel == segment)
  ggplot(segment_data, aes(x = TotalSteps, y = Calories)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE) +
    labs(title = paste("Regresión lineal de Calorías vs. Pasos (", segment, ")", sep = ""),
         x = "Pasos (Normalizado)",
         y = "Calorías (Normalizado)")
})

# Mostrar todos los gráficos de regresión en una sola pantalla
do.call(grid.arrange, c(plots, ncol = 1))
