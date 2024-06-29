# Instalar paquetes si es necesario
if (!requireNamespace("knitr", quietly = TRUE)) install.packages("knitr")
if (!requireNamespace("kableExtra", quietly = TRUE)) install.packages("kableExtra")
if (!requireNamespace("webshot", quietly = TRUE)) install.packages("webshot")
if (!requireNamespace("htmlwidgets", quietly = TRUE)) install.packages("htmlwidgets")
if (!requireNamespace("DT", quietly = TRUE)) install.packages("DT")

# Cargar librerías
library(knitr)
library(kableExtra)
library(webshot)
library(htmlwidgets)
library(DT)

# Instalar PhantomJS si es necesario
if (!webshot::is_phantomjs_installed()) webshot::install_phantomjs()

# Configurar el directorio de trabajo
setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")

# Cargar los archivos RDS
matriz_correlacion_minsa <- readRDS("output/minsa/matriz_correlacion.rds")
modelo_regresion_minsa <- readRDS("output/minsa/modelo_regresion.rds")

# Crear y guardar la tabla de la matriz de correlación
kable_matriz_correlacion <- kable(matriz_correlacion_minsa, format = "html", table.attr = "class='table table-bordered table-hover'") %>%
  kable_styling(full_width = F) %>%
  add_header_above(c(" ", "Matriz de Correlación MINSA" = ncol(matriz_correlacion_minsa)))
save_kable(kable_matriz_correlacion, file = "correlation_matrix_minsa.html")

# Convertir el archivo HTML a una imagen
webshot("correlation_matrix_minsa.html", "correlation_matrix_minsa.png")

# Extraer los coeficientes y los valores p del modelo de regresión
coeficientes <- as.data.frame(summary(modelo_regresion_minsa)$coefficients)

# Crear y guardar la tabla de coeficientes de regresión
kable_coeficientes <- kable(coeficientes, format = "html", table.attr = "class='table table-bordered table-hover'") %>%
  kable_styling(full_width = F) %>%
  add_header_above(c(" ", "Coeficientes del Modelo de Regresión MINSA" = ncol(coeficientes)))
save_kable(kable_coeficientes, file = "regression_coefficients_minsa.html")

# Convertir el archivo HTML a una imagen
webshot("regression_coefficients_minsa.html", "regression_coefficients_minsa.png")

# Generar tablas con DT::datatable
datatable_minsa_correlation <- datatable(matriz_correlacion_minsa)

# Guardar las tablas como archivos HTML
saveWidget(datatable_minsa_correlation, "datatable_minsa_correlation.html")

# Convertir los archivos HTML a imágenes
webshot("datatable_minsa_correlation.html", "datatable_minsa_correlation.png")