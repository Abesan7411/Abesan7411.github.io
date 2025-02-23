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
library(lubridate)
library(gridExtra)

# Definir la ruta de los archivos combinados
combined_files_folder <- "data/Fitbit/Processed_Files"

# Lista de archivos combinados
combined_files <- c(
  "filtered_dailyActivity_merged.csv",
  "filtered_heartrate_seconds_merged.csv",
  "filtered_weightLogInfo_merged.csv",
  "filtered_hourlyCalories_merged.csv"
)

# Función para leer archivos combinados
read_combined_data <- function(files_folder, files) {
  combined_data <- lapply(files, function(file) {
    read_csv(file.path(files_folder, file))
  })
  names(combined_data) <- files
  return(combined_data)
}

# Leer los datos combinados
combined_data <- read_combined_data(combined_files_folder, combined_files)

# Visualizar algunas observaciones de los datos combinados
head(combined_data[[1]])

# Función para normalizar datos
normalize <- function(x) {
  return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
}

# Normalizar los datos
combined_data[["filtered_dailyActivity_merged.csv"]] <- combined_data[["filtered_dailyActivity_merged.csv"]] %>%
  mutate(TotalSteps = normalize(TotalSteps))

combined_data[["filtered_heartrate_seconds_merged.csv"]] <- combined_data[["filtered_heartrate_seconds_merged.csv"]] %>%
  mutate(Value = normalize(Value))

combined_data[["filtered_weightLogInfo_merged.csv"]] <- combined_data[["filtered_weightLogInfo_merged.csv"]] %>%
  mutate(WeightKg = normalize(WeightKg))

combined_data[["filtered_hourlyCalories_merged.csv"]] <- combined_data[["filtered_hourlyCalories_merged.csv"]] %>%
  mutate(Calories = normalize(Calories))

# Segmentar datos por grupos de usuarios (ejemplo por niveles de actividad)
combined_data[["filtered_dailyActivity_merged.csv"]] <- combined_data[["filtered_dailyActivity_merged.csv"]] %>%
  mutate(ActivityLevel = case_when(
    TotalSteps < 0.33 ~ "Low Activity",
    TotalSteps >= 0.33 & TotalSteps < 0.66 ~ "Moderate Activity",
    TotalSteps >= 0.66 ~ "High Activity"
  ))

# Graficar promedios de pasos diarios por niveles de actividad
combined_daily_steps_segmented <- combined_data[["filtered_dailyActivity_merged.csv"]] %>%
  group_by(Date_time, ActivityLevel) %>%
  summarise(AverageSteps = mean(TotalSteps, na.rm = TRUE))

plot_steps_segmented <- ggplot(combined_daily_steps_segmented, aes(x = Date_time, y = AverageSteps, color = ActivityLevel)) +
  geom_line() +
  labs(title = "Distribución Promedio de Pasos Diarios por Nivel de Actividad", x = "Fecha", y = "Pasos Promedio") +
  facet_wrap(~ ActivityLevel)

# Segmentar datos por frecuencia cardíaca
combined_data[["filtered_heartrate_seconds_merged.csv"]] <- combined_data[["filtered_heartrate_seconds_merged.csv"]] %>%
  mutate(HeartRateLevel = case_when(
    Value < 0.33 ~ "Low Heart Rate",
    Value >= 0.33 & Value < 0.66 ~ "Moderate Heart Rate",
    Value >= 0.66 ~ "High Heart Rate"
  ))

# Graficar promedios de frecuencia cardíaca por niveles
combined_heart_rate_segmented <- combined_data[["filtered_heartrate_seconds_merged.csv"]] %>%
  group_by(Date_time, HeartRateLevel) %>%
  summarise(AverageHeartRate = mean(Value, na.rm = TRUE))

plot_heart_rate_segmented <- ggplot(combined_heart_rate_segmented, aes(x = Date_time, y = AverageHeartRate, color = HeartRateLevel)) +
  geom_line() +
  labs(title = "Distribución Promedio de Frecuencia Cardíaca por Nivel", x = "Fecha", y = "Frecuencia Cardíaca Promedio") +
  facet_wrap(~ HeartRateLevel)

# Segmentar datos por peso
combined_data[["filtered_weightLogInfo_merged.csv"]] <- combined_data[["filtered_weightLogInfo_merged.csv"]] %>%
  mutate(WeightLevel = case_when(
    WeightKg < 0.33 ~ "Low Weight",
    WeightKg >= 0.33 & WeightKg < 0.66 ~ "Moderate Weight",
    WeightKg >= 0.66 ~ "High Weight"
  ))

# Graficar promedios de peso por niveles
combined_weight_segmented <- combined_data[["filtered_weightLogInfo_merged.csv"]] %>%
  group_by(Date_time, WeightLevel) %>%
  summarise(AverageWeight = mean(WeightKg, na.rm = TRUE))

plot_weight_segmented <- ggplot(combined_weight_segmented, aes(x = Date_time, y = AverageWeight, color = WeightLevel)) +
  geom_line() +
  labs(title = "Distribución Promedio de Peso por Nivel", x = "Fecha", y = "Peso Promedio") +
  facet_wrap(~ WeightLevel)

# Segmentar datos por calorías
combined_data[["filtered_hourlyCalories_merged.csv"]] <- combined_data[["filtered_hourlyCalories_merged.csv"]] %>%
  mutate(CaloriesLevel = case_when(
    Calories < 0.33 ~ "Low Calories",
    Calories >= 0.33 & Calories < 0.66 ~ "Moderate Calories",
    Calories >= 0.66 ~ "High Calories"
  ))

# Graficar promedios de calorías por niveles
combined_calories_segmented <- combined_data[["filtered_hourlyCalories_merged.csv"]] %>%
  group_by(Date_time, CaloriesLevel) %>%
  summarise(AverageCalories = mean(Calories, na.rm = TRUE))

plot_calories_segmented <- ggplot(combined_calories_segmented, aes(x = Date_time, y = AverageCalories, color = CaloriesLevel)) +
  geom_line() +
  labs(title = "Distribución Promedio de Calorías por Nivel", x = "Fecha", y = "Calorías Promedio") +
  facet_wrap(~ CaloriesLevel)

# Mostrar todos los gráficos en una sola pantalla
grid.arrange(plot_steps_segmented, plot_heart_rate_segmented, plot_weight_segmented, plot_calories_segmented, ncol = 2, nrow = 2)
