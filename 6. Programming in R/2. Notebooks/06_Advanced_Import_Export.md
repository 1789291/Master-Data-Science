Advanced Importing and Exporting
================

Index
-----

1.  [Importar datos](#importar-datos)
2.  [Exportar datos](#exportar-datos)

Este notebook contiene nociones avanzadas de importado y exportado de datos.

Cargamos librerías:

``` r
require(readr)  # for read_csv()
```

    ## Loading required package: readr

``` r
require(dplyr)  # for mutate()
```

    ## Loading required package: dplyr

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
require(tidyr)  # for unnest()
```

    ## Loading required package: tidyr

``` r
require(purrr)  # for map(), reduce()
```

    ## Loading required package: purrr

``` r
require(data.table) # for fread()
```

    ## Loading required package: data.table

    ## 
    ## Attaching package: 'data.table'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     transpose

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

Importar datos
==============

Para leer varios ficheros de forma automatizada y combinarlos (por ejemplo, cuando tenemos varios ficheros de la misma estructura pero para distinto año, mes, etc...):

``` r
data_path <- file.path("data", "flights")  # creamos el path
files <- dir(data_path, pattern = "*.csv")  # creamos un string con todo lo que termine en csv
```

Leemos todos los archivos y los combinamos en una tabla:

``` r
flights <- files %>%
  # read in all the files, appending the path before the filename
  map(~ read_csv(file.path(data_path, .))) %>%  
  reduce(rbind)
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

Otra manera:

``` r
flights <- files %>%
  map(function(x) read_csv(file.path(data_path, x))) %>%  
  reduce(rbind)
flights
```

Una manera más rápida de hacerlo es con `data.table`. Podemos crear una lista con los dos dataframes:

``` r
system.time( flights <- data_frame(filename = files) %>% # create a data frame
               # holding the file names
               mutate(file_contents = map(filename,          # read files into
                                          ~ data.table::fread(file.path(data_path, .), showProgress=T, nThread=4)) # a new data column
               )  )
```

    ##    user  system elapsed 
    ##    9.33    0.89    2.89

``` r
flights
```

    ## # A tibble: 2 x 2
    ##   filename file_contents                
    ##   <chr>    <list>                       
    ## 1 2007.csv <data.table [7,453,215 x 29]>
    ## 2 2008.csv <data.table [7,009,728 x 29]>

Y después, con `unnest`:

``` r
flights <- unnest(flights)
```

``` r
head(flights)
```

    ## # A tibble: 6 x 30
    ##   filename  Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime
    ##   <chr>    <int> <int>      <int>     <int>   <int>      <int>   <int>
    ## 1 2007.csv  2007     1          1         1    1232       1225    1341
    ## 2 2007.csv  2007     1          1         1    1918       1905    2043
    ## 3 2007.csv  2007     1          1         1    2206       2130    2334
    ## 4 2007.csv  2007     1          1         1    1230       1200    1356
    ## 5 2007.csv  2007     1          1         1     831        830     957
    ## 6 2007.csv  2007     1          1         1    1430       1420    1553
    ## # ... with 22 more variables: CRSArrTime <int>, UniqueCarrier <chr>,
    ## #   FlightNum <int>, TailNum <chr>, ActualElapsedTime <int>,
    ## #   CRSElapsedTime <int>, AirTime <int>, ArrDelay <int>, DepDelay <int>,
    ## #   Origin <chr>, Dest <chr>, Distance <int>, TaxiIn <int>, TaxiOut <int>,
    ## #   Cancelled <int>, CancellationCode <chr>, Diverted <int>,
    ## #   CarrierDelay <int>, WeatherDelay <int>, NASDelay <int>,
    ## #   SecurityDelay <int>, LateAircraftDelay <int>

``` r
print(object.size(get('flights')), units='auto')
```

    ## 1.9 Gb

Exportar datos
==============

Creamos una carpeta destino:

``` r
dir.create('exports')
```

Exportamos a csv:

``` r
flights %>% 
  sample_n(1000) %>% 
  write_csv(., file.path("exports", "flights.csv"))
```

Podemos exportar un archivo con cada mes:

``` r
flights %>% 
  sample_n(1000) %>% 
  group_by(Year, Month) %>%
  do(write_csv(., file.path("exports", paste0(unique(.$Year),"_",unique(.$Month), "_flights.csv"))))
```
