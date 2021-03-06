


setwd("C:\\Users\\jmartinez\\Desktop\\WorkshopR_2-master")

library(rgdal)
distritos <- readOGR("chihuahua", "AGEBs_MPOChih", stringsAsFactors = FALSE,
                     GDAL1_integer64_policy = T)

colnames(distritos@data)

library(GISTools)
library(RColorBrewer)


# Definir m�rgenes para ocupar todo el espacio
par(mar = c(0, 0, 1.5, 0))

# Definir un esquema para colorear el mapa de acuerdo a desviaciones
# est�ndar
shades <- auto.shading(distritos$POB20_R, cutter = sdCuts, n = 6, cols = rev(brewer.pal(6,"RdYlBu")))

# Definimos el mapa tem�tico
choropleth(distritos, distritos$POB20_R, shades)

# Agregar una leyenda
choro.legend(-95, 32, shades, under = "<", over = ">", between = "a", box.lty = "blank",
             x.intersp = 0.75, y.intersp = 0.75, cex = 0.75)
# Agregar t�tulo
title(main = "Porcentaje de poblaci�n en Chihuahua",
      cex.main = 0.75)


