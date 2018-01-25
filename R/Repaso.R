
# Repaso de R

## Contenido

#1. Preliminares
#2. Objetos en R
#3. Paquetes y librerías
#4. Importar datos
#5. Gráficos



#1. Preliminares

# Comentarios

# Todo aquello que se escriba a la derecha del signo numeral (#) se 
# coloreará de verde pálido y será tomado por R como un comentario.


## Ejecutar una instrucción: <Ctrl> + <R>

# Ubicar el cursor al inicio de la línea de comando o seleccionar un
# conjunto de líneas de comandos y oprimir las teclas <Ctrl> y <R>. 


## La Consola

# El signo '>' al final de la consola significa que R está listo para
# ejecutar la siguiente tarea.

# Un signo de '+' al final es indicativo de que la instrucción 
# ejecutada está incompleta.


## Operadores
  
# Aritméticos: +,  -,  *,  /  y  ^.

# Relacionales: >,  >=,  <,  <=,  ==  y  !=.

# Lógicos: & y |.
 
 

#2. Objetos en R

# Un objeto en R puede ser una tabla con datos, una base de datos, 
# una variable o un valor.

# Con el operador '<-' se asigna un valor a un objeto. Los objetos
# aparecen en la ventana superior de la derecha.
  

## Objetos numéricos
  
x <- 2

## Objetos de caracteres
  
aqui <- "Chihuahua"

## Vector numérico
  
cm <- c(167, 172, 153, 164, 182, 147)
kg <- c(48, NA, 55, 63, 71, 49)

## Vector de caracteres
  
nivel <- c("A", "B", "C", "D", "E", "F")
  

## Matrices

mv <- matrix(cm, nrow=3, ncol=2) 

mh <- matrix(cm, nrow=3, ncol=2, byrow=TRUE) 

  ## Llamar a los objetos
  
  mv
  
  mh


## Factor
  
# Objeto que almacena el valor de una variable categórica.
  
sexo <- factor(c("H", "M", "M", "M", "H", "M")) 
  
summary(sexo)  
  

## Data frame
  
# Un 'data frame' es más general que una matriz. Las columnas pueden
# tener diferentes clases de objetos (numéricos, factores, etc).
  
datos <- data.frame(nivel, sexo,cm, kg)
  
View(datos)


## Borrar objetos del workspace

rm(x, aqui) # Sólo algunos objetos

rm(list = ls()) # Todos los objetos



#3. Paquetes y librerías

# En la Red existe un sin número de paquetes y están disponibles al
# público de manera gratuita. Para usar estos recursos hay que:
  
#   1o. Descargar e instalar el paquete de interés.
#   2o. Cargar el paquete a la sesión de trabajo.


# Ejemplo. Pirámide de población.

install.packages("pyramid")

library(pyramid)

## Carpeta de trabajo

getwd()

# Cambiar carpeta de trabajo

setwd("C:\\Users\\jmartinez\\Desktop\\teTra-Red-master\\teTra-Red-master\\data")



#4. Importar datos

# En la práctica es común encontrar/tener la información almacenada
# en varios formatos. Los más comunes son: dbf, csv, dta, sav y dat
  
# R puede cargar/abrir cualquier base de datos, no importa el 
# formato; sólo se necesita la librería 'foreign'.
  
install.packages("foreign")

library(foreign)
  

enut <- read.dta("ENUT.dta")  


## Guardar una base de datos o una tabla en formato *.RData.

save(enut, file = "ENUT2014.RData")

rm(list=ls())


# Para cargar los datos utilizamos la función 'load()'.

load("ENUT2014.RData")

# ¿Qué variables tiene la ENUT?

names(enut)

# p 7.3: "En general, ¿qué tan feliz diría que es usted?"

# Para cambiar el nombre a una variable usamos la función 'rename'
# (se encuentra en el paquete 'reshape').

install.packages("reshape")

library(reshape)


## Renombrar la variable p7_3

enut <- rename(enut, c(p7_3  = "felicidad"))

names(enut)


## Selección de variables

