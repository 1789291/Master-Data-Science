Reading Data
================

Index
-----

1.  [Reading data with Base R](#reading-data-with-base-r)
2.  [Reading data with readr](#reading-data-with-readr)
3.  [Reading data with data.table](#reading-data-with-data.table)
4.  [Reading multiple files](#reading-multiple-files)
5.  [Parallel reading](#parallel-reading)
6.  [Reading big files](#reading-big-files)
7.  [Queries con SQLite](#queries-con-sqlite)
8.  [Chunks](#chunks)

Reading data with Base R
========================

``` r
airports <- read.csv("data/airports.csv")
```

Reading data with readr
=======================

``` r
library(readr)

ptm <- proc.time()
flights <- read_csv('data/flights/2007.csv', progress = F)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_integer(),
    ##   UniqueCarrier = col_character(),
    ##   TailNum = col_character(),
    ##   Origin = col_character(),
    ##   Dest = col_character(),
    ##   CancellationCode = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
proc.time() - ptm  # Manera de ver cuánto tardo
```

    ##    user  system elapsed 
    ##   10.78    0.37   11.15

``` r
# Para ver el tamaño:

print(object.size(get('flights')), units='auto')
```

    ## 967 Mb

Reading data with data.table
============================

Esta librería es mucho más rápida, pero su sintaxis es bastante poco intuitiva

``` r
library(data.table)

ptm <- proc.time()
flights <- fread("data/flights/2007.csv")
proc.time() - ptm
```

    ##    user  system elapsed 
    ##    4.83    0.54    1.61

Reading multiple files
======================

``` r
( data_path <- file.path('data','flights') )  # file.path me concatena eso de manera que lo transforma en una ruta a un directorio
```

    ## [1] "data/flights"

``` r
( files <- list.files(data_path, pattern = '*.csv', full.names = T) )  # me da la ruta completa (archivo incluido)
```

    ## [1] "data/flights/2007.csv" "data/flights/2008.csv"

``` r
system.time( flights <- lapply(files, fread) )  # lapply es una función de R Base que es como hacer un bucle: a cada i en files, aplica fread
```

    ##    user  system elapsed 
    ##    9.71    1.12    3.41

``` r
system.time( flights <- lapply(files, fread, nThread=7) )  # Número de hilos que puede utilizar en paralelo
```

    ##    user  system elapsed 
    ##    9.90    0.91    3.18

Ojo, `flights` es una lista:

``` r
class(flights)  # Es una LISTA
```

    ## [1] "list"

He de convertirla:

``` r
flights <- rbindlist(flights)
class(flights)  # Ahora es un dataframe
```

    ## [1] "data.table" "data.frame"

Parallel reading
================

``` r
library(doParallel)
```

    ## Loading required package: foreach

    ## Loading required package: iterators

    ## Loading required package: parallel

``` r
registerDoParallel(cores = detectCores() - 1)  # Nos dice los núcleos que tiene el ordenador
# Le decimos que todo lo que se pueda hacer en paralelo lo haga en el número de cores que tengo -1
```

De forma paralelizada, aplicamos read\_csv a cada uno de los archivos

``` r
library(foreach)
system.time( flights <- foreach(i = files, .combine = rbind) %dopar% read_csv(i, progress = F) )  # Aquí podríamos tener la función que queramos
# Al final me convierte esas listas a dataframe y me los junta

system.time( flights <- data.table::rbindlist(foreach(i = files) %dopar% data.table::fread(i, nThread=8)))
# Esto es similar pero con data.table 
```

Reading big files
=================

Cuando los ficheros son demasiado grandes y no caben en memoria:

``` r
# En Linux, línea de comandos:

system('head -5 data/flights/2008.csv')
```

Leer sólo algunas líneas:

``` r
readLines("data/flights/2008.csv", n=2)
```

    ## [1] "Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay"
    ## [2] "2008,1,3,4,2003,1955,2211,2225,WN,335,N712SW,128,150,116,-14,8,IAD,TPA,810,4,8,0,,0,NA,NA,NA,NA,NA"

Averiguar el número de filas:

``` r
length(readLines("data/flights/2008.csv")) # Tarda bastante y no es tan grande el archivo
```

    ## [1] 7009729

``` r
nrow(data.table::fread("data/flights/2008.csv", select = 1L, nThread = 2)) # Using fread on the first column
```

Leer con SQL sólo lo que necesitamos

``` r
library(sqldf)  # SQL en R
jfk <- sqldf::read.csv.sql("data/flights/2008.csv", 
                           sql = "select * from file where Dest = 'JFK'")
```

Leer con `fread` lo que necesitamos:

``` r
data.table::fread("data/flights/2008.csv", select = c("UniqueCarrier","Dest","ArrDelay" ))
```

Queries con SQLite
==================

SQLite es una base relacional diminuta que se genera en un archivo en el disco como si fuera cualquier motor relacional (postgres, etc...).

``` r
read.csv.sql("./data/flights/2008.csv", 
             sql = c("attach 'flights_db.sqlite' as flights",   # flights_db.sqlite será un archivo en mi disco
                     "DROP TABLE IF EXISTS flights.delays",  # si existe flights.delays me la borras
                     "CREATE TABLE flights.delays as SELECT UniqueCarrier, TailNum, ArrDelay FROM file WHERE ArrDelay > 0") 
                            # Me creas esa tabla
)
```

``` r
db <- dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')  # db es un puntero en el que tenemos nuestra conexión
dbListTables(db)

delays.df <- dbGetQuery(db, "SELECT UniqueCarrier, AVG(ArrDelay) AS AvgDelay FROM delays GROUP BY UniqueCarrier")  
delays.df

# Esto como funciona es que me crea un motorcillo de SQL que tiene las cosas en DISCO en vez de en MEMORIA, por lo que no tengo limitaciones de espacio. Cuando hago consultas, sólo lo que necesita lo pasa a memoria.
```

Pte ver porque en windows a veces da error. Para terminar la sesión:

``` r
# Esto para terminar la sesión
unlink("flights_db.sqlite")
dbDisconnect(db)
```

Chunks
======

``` r
# read_csv_chunked
library(readr)
f <- function(x, pos) subset(x, Dest == 'JFK')  # Esto es una función que de cada chunk me va a coger los registros de Dest = 'JFK'
```

``` r
# Utilizamos esta función
jfk <- read_csv_chunked("./data/flights/2008.csv",
                        progress = F,
                        chunk_size = 50000,
                        callback = DataFrameCallback$new(f))
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_integer(),
    ##   UniqueCarrier = col_character(),
    ##   TailNum = col_character(),
    ##   Origin = col_character(),
    ##   Dest = col_character(),
    ##   CancellationCode = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
# Cada vez que acabe un chunk, va a ejecutar lo del callback -> la función
```

Chunks con SQLite:

``` r
# Importing a file into a DBMS:
db <- DBI::dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')  # Nos conectamos a sqlite y le decimos el nombre de la BD
dbListTables(db)
dbWriteTable(db,"jfkflights",jfk) # Inserta en df en memoria en la base de datos. Me lo escribe en disco en la BD
dbGetQuery(db, "SELECT count(*) FROM jfkflights")  # Ahora hago cualquier consulta
dbRemoveTable(db, "jfkflights")
rm(jfk)

# La diferencia de esta con la anterior es que 'jfk' se lee mediante chunks, y lo de SQLite es sin chunks.
# En la anterior al llamar a la tabla se cargaba entera en memoria y se hacía la consulta.
```
