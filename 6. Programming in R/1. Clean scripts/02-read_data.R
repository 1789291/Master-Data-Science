##########################################################################
# Jose Cajide - @jrcajide
# Master Data Science: Reading data
##########################################################################

list.of.packages <- c("R.utils", "tidyverse", "doParallel", "foreach", "sqldf")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


# Base R: Do not run
# flights <- read.csv("data/flights/2007.csv")
# Tenemos una función de R base que es muy lenta para archivos grandes

airports <- read.csv("data/airports.csv")


# Reading data ------------------------------------------------------------

# readr
library(readr)

?read_csv  # Esta es una mejora de la de R base

ptm <- proc.time()
flights <- read_csv('data/flights/2007.csv', progress = T)
proc.time() - ptm

# Lo del proc.time es para ver cuánto tiempo he tardado en cargar el archivo

print(object.size(get('flights')), units='auto')

# Si queremos mejorar todavía más, data.table (en esta librería la sintaxis es menos amigable)
# A día de hoy 


# data.table
remove.packages("data.table")
# Notes:
# http://www.openmp.org/
# https://github.com/Rdatatable/data.table/wiki/Installation
# 
# Linux & Mac:
# install.packages("data.table", type = "source", repos = "http://Rdatatable.github.io/data.table")
# 
# install.packages("data.table")

library(data.table)

# data.table da ventajas de rapidez a la hora de leer archivos

ptm <- proc.time()
flights <- fread("data/flights/2007.csv")
proc.time() - ptm

# Mucho más rápido (menos de 5s)

# Reading multiple files --------------------------------------------------


( data_path <- file.path('data','flights') )  # file.path me concatena eso de manera que lo transforma en un directorio

( files <- list.files(data_path, pattern = '*.csv', full.names = T) )  # me da la ruta completa (archivo incluido)

system.time( flights <- lapply(files, fread) )  # lapply es una func. de R Base que es como hacer un bucle: a cada i en files, aplica fread

system.time( flights <- lapply(files, fread, nThread=7) )  # Número de hilos que puede utilizar en paralelo


# What is flights?
class(flights)  # Es una LISTA

flights <- rbindlist(flights)

class(flights)  # Ahora es un dataframe

flights %>% 
  filter(!is.na(UniqueCarrier))

# Parallel reading --------------------------------------------------------

# library(parallel)
# system.time(flights <- mclapply(files, data.table::fread, mc.cores = 8))
# Esta función es interesante para optimizar código paralelizando (y hacer las cosas más rápidas)

library(doParallel)
registerDoParallel(cores = detectCores() - 1)  # Nos dice los núcleos que tiene el ordenador
# Le decimos que todo lo que se pueda hacer en paralelo lo haga en el número de cores que tengo -1

detectCores()


# De forma paralelizada, aplicamos read_csv a cada uno de los files
library(foreach)
system.time( flights <- foreach(i = files, .combine = rbind) %dopar% read_csv(i) )  # Aquí podríamos tener la función que queramos
# Al final me convierte esas listas a dataframe y me los junta

system.time( flights <- data.table::rbindlist(foreach(i = files) %dopar% data.table::fread(i, nThread=8)))
# Esto es similar pero con data.tabla en vez de 

print(object.size(get('flights')), units='auto')
unique(flights$Year)



# Reading big files -------------------------------------------------------

# Cuando los ficheros ya son demasiado grandes...

# Some times system commands are faster
system('head -5 data/flights/2008.csv')  # Línea de comandos
readLines("data/flights/2008.csv", n=5)

# Num rows
length(readLines("data/flights/2008.csv")) # Not so big files  # Tarda bastante y no es tan grande

nrow(data.table::fread("data/flights/2008.csv", select = 1L, nThread = 2)) # Using fread on the first column


# Reading only what I need
library(sqldf)  # SQL en R
jfk <- sqldf::read.csv.sql("data/flights/2008.csv", 
                           sql = "select * from file where Dest = 'JFK'")
head(jfk)

data.table::fread("data/flights/2008.csv", select = c("UniqueCarrier","Dest","ArrDelay" ))


# Using other tools
# shell: csvcut ./data/airlines.csv -c Code,Description

data.table::fread('/Library/Frameworks/Python.framework/Versions/2.7/bin/csvcut ./data/airports.csv -c iata,airport' )
# Llamamos a csv cut, al fichero y a las columnas que quierp

