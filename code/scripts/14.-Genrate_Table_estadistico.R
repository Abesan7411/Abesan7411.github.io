# Instalar paquetes si es necesario
if (!requireNamespace("knitr", quietly = TRUE)) install.packages("knitr")
if (!requireNamespace("kableExtra", quietly = TRUE)) install.packages("kableExtra")
if (!requireNamespace("webshot", quietly = TRUE)) install.packages("webshot")
if (!requireNamespace("htmlwidgets", quietly = TRUE)) install.packages("htmlwidgets")

# Cargar librerías
library(knitr)
library(kableExtra)
library(webshot)
library(htmlwidgets)

# Instalar PhantomJS si es necesario
if (!webshot::is_phantomjs_installed()) webshot::install_phantomjs()

# Configurar el directorio de trabajo
setwd("C:/Users/FX506/Documents/Portafolio/Bellabeat_2016")

# Cargar los archivos RDS
correlation_matrices <- readRDS("output/fitbit/correlation_matrices.rds")
regression_results <- readRDS("output/fitbit/regression_results.rds")

# Generar tablas con knitr::kable
kable_moderate_activity <- kable(correlation_matrices[["Moderate Activity"]], caption = "Moderate Activity Correlation Matrix")
kable_high_activity <- kable(correlation_matrices[["High Activity"]], caption = "High Activity Correlation Matrix")
kable_low_activity <- kable(correlation_matrices[["Low Activity"]], caption = "Low Activity Correlation Matrix")

# Guardar las tablas como archivos HTML con kableExtra::save_kable
save_kable(kable_moderate_activity, file = "correlation_moderate_activity.html")
save_kable(kable_high_activity, file = "correlation_high_activity.html")
save_kable(kable_low_activity, file = "correlation_low_activity.html")

# Convertir los archivos HTML a imágenes
webshot("correlation_moderate_activity.html", "correlation_moderate_activity.png")
webshot("correlation_high_activity.html", "correlation_high_activity.png")
webshot("correlation_low_activity.html", "correlation_low_activity.png")

# Generar tablas con DT::datatable
datatable_moderate_activity <- datatable(correlation_matrices[["Moderate Activity"]])
datatable_high_activity <- datatable(correlation_matrices[["High Activity"]])
datatable_low_activity <- datatable(correlation_matrices[["Low Activity"]])

# Guardar las tablas como archivos HTML
saveWidget(datatable_moderate_activity, "datatable_moderate_activity.html")
saveWidget(datatable_high_activity, "datatable_high_activity.html")
saveWidget(datatable_low_activity, "datatable_low_activity.html")

# Convertir los archivos HTML a imágenes
webshot("datatable_moderate_activity.html", "datatable_moderate_activity.png")
webshot("datatable_high_activity.html", "datatable_high_activity.png")
webshot("datatable_low_activity.html", "datatable_low_activity.png")