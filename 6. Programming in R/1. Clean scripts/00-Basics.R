# R Basics

# Para ejecutar una línea, si pongo el cursor en ella me la ejecuta

# https://www.rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf

# Workspace Environment
# When saving your R working session, these are the components along with the script files that will be saved in your working directory

# ¿Cuál es mi directorio de trabajo?

getwd()

# Fijo el directorio de trabajo. También puedo hacerlo en el panel (More)

setwd("C:/Users/migue/Data Science/Master Data Science/KSCHOOL/1. Temario/7. Introducción a R/Github Repo jrcajide/master_data_science-master")   


# The workspace environment will also list your user defined objects such as vectors, matrices, data frames, lists, and functions

x <- 2  # Esto es un =. Creo la variable x y le asigno el valor 2
y <- 3

# Me lista todos los objetos que tengo en memoria.
ls()              

# Me dice si existe un objeto
exists("x")        

# Borramos un objeto. No lo usaremos mucho, salvo para cosas que ocupan mucho y no lo usaremos
rm(x)            

# you can remove multiple objects
rm(x, y)  

# Me borra todo lo que tengo en el wd. ls() me decía lo que tengo en memoria
rm(list = ls())  # Esto también se puede hacer con el icono de la escoba

help(rm)

# Getting Help ------------------------------------------------------------
help(mean)      # provides details for specific function 
?mean           # provides same information as help(functionname) 
example(mean)   # Me hace un ejemplo 

# Al mirar la ayuda, en "mean{base}" me dice que la función mean está en la librería base.



# Working with packages ---------------------------------------------------

# Installing and loading Packages 

# The most common place to get packages from is CRAN

install.packages("dplyr", dependencies = T)  # Instala la librería desde CRAN. 
# Con el dependencies le digo que me instale todo lo que necesito.

# También se puede instalar desde el panel. 

# Una vez instalada, he de cargarla
library(dplyr)      

# Ojo, los mensajes rojos son warnings, no errores.

# use a particular function within a package without loading the package: packagename::functionname  
dplyr::select(iris, 
              'Sepal.Length')

# dplyr tiene un método select. Le digo que de iris me seleccione 'Sepal.Length'

# Yo no necesitaría poner el dplyr::. Pero lo usamos cuando tengamos dudas de que otro paquete tenga otro método 
# llamado select. Para asegurarnos que es el método select de dplyr, le ponemos eso.

help(package = "dplyr")      # provides details regarding contents of a package
vignette(package = "dplyr")  # Las vignettes son casos prácticos de uso de una librería
vignette("dplyr")            # Para ver una vignette específica

# Installing for GitHub

# Esto es para cuando una librería no está en CRAN y la tiene un tío en github.

install.packages("devtools")
library(devtools)
install_github("hadley/dplyr")



# Quick list of useful R packages: https://support.rstudio.com/hc/en-us/articles/201057987-Quick-list-of-useful-R-packages


# Exercises
# ggplot2 is an extremely popular package for data visualization and is available from CRAN. Perform the following tasks:
#   
# Install the ggplot2 package.
# Load the ggplot2 package.
# Access the help documentation for the ggplot2 package.
# Check out the vignette(s) for ggplot2


install.packages('ggplot2')
library(ggplot2)
help(ggplot2)
vignette(package = 'ggplot2')
vignette('ggplot2-specs')

# Las librerías de R van siempre a una carpeta de nuestro ordenador. Con .libPaths() en la consola podemos ver el path.
# Las librerías se pueden gestionar (y también borrar) desde el panel.

# Assignment & Evaluation -------------------------------------------------

# assignment
x <- 3

# evaluation
x


y <- 3 
z <- 4
x * y * z

# R as a Calculator -------------------------------------------------------
8 + 9 / 5 ^ 2

1 / 7

options(digits = 3)  # Número de decimales
1 / 7

42 / 4          # regular division
42 %/% 4        # integer division
42 %% 4         # resto (remainder)


# Miscellaneous Mathematical Functions

x <- 10

abs(x)      # absolute value
sqrt(x)     # square root
exp(x)      # exponential transformation
log(x)      # logarithmic transformation
cos(x)      # cosine and other trigonometric functions


# Infinite, and NaN Numbers
1 / 0           # infinity
Inf - Inf       # infinity minus infinity (res: not a number)
-1 / 0          # negative infinity
0 / 0           # not a number
sqrt(-9)        # square root of -9



