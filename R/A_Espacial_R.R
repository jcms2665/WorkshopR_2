
# An�lisis Espacial con R


## Contenido

#1. Mapa tem�tico
#2. �ndice de Mooran

#1. Mapa tem�tico

# Cambiar directorio de trabajo
setwd("C:\\Users\\jmartinez\\Desktop\\teTra-Red-master\\teTra-Red-master")


# Lista de librer�as:
list.of.packages <- c("rgdal", "sp", "GISTools", "RColorBrewer", "ggplot2",
                      "reshape2", "grid", "gridExtra")
# Ver qu� no est� instalado
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

# Si falta algo, instalarlo
if (length(new.packages)) install.packages(new.packages)


library(rgdal)
distritos <- readOGR("data", "elecciones_simplified", stringsAsFactors = FALSE,
                     GDAL1_integer64_policy = T)

colnames(distritos@data)

library(GISTools)
library(RColorBrewer)


# Definir m�rgenes para ocupar todo el espacio
par(mar = c(0, 0, 1.5, 0))

# Definir un esquema para colorear el mapa de acuerdo a desviaciones
# est�ndar
shades <- auto.shading(distritos$PRI94, cutter = sdCuts, n = 6, cols = rev(brewer.pal(6,"RdYlBu")))

# Definimos el mapa tem�tico
choropleth(distritos, distritos$PRI94, shades)

# Agregar una leyenda
choro.legend(-95, 32, shades, under = "<", over = ">", between = "a", box.lty = "blank",
             x.intersp = 0.75, y.intersp = 0.75, cex = 0.75)
# Agregar t�tulo
title(main = "Porcentaje de votos ganados por el PRI en 1994\n(desviaciones est�ndar)",
      cex.main = 0.75)




#2. �ndice de Mooran


# Lista de librer�as:
list.of.packages <- c("spdep")

# Ver qu� no est� instalado
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,
                                                                              "Package"])]
# Si falta algo, instalarlo
if (length(new.packages)) install.packages(new.packages)

library(rgdal)

mpb <- readOGR("data", "mpb00")

frontera <- readOGR("data", "BOUNDARY")

#Ahora cargamos la biblioteca spdep.
library(spdep)

# Calcular los vecinos m�s cercanos y hacer una lista
k1 <- knn2nb(knearneigh(mpb, k = 1, longlat = TRUE))

# Calcular distancias de los vecinos m�s cercanos, hacer un vector y encontrar el m�ximo
distancia <- max(unlist(nbdists(k1, mpb)))

# Encontrar vecinos
vecinos <- dnearneigh(mpb, 0, distancia)

summary(vecinos)


# Lista de pesos
mpb.lw <- nb2listw(vecinos) # style = "W" estandarizada por rengl�n
#mpb.lw <- nb2listw(vecinos, style = "B") # pesos binarios
#mpb.lw <- nb2listw(vecinos, style = "C") # estandarizada por rengl�n globalmente


# Estandarizar valores de Z y salvarlos como una nueva columna
mpb$zScaled <- scale(mpb$Z)

# Calcular la variable de retraso y salvarla
mpb$lagZ <- lag.listw(mpb.lw, mpb$Z)

summary(mpb$zScaled)
summary(mpb$lagZ)

# Diagrama de dispersi�n
plot(mpb$zScaled, mpb$lagZ)

# Ejes que pasan por el origen
abline(h = 0, v = 0)

# Recta de ajuste lineal entre las dos variables
abline(lm(mpb$lagZ ~ mpb$zScaled), lty = 2, lwd = 2, col = "red")
title("Diagrama de dispersi�n de Moran")

# Con variables estandarizadas
plot(mpb$zScaled,mpb$lagZ-mean(mpb$lagZ))

# o bien, plot(mpb$zScaled,scale(mpb$lagZ))
abline(h = 0, v = 0)
abline(lm(mpb$lagZ-mean(mpb$lagZ) ~ mpb$zScaled), lty = 2, lwd = 2, col = "red")
title("Diagrama de dispersi�n de Moran")