# La forma de acceder a las variables en R es mediante el nombre del
# base (objeto), seguido del signo "$" y el nombre de la variable. 

# Desplegar los primeros valores de la variable 'edad'.

head(enut$edad)


## Crear una variable

# Tiempo dedicado a la limpieza del hogar

enut$limpiar <- enut$p6_5_2_2 + (enut$p6_5_2_3/60)


## Resumen de datos

## Tabla de frecuencias

# Distribución de los individuos según nivel de felicidad

table(enut$felicidad)

# 1 Nada; 2 Poco feliz; 3 Más o menos; 4 Feliz; y 5 Muy feliz


# Distribución incluyendo los valores perdidos

table(enut$felicidad, useNA = "always")


# Distribución de los individuos por 'felicidad' y 'sexo'

table(enut$felicidad, enut$sexo)


# Frecuencia relativa de los individuos por 'felicidad' y 'sexo'

# Por renglón (prop. hombres + prop. mujeres = 1)

prop.table(table(enut$felicidad, enut$sexo), 1)


# Por columna (prop. nada + ... + prop. muy feliz = 1)

prop.table(table(enut$felicidad, enut$sexo), 2)*100


## Función 'aggregate'

# Felicidad media por nivel de escolaridad (niv)

aggregate(enut$felicidad, by = list(enut$niv), 
          FUN = mean, na.rm = TRUE)


## Función 'summarySE'

  install.packages("Rmisc")
  library(Rmisc)

summarySE(enut, measurevar="limpiar", groupvars=c("sexo"), 
          na.rm = TRUE)



#4. Gráficos

load("data/ENUT2014.RData")
enut$limpiar <- enut$p6_5_2_2 + (enut$p6_5_2_3/60)


## De línea

# Ejemplo. Tiempo promedio dedicado a la limpieza del hogar por edad

limpieza <- aggregate(enut$limpiar, by = list(enut$edad),
                      FUN = mean, na.rm = TRUE)

head(limpieza)

names(limpieza) <- c("edad","media")
head(limpieza)

plot(limpieza$edad ,limpieza$media, type="l", xlab="Edad", 
     ylab="Tiempo promedio")


## Histogramas

# Ejemplo. Tiempo dedicado a cocinar

# Mujeres

hist(enut$p6_4_3_2[enut$sexo == 2], freq = FALSE, 
     ylab = "Frec. rel.", xlab = "Horas", breaks = 20, 
     ylim = c(0, 0.4), col = "purple")

# Hombres

hist(enut$p6_4_3_2[enut$sexo == 1], freq = FALSE, 
     ylab = "Frec. rel.", xlab = "Horas", breaks = 20, 
     ylim = c(0, 0.4), col = "cyan", add=TRUE)


## Gráfica de caja

boxplot(enut$limpiar ~ enut$sexo, 
        main = "Tiempo dedicado a limpiar")

  enut$sexof <- factor(enut$sexo, levels = c(1,2), 
                       labels = c("Hombres", "Mujeres"))

boxplot(enut$limpiar ~ enut$sexof, 
        main = "Tiempo dedicado a limpiar")


## Guardar en el escritorio las imágenes como un archivo *.png

getwd()
setwd("C:/Users/marius/Desktop")

png("Limpiar.png")
plot(limpieza$edad ,limpieza$media, type="l", xlab="Edad", 
     ylab="Tiempo promedio")
dev.off()


# Varias gráficas en una imagen

png("Arreglo de gráficas - 2 en 1.png", width = 700, height = 800)

par(mfrow = c(2,1))

boxplot(enut$escoacum ~ enut$p7_3, 
        main="Escolaridad por nivel de felicidad", 
        xlab="Nivel de felicidad", ylab="AÃ±os de escolaridad", 
        col="cyan")

plot(limpieza$edad ,limpieza$media, type="l", 
     main="Tiempo promedio dedicado a la \n limpieza del hogar por edad",
     xlab="Edad", ylab="Media de felicidad") 

par(mfrow = c(1,1))

dev.off()