# Vectorization -----------------------------------------------------------

x <- c(1, 3, 4)  # Creo un vector con c (concatenar)
y <- c(1, 2, 4)

x
y

# empty vector 
z <- as.vector(NULL)

# En R empezamos en 1, no en 0.

# `for` loop to add corresponding elements in each vector
for (i in seq_along(x)) {
  z[i] <- x[i] + y[i]
  print(z)
}

z

# in R, + is a vectorized function
# add each element in x and y
x + y

# multiply each element in x and y
x * y

# compare each element in x to y
x > y

# Note that there are no scalars in R, so c is actually a vector of length 1
c <- 3


######################
# Data types
######################

# Dealing with Numbers ----------------------------------------------------
dbl_var <- c(1, 2.5, 4.5)  
dbl_var

# Forzamos a que sean enteros, aunque no se suele hacer
int_var <- c(1L, 6L, 10L)
int_var

# Me dice el tipo de la variable
typeof(dbl_var)
typeof(int_var)

# Converting Between Integer and Double Values

as.numeric(int_var)  # Aquí me lo muestra, pero si no lo asigno no me cambia el formato (como en Python)
as.integer(dbl_var)


# Generating Non-random Numbers
# create a vector of integers between 1 and 10
1:10     

# Generating Regular Sequences
# generate a sequence of numbers from 1 to 21 by increments of 2
seq(from = 1, to = 21, by = 2)  

# generate a sequence of numbers from 1 to 21 that has 15 equal incremented numbers
seq(0, 21, length.out = 15)

# Generating Repeated Sequences
# replicates the values in x a specified number of times in a collated fashion
rep(1:4, times = 2)  # Repíteme el vector dos veces
# replicates the values in x in an uncollated fashion
rep(1:4, each = 2)


# Comparing Numeric Values

x <- c(1, 4, 9, 12)
y <- c(4, 4, 9, 13)
x == y
# How many pairwise equal values are in vectors x and y
sum(x == y)  # Cuántos elementos coinciden entre uno y otro

# Where are the pairwise equal values located in vectors x and y
which(x == y)    

x[which(x == y)] # Subsetting: more on this later

# Exact Equality

x <- c(4, 4, 9, 12)
y <- c(4, 4, 9, 13)

identical(x, y)

# Rounding numeric Values

x <- c(1, 1.35, 1.7, 2.05, 2.4, 2.75, 3.1, 3.45, 3.8, 4.15, 4.5, 4.85, 5.2, 5.55, 5.9)

# Round to the nearest integer
round(x)

# Round up
ceiling(x)

# Round down
floor(x)

# Round to a specified decimal
round(x, digits = 1)


# Dealing with Characters -------------------------------------------------

# Creating Strings

a <- "learning to create"    # create string a
b <- "character strings"     # create string

# paste together string a & b (concatenar)
paste(a, b)

# paste character and number strings (converts numbers to character class)
paste("The life of", pi)  # Me convierte directamente los números a texto

# paste multiple strings
paste("I", "love", "R")            

# paste multiple strings with a separating character
paste("I", "love", "R", sep = "-")  

# use paste0() to paste without spaces btwn characters
paste0("I", "love", "R")

# paste objects with different lengths
paste("R", 1:5, sep = " v1.")  # Está creando un vector de 5 elementos. Esto será muy útil para pegar cosas a columnas


x <- "print strings"

# substitute a single string/variable
sprintf("Learning to %s in R", x)   
# substitute multiple strings/variables
y <- "in R"
sprintf("Learning to %s %s", x, y)   

# For integers, use %d or a variant:
version <- R.version$major  # Lo veremos
version <- as.numeric(version)
sprintf("This is R version: %d", version)

# Counting string elements and characters
length("How many elements are in this string?")
length(c("How", "many", "elements", "are", "in", "this", "string?"))

nchar("How many characters are in this string?")
nchar(c("How", "many", "characters", "are", "in", "this", "string?"))

# String manipulation with stringr

# install stringr package
install.packages("stringr")

# load package
library(stringr)

# str_c() is equivalent to the paste() functions
str_c("Learning", "to", "use", "the", "stringr", "package", sep = " ")

# str_length() is similiar to the nchar() but: (compare)
# some text with NA
text = c("Learning", "to", NA, "use", "the", NA, "stringr", "package")  # Da igual poner = que <-, aunque por lo general es asignar
nchar(text)
str_length(text)

# str_sub() is similar to substr()
x <- "Learning to use the stringr package"

