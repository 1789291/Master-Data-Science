Basics of programming in R
================

Índice
------

1.  [RStudio](#rstudio)
2.  [Pedir ayuda](#pedir-ayuda)
3.  [Trabajando con paquetes](#trabajando-con-paquetes)
4.  [R como calculadora](#r-como-calculadora)
5.  [Vectorización](#vectorización)
6.  [Tipos de datos](#tipos-de-datos)

-   6.1. [Numéricos](#numéricos)
-   6.2. [Strings](#strings)
-   6.3. [Expresiones regulares](#expresiones-regulares)
-   6.4. [Expresiones lógicas](#expresiones-lógicas)
-   6.5. [Fechas](#fechas)
-   6.6. [Valores missing](#valores-missing)
-   6.7. [Estructuras de datos (vectores, listas,dataframes)](#estructuras-de-datos)

RStudio
-------

Cheatsheet de RStudio en:

<https://www.rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf>

Obtener el directorio de trabajo

``` r
getwd()
```

    ## [1] "C:/Users/migue/Data Science/Master Data Science/KSCHOOL/1. Temario/7. Programación en R/Github Repo jrcajide/master_data_science-master"

Fijar el directorio de trabajo

``` r
setwd("C:/Users/migue/Data Science/Master Data Science/KSCHOOL/1. Temario/7. Introducción a R/Github Repo jrcajide/master_data_science-master")   
```

Asignación de variables

``` r
x <- 2
y <- 3
x
```

    ## [1] 2

Listar todos los objetos que tengo en memoria

``` r
ls()
```

    ## [1] "x" "y"

¿Existe un objeto?

``` r
exists('x')
```

    ## [1] TRUE

Borrar un objeto

``` r
rm(x)
```

Borrar todo lo que tengo en el WD:

``` r
rm(list = ls())
```

Pedir ayuda
-----------

``` r
help(mean)      # ayuda
?mean           # lo mismo
example(mean)   # me hace un ejemplo 
```

Trabajando con paquetes
-----------------------

El sitio más común para obtener paquetes es CRAN, aunque puedo obtenerlos de cualquier sitio.

``` r
install.packages("dplyr", dependencies = T)

# Con el dependencies le digo que me instale todos los demás paquetes que necesite dplyr.
```

También puedo instalar paquetes desde el panel de RStudio.

Una vez instalada tengo que cargarla:

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

Para utilizar una función específica de un paquete:

``` r
dplyr::select(iris, 'Sepal.Length')
```

En principio no hace falta poner `dplyr::`, pero hay veces que una misma función está en dos paquetes diferentes, por lo que en estos casos evitamos problemas.

Ayuda de paquetes.

``` r
help(package = "dplyr")      # provides details regarding contents of a package
vignette(package = "dplyr")  # Las vignettes son casos prácticos de uso de una librería
vignette("dplyr")            # Para ver una vignette específica
```

Instalar un paquete de alguien en github:

``` r
install.packages("devtools")
library(devtools)
install_github("hadley/dplyr")
```

Lista de paquetes útiles en R:

<https://support.rstudio.com/hc/en-us/articles/201057987-Quick-list-of-useful-R-packages>

R como calculadora
------------------

``` r
8 + 9 / 5 ^ 2
```

    ## [1] 8.36

``` r
options(digits = 3)  # Número de decimales
1 / 7
```

    ## [1] 0.143

``` r
42 / 4          # regular division
```

    ## [1] 10.5

``` r
42 %/% 4        # integer division
```

    ## [1] 10

``` r
42 %% 4         # resto (remainder)
```

    ## [1] 2

Funciones matemáticas

``` r
x <- 10

abs(x)      # absolute value
```

    ## [1] 10

``` r
sqrt(x)     # square root
```

    ## [1] 3.16

``` r
exp(x)      # exponential transformation
```

    ## [1] 22026

``` r
log(x)      # logarithmic transformation
```

    ## [1] 2.3

``` r
cos(x)      # cosine and other trigonometric functions
```

    ## [1] -0.839

Vectorización
-------------

``` r
x <- c(1,3,4)  # Creo un vector con c (concatenar)
y <- c(2,5,1)
x
```

    ## [1] 1 3 4

``` r
# empty vector 
z <- as.vector(NULL)
z
```

    ## NULL

En R empezamos en \[1\], no en \[0\]. Es un lenguaje vectorizado como python:

``` r
x*y
```

    ## [1]  2 15  4

``` r
x > y
```

    ## [1] FALSE FALSE  TRUE

Tipos de datos
--------------

### Numéricos

``` r
dbl_var <- c(1, 2.5)
int_var <- c(1L, 6L)  # Forzamos a que sean enteros
```

Obtener el tipo de una variable

``` r
print(typeof(dbl_var))
```

    ## [1] "double"

``` r
print(typeof(int_var))
```

    ## [1] "integer"

Convertir variables

``` r
print(as.numeric(int_var))
```

    ## [1] 1 6

``` r
print(as.integer(dbl_var))
```

    ## [1] 1 2

Crear vectores

``` r
1:10
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

Crear secuencias

``` r
seq(from = 1, to = 21, by = 3)
```

    ## [1]  1  4  7 10 13 16 19

``` r
seq(0, 21, length.out = 3) # 3 elementos de 0 a 21
```

    ## [1]  0.0 10.5 21.0

``` r
rep(1:4, each = 2)
```

    ## [1] 1 1 2 2 3 3 4 4

``` r
rep(1:4, times = 2)
```

    ## [1] 1 2 3 4 1 2 3 4

Comparación de números

``` r
x <- c(1, 4, 9, 12)
y <- c(4, 4, 9, 13)
x == y
```

    ## [1] FALSE  TRUE  TRUE FALSE

``` r
# Me compara elemento a elemento
```

``` r
sum(x == y)  # Cuántos elementos coinciden entre uno y otro
```

    ## [1] 2

``` r
which(x == y) # En qué posiciones están los que coinciden
```

    ## [1] 2 3

``` r
x <- c(4, 4, 9, 12)
y <- c(4, 4, 9, 13)

identical(x, y)  # Igualdad exacta
```

    ## [1] FALSE

Redondeo

``` r
x <- c(1, 1.35, 1.7, 2.05, 2.4, 2.75, 3.1)

print(round(x))
```

    ## [1] 1 1 2 2 2 3 3

``` r
print(ceiling(x))
```

    ## [1] 1 2 2 3 3 3 4

``` r
print(floor(x))
```

    ## [1] 1 1 1 2 2 2 3

``` r
print(round(x, digits = 1))
```

    ## [1] 1.0 1.4 1.7 2.0 2.4 2.8 3.1

### Strings

``` r
a <- "learning to create"    
b <- "character strings"     
```

Pegar strings

``` r
paste(a,b)
```

    ## [1] "learning to create character strings"

``` r
paste("The life of", pi)  # Me convierte directamente los números a texto
```

    ## [1] "The life of 3.14159265358979"

``` r
paste("R", 1:5, sep = " v1.")  # Está creando un vector de 5 elementos. Esto será muy útil para pegar cosas a columnas
```

    ## [1] "R v1.1" "R v1.2" "R v1.3" "R v1.4" "R v1.5"

Imprimir con referencia a variables

``` r
x <- "print strings"
sprintf("Learning to %s in R", x)   
```

    ## [1] "Learning to print strings in R"

``` r
y <- "in R"
sprintf("Learning to %s %s", x, y)   
```

    ## [1] "Learning to print strings in R"

``` r
# Con números
version <- R.version$major
version <- as.numeric(version)
sprintf("This is R version: %d", version)
```

    ## [1] "This is R version: 3"

Contar elementos

``` r
length("How many elements are in this string?")
```

    ## [1] 1

``` r
length(c("How", "many", "elements", "are", "in", "this", "string?"))
```

    ## [1] 7

``` r
nchar("How many characters are in this string?")
```

    ## [1] 39

``` r
nchar(c("How", "many", "characters", "are", "in", "this", "string?"))
```

    ## [1]  3  4 10  3  2  4  7

Manipulación de strings: librería `stringr`

``` r
library('stringr')
```

``` r
# Igual que paste()
str_c("Learning", "to", "use", "the", "stringr", "package", sep = " ")
```

    ## [1] "Learning to use the stringr package"

Substring:

``` r
x <- "Learning to use the stringr package"
str_sub(x, start = 10, end = 15)
```

    ## [1] "to use"

Quitar espacios antes y después

``` r
text <- c("Text ", "  with", " whitespace ", " on", "both ", " sides ")
str_trim(text, side = "both")  # Elimina los espacios en blanco. Con side le decimos que sea por ambos lados. Es el strip.
```

    ## [1] "Text"       "with"       "whitespace" "on"         "both"      
    ## [6] "sides"

Operaciones con sets en strings

``` r
set_1 <- c("lagunitas", "bells", "dogfish", "summit", "odell")
set_2 <- c("sierra", "bells", "harpoon", "lagunitas", "founders")

union(set_1, set_2)
```

    ## [1] "lagunitas" "bells"     "dogfish"   "summit"    "odell"     "sierra"   
    ## [7] "harpoon"   "founders"

``` r
intersect(set_1, set_2)
```

    ## [1] "lagunitas" "bells"

``` r
# returns elements in set_1 not in set_2
setdiff(set_1, set_2)
```

    ## [1] "dogfish" "summit"  "odell"

``` r
identical(set_1, set_2)
```

    ## [1] FALSE

Identificar si un caracter está en una string

``` r
'sierra' %in% set_2  
```

    ## [1] TRUE

Ordenar por orden alfabético

``` r
sort(set_2, decreasing = TRUE)
```

    ## [1] "sierra"    "lagunitas" "harpoon"   "founders"  "bells"

### Expresiones regulares

``` r
sub(pattern = "\\$", "\\!", "I love R$")  
```

    ## [1] "I love R!"

``` r
# Le digo que me reemplace '$' por '!'
# Hay que meter las \\ porque el carácter $ y !! es característico de expresiones regulares.
```

``` r
# substitute \\ with whitespace
gsub(pattern = "\\\\", " ", "I\\need\\space")
```

    ## [1] "I need space"

### Expresiones lógicas

``` r
x <- 5

x > 13
```

    ## [1] FALSE

``` r
x <- c(5, 14, 10, 22)

x > 13
```

    ## [1] FALSE  TRUE FALSE  TRUE

``` r
x[x>13]  # Filtrado en vectores (como en python)
```

    ## [1] 14 22

``` r
12 == 12
```

    ## [1] TRUE

``` r
12 <= c(12, 11)  # Menor o igual
```

    ## [1]  TRUE FALSE

``` r
12 %in% c(12, 11, 8)  # Está 12 contenido en ese vector=
```

    ## [1] TRUE

``` r
x <- c(12, NA, 11, NA, 8)
is.na(x)
```

    ## [1] FALSE  TRUE FALSE  TRUE FALSE

``` r
x <- c(5, 14, 10, 22)
sum(x > 13)  # Me devuelve cuántos elementos son >13, no la suma de ellos
```

    ## [1] 2

### Fechas

Librería `lubridate`

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

Obtener fecha y hora actuales

``` r
Sys.timezone()
```

    ## [1] "Europe/Paris"

``` r
Sys.Date()
```

    ## [1] "2018-06-17"

``` r
Sys.time()
```

    ## [1] "2018-06-17 23:02:47 CEST"

``` r
now()
```

    ## [1] "2018-06-17 23:02:47 CEST"

Convertir string a fecha

``` r
y <- c("07/01/2015", "07/01/2015", "07/01/2015")

as.Date(y, format = "%m/%d/%Y") # format es el formato de entrada
```

    ## [1] "2015-07-01" "2015-07-01" "2015-07-01"

``` r
ymd(x)  # "Mi vector x viene en el formato ymd" -> lo guarda en formato fecha. Abreviatura de la anterior
```

    ## Warning: All formats failed to parse. No formats found.

    ## [1] NA NA NA NA

``` r
mdy(y)
```

    ## [1] "2015-07-01" "2015-07-01" "2015-07-01"

Crear fechas uniendo datos

``` r
yr <- c("2012", "2013", "2014", "2015")
mo <- c("1", "5", "7", "2")
day <- c("02", "22", "15", "28")

# ISOdate converts to a POSIXct object
ISOdate(year = yr, month = mo, day = day)
```

    ## [1] "2012-01-02 12:00:00 GMT" "2013-05-22 12:00:00 GMT"
    ## [3] "2014-07-15 12:00:00 GMT" "2015-02-28 12:00:00 GMT"

``` r
as.Date(ISOdate(year = yr, month = mo, day = day))  # Si no quiero la hora
```

    ## [1] "2012-01-02" "2013-05-22" "2014-07-15" "2015-02-28"

Extraer parte de las fechas

``` r
x <- c("2015-07-01", "2015-08-01", "2015-09-01")
year(x)
```

    ## [1] 2015 2015 2015

``` r
# Nombre abreviado de los meses

month(x, label = TRUE)  # Esto es una variable categórica
```

    ## [1] jul\\. ago\\. sep\\.
    ## 12 Levels: ene\\. < feb\\. < mar\\. < abr\\. < may\\. < ... < dic\\.

Secuencias de fechas

``` r
seq(as.Date("2010-1-1"), as.Date("2014-1-1"), by = "years")
```

    ## [1] "2010-01-01" "2011-01-01" "2012-01-01" "2013-01-01" "2014-01-01"

``` r
seq(as.Date("2015/1/1"), as.Date("2015/12/30"), by = "quarter")
```

    ## [1] "2015-01-01" "2015-04-01" "2015-07-01" "2015-10-01"

Diferencia de fechas

``` r
x <- as.Date("2012-03-1")
y <- as.Date("2012-02-28")

x - y
```

    ## Time difference of 2 days

``` r
as.numeric(x - y)
```

    ## [1] 2

``` r
# Sumar días o horas
x + days(4)
```

    ## [1] "2012-03-05"

``` r
x - hours(4)
```

    ## [1] "2012-02-29 20:00:00 UTC"

#### Ejercicio:

``` r
# 1. crear un vector con todas las fechas de este año

all_dates <- seq(as.Date("2018/1/1"), as.Date("2018/12/31"), by = "day")
all_dates[1:5]
```

    ## [1] "2018-01-01" "2018-01-02" "2018-01-03" "2018-01-04" "2018-01-05"

``` r
# 2. Obtener el día de hoy

hoy <- as.Date(now())

hoy
```

    ## [1] "2018-06-17"

``` r
# 3. ¿En qué día del año estamos?

as.numeric(as.Date(now()) - first(all_dates))
```

    ## [1] 167

``` r
# 4. Cuántos meses faltan para acabar el año?

ultimo_dia <-last(all_dates)
hoy <- as.Date(now())

ultimo_dia
```

    ## [1] "2018-12-31"

``` r
hoy
```

    ## [1] "2018-06-17"

``` r
dias_hasta_final <- ultimo_dia - hoy
dias_hasta_final
```

    ## Time difference of 197 days

``` r
meses_hasta_final <- (ultimo_dia - hoy)/30 
as.numeric(meses_hasta_final)
```

    ## [1] 6.57

### Valores missing

``` r
x <- c(1:4, NA, 6:7, NA)
x
```

    ## [1]  1  2  3  4 NA  6  7 NA

``` r
is.na(x)  # Trues donde hay un valor nulo
```

    ## [1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE

``` r
which(is.na(x))  # Posiciones del vector donde tengo nulos
```

    ## [1] 5 8

``` r
x[is.na(x)]  # Quédate con los NA
```

    ## [1] NA NA

``` r
x[!is.na(x)]  # No te quedes con los NA
```

    ## [1] 1 2 3 4 6 7

``` r
x[is.na(x)] <- mean(x, na.rm = TRUE)  # Reemplázame los NA por la media
x
```

    ## [1] 1.00 2.00 3.00 4.00 3.83 6.00 7.00 3.83

### Estructuras de datos

``` r
vector <- 1:10  #Vector
list <- list(item1 = 1:10, item2 = LETTERS[1:18])  # Listas: es una lista de vectores
matrix <- matrix(1:12, nrow = 4)  # Matriz
df <- data.frame(item1 = 1:18, item2 = LETTERS[1:18])  # Dataframes
```

`str` me permite ver en pantalla la info que tiene ese objeto

``` r
str(vector)
```

    ##  int [1:10] 1 2 3 4 5 6 7 8 9 10

``` r
str(list)
```

    ## List of 2
    ##  $ item1: int [1:10] 1 2 3 4 5 6 7 8 9 10
    ##  $ item2: chr [1:18] "A" "B" "C" "D" ...

``` r
str(matrix)
```

    ##  int [1:4, 1:3] 1 2 3 4 5 6 7 8 9 10 ...

``` r
str(df)
```

    ## 'data.frame':    18 obs. of  2 variables:
    ##  $ item1: int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ item2: Factor w/ 18 levels "A","B","C","D",..: 1 2 3 4 5 6 7 8 9 10 ...

Clase de la estructura de datos

``` r
class(vector)
```

    ## [1] "integer"

``` r
class(list)
```

    ## [1] "list"

``` r
class(matrix)
```

    ## [1] "matrix"

``` r
class(df)
```

    ## [1] "data.frame"

Atributos

``` r
attributes(df)  # un df tiene como atributos los nombres de las columnas, los "nombres" de las filas, y la clase (dataframe)
```

    ## $names
    ## [1] "item1" "item2"
    ## 
    ## $row.names
    ##  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18
    ## 
    ## $class
    ## [1] "data.frame"

``` r
attributes(matrix)  # la matriz tiene como atributo su dimensión
```

    ## $dim
    ## [1] 4 3

Acceder a los atributos: dos maneras

``` r
names(df)
```

    ## [1] "item1" "item2"

``` r
attributes(df)$names
```

    ## [1] "item1" "item2"

#### Vectores

Crear un vector

``` r
x <- c(0.5, 0.6, 0.2)
x
```

    ## [1] 0.5 0.6 0.2

``` r
y <- c(TRUE, FALSE, FALSE)
y
```

    ## [1]  TRUE FALSE FALSE

``` r
z <- c("a", "b", "c") 
z
```

    ## [1] "a" "b" "c"

``` r
seq(from = 1, to = 21, by = 2) 
```

    ##  [1]  1  3  5  7  9 11 13 15 17 19 21

``` r
rep(1:4, times = 2) 
```

    ## [1] 1 2 3 4 1 2 3 4

Añadir items a vectores existentes

``` r
v1 <- 8:17

c(v1, 18:22)  # Concateno
```

    ##  [1]  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22

Acceder a elementos de vectores

``` r
v1
```

    ##  [1]  8  9 10 11 12 13 14 15 16 17

``` r
v1[2]
```

    ## [1] 9

``` r
v1[2:4]
```

    ## [1]  9 10 11

``` r
v1[c(2, 4, 6, 8)]
```

    ## [1]  9 11 13 15

``` r
v1[-1]  # Todos menos el primero
```

    ## [1]  9 10 11 12 13 14 15 16 17

``` r
v1[length(v1)]  # El último
```

    ## [1] 17

No hay problema con el tipo de los datos

``` r
vector <- c(20,"Hola")
vector  # Transforma el número en texto
```

    ## [1] "20"   "Hola"

#### Listas

En los vectores todos los elemntos son del mismo tipo. En las listas no. Las listas nos sirven para combinar elementos de distinto tipo.

``` r
l <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.5, 4.2))
str(l)
```

    ## List of 4
    ##  $ : int [1:3] 1 2 3
    ##  $ : chr "a"
    ##  $ : logi [1:3] TRUE FALSE TRUE
    ##  $ : num [1:2] 2.5 4.2

``` r
# Añadir nombres a una lista

l1 <- list(1:3, "a", c(TRUE, FALSE, TRUE))
names(l1) <- c("item6", "item2", "item3")  # Le doy nombres a cada elemento de la lista
attributes(l1)
```

    ## $names
    ## [1] "item6" "item2" "item3"

Acceder a elementos de listas

``` r
l1[1]  # Dame el primer elemento de la lista (el item)
```

    ## $item6
    ## [1] 1 2 3

``` r
l1[[1]]  # Si quiero acceder a los elementos del vector, con el doble corchete
```

    ## [1] 1 2 3

``` r
l1$item6  # Lo mismo
```

    ## [1] 1 2 3

#### Dataframes

Crear dataframe

``` r
df <- data.frame(col1 = 1:3, 
                 col2 = c("this", "is", "text"), 
                 col3 = c(TRUE, FALSE, TRUE), 
                 col4 = c(2.5, 4.2, pi))
str(df)
```

    ## 'data.frame':    3 obs. of  4 variables:
    ##  $ col1: int  1 2 3
    ##  $ col2: Factor w/ 3 levels "is","text","this": 3 1 2
    ##  $ col3: logi  TRUE FALSE TRUE
    ##  $ col4: num  2.5 4.2 3.14

``` r
# Número de filas
nrow(df)
```

    ## [1] 3

``` r
# Número de columnas
ncol(df)
```

    ## [1] 4

``` r
# Añadir atributos a dataframes
rownames(df) <- c("row1", "row2", "row3")  # Como el índice de python
colnames(df) <- c("col_1", "col_2", "col_3", "col_4")  # Nombre a las columnas
```
