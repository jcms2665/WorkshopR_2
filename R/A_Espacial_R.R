
# Análisis Espacial con R


## Contenido

#1. Mapa temático
#2. Índice de Mooran

#1. Mapa temático

# Cambiar directorio de trabajo
setwd("C:\\Users\\jmartinez\\Desktop\\teTra-Red-master\\teTra-Red-master")


# Lista de librerías:
list.of.packages <- c("rgdal", "sp", "GISTools", "RColorBrewer", "ggplot2",
                      "reshape2", "grid", "gridExtra")
# Ver qué no está instalado
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

# Si falta algo, instalarlo
if (length(new.packages)) install.packages(new.packages)


library(rgdal)
distritos <- readOGR("data", "elecciones_simplified", stringsAsFactors = FALSE,
                     GDAL1_integer64_policy = T)

colnames(distritos@data)

library(GISTools)
library(RColorBrewer)


# Definir márgenes para ocupar todo el espacio
par(mar = c(0, 0, 1.5, 0))

# Definir un esquema para colorear el mapa de acuerdo a desviaciones
# estándar
shades <- auto.shading(distritos$PRI94, cutter = sdCuts, n = 6, cols = rev(brewer.pal(6,"RdYlBu")))

# Definimos el mapa temático
choropleth(distritos, distritos$PRI94, shades)

# Agregar una leyenda
choro.legend(-95, 32, shades, under = "<", over = ">", between = "a", box.lty = "blank",
             x.intersp = 0.75, y.intersp = 0.75, cex = 0.75)
# Agregar título
title(main = "Porcentaje de votos ganados por el PRI en 1994\n(desviaciones estándar)",
      cex.main = 0.75)




#2. Índice de Mooran


# Lista de librerías:
list.of.packages <- c("spdep")

# Ver qué no está instalado
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,
                                                                              "Package"])]
# Si falta algo, instalarlo
if (length(new.packages)) install.packages(new.packages)

library(rgdal)

mpb <- readOGR("data", "mpb00")

frontera <- readOGR("data", "BOUNDARY")

#Ahora cargamos la biblioteca spdep.
library(spdep)

# Calcular los vecinos más cercanos y hacer una lista
k1 <- knn2nb(knearneigh(mpb, k = 1, longlat = TRUE))

# Calcular distancias de los vecinos más cercanos, hacer un vector y encontrar el máximo
distancia <- max(unlist(nbdists(k1, mpb)))

# Encontrar vecinos
vecinos <- dnearneigh(mpb, 0, distancia)

summary(vecinos)


# Lista de pesos
mpb.lw <- nb2listw(vecinos) # style = "W" estandarizada por renglón
#mpb.lw <- nb2listw(vecinos, style = "B") # pesos binarios
#mpb.lw <- nb2listw(vecinos, style = "C") # estandarizada por renglón globalmente


# Estandarizar valores de Z y salvarlos como una nueva columna
mpb$zScaled <- scale(mpb$Z)

# Calcular la variable de retraso y salvarla
mpb$lagZ <- lag.listw(mpb.lw, mpb$Z)

summary(mpb$zScaled)
summary(mpb$lagZ)

# Diagrama de dispersión
plot(mpb$zScaled, mpb$lagZ)

# Ejes que pasan por el origen
abline(h = 0, v = 0)

# Recta de ajuste lineal entre las dos variables
abline(lm(mpb$lagZ ~ mpb$zScaled), lty = 2, lwd = 2, col = "red")
title("Diagrama de dispersión de Moran")

# Con variables estandarizadas
plot(mpb$zScaled,mpb$lagZ-mean(mpb$lagZ))

# o bien, plot(mpb$zScaled,scale(mpb$lagZ))
abline(h = 0, v = 0)
abline(lm(mpb$lagZ-mean(mpb$lagZ) ~ mpb$zScaled), lty = 2, lwd = 2, col = "red")
title("Diagrama de dispersión de Moran")