# shell: head -n 100 ./data/flights/2007.csv | csvcut -c UniqueCarrier,Dest,ArrDelay | csvsort -r -c 3

data.table::fread('head -n 100 ./data/flights/2007.csv | /Library/Frameworks/Python.framework/Versions/2.7/bin/csvcut -c UniqueCarrier,Dest,ArrDelay | /Library/Frameworks/Python.framework/Versions/2.7/bin/csvsort -r -c 3')


# Dealing with larger than memory datasets

# SQLite es una base relacional diminuta que se genera en un archivo en el disco como si fuera cualquier motor relacional (postgres, etc...)

# Using a DBMS
# sqldf("attach 'flights_db.sqlite' as flights")
# sqldf("DROP TABLE IF EXISTS flights.delays")

read.csv.sql("./data/flights/2008.csv", 
             sql = c("attach 'flights_db.sqlite' as flights",   # flights_db.sqlite será un archivo en mi disco
                     "DROP TABLE IF EXISTS flights.delays",  # si existe flights.delays me la borras
                     "CREATE TABLE flights.delays as SELECT UniqueCarrier, TailNum, ArrDelay FROM file WHERE ArrDelay > 0") 
                            # Me creas esa tabla
             # filter = "head -n 100000")
)

db <- dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')  # db es un puntero en el que tenemos nuestra conexión
dbListTables(db)

delays.df <- dbGetQuery(db, "SELECT UniqueCarrier, AVG(ArrDelay) AS AvgDelay FROM delays GROUP BY UniqueCarrier")  
delays.df

# Esto como funciona es que me crea un motorcillo de SQL que tiene las cosas en DISCO en vez de en MEMORIA, por lo que no tengo
# limitaciones de espacio. Cuando hago consultas, sólo lo que necesita lo pasa a memoria.

# PTE: en windows así no funciona

# Esto para terminar la sesión
unlink("flights_db.sqlite")
dbDisconnect(db)


# Chunks ------------------------------------------------------------------

# read_csv_chunked
library(readr)
f <- function(x, pos) subset(x, Dest == 'JFK')  # Esto es una función que de cada chunk me va a coger lo de Dest = 'JFK'

# Utilizamos esta función
jfk <- read_csv_chunked("./data/flights/2008.csv",
                        chunk_size = 50000,
                        callback = DataFrameCallback$new(f))
# Cada vez que acabe un chunk, va a ejecutar lo del callback -> la función

# Importing a file into a DBMS:
db <- DBI::dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')  # Nos conectamos a sqlite y le decimos el nombre de la BD
dbListTables(db)
dbWriteTable(db,"jfkflights",jfk) # Inserta en df en memoria en la base de datos. Me lo escribes en disco en la BD
dbGetQuery(db, "SELECT count(*) FROM jfkflights")  # Ahora hago cualquier consulta
dbRemoveTable(db, "jfkflights")
rm(jfk)

# La diferencia de esta con la anterior es que esta es con chunks, y lo de SQLite es sin chunks.
# En la anterior al llamar a la tabla se cargaba entera en memoria y se hacía la consulta.

##########################################################################
# Ex: Coding exercise: Using read_csv_chunked, read ./data/flights/2008.csv by chunks while sending data into a RSQLite::SQLite() database
##########################################################################

db <- DBI::dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')
writetable <- function(df,pos) {
  dbWriteTable(db,"flights",df,append=TRUE)
}
readr::read_csv_chunked(file="./data/flights/2008.csv", callback=SideEffectChunkCallback$new(writetable), chunk_size = 50000)

# Check
num_rows <- dbGetQuery(db, "SELECT count(*) FROM flights")
num_rows == nrow(data.table::fread("data/flights/2008.csv", select = 1L, nThread = 2)) 

dbGetQuery(db, "SELECT * FROM flights LIMIT 6") 

dbRemoveTable(db, "flights")
dbDisconnect(db)

# sqlite3 /Users/jose/Documents/GitHub/master_data_science/flights_db.sqlite
# sqlite> .tables
# sqlite> SELECT count(*) FROM flights;



# Basic functions for data frames -----------------------------------------

names(flights)
str(flights)
nrow(flights)
ncol(flights)
dim(flights)
