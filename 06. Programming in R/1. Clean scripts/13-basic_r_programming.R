##########################################################################
# Jose Cajide - @jrcajide
# Master Data Science: R Programming
##########################################################################



## Estructuras de control

# `if`,`else`,`for`,`while`,`repeat`,`break`,`next`,`return`


# if, else ----------------------------------------------------------------

# if (condicion) {
#   # haz algo
# } else {
#   # haz otra cosa
# }
# 

numeros <- 1:15

numero_aleatorio <- sample(numeros, 1)

if (numero_aleatorio <= 10) {
  print(paste(numero_aleatorio, "es menor o igual que 10"))
} else {
  print(paste(numero_aleatorio, "es mayor que 10"))
}

# EJERCICIO: 
# Repite lo mismo empleando la función: ifelse()
# Usa la ayuda para consultar los parámetros de dicha función.

# ?ifelse()

ifelse(numero_aleatorio <= 10,
       print(paste(numero_aleatorio, "es menor o igual que 10")),
       print(paste(numero_aleatorio, "es mayor que 10")))


# else if -----------------------------------------------------------------

if (numero_aleatorio >= 10) {
  print( paste(numero_aleatorio, "es mayor o igual que 10") )
} else if (numero_aleatorio > 5) {
  print( paste(numero_aleatorio, "es mayor o igual que 5") )
} else {
  print( paste(numero_aleatorio, "es menor que 5") )
}


# AND y OR ----------------------------------------------------------------

numero_aleatorio > 5 & numero_aleatorio < 10

numero_aleatorio > 5 | numero_aleatorio < 10


# for ---------------------------------------------------------------------

for (indice in vector) {
  # haz algo
}

# Creamos un vector:
calendario <- seq(2000, 2018 , by = 1)

for (ano in calendario){
  print(paste("El año es", ano))
}

ano_actual <- as.numeric(format(Sys.Date(),'%Y'))  # obtenemos el año actual

ano_actual
# install.packages('lubridate')
library(lubridate)
ano_actual <- year(Sys.Date())

for (ano in calendario){
  ifelse(ano == ano_actual, print(paste("El año es", ano)), print(ano))
}

# Normalmente suelen recomendar no utilizar este tipo de bucles con R.
# Recomiendan utilizar estructuras de R para hacer este tipo de operaciones.

# Con lapply a 'calendario' le pasa una función 'print'.
lapply( calendario, print)

lapply( calendario, function(ano) ifelse(ano == ano_actual, print(paste("El años es", ano)), print(ano)))

# Más limpio. Creación de funciones:

busca_ano_actual <- function(ano) {
  resultado <- if(ano == ano_actual) {  # No hace falta poner ese resultado del principio
    resultado <- paste( ano, "es el año actual")
  } else {
    resultado <- paste( ano, "no es el año actual")
  }
  return(resultado)
}

# Si quisiéramos retornar varios valores -> con una lista

busca_ano_actual(2000)
busca_ano_actual(2018)

sapply(calendario, busca_ano_actual)

# lapply me devuelve una lista
# sapply me devuelve un vector


# Ejercicio ---------------------------------------------------------------

# Año bisiesto
# https://es.wikipedia.org/wiki/A%C3%B1o_bisiesto#Algoritmo_computacional
# Un año es bisiesto si es divisible entre cuatro y (no es divisible entre 100 ó es divisible entre 400).

`%%` #División de enteros
2000 %% 4 == 0

es_ano_bisiesto <- function(ano){
  if ((ano %% 4 == 0) & (ano %% 100 != 0 | ano %% 400 == 0)){
    resultado <- paste(ano, " es bisiesto")
  }
  else {
    resultado <- paste(ano, " NO es bisiesto")
  }
  return(resultado)
}

# Otra manera
es_ano_bisiesto_2 <- function(ano){
  return (ano %% 4 == 0 & ano %% 100 != 0 | ano %% 400 == 0)
}

es_ano_bisiesto(2000)
es_ano_bisiesto_2(2000)

# Aplica a todos los años del calendario la función anterior para comprobar cuáles son años bisiestos
resultado <- sapply(calendario, es_ano_bisiesto_2)
resultado  

# Guarda los años bisiestos en un vector
anos_bisiestos <- calendario[resultado]

anos_bisiestos




