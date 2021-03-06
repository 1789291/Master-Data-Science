## -------------------------------------------------------------------------
## SCRIPT: Introducción a la Modelización Estadística.R
## CURSO: Master en Data Science
## SESIÓN: Introducción a la Modelización Estadística
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("ggplot2")){
  install.packages("ggplot2")
  library("ggplot2")
}

if (!require("gap")){
  install.packages("gap")
  library(gap)
}

# setwd("D:/Documentos, Trabajos y Demás/Formación/Kschool/201807 Clase VIII Master Data Science/2 Introducción a la Modelización Estadística")

## -------------------------------------------------------------------------
##       PARTE 1: INTRODUCCIÓN A LA REGRESION LINEAL
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

creditos=read.csv("data/creditos.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 3. Bloque de revisión basica del dataset #####

str(creditos)
head(creditos)
summary(creditos)

## -------------------------------------------------------------------------

##### 4. Bloque de tratamiento de variables #####

creditos$Gender=as.factor(creditos$Gender)
creditos$Mortgage=as.factor(creditos$Mortgage)
creditos$Married=as.factor(creditos$Married)
creditos$Ethnicity=as.factor(creditos$Ethnicity)

summary(creditos)

## -------------------------------------------------------------------------

##### 5. Bloque de test de diferencia de medias mediante regresion lineal #####

# Una hipótesis que me puedo plantear es: ¿el income depende del sexo?

# H0: media salario hombres = media salario mujeres
# H1: distintos


t.test(Income ~ Gender, data = creditos)  # p > alpha => no rechazo H0. No hay diferencia significativa.

# La regresión lineal es la evolución de un contraste de hipótesis. Aceptar H0 es lo mismo que
# que el coeficiente del sexo en la regresión sea 0

# mediante un modelo lineal
modeloT=lm(Income ~ Gender, data = creditos)
summary(modeloT)

# Y vemos que el p-valor del sexo es el mismo que el del contraste de hipótesis.

# La fórmula es y = 44.802 - 1.3*mujer

# Hay diferencias pero no son significativas (el t no se cumple). Su media es -1.335, pero su desviación es 3.944 (mucho mayor, puede ser + o -)

# Para calcular intervalos de confianza: thumb rule -> si al Estimate le sumo:
# 1 std: 68%
# 2 std: 95%
# 3 std: 99%

# Moraleja: la regresión no es sólo la fórmula, y hablemos siempre de intervalos de confianza y no de valores puntuales.
# Hay que tener en cuenta toda la salida, que nos da mucha información

## -------------------------------------------------------------------------

##### 6. Bloque de regresion lineal individual #####

modeloInd1=lm(Income ~ Rating, data = creditos)
summary(modeloInd1)

# Tiene un R2 que parece muy bajo. Entonces digo que el rating no influye en el ingreso?
# NO: me está diciendo que calculo un 57% de la varianza de los ingresos con el rating. Me dice que hay otras variables
# que explican los ingresos, pero no me dice que el rating sea malo.
# De hecho, viendo el t test es bueno.

# Habría que calcular el intervalo (porque lo puntual no me vale), y siempre teniendo en cuenta que los intervalos son
# a una confianza.

## -------------------------------------------------------------------------

##### 7. Bloque de representación gráfica #####

ggplot(creditos, aes(x = Rating, y = Income)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

# ¿Qué nos parece? Podría parecer que la recta no se ajusta bien, pero es que es imposible!!
# Para un rating de 250 hay muchos valores de income, por lo que NUNCA con la misma fórmula podré obtener varios valores 
# de income para un valor de rating.
# Sin embargo sí que se ve que más o menos, para los rating de 250, la recta está en la media.

# Esto es lo que se busca con la regresión -> GENERALIZAR. No podemos acertar siempre porque no se puede, por definición,
# no porque el modelo sea malo. El modelo, por definición, no puede pasar por todos los puntos.

## -------------------------------------------------------------------------

##### 8. Bloque de regresion lineal otras variables #####

modeloInd2=lm(Income ~ Products, data = creditos)
summary(modeloInd2)

# No es intuitivo income en función de productos, si no al revés. Pero esque esto es correlación, no causa-efecto.
# Nos quitamos de la cabeza causa-efecto, la correlación es simétrica. Para ver la relación entre variables (que es 
# lo que yo quiero ver), no me hace falta causa-efecto.

# Viendo el t-test, la conclusión que sacamos es que con NUESTROS DATOS, no podemos concluir que hay un efecto entre productos
# e ingreso.
# Podría pasar que con otros datos sí saliera significativo. Con muchos datos hay cosas que pueden salir significativas,
# y hay que tener cuidado con eso.
# --------

modeloInd3=lm(Income ~ Age, data = creditos)
summary(modeloInd3)

# Ahora con esto vemos que el p-valor está ahí ahí. Y ¿por qué el 0.05? Es por convención. Hace dos años la ASA
# dijo que era un error fijarse en el 0.05.

# Detectaron lo siguiente: con un nivel de confianza del 95%, de cada 20 experimentos, 1 te va a salir significativa.
# Por tanto, si repito el experimento 20 veces, o lo hacen 20 personas distintas, 1 por azar va a salir significativa,
# y esa se publica.

# https://www.amstat.org/asa/files/pdfs/P-ValueStatement.pdf

# Hay que tener cuidado con el 95%: de cada 20 preguntas que me haga con datos, 1 la voy a responder por azar. Si a los
# datos les estrujas, al final sale lo que quieras.

# Moraleja: a no ser que las conclusiones sean MUY claras, o tenga otros datos para contrastar, cuidado.
# --------

modeloInd4=lm(Income ~ Education, data = creditos)
summary(modeloInd4)

# Sale que el ingreso no depende de la educación. Por qué? Porque está relacionado con la edad:
# Las personas de más edad son las que más salario tienen, y además hay un sesgo porque antes se estudiaba menos.

modeloInd5=lm(Income ~ Gender, data = creditos)
summary(modeloInd5)

modeloInd6=lm(Income ~ Mortgage, data = creditos)
summary(modeloInd6)

modeloInd7=lm(Income ~ Married, data = creditos)
summary(modeloInd7)

modeloInd8=lm(Income ~ Ethnicity, data = creditos)
summary(modeloInd8)

modeloInd9=lm(Income ~ Balance, data = creditos)
summary(modeloInd9)

## -------------------------------------------------------------------------

##### 9. Bloque de regresion lineal multiple #####

modeloGlobal=lm(Income ~ ., data = creditos)
summary(modeloGlobal)

# Vemos que el coeficiente de las mortgages es muy alto (el promedio de income era 44
# y esto me dice que tener hipoteca me dobla el income) -> puede indicar multicolinealidad.

## -------------------------------------------------------------------------

##### 10. Bloque de comparacion de modelos #####

anova(modeloInd1,modeloGlobal)

## -------------------------------------------------------------------------

##### 11. Bloque de Ejercicio #####

## ¿Cuales serian las variables que incluiriamos en el modelo?

modeloMultiple=lm(Income ~            , data = creditos)
summary(modeloMultiple)

anova(modeloInd1,modeloMultiple)
anova(modeloMultiple,modeloGlobal)

## -------------------------------------------------------------------------

##### 12. Bloque de analisis del modelo #####

modeloFinal=lm(Income ~ Rating+Mortgage+Balance, data = creditos)
summary(modeloFinal)
plot(modeloFinal$residuals)
hist(modeloFinal$residuals)
# Parece que no son normales. Pero con estos datos no voy a conseguirlo. Pues, o tiro los datos,
# o me conformo con esto que es lo mejor de lo posible.

qqnorm(modeloFinal$residuals); qqline(modeloFinal$residuals,col=2)
confint(modeloFinal,level=0.95)

# La correlación de los residuos y las variables independientes tiene que ser 0 (exogeneidad débil)
cor(modeloFinal$residuals,creditos$Rating)
cor(modeloFinal$residuals,creditos$Balance)
# Como habíamos dicho, ya sólo por usar MCO eso tiene que ser 0.

boxplot(modeloFinal$residuals~creditos$Mortgage)
aggregate(modeloFinal$residuals~creditos$Mortgage,FUN=mean)

shapiro.test(modeloFinal$residual)  # Test de normalidad

anova(modeloFinal,modeloGlobal)  # Esto me compara mi modelo con el modelo completo. Nos dice que NO hay diferencias
# significativas entre ambos modelos. ¿Con cuál me quedo? Con el más simple

## -------------------------------------------------------------------------

##### 13. Bloque de analisis de variable Balance #####

modeloBalance=lm(Balance ~ ., data = creditos)  # Balance en función del resto de variables.
summary(modeloBalance)

# Vemos que el income es negativo. ¿A más balance tiene menos income? ¿Qué sentido tiene?
# Ceteris paribus: el truco está en el rating. Ese -8.05 es a igualdad de rating. Es decir, a igualdad de rating,
# a menos income más balance -> claro, si el rating es igual y tengo más ingresos, es porque tengo que tener menos balance.

# Ojo con el ceteris páribus! Como hay colinealidad, cuidado.

## -------------------------------------------------------------------------

##### 14. Bloque de ejercicio #####

## ¿Cuales serian las variables que incluiriamos en el modelo?

modeloBalanceFin=lm(Balance ~                    , data = creditos)
summary(modeloBalanceFin)

anova(modeloBalance,modeloBalanceFin)

## -------------------------------------------------------------------------

##### 15. Bloque de modelado (stepwise) backward #####

# Para elegir el mejor modelo (es decir, con qué variables me sale el mejor modelo )

ModelAutoBackward=step(modeloBalance,direction="backward",trace=1)
summary(ModelAutoBackward)
# Empieza con el modelo entero, mide su AIC, y va quitando variables, va analizando todas las combinaciones y al final se
# queda con el mejor.

ModelAutoStepwise=step(modeloBalance,direction="both",trace=1)  # backward y stepwise
summary(ModelAutoStepwise)


anova(ModelAutoBackward,modeloBalance)
anova(ModelAutoStepwise,modeloBalance)

## -------------------------------------------------------------------------
##       PARTE 2: REGRESIÓN MULTIPLE:
##                  APLICACIONES AL ESTUDIO DE LA OFERTA y LA DEMANDA
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 16. Bloque de carga de datos #####

Ventas=read.csv2("data/ventas.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 17. Bloque de revisión basica del dataset #####

str(Ventas)
head(Ventas)
summary(Ventas)

## -------------------------------------------------------------------------

##### 18. Bloque de formateo de variables #####

Ventas$Fecha=as.Date(Ventas$Fecha)
Ventas$Producto=as.factor(Ventas$Producto)

str(Ventas)
head(Ventas)
summary(Ventas)

## -------------------------------------------------------------------------

##### 19. Bloque de Estimación de ventas en función al precio #####

modelo1=lm(Cantidad~Precio,data=Ventas)
summary(modelo1)
# Ojo: el t-test me dice si el coeficiente es distinto de cero o igual a 0. No nos dice si ese valor es estadísticamente
# significativo de por sí. Eso se mira con el error estándar.


plot(modelo1$residuals)
smoothScatter(modelo1$residuals)
hist(modelo1$residuals)
qqnorm(modelo1$residuals); qqline(modelo1$residuals,col=2)

confint(modelo1,level=0.95)

# El modelo está OK. Sin embargo, no parece intuitivo que la relación sea una recta (precios negativos, etc...)
# Hagamos transformaciones

## -------------------------------------------------------------------------

##### 20. Bloque de Estimación de semielasticidad de las ventas con respecto al precio #####

modelo2=lm(log(Cantidad)~Precio,data=Ventas)
summary(modelo2)
plot(modelo2$residuals)
smoothScatter(modelo2$residuals)
hist(modelo2$residuals)
qqnorm(modelo2$residuals); qqline(modelo2$residuals,col=2)
confint(modelo2,level=0.95)

## -------------------------------------------------------------------------

##### 21. Bloque de Estimación de elasticidad de las ventas con respecto al precio #####

modelo3=lm(log(Cantidad)~log(Precio),data=Ventas)
summary(modelo3)
plot(modelo3$residuals)
hist(modelo3$residuals)
qqnorm(modelo3$residuals); qqline(modelo3$residuals,col=2)
confint(modelo3,level=0.95)

## -------------------------------------------------------------------------
##       PARTE 3: REGRESIÓN LINEAL MULTIPLE: 
##                  ESTUDIO DE CAMBIOS ESTRUCTURALES
## -------------------------------------------------------------------------

# Antes, en el modelo de Precio frente a Cantidad, nos salía un R2 de 82%.

## -------------------------------------------------------------------------

##### 22. Bloque de análisis gráfico por tipo producto #####

plot(Ventas$Precio,Ventas$Cantidad)  # Vemos que el ajuste es una mierda
abline(modelo1,col=2)

# Esto ha pasado por que hay dos subpoblaciones que no debería estimar de forma conjunta.
# Intentaremos hacer un modelo para cada población y ver si tienen la misma estructura con el test de Chow

plot(modelo1$residuals,col=Ventas$Producto)
plot(modelo2$residuals,col=Ventas$Producto)
plot(modelo3$residuals,col=Ventas$Producto)

## -------------------------------------------------------------------------

##### 23. Bloque de análisis de estructuras por producto #####

modelo1_A0143=lm(Cantidad~Precio,data=Ventas[Ventas$Producto=="A0143",])  # Modelo sólo para un producto
modelo1_A0351=lm(Cantidad~Precio,data=Ventas[Ventas$Producto=="A0351",])

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col="red",lty = "dashed")
abline(modelo1_A0143,col="blue")
abline(modelo1_A0351,col="green")

summary(modelo1)
summary(modelo1_A0143)
summary(modelo1_A0351)

# Mirando los R2, vemos que es contraintuitivo totalmente. Al hacer la regresión azul sólo con los datos de la izquierda
# en vez de con todos sale el R2 mucho más bajo. Habría que seguir indagando.
# Tampoco podemos decir que ese R2 sea malo (habrá que comparar con otro modelo con ese mismo conjunto de datos)

## -------------------------------------------------------------------------

##### 24. Bloque de contraste de Chow de diferencias estructurales #####

# ¿Hay diferencia estructural entre un producto y otro?

chow.test(Ventas$Cantidad[Ventas$Producto=="A0143"],Ventas$Precio[Ventas$Producto=="A0143"],Ventas$Cantidad[Ventas$Producto=="A0351"],Ventas$Precio[Ventas$Producto=="A0351"])
# Rechazamos la hipótesis de la igualdad de los modelos.
# En R este test no nos da mucha info porque si hay varias variables, no me da info de por dónde varía la cosa.

# Hay otra manera de hacerlo:

modelo1_Chow=lm(Cantidad~Precio*Producto,data=Ventas)

summary(modelo1)
summary(modelo1_Chow)

plot(modelo1$residuals,col=Ventas$Producto)
plot(modelo1_Chow$residuals,col=Ventas$Producto)

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col="red",lty = "dashed")
abline(a=7264.56,b=-1139.53,col="blue")
abline(a=7264.56-3244.34,b=-1139.53+796.03,col="green")

anova(modelo1,modelo1_Chow)

# Viene bien analizar posibles subpoblaciones en los modelos.

## -------------------------------------------------------------------------
##       PARTE 3: REGRESIÓN MULTIPLE:
##                  OUTLIERS Y LA FALTA DE ROBUSTEZ
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 25. Bloque de creación de datos simulados #####

x=c(1,2,3,4,5,6,7,8,9,10)
y=3*x+2+rnorm(length(x),0,1)
Datos=data.frame(x,y)
modelolm=lm(y~x, data=Datos)
summary(modelolm)
# Vemos que el modelo ha encontrado el patrón más o menos

# Metemos outliers
xOut=c(x,15)
yOut=c(y,300)
DatosOut=data.frame(xOut,yOut)
modelolmOut=lm(yOut~xOut,data=DatosOut)
summary(modelolmOut)

## -------------------------------------------------------------------------

##### 26. Bloque de representación gráfica #####

plot(xOut,yOut)
abline(modelolm,col="blue")
abline(modelolmOut,col="red")
abline(a=modelolm$coefficients[1],b=modelolm$coefficients[2],col="blue")
abline(a=modelolmOut$coefficients[1],b=modelolmOut$coefficients[2],col="red")

# Un solo outlier me jode la regresión. La estadística clásica busca eliminar estos outliers, pero...
# Qué es un outlier? Qué no?

# Vamos a hacer una regresión robusta:
library(MASS)
modelorlm=lm(y~x, data=Datos)
modelorlmOut=lm(y~x, data=DatosOut)

plot(xOut,yOut)
abline(modelolm,col="blue")
abline(modelolmOut,col="red")
abline(modelorlm,col="green")
abline(modelorlmOut,col="brown")

# Ha entendido que hay outliers y ya lo hace solo, de forma sistematizada y científica por nosotros.

# Regresión son outliers
ggplot(Datos, aes(x = x, y = y)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

# Regresión con outliers
ggplot(DatosOut, aes(x = xOut, y = yOut)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

## -------------------------------------------------------------------------