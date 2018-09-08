# Cargamos la tabla cars
View(cars)

lmcars <- lm(speed~dist, cars)

lmcars$fitted.values

require(ggplot2)
ggplot(cars) + 
  aes(x = dist, y = speed) + 
  geom_point()

lmcars$residuals

summary(lmcars$residuals)
lmcars$fitted.values

lmcars$coefficients

mtcars <- mtcars

lmmtcars <- lm(qsec ~ cyl + hp + wt, data = mtcars)

summary(lmmtcars)

plot(lmmtcars)
# Selección por pasos

# Una vez hecho el modelo, es importante ver si el modelo se ha entrenado bien, si es fiable.
# Hay que tener en mente que los modelos parten de asunciones (ejemplo -> normalidad)

# Si yo hago plot(modelo), me salen 4 gráficos:
# 1. Residuos contra fitted: me dice si los errores y las estimaciones correlacionan => algo va mal.
#    O tengo colinealidad, o algo va mal. Por ejemplo, si yo tengo que cuando los coches van lento 
#    subestimo siempre la predicción y cuando van rápido lo sobreestimo, eso está mal. El error debería ser igual
#    para todas las observaciones
# 2. QQPLOT: si todos los cuantiles me coinciden, es porque mi distribución es común a una normal. Es decir,
#    que mis RESIDUOS son normales.
# 3. Residuos estandarizados (normalizado) frente a valores predichos. Se debería distribuir sin patrones
#    y te señala los outliers.
# 4. Leverage: es un número que intenta decirte si un sólo dato es influyente. Entendiendo por influyente 
#    que influencia mucho al modelo. Por ejemplo, un valor atípico muy lejos de mi línea cambiaría bastante
#    mi línea. Si no hay puntos que están fuera de las líneas de puntos estamos OK.

library('ROCR')
library('caret')
# install.packages('caret')

# Ojo, al crear variables dummy siempre hay una referencia (que es la que no se mete en el modelo), y al final si yo
# hago un modelo y veo un coeficiente de -1.5 en la variable dummy, eso hay que mirarlo como en referencia al valor referencia.

# Vamos a convertir una variable cuantitativa en una cualitativa
summary(mtcars$mpg)

mtcars$mpg_cualitativa <- as.factor((mtcars$mpg < 15) + (mtcars$mpg < 22))
# Ahora los de más de 22 serán un 2, los de entre medias un 1, y los de debajo de 15 0.

# Hagamos un modelo con esta variable:

lmmtcars_cualitativo <- lm(qsec ~ mpg_cualitativa + hp, data = mtcars)
summary(lmmtcars_cualitativo)

# Vemos que se han quedado mpg_cualitativa1 y mpg_cualitativa2. La de referencia es mpg_cualitativa0.
# Ese 0.10 se interpreta como que si eres del grupo 1, tu valor promedio de qsec se eleva en 0.10 con respecto al grupo de
# REFERENCIA (tener 0).

# Esto a veces causa problemas para interpretar un modelo estadística: por ejemplo, si tengo clases que son equipos de fútbol,
# no es tan intuitivo coger uno de referencia. Hay maneras de fijar la referencia.

# Regresión logística

# La regresión logística se usa un montón. Va muy bien. Si tienes una red neuronal, quitas la última capa
# y le metes una logística.

library(titanic)

View(Titanic)
titanic_train

titanic0 <- glm(Survived ~ Age, data = titanic_train)
summary(titanic0)

# Este modelo está mal, porque si nos fijamos en titanic0$family, por defecto la función de enlace es lineal. 
# Está MAL. La variable no sigue una distribución normal, por lo que no puedes usar esa función de enlace.
# Tampoco estoy puteado si mi variable no sigue una normal -> puedo transformar la variable (logaritmo, raíz, etc...)

titanic0$family


# En el help, vemos que hay muchas funciones de enlace en función de la distribución (gamma, etc.)
# Al final la manera es plotear el histograma de la variable y si veo que se parece a una gamma, lo hago con una gamma.
# También se puede hacer qqplot y cosas del estilo con la distribución que sea

titanic1 <- glm(Survived ~ Age, data = titanic_train, family = binomial(link="identity"))  # Esto no va a funcionar bien

summary(titanic1)

# Interpretemos: esto me dice que si tengo 0 años, la probabilidad de sobrevivir es el intercepto. 
# Si tengo un año, empieza a disminuir. Si sigo sumando años, disminuye más.
# Pero esto no es una relación lineal. Sin embargo, como he puesto una función de enlace lineal (identidad),
# se ve que es muy plana, porque yo tengo muchos puntos en 0 y en 1 pero no entre medias, por lo que al ajustar una recta
# lo ajusta mal.

# Otra cosa aquí: el valor de referencia serían 0 años, lo que no tiene mucho sentido. Lo que se suele hacer es
# normalizar y hacer que la referencia sean, por ejemplo, 30 años, de manera que ahora mi 0 son 30 en vez de 0 años, lo que
# tiene más sentido.

titanic2 <- glm(Survived ~ Age, data = titanic_train, family = binomial(link="logit"))  # Esto no va a funcionar bien

summary(titanic1)

summary(titanic2)

# Qué significa el número de los coeficientes exactamente: es la variación en el odds ratio del grupo-evento age-survived

titanic3 <- glm(Survived ~ Age + Pclass + Sex, data = titanic_train, family = binomial(link="identity"))  

# Esto da un error porque al poner más variables, la relación lineal es tan mala que ni siquiera la línea converge.
# Ojo, esto es con identity, que no lo usaremos.

titanic2 <- glm(Survived ~ Age + Pclass + Sex, data = titanic_train, family = binomial(link="logit"))  

summary(titanic2)

# Como la clase no me la ha hecho como un factor (y debería porque es lo que tiene sentido), lo hacemos:
titanic2 <- glm(Survived ~ Age + as.factor(Pclass) + Sex, data = titanic_train, family = binomial(link="logit"))  
summary(titanic2)


# el 2.52 dice que si eres hombre tienes menos 2.5 veces de odd ratio.

# Ojo: debajo de la regresión logística hay un supuesto muy fuerte: tiene que haberaditividad.
# Ejemplo: los rectángulos: la relación de la superficie de un rectángulo con su altura y anchura no es aditiva: es el producto.
# Puede ser muy alto o no, pero su superficie depende totalmente de el ancho.
# En la vida real no suele haber aditividad, pero si pones un modelo te puede hacer un buen papel

# La regresión logística nos da, con el elemento 3 (pesos), una serie de números entre 0 y 1 

# El siguiente paso es: ¿dónde pongo el corte?:

# EVALUACIÓN DEL ERROR

misPredicciones <- (titanic2$fitted.values > 0.5)*1  # Estas serían mis predicciones si corto en 0.5

titanic_train$Survived  # Habría que hacerlo con el test pero pasamos de ese detalle.

misPredicciones == titanic_train$Survived  # Miro cuántas he acertado: TRUE

mean((misPredicciones*1) == titanic_train$Survived) # 0.52

# Si hago la media con cada corte, me dará un valor de acierto.

# Imaginemos dos distribuciones (1 y 0) y un punto de corte: depende de donde yo ponga el corte, tendré:
# Si lo pongo muy a la izquierda, tendré mucho error de un tipo y muy poco del otro.
# Depende del error que yo quiera cometer, pongo el corte en un punto o en otro.

# Ejemplo: una prueba médica:

# Puede haber dos tipos de errores:
# Que esté enfermo y no lo detecte
# Que no lo esté y me lo detecte

# Sensibilidad: no se le pasa ni una, pero puede tener muchos falsos positivos. Si pongo un modelo muy sensible,
# no va a pasar ni uno que tenga la enfermedad sin detectársela. Pero me va a pasar que habrá mucha gente que no la tenga
# y les salga positivo.

# Especificidad: no quiero falsos positivos. Entonces saltará mucho menos, seré menos sensible, pero me evitaré falsos positivos.

# Al final es decidir si quiero muchos falsos positivos o pocos.
# Depende de si lo que yo puedo tolerar es que haya muchos falsos positivos o no.

# Cómo decido dónde pongo el corte? Curva ROC.

# Obtengo los fitted values

titanic_train$Age[is.na(titanic_train$Age)] <- mean(titanic_train$Age, na.rm=T)

titanic2 <- glm(Survived ~ Age + as.factor(Pclass) + Sex, data = titanic_train, family = binomial(link="logit"))

p <- titanic2$fitted.values  # primera manera

p <- predict(titanic2, type="response")  # segunda manera
# si aquí no le pongo el response, me devuelve la y del estimador lineal. La g es la variable respuesta, porlo que le digo que es g(y)

library(ROCR)



titanic_prediction <- prediction(p, titanic_train$Survived)

# Hay muchos estadísticos para medir la precisión, pero todos están basados en una matriz de confusión. 
# Depende de lo que sumes y dividas sale un número u otro. Dos muy importantes son el TPR (True positive rate) y FPR (False Positive rate)
# Pero hay muchas más.

# Curva ROC
plot(performance(titanic_prediction, measure = "tpr", x.measure='fpr'))

# El mejor modelo será aquel en el que yo tenga muy pocos falsos positivos y muchos true positivos (que es sensible pero no
# demasiado y me da miles de falsos positivos).

performance(titanic_prediction, measure="auc")

# Un AUC de 0.5 es un modelo aleatorio
# Un AUC por debajo de 0.5 es un modelo bueno pero predice al revés. Lo cambias y listo.

# Para elegir el valor de corte, depende:

# Por ejemplo digo que no quiero más de un 20% de FPR
k <- performance(titanic_prediction, measure = "tpr", x.measure='fpr')
l <- k@x.values[[1]]  # la arroba es porque k es un objeto especial que tiene slots. Para acceder a los slots es con la @

max(which(l < 0.20))

k@alpha.values[[1]][153]  # Este sería el punto de corte



# La probit no la recomienda: da muy parecido a la logit y los coefs son mucho más difíciles de interpretar.

# Abstracto: los modelos lineales separan mediante una línea: si no puedo separar con una línea, un modelo lineal no me vale.

# Poisson: si mi variable es un conteo, 

# Bonus: regresión logística multiclase

# paquete nnet: función multinom