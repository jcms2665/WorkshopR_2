
# Repaso de R

## Contenido

#1. Preliminares
#2. Objetos en R
#3. Paquetes y librer�as
#4. Importar datos
#5. Gr�ficos



#1. Preliminares

# Comentarios

# Todo aquello que se escriba a la derecha del signo numeral (#) se 
# colorear� de verde p�lido y ser� tomado por R como un comentario.


## Ejecutar una instrucci�n: <Ctrl> + <R>

# Ubicar el cursor al inicio de la l�nea de comando o seleccionar un
# conjunto de l�neas de comandos y oprimir las teclas <Ctrl> y <R>. 


## La Consola

# El signo '>' al final de la consola significa que R est� listo para
# ejecutar la siguiente tarea.

# Un signo de '+' al final es indicativo de que la instrucci�n 
# ejecutada est� incompleta.


## Operadores
  
# Aritm�ticos: +,  -,  *,  /  y  ^.

# Relacionales: >,  >=,  <,  <=,  ==  y  !=.

# L�gicos: & y |.
 
 

#2. Objetos en R

# Un objeto en R puede ser una tabla con datos, una base de datos, 
# una variable o un valor.

# Con el operador '<-' se asigna un valor a un objeto. Los objetos
# aparecen en la ventana superior de la derecha.
  

## Objetos num�ricos
  
x <- 2

## Objetos de caracteres
  
aqui <- "Chihuahua"

## Vector num�rico
  
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
  
# Objeto que almacena el valor de una variable categ�rica.
  
sexo <- factor(c("H", "M", "M", "M", "H", "M")) 
  
summary(sexo)  
  

## Data frame
  
# Un 'data frame' es m�s general que una matriz. Las columnas pueden
# tener diferentes clases de objetos (num�ricos, factores, etc).
  
datos <- data.frame(nivel, sexo,cm, kg)
  
View(datos)


## Borrar objetos del workspace

rm(x, aqui) # S�lo algunos objetos

rm(list = ls()) # Todos los objetos



#3. Paquetes y librer�as

# En la Red existe un sin n�mero de paquetes y est�n disponibles al
# p�blico de manera gratuita. Para usar estos recursos hay que:
  
#   1o. Descargar e instalar el paquete de inter�s.
#   2o. Cargar el paquete a la sesi�n de trabajo.


# Ejemplo. Pir�mide de poblaci�n.

install.packages("pyramid")

library(pyramid)

## Carpeta de trabajo

getwd()

# Cambiar carpeta de trabajo

setwd("C:\\Users\\jmartinez\\Desktop\\teTra-Red-master\\teTra-Red-master\\data")



#4. Importar datos

# En la pr�ctica es com�n encontrar/tener la informaci�n almacenada
# en varios formatos. Los m�s comunes son: dbf, csv, dta, sav y dat
  
# R puede cargar/abrir cualquier base de datos, no importa el 
# formato; s�lo se necesita la librer�a 'foreign'.
  
install.packages("foreign")

library(foreign)
  

enut <- read.dta("ENUT.dta")  


## Guardar una base de datos o una tabla en formato *.RData.

save(enut, file = "ENUT2014.RData")

rm(list=ls())


# Para cargar los datos utilizamos la funci�n 'load()'.

load("ENUT2014.RData")

# �Qu� variables tiene la ENUT?

names(enut)

# p 7.3: "En general, �qu� tan feliz dir�a que es usted?"

# Para cambiar el nombre a una variable usamos la funci�n 'rename'
# (se encuentra en el paquete 'reshape').

install.packages("reshape")

library(reshape)


## Renombrar la variable p7_3

enut <- rename(enut, c(p7_3  = "felicidad"))

names(enut)


## Selecci�n de variables

# La forma de acceder a las variables en R es mediante el nombre del
# base (objeto), seguido del signo "$" y el nombre de la variable. 

# Desplegar los primeros valores de la variable 'edad'.

head(enut$edad)


## Crear una variable

# Tiempo dedicado a la limpieza del hogar

enut$limpiar <- enut$p6_5_2_2 + (enut$p6_5_2_3/60)


## Resumen de datos

## Tabla de frecuencias

# Distribuci�n de los individuos seg�n nivel de felicidad

table(enut$felicidad)

# 1 Nada; 2 Poco feliz; 3 M�s o menos; 4 Feliz; y 5 Muy feliz


# Distribuci�n incluyendo los valores perdidos

table(enut$felicidad, useNA = "always")


# Distribuci�n de los individuos por 'felicidad' y 'sexo'

table(enut$felicidad, enut$sexo)


# Frecuencia relativa de los individuos por 'felicidad' y 'sexo'

# Por rengl�n (prop. hombres + prop. mujeres = 1)

prop.table(table(enut$felicidad, enut$sexo), 1)


# Por columna (prop. nada + ... + prop. muy feliz = 1)

prop.table(table(enut$felicidad, enut$sexo), 2)*100


## Funci�n 'aggregate'

# Felicidad media por nivel de escolaridad (niv)

aggregate(enut$felicidad, by = list(enut$niv), 
          FUN = mean, na.rm = TRUE)


## Funci�n 'summarySE'

  install.packages("Rmisc")
  library(Rmisc)

summarySE(enut, measurevar="limpiar", groupvars=c("sexo"), 
          na.rm = TRUE)



#4. Gr�ficos

load("data/ENUT2014.RData")
enut$limpiar <- enut$p6_5_2_2 + (enut$p6_5_2_3/60)


## De l�nea

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


## Gr�fica de caja

boxplot(enut$limpiar ~ enut$sexo, 
        main = "Tiempo dedicado a limpiar")

  enut$sexof <- factor(enut$sexo, levels = c(1,2), 
                       labels = c("Hombres", "Mujeres"))

boxplot(enut$limpiar ~ enut$sexof, 
        main = "Tiempo dedicado a limpiar")


## Guardar en el escritorio las im�genes como un archivo *.png

getwd()
setwd("C:/Users/marius/Desktop")

png("Limpiar.png")
plot(limpieza$edad ,limpieza$media, type="l", xlab="Edad", 
     ylab="Tiempo promedio")
dev.off()


# Varias gr�ficas en una imagen

png("Arreglo de gr�ficas - 2 en 1.png", width = 700, height = 800)

par(mfrow = c(2,1))

boxplot(enut$escoacum ~ enut$p7_3, 
        main="Escolaridad por nivel de felicidad", 
        xlab="Nivel de felicidad", ylab="Años de escolaridad", 
        col="cyan")

plot(limpieza$edad ,limpieza$media, type="l", 
     main="Tiempo promedio dedicado a la \n limpieza del hogar por edad",
     xlab="Edad", ylab="Media de felicidad") 

par(mfrow = c(1,1))

dev.off()