# alternative indexing
str_sub(x, start = 10, end = 15)

# Replacement
str_sub(x, end = 15) <- "I know how to use"
x

# Remove Leading and Trailing Whitespace
text <- c("Text ", "  with", " whitespace ", " on", "both ", " sides ")
str_trim(text, side = "both")  # Elimina los espacios en blanco. Con side le decimos que sea por ambos lados. Es el strip.

# Set operatons for character strings
set_1 <- c("lagunitas", "bells", "dogfish", "summit", "odell")
set_2 <- c("sierra", "bells", "harpoon", "lagunitas", "founders")

union(set_1, set_2)
intersect(set_1, set_2)
# returns elements in set_1 not in set_2
setdiff(set_1, set_2)
identical(set_1, set_2)

# Identifying if Elements are Contained in a String
'sierra' %in% set_2  

# Sorting a String
sort(set_2, decreasing = TRUE)



# Dealing with Regular Expressions ----------------------------------------

# substitute $ with !
sub(pattern = "\\$", "\\!", "I love R$")  
# Le digo que me reemplace '$' por '!'
# Hay que meter las \\ porque el carácter $ y !! es característico de expresiones regulares.

sub(pattern = 'H', 'h', 'Hola')  # Aquí como no tengo caracteres especiales no tengo que meter nada 

# substitute \\ with whitespace
gsub(pattern = "\\\\", " ", "I\\need\\space")


# Dealing with Logicals ---------------------------------------------------

x <- 5

x > 13

x <- c(5, 14, 10, 22)

x > 13

x[x>13]  # Filtrado en vectores (como en python)

12 == 12

12 <= c(12, 11)  # Menor o igual

12 %in% c(12, 11, 8)  # Está 12 contenido en ese vector=

x <- c(12, NA, 11, NA, 8)
is.na(x)

x <- c(5, 14, 10, 22)
sum(x > 13)  # Me devuelve cuántos elementos son >13, no la suma de ellos


# Dealing with Dates ------------------------------------------------------

# Getting current date & time
Sys.timezone()

Sys.Date()

Sys.time()

install.packages('lubridate')
library(lubridate)

now()

# Converting strings to dates
x <- c("2015-07-01", "2015-08-01", "2015-09-01")

as.Date(x)

y <- c("07/01/2015", "07/01/2015", "07/01/2015")

as.Date(y, format = "%m/%d/%Y") # format es el formato de entrada

# Aunque en la consola vea que sean iguales antes y después del as.Date, internamente R ya sabe que es una fecha, no un string

ymd(x)  # "Mi vector x viene en el formato ymd" -> lo guarda en formato fecha. Abreviatura de la anterior
mdy(y)

# Create Dates by Merging Data -> Para componer una fecha sobre varias columnas de un dataset

yr <- c("2012", "2013", "2014", "2015")
mo <- c("1", "5", "7", "2")
day <- c("02", "22", "15", "28")

# ISOdate converts to a POSIXct object
ISOdate(year = yr, month = mo, day = day)
as.Date(ISOdate(year = yr, month = mo, day = day))  # Si no quiero la hora

# truncate the unused time data by converting with as.Date
as.Date(ISOdate(year = yr, month = mo, day = day))

# Extract & manipulate parts of dates

x <- c("2015-07-01", "2015-08-01", "2015-09-01")

year(x)

# default is numerical value
month(x)

# show abbreviated name
month(x, label = TRUE)  # Esto es una variable categórica (lo veremos)

# Creating date sequences
seq(as.Date("2010-1-1"), as.Date("2015-1-1"), by = "years")
seq(as.Date("2015/1/1"), as.Date("2015/12/30"), by = "quarter")

# Calculations with dates

x <- Sys.Date()
x

y <- as.Date("2015-09-11")
x > y
x - y

diferencia <- as.numeric(x-y)
diferencia

# last leap year (tiene en cuenta años bisiestos)
x <- as.Date("2012-03-1")
y <- as.Date("2012-02-28")

x - y

# example with time zones
x <- as.POSIXct("2017-01-01 01:00:00", tz = "US/Eastern")
y <- as.POSIXct("2017-01-01 01:00:00", tz = "US/Pacific")

y == x
y - x

# Sumar días o horas
x + days(4)
x - hours(4)


# EJERCICIO:

# 1. crear un vector con todas las fechas de este año

all_dates <- seq(as.Date("2018/1/1"), as.Date("2018/12/31"), by = "day")
all_dates

