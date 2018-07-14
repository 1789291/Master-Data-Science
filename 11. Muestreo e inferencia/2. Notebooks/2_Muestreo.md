Muestreo
================

Index
-----

1.  [Muestreo simple](#muestreo-simple)
2.  [Muestreo simple con reposición](#muestreo-simple-con-reposición)
3.  [Muestreo estratificado](#muestreo-estratificado)
4.  [Muestreo por conglomerado](#muestreo-por-conglomerado)

Este notebook complementa a la teoría de las presentaciones sobre **muestreo**.

> Inicialización:

``` r
require(tidyverse)
require(ggplot2)
set.seed(1234)  # Semilla de los números aleatorios.

require(rvest)
url="https://es.wikipedia.org/wiki/Provincia_de_España"
provincias<-read_html(url) %>% html_nodes("table") %>% .[[2]] %>% html_table(header=TRUE,fill=TRUE) %>% .[[1]]
```

Muestreo simple
===============

El muestreo simple es con la función sample.

``` r
NN=10000
poblacion=rnorm(NN,108,5)
nn=250 #tamaño muestral
muestra=sample(poblacion,nn)
mean(muestra)
```

    ## [1] 108.0559

``` r
# t.test(muestra)
```

Muestreo simple con reposición
==============================

``` r
muestra=sample(provincias,nn,replace=TRUE)
table(muestra)
```

    ## muestra
    ##                  Álava               Albacete               Alicante 
    ##                      5                      5                      7 
    ##                Almería               Asturias                  Ávila 
    ##                      5                      3                      3 
    ##                Badajoz               Baleares              Barcelona 
    ##                      4                      3                      4 
    ##                 Burgos                Cáceres                  Cádiz 
    ##                      6                      3                      4 
    ##              Cantabria              Castellón                  Ceuta 
    ##                      4                      7                      5 
    ##        Ciudad Autónoma            Ciudad Real                Córdoba 
    ##                      7                      6                      3 
    ##                 Cuenca                 Gerona                Granada 
    ##                      6                      4                      6 
    ##            Guadalajara              Guipúzcoa                 Huelva 
    ##                      2                      4                      2 
    ##                 Huesca              La Coruña               La Rioja 
    ##                      6                      4                      4 
    ##             Las Palmas                   León                 Lérida 
    ##                      7                      4                      6 
    ##                   Lugo                 Madrid                 Málaga 
    ##                      7                      5                      8 
    ##                Melilla                 Murcia                Navarra 
    ##                      2                      4                      3 
    ##                 Orense               Palencia             Pontevedra 
    ##                      9                      5                      6 
    ##              Salamanca Santa Cruz de Tenerife                Segovia 
    ##                      4                      4                      7 
    ##                Sevilla                  Soria              Tarragona 
    ##                      3                      6                      5 
    ##                 Teruel                 Toledo               Valencia 
    ##                      5                      3                      4 
    ##             Valladolid                Vizcaya                 Zamora 
    ##                      6                      3                      3 
    ##               Zaragoza 
    ##                      9

``` r
muestra=sample(poblacion,nn,replace=TRUE)
mean(muestra)
```

    ## [1] 108.2563

``` r
#t.test(muestra)
```

Muestreo estratificado
======================

``` r
NN=nrow(diamonds) #tamaño de la poblacion
nn= 250 #tamaño muestral
```

**Preámbulo**:

``` r
diamonds %>% sample_n(nn) #muestreo simple de la base de datos "diamonds"
```

    ## # A tibble: 250 x 10
    ##    carat cut       color clarity depth table price     x     y     z
    ##    <dbl> <ord>     <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
    ##  1 0.900 Good      F     VS2      63.8   55.  4309  6.09  6.13  3.90
    ##  2 1.01  Ideal     H     SI1      62.4   53.  4642  6.47  6.42  4.02
    ##  3 0.350 Premium   E     VS1      62.3   60.  1063  4.52  4.50  2.81
    ##  4 0.730 Ideal     D     SI2      59.9   57.  2770  5.92  5.89  3.54
    ##  5 0.410 Very Good D     VVS2     62.5   54.  1160  4.79  4.81  3.00
    ##  6 0.380 Ideal     G     VVS2     60.7   57.   873  4.70  4.73  2.86
    ##  7 0.320 Ideal     F     VS2      62.4   57.   828  4.38  4.34  2.72
    ##  8 1.80  Ideal     H     VS1      62.3   56. 15105  7.79  7.76  4.84
    ##  9 0.310 Ideal     H     VVS1     61.6   55.   687  4.37  4.40  2.70
    ## 10 0.550 Ideal     E     VS2      61.8   57.  1792  5.34  5.27  3.28
    ## # ... with 240 more rows

``` r
mean(diamonds$price) 
```

    ## [1] 3932.8

``` r
mean((diamonds %>% sample_n(nn))$price) # Haciendo esto muchas veces veo que hay mucha variabilidad entre muestras. 
```

    ## [1] 3984.404

Si quiero mejorar la variabilidad: muestreo estratificado:

``` r
diamonds %>%  group_by(cut) %>% summarise(media=mean(price), n = n()) #peso y media de los estratos: calidad del diamante (cut)
```

    ## # A tibble: 5 x 3
    ##   cut       media     n
    ##   <ord>     <dbl> <int>
    ## 1 Fair      4359.  1610
    ## 2 Good      3929.  4906
    ## 3 Very Good 3982. 12082
    ## 4 Premium   4584. 13791
    ## 5 Ideal     3458. 21551

Muestreo estratificado con afijación fija
-----------------------------------------

``` r
# Asigno el mismo número de observaciones a cada estrato

muestra <- diamonds %>% group_by(cut) %>% sample_n(nn/5) 
muestra %>% summarise(media=mean(price), n = n())
```

    ## # A tibble: 5 x 3
    ##   cut       media     n
    ##   <ord>     <dbl> <int>
    ## 1 Fair      4344.    50
    ## 2 Good      3552.    50
    ## 3 Very Good 4139.    50
    ## 4 Premium   4904.    50
    ## 5 Ideal     3619.    50

Muestreo estratificado con afijación proporcional
-------------------------------------------------

``` r
muestra <- diamonds %>% group_by(cut) %>% sample_frac(nn/NN)
muestra %>% summarise(media=mean(price),n = n())
```

    ## # A tibble: 5 x 3
    ##   cut       media     n
    ##   <ord>     <dbl> <int>
    ## 1 Fair      3982.     7
    ## 2 Good      3618.    23
    ## 3 Very Good 3622.    56
    ## 4 Premium   4561.    64
    ## 5 Ideal     3140.   100

``` r
# Ahora la distribución de mi muestra es como la de mi población
```

Muestreo estratificado por calidad y color del diamante
-------------------------------------------------------

``` r
muestra <- diamonds %>% group_by(cut,color) %>% sample_frac(nn/NN) 
muestra2 <- muestra %>% summarise(media=mean(price),n = n())
```

Muestreo por conglomerado
=========================

``` r
diamonds$origen=sample(provincias,NN,replace=TRUE) #se asigna de manera artificial un estado a cada diamante
diamonds %>%  group_by(origen) %>% summarise(media=mean(price), n = n())
```

    ## # A tibble: 53 x 3
    ##    origen    media     n
    ##    <chr>     <dbl> <int>
    ##  1 Álava     4065.   990
    ##  2 Albacete  3797.  1055
    ##  3 Alicante  3798.  1052
    ##  4 Almería   4102.   983
    ##  5 Asturias  3823.  1065
    ##  6 Ávila     3905.  1063
    ##  7 Badajoz   4029.   996
    ##  8 Baleares  3877.  1057
    ##  9 Barcelona 3933.   984
    ## 10 Burgos    4001.  1091
    ## # ... with 43 more rows

``` r
mm=10 # Selecciono 10 provincias
muestraI <- diamonds %>%  group_by(origen) %>% summarise(N = n()) %>% sample_n(mm,weight=N) #Primero se muestrea 10 estados de acuerdo a su tamaño
muestraI
```

    ## # A tibble: 10 x 2
    ##    origen          N
    ##    <chr>       <int>
    ##  1 Salamanca    1044
    ##  2 Guadalajara   993
    ##  3 Málaga        994
    ##  4 Soria        1069
    ##  5 Huesca       1009
    ##  6 Tarragona    1036
    ##  7 Orense       1025
    ##  8 Navarra      1011
    ##  9 Gerona        995
    ## 10 Valencia     1037

``` r
# Con esto hemos seleccionado las 10 provincias que tienen más número de tamaños

# Ahora nos quedamos con esas provincias
frameI <- diamonds %>% filter(origen %in% muestraI$origen)  # nos quedamos con los 10 estados seleccionados
NNI=nrow(frameI)

# Ahora en cada conglomerado hago un muestreo proporcional en el seno de cada conglomerado (provincia)
muestraII <- frameI %>% group_by(origen) %>% sample_frac(nn/NNI) #Muestreo dentro de la base resultante
muestraII %>% summarise(media=mean(price),n = n())
```

    ## # A tibble: 10 x 3
    ##    origen      media     n
    ##    <chr>       <dbl> <int>
    ##  1 Gerona      2932.    24
    ##  2 Guadalajara 3813.    24
    ##  3 Huesca      4506.    25
    ##  4 Málaga      5312.    24
    ##  5 Navarra     3734.    25
    ##  6 Orense      3189.    25
    ##  7 Salamanca   2973.    26
    ##  8 Soria       4075.    26
    ##  9 Tarragona   3831.    25
    ## 10 Valencia    2475.    25

``` r
# Si yo quiero hacer un muestreo por conglomerado equiprobabilístico (sin combinar con nada, tal y como en la transparencia)
muestraIII <- frameI %>%    group_by(origen) %>% sample_n(nn/mm)
muestraIII %>% summarise(media=mean(price),n = n())
```

    ## # A tibble: 10 x 3
    ##    origen      media     n
    ##    <chr>       <dbl> <int>
    ##  1 Gerona      3902.    25
    ##  2 Guadalajara 4077.    25
    ##  3 Huesca      4450.    25
    ##  4 Málaga      3331.    25
    ##  5 Navarra     4711.    25
    ##  6 Orense      5066.    25
    ##  7 Salamanca   3144.    25
    ##  8 Soria       2530.    25
    ##  9 Tarragona   4473.    25
    ## 10 Valencia    5097.    25
