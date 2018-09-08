## -------------------------------------------------------------------------
## SCRIPT: Aprendizaje no Supervisado.R
## CURSO: Master en Data Science
## SESIÓN: Aprendizaje no Supervisado
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("dummies")){
  install.packages("dummies")
  library("dummies")
}

# setwd("D:/Documentos, Trabajos y Demás/Formación/Kschool/201807 Clase VIII Master Data Science/5 Aprendizaje no Supervisado")

# indicar el directorio de trabajo
# setwd("C:/....")

## -------------------------------------------------------------------------
##       PARTE 1: CLUSTERING JERARQUICO: NETFLIX MOVIELENS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

movies = read.table("data/movies.txt",header=TRUE, sep="|",quote="\"")

## -------------------------------------------------------------------------

##### 3. Bloque de analisis preliminar del dataset #####

str(movies)
head(movies)
tail(movies)

table(movies$Comedy)  # Número de comedias
table(movies$Western)
table(movies$Romance, movies$Drama)  # Muchos dramas que no son romance o que sí, romances que no son drama y 801 que no son ni romance ni drama. 
# Hay muchas mezclas y posibilidades.

# Lo que yo quiero es agrupar películas en base a algo más a alto nivel que el género tal y como viene en la tabla. Al final lo más razonable es que un usuario tenga, por ejemplo,
# 6 elecciones, no 30. Y en qué 6 categorías divido? Pues seguro que vouy a estar sesgado por mis gustos. 
# Para estas cosas viene bien el aprendizaje supervisado, tengo una idea de lo que quiero obtener y agrupo.

## -------------------------------------------------------------------------

##### 4. Bloque de calculo de distancias #####

# Lo primero que hacemos es calcular las distancias Esto es un paso previo que hay que hacer.
# No escalamos ni normalizamos porque son todo ceros y unos, pero siempre hay que tenerlo en cuenta cuando usemos distancias.
distances = dist(movies[2:20], method = "euclidean")

## -------------------------------------------------------------------------

##### 5. Bloque de clustering jerarquico #####

# Calculamos los clusters. Es muy rápido, pero tener en cuenta que no escala bien.
clusterMovies = hclust(distances, method = "ward.D")  # método completo.

dev.off()
plot(clusterMovies)  # No se ve nada.

rect.hclust(clusterMovies, k=2, border="yellow")
rect.hclust(clusterMovies, k=3, border="blue")
rect.hclust(clusterMovies, k=4, border="green")

# Imaginemos que agrupo en 6. ¿Y qué nombre le doy a los grupos?
# Lo importante aquí es ENTENDER qué hay en cada grupo.

NumCluster=6

rect.hclust(clusterMovies, k=NumCluster, border="red")

movies$clusterGroups = cutree(clusterMovies, k = NumCluster)

## -------------------------------------------------------------------------

##### 6. Bloque de analisis de clusters #####

table(movies$clusterGroups)

tapply(movies$Action, movies$clusterGroups, mean)  # Vamos a ver de cada grupo, cuántas hay de acción
tapply(movies$Adventure, movies$clusterGroups, mean)
tapply(movies$Animation, movies$clusterGroups, mean)
tapply(movies$Childrens, movies$clusterGroups, mean)
tapply(movies$Comedy, movies$clusterGroups, mean)
tapply(movies$Crime, movies$clusterGroups, mean)
tapply(movies$Documentary, movies$clusterGroups, mean)
tapply(movies$Drama, movies$clusterGroups, mean)

aggregate(.~clusterGroups,FUN=mean, data=movies)

# Si lo hacemos con 2 grupos, vemos que:
# Podemos ver que el primer grupo tiene un 0,19(19%) de accion, 0,10 de aventura, etc...
# Vemos que en el grupo 2 es todo drama, y el otro grupo es el resto.

# Si lo hacemos con 4, vemos:
# El grupo 1 tiene un poco de todo.
# El grupo 2 tiene drama
# El grupo 3 tiene comedias que pueden tener un punto dramático
# El grupo 4 tiene romances que tienen algo de comedia en ellos, y algo de drama en ellos.