# 2. Obtener el día de hoy

as.Date(now())

# 3. ¿En qué día del año estamos?

as.numeric(as.Date(now()) - first(all_dates))

# 4. Cuántos meses faltan para acabar el año?

ultimo_dia <-last(all_dates)
hoy <- as.Date(now())

ultimo_dia
hoy
dias_hasta_final <- ultimo_dia - hoy
dias_hasta_final

meses_hasta_final <- (ultimo_dia - hoy)/30 
meses_hasta_final

# Corrección:

fechas <- seq(as.Date("2018/1/1"), as.Date("2018/12/31"), by = "days")
length(fechas)

# Día actual
hoy <- Sys.Date()

# Días desde el comienzo del año
which(hoy == fechas)
length(fechas) - which(hoy == fechas)

# Meses que faltan para que termine el año
floor((length(fechas) - which(hoy == fechas))/30)



# Dealing with Missing Values ---------------------------------------------

x <- c(1:4, NA, 6:7, NA)
x

is.na(x)  # Trues donde hay un valor nulo
which(is.na(x))  # Posiciones del vector donde tengo nulos
x[is.na(x)]  # Quédate con los NA
x[!is.na(x)]  # No te quedes con los NA
x[is.na(x)] <- mean(x, na.rm = TRUE)  # Reemplázame los NA por la media
x


# Data Structure Basics ---------------------------------------------------

# Identifying the Data Structure
vector <- 1:10  #Vector
list <- list(item1 = 1:10, item2 = LETTERS[1:18])  # Listas: es una lista de vectores
matrix <- matrix(1:12, nrow = 4)  # Matriz
df <- data.frame(item1 = 1:18, item2 = LETTERS[1:18])  # Dataframes


# str me permite ver en pantalla la info que tiene ese objeto
str(vector)
str(list)
str(matrix)
str(df)

class(vector)
class(list)
class(matrix)
class(df)

# Understanding Attributes
attributes(df)  # un df tiene como atributos los nombres de las columnas, los "nombres" de las filas, y la clase (dataframe)
attributes(matrix)


# Así accedo a los atributos
names(df)
dim(matrix)
length(vector)
length(list)
length(df)

# Es lo mismo que:
attributes(df)$names

# Managing Vectors

# Creating Vectors
x <- c(0.5, 0.6, 0.2)
x

y <- c(TRUE, FALSE, FALSE)
y

z <- c("a", "b", "c") 
z

seq(from = 1, to = 21, by = 2) 
rep(1:4, times = 2) 

# adding additional elements to a pre-existing vector

v1 <- 8:17

c(v1, 18:22)  # Concateno

# Subsetting Vectors
v1
v1[2]
v1[2:4]
v1[c(2, 4, 6, 8)]
v1[-1]  # Todos menos el primero
v1[length(v1)]  # El último

# Subsetting with logical values

v1[c(TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, TRUE)]  # Me va a seleccionar sólo los correspondientes a TRUE
v1[c(TRUE, FALSE)]


vector <- c(20,"Hola")
vector  # Transforma el número en texto

vector2 <- c(TRUE,"Hola")
vector2  # Lo mismo

c(TRUE,2)

# En los vectores, todos los elementos son del mismo tipo. En las listas no es así.

# Las listas nos sirven para combinar elementos de distinto tipo

# Managing Lists

# Creating Lists
l <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.5, 4.2))
str(l)

# adding names to a pre-existing list

l1 <- list(1:3, "a", c(TRUE, FALSE, TRUE))
names(l1) <- c("item1", "item2", "item3")  # Le doy nombres a cada elemento de la lista

# Subsetting Lists

l1[1]  # Dame el primer elemento de la lista (el item)
l1[[1]]  # Si quiero acceder a los elementos del vector, con el doble corchete
l1$item1  # Lo mismo

# Managing Data Frames

# Creating Data Frames
# read_csv

df <- data.frame(col1 = 1:3, 
                 col2 = c("this", "is", "text"), 
                 col3 = c(TRUE, FALSE, TRUE), 
                 col4 = c(2.5, 4.2, pi))
str(df)

# number of rows
nrow(df)

# number of columns
ncol(df)

# Adding Attributes to Data Frames
rownames(df) <- c("row1", "row2", "row3")  # Como el índice de python
colnames(df) <- c("col_1", "col_2", "col_3", "col_4")  # Nombre a las columnas

