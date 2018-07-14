require(tidyverse)
require(ggplot2)
set.seed(1234)  # Semilla de los números aleatorios.

require(rvest)
url="https://es.wikipedia.org/wiki/Provincia_de_España"
provincias<-read_html(url) %>% html_nodes("table") %>% .[[2]] %>% html_table(header=TRUE,fill=TRUE) %>% .[[1]]

#####################################
######## Muestreo simple ############
#####################################

# El muestreo simple es con la función sample.

sample(provincias,5)  # Una muestra de tamaño 5.

########
NN=10000
poblacion=rnorm(NN,108,5)
nn=250 #tamaño muestral
muestra=sample(poblacion,nn)
mean(muestra)
# t.test(muestra)

#####################################
### Muestreo simple con reposición ##
#####################################

muestra=sample(provincias,nn,replace=TRUE)
table(muestra)

muestra=sample(poblacion,nn,replace=TRUE)
mean(muestra)
#t.test(muestra)


#####################################
######## Muestreo estratificado #####
#####################################

NN=nrow(diamonds) #tamaño de la poblacion
nn= 250 #tamaño muestral

######## Preambulo
diamonds %>% sample_n(nn) #muestreo simple de la base de datos "diamonds"
mean(diamonds$price) 
mean((diamonds %>% sample_n(nn))$price) # Haciendo esto veo que hay mucha variabilidad entre muestras. 

# Si quiero mejorar la variabilidad: muestreo estratificado

diamonds %>%  group_by(cut) %>% summarise(media=mean(price), n = n()) #peso y media de los estratos: calidad del diamante (cut)

######## Muestreo estratificado con afijación fija

# Asigno el mismo número de observaciones a cada estrato

muestra <- diamonds %>% group_by(cut) %>% sample_n(nn/5) 
muestra %>% summarise(media=mean(price), n = n())


######## Muestreo estratificado con afijación proporcional

muestra <- diamonds %>% group_by(cut) %>% sample_frac(nn/NN)
muestra %>% summarise(media=mean(price),n = n())

# Ahora la distribución de mi muestra es como la de mi población


####### Muestreo estratificado por calidad y color del diamante

muestra <- diamonds %>% group_by(cut,color) %>% sample_frac(nn/NN) 
muestra2 <- muestra %>% summarise(media=mean(price),n = n())

#####################################
#####Muestreo por conglomerado ######
#####################################

diamonds$origen=sample(provincias,NN,replace=TRUE) #se asigna de manera artificial un estado a cada diamante
diamonds %>%  group_by(origen) %>% summarise(media=mean(price), n = n())

mm=10 # Selecciono 10 provincias
muestraI <- diamonds %>%  group_by(origen) %>% summarise(N = n()) %>% sample_n(mm,weight=N) #Primero se muestrea 10 estados de acuerdo a su tamaño
muestraI
# Con esto hemos seleccionado las 10 provincias que tienen más número de tamaños

# Ahora nos quedamos con esas provincias
frameI <- diamonds %>% filter(origen %in% muestraI$origen)  # nos quedamos con los 10 estados seleccionados
NNI=nrow(frameI)

# Ahora en cada conglomerado hago un muestreo proporcional en el seno de cada conglomerado (provincia)
muestraII <- frameI %>%	group_by(origen) %>% sample_frac(nn/NNI) #Muestreo dentro de la base resultante
muestraII %>% summarise(media=mean(price),n = n())


# Si yo quiero hacer un muestreo por conglomerado equiprobabilístico (sin combinar con nada, tal y como en la transparencia)
muestraIII <- frameI %>%	group_by(origen) %>% sample_n(nn/mm)
muestraIII %>% summarise(media=mean(price),n = n())