# Si lo hacemos con 6:
# 1. Otros
# 2. alta tensión
# 3. dramón
# 4. comedia
# 5. ...

# NO hay un clustering que sea mejor, sino el que nos sirva.

## -------------------------------------------------------------------------

##### 7. Bloque de ejemplo #####

subset(movies, Title=="Men in Black (1997)")  # vemos en la columna clusterGroups que es del cluster 2.

cluster2 = subset(movies, movies$clusterGroups==2)  # sacamos las películas del cluster 2

cluster2$Title[1:10]  # vemos que las del cluster 2 son parecidas en concepto a la de men in black.

# Si ahora yo meto una película nueva, dónde la asigno? Analíticamente, no puedo.
# Ese es el problema del clustering jerárquico: va muy bien, pero no puedo asignar nuevos puntos de una manera analítica (mediante una función)

## -------------------------------------------------------------------------
##       PARTE 2: CLUSTERING kMEANS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 8. Bloque de carga de Datos #####

creditos=read.csv("data/creditos.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 9. Bloque de revisión basica del dataset #####

str(creditos)
head(creditos)
summary(creditos)

# Yo me podría plantear ¿cómo son mis clientes? Podríamos segmentar clientes por cómo sean y ofrecerles cosas que les interesen más.

## -------------------------------------------------------------------------

##### 10. Bloque de tratamiento de variables #####

creditosNumericos=dummy.data.frame(creditos, dummy.class="character" )  # En vez de transformarlas en factores, las transformamos en dummies directamente.
summary(creditosNumericos)

## -------------------------------------------------------------------------

##### 11. Bloque de Segmentación mediante Modelo RFM 12M  #####

# Ojo: siempre que trabajemos con distancias (KMeans) es que tendremos que escalar. Normalmente se normaliza (- media entre std)
creditosScaled=scale(creditosNumericos)

NUM_CLUSTERS=5
set.seed(1234)
Modelo=kmeans(creditosScaled,NUM_CLUSTERS)

creditos$Segmentos=Modelo$cluster
creditosNumericos$Segmentos=Modelo$cluster

table(creditosNumericos$Segmentos)

aggregate(creditosNumericos, by = list(creditosNumericos$Segmentos), mean)

# Con 2 grupos separa en mujeres casadas asiáticas y hombres solteros. Ya tenemos dos perfiles (el perfil siempre es una simplificación, no va 
# nunca a ser exacto). Esto ya nos da algo de info:

# Con 3 grupos: mujeres casadas, hombres casados y no casados.

# Con 4 grupos: casados sin hipoteca, solteros sin hipoteca hombres, mujeres casadas sin hipoteca, con hipoteca.
# Además también puedo ver variables que, a parte de diferenciar grupos, pueden describirlos: veo que el grupo 3 tiene más income.

## -------------------------------------------------------------------------

##### 12. Bloque de Ejericio  #####

## Elegir el numero de clusters

# Deoende!!

## -------------------------------------------------------------------------

##### 13. Bloque de Metodo de seleccion de numero de clusters (Elbow Method) #####

Intra <- (nrow(creditosNumericos)-1)*sum(apply(creditosNumericos,2,var))  # errores intragrupo (distancia con respecto al centroide)
for (i in 2:15) Intra[i] <- sum(kmeans(creditosNumericos, centers=i)$withinss)
plot(1:15, Intra, type="b", xlab="Numero de Clusters", ylab="Suma de Errores intragrupo")
# Esto me dice que a cuantos más clusters haga, menor error tengo. El K que hay que elegir es el codo: el punto a partir del cual añadir un cluster
# no me mejora demasiado el error, mientras que se me mete complejidad de cálculo.


## -------------------------------------------------------------------------
##       PARTE 3: PCA: REDUCCIÓN DE DIMENSIONALIDAD.
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 14. Bloque de carga de datos #####

coches=mtcars # Base de datos ejemplo en R

## -------------------------------------------------------------------------

##### 15. Bloque de revisión basica del dataset #####

str(coches)
head(coches)
summary(coches)

## -------------------------------------------------------------------------

##### 16. Bloque de modelo lineal #####

modelo_bruto=lm(mpg~.,data=coches)
summary(modelo_bruto)

cor(coches)  # Mucha multicolinealidad

## -------------------------------------------------------------------------

##### 17. Bloque de modelos univariables #####

modelo1=lm(mpg~cyl,data=coches)
summary(modelo1)
modelo2=lm(mpg~disp,data=coches)
summary(modelo2)
modelo3=lm(mpg~hp,data=coches)
summary(modelo3)
modelo4=lm(mpg~drat,data=coches)
summary(modelo4)
modelo5=lm(mpg~wt,data=coches)
summary(modelo5)
modelo6=lm(mpg~qsec,data=coches)
summary(modelo6)
modelo7=lm(mpg~vs,data=coches)
summary(modelo7)
modelo8=lm(mpg~am,data=coches)
summary(modelo8)
modelo9=lm(mpg~gear,data=coches)
summary(modelo9)
modelo10=lm(mpg~carb,data=coches)
summary(modelo10)

cor(coches)

# Una a una todas son significativas, pero al poner todas juntas hay mucha correlación, multicolinealidad, y hay problemas.
# Vemos un R2 alto y sin embargo ninguna significativa.

## -------------------------------------------------------------------------

##### 18. Bloque de Ejercicio #####

## ¿Qué modelo de regresión lineal realizarías?

# Este sería teóricamente el mejor modelo
modelo = step(modelo_bruto,direction = "both", trace = 1)
summary(modelo)

# Vamos a hacer PCA a ver qué pasa

## -------------------------------------------------------------------------

##### 19. Bloque de Analisis de Componentes Principales #####

PCA<-prcomp(coches[,-c(1)],scale. = TRUE)  # todas menos la independiente

summary(PCA)
# Me da las varianzas y la proporción de la varianza
# Puedo quedarme sólo con 4? Sí. Pero también por 10: reducción de la dimensionalidad no es sólo para quitar variables,
# sino que por ejemplo PCA es para obtener variables incorreladas

plot(PCA)

# Cuántas quito? pues DEPENDE: de lo que yo pueda asumir, del negocio. Si puedo asumir perder un 15%, perfecto.

# Como en este problema lo que pasaba es la multicolinealidad, no voy a quitar ninguna.

## -------------------------------------------------------------------------

##### 20. Bloque de ortogonalidad de componentes principales #####

cor(coches)
cor(PCA$x)  # son todas incorreladas por definición

## -------------------------------------------------------------------------

##### 21. Bloque de representacion grafica mediante componentes principales #####

biplot(PCA)

PCA$rotation
# Esto lo que me permite saber es cómo he construido la variable PCA1 = 0.40cyl + 0.39disp. Lo que pasa es que
# esto son transformaciones lineales algebraicas para buscar ortogonalidad, pero no tienen interpretabilidad.
# Cuando prediga nuevos puntos, tendré que calcular primero todas las PCAs.

## -------------------------------------------------------------------------

##### 22. Bloque de creacion de variables componentes principales #####

coches$PCA1=PCA$x[,1]
coches$PCA2=PCA$x[,2]
coches$PCA3=PCA$x[,3]

## -------------------------------------------------------------------------

##### 23. Bloque de regresion lineal con componentes principales #####

modelo_PCA=lm(mpg~PCA1,data=coches)
summary(modelo_PCA)
# Con sólo una variable, tengo mejor R2 que con cualquiera de las originales.
# ¿y si meto todas las PCAi? pues tendré el mismo R2, porque es la misma información.

modelo_PCA=lm(mpg~PCA$x,data=coches)
summary(modelo_PCA)

modelo_PCA=lm(mpg~PCA1+PCA3,data=coches)
summary(modelo_PCA)

biplot(PCA,choices=c(1,3))

## -------------------------------------------------------------------------
##       PARTE 4: CLUSTERING K-MEANS Y PCA. SAMSUNG MOBILITY DATA
## -------------------------------------------------------------------------

# Intentaremos crear un modelo predictivo que permita saber si la persona está quieta, andando, etc... en base
# a su móvil.

# Tenemos un problema de aprendizaje supervisado con seis categorías.

## -------------------------------------------------------------------------

##### 24 Bloque de inicializacion de librerias y establecimiento de directorio #####

library(ggplot2)
library(effects)
library(plyr)
## -------------------------------------------------------------------------

##### 25. Bloque de carga de Datos #####

load("data/samsungData.rda")

## -------------------------------------------------------------------------

##### 26. Bloque de analisis preliminar del dataset #####

# Vemos que hay muchas variables, problemas: computación, multicolinealidad...

str(samsungData)
head(samsungData)
tail(samsungData)

# Tenemos pocos datos, y 6 clases, con lo cual para cada clase tengo 1/6 de los datos, y encima tengo que dividir
# en train y test set... y además tengo muchísimas variables -> overfitting.
# Puedo reducir la dimensionalidad, y encima me quito la multicolinealidad.

# Si yo segmento en base a un clustering, y miro en cada cluster la etiqueta que más se repite, 
# eso me permite hacer un modelo de clasificación con un clustering.

# Y si encima después del clustering hiciera un modelo de clasificación, pues afino mucho más.

table(samsungData$activity)
str(samsungData[,c(562,563)])
## -------------------------------------------------------------------------

##### 27. Bloque de segmentacion kmeans #####

samsungScaled=scale(samsungData[,-c(562,563)])

set.seed(1234)
kClust1 <- kmeans(samsungScaled,centers=8)
table(kClust1$cluster,samsungData[,563])

# Si lo hacemos con 6 clusters:
# Me ha hecho 6 clusters:
# En 1 podríamos hacer un modelo de clasificación con las 3 últimas
# En 2
# En 3 bajando escaleras
# En 4 tumbado
# ...
# Y no podemos asignar ninguno a walk así a priori. Por eso conviene hacer más clusters que etiquetas.

# Si lo hacemos con 8 seguimos sin tener walk. Le está costando más separar entre walk, walkdown y walkup.
# Donde hay más posibilidades de mejora es en los clusters 1 y 8.
# Hemos cambiado de un problema complejo a 2 problemas sencillos de pocos datos.

nombres8<-c("walkup","laying","walkdown","laying","standing","sitting","laying","walkdown")

Error8=(length(samsungData[,563])-sum(nombres8[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error8  # error del 40% con un clustering. Es más que el 80 y pico % base.

## CLuster con 10 centros.
set.seed(1234)
kClust1 <- kmeans(samsungScaled,centers=10)

table(kClust1$cluster,samsungData[,563])
# Habría que seguir poniendo foco en 1, 4, 5, 6, 8 y 9

nombres10<-c("walkup","laying","walkdown","sitting","standing","laying","laying","walkdown","sitting","walkup")

Error10=(length(samsungData[,563])-sum(nombres10[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error10

# El mismo error prácticamente

## -------------------------------------------------------------------------

# Vamos a ver qué pasa con PCA

##### 28. Bloque de PCA #####

PCA<-prcomp(samsungData[,-c(562,563)],scale=TRUE)
#PCA$rotation
#attributes(PCA)
summary(PCA)
plot(PCA)
PCA$x[,1:3]

# Como tenemos muchas variables, podemos representar las primeras componentes principales.
# Lo suyo sería representar variables de verdad, pero como no entendemos de acelerómetros,
# representamos las componentes principales.
dev.off()
par(mfrow=c(1,3))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(2,3)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(1,3)],col=as.numeric(as.factor(samsungData[,563])))
# Se puede ver que hay seis colores, y dos principales grupos: quieto y moviendo.
# Vemos en PC1 que justo en 0 corta, y los quietos serán positivos y los moviendo negativo o algo así.


par(mfrow=c(1,1))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))

# Esto me permite visualizar un poco de forma intuitiva o representar 563 variables para que se vea un poco la idea.
## -------------------------------------------------------------------------