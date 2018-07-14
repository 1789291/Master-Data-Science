SQL in R
================

Index
-----

1.  [SQL with R](#sql-with-r)
2.  [Working with databases](#working-with-databases)

SQL with R
==========

Para escribir queries de SQL en R, utilizamos `sqldf`. Ver paquete en: <https://github.com/ggrothendieck/sqldf>

Cargamos un df:

``` r
flights <- data.table::fread('data/flights/2008.csv')
```

``` r
library(sqldf)
```

    ## Loading required package: gsubfn

    ## Loading required package: proto

    ## Loading required package: RSQLite

``` r
carrier_delays <- sqldf("SELECT UniqueCarrier, COUNT(ArrDelay) AS ArrivalDelays FROM flights WHERE ArrDelay > 0 AND Dest = 'JFK' AND Year = 2008  GROUP BY UniqueCarrier ORDER BY 2 DESC");
```

``` r
head(carrier_delays)
```

    ##   UniqueCarrier ArrivalDelays
    ## 1            B6         21719
    ## 2            OH          9461
    ## 3            DL          7722
    ## 4            AA          6340
    ## 5            MQ          3540
    ## 6            UA          2389

Working with databases
======================

Podemos gestionar datos en una base de datos relacional con DBI:

``` r
library(DBI)

con <- dbConnect(RSQLite::SQLite(), path = ":memory:")  # Le estamos diciento que cree la BD relacional en memoria
```

``` r
# Crea la conexión en un archivo temporal
tmp <- tempfile()
con <- dbConnect(RSQLite::SQLite(), tmp)
```

``` r
dbWriteTable(con, "flights", flights)  # Escribimos una tabla: cogemos una tabla y le decimos cómo guardarla en la BD
dbListTables(con)  # Lista de las tablas que tengo
```

    ## [1] "flights"

``` r
dbListFields(con, "flights")  # Lista los campos
```

    ##  [1] "Year"              "Month"             "DayofMonth"       
    ##  [4] "DayOfWeek"         "DepTime"           "CRSDepTime"       
    ##  [7] "ArrTime"           "CRSArrTime"        "UniqueCarrier"    
    ## [10] "FlightNum"         "TailNum"           "ActualElapsedTime"
    ## [13] "CRSElapsedTime"    "AirTime"           "ArrDelay"         
    ## [16] "DepDelay"          "Origin"            "Dest"             
    ## [19] "Distance"          "TaxiIn"            "TaxiOut"          
    ## [22] "Cancelled"         "CancellationCode"  "Diverted"         
    ## [25] "CarrierDelay"      "WeatherDelay"      "NASDelay"         
    ## [28] "SecurityDelay"     "LateAircraftDelay"

``` r
# Hacemos una query
query <- dbSendQuery(con, "SELECT * FROM flights WHERE Dest = 'JFK' LIMIT 10")

# Almacenamos el resultado de la query en jfk
jfk <- dbFetch(query)

head(jfk)
```

    ##   Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime CRSArrTime
    ## 1 2008     1          1         2     945        935    1135       1118
    ## 2 2008     1          1         2    1315       1325    1500       1516
    ## 3 2008     1          1         2    2015       2025    2205       2218
    ## 4 2008     1          2         3    1010        935    1155       1118
    ## 5 2008     1          2         3    1436       1325    1611       1516
    ## 6 2008     1          2         3    2020       2025    2240       2218
    ##   UniqueCarrier FlightNum TailNum ActualElapsedTime CRSElapsedTime AirTime
    ## 1            YV      2614  N939LR               110            103      79
    ## 2            YV      2622  N904FJ               105            111      70
    ## 3            YV      2626  N914FJ               110            113      76
    ## 4            YV      2614  N914FJ               105            103      72
    ## 5            YV      2622  N905FJ                95            111      73
    ## 6            YV      2626  N928LR               140            113     101
    ##   ArrDelay DepDelay Origin Dest Distance TaxiIn TaxiOut Cancelled
    ## 1       17       10    CLT  JFK      541     17      14         0
    ## 2      -16      -10    CLT  JFK      541     10      25         0
    ## 3      -13      -10    CLT  JFK      541     10      24         0
    ## 4       37       35    CLT  JFK      541      4      29         0
    ## 5       55       71    CLT  JFK      541      8      14         0
    ## 6       22       -5    CLT  JFK      541     10      29         0
    ##   CancellationCode Diverted CarrierDelay WeatherDelay NASDelay
    ## 1                         0           17            0        0
    ## 2                         0           NA           NA       NA
    ## 3                         0           NA           NA       NA
    ## 4                         0           37            0        0
    ## 5                         0            0            0       55
    ## 6                         0            0            0       22
    ##   SecurityDelay LateAircraftDelay
    ## 1             0                 0
    ## 2            NA                NA
    ## 3            NA                NA
    ## 4             0                 0
    ## 5             0                 0
    ## 6             0                 0

Para finalizar la conexión:

``` r
dbClearResult(query)  
dbDisconnect(con)
unlink(tmp)
```
