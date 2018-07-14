# Imaginemos que queremos hallar el área de un círculo pero no sabemos nada de matemáticas. 
# Una cosa que podemos hacer es coger un cuadrado (el área de un cuadrado es mucho más intuitiva) y tirar pelotas 
# que entren dentro. Las que entren las cuento. 
# Esa proporción de las que entran entre las totales serán el área de un círculo.




N <- 10000

x <- runif(N, -1, 1)  # 10000 valores entre -1 y 1 con una distribución uniforme.

y <- runif(N, -1, 1)

plot(x,y, cex = .1)

# La ecuación de un círculo de radio 1 es x2 + y2 <= 1

c <- (x^2 + y^2 <= 1)

plot(x, y, cex = .1, col = c) # Pintamos todos los puntos que cumplen esa condición

head(c)  # c es un vector de TRUE y FALSE

mean(c)  # El 78% de los puntos están dentro

# Si multiplico eso * 4 (es la superficie del cuadrado), me dará el número de puntos en el cuadrado

mean(c) * 4  # Obtenemos una buena aproximación de pi

# También jugando con valores de N vemos que al aumentar, nos acercamos al número pi.
# De todas maneras, este acercamiento no es lineal (de hecho, es función de la raíz de N)
