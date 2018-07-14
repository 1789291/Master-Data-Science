Basics of programming in R: part 2
================

Index
-----

1.  [Estructuras de control](#estructuras-de-control)
2.  [Condiciones](#condiciones)
3.  [Bucles for](#bucles-for)
4.  [Creación de funciones](#creación-de-funciones)
5.  [lapply y sapply](#lapply-y-sapply)

Estructuras de control
======================

-   If-else:

``` r
numeros <- 1:15

numero_aleatorio <- sample(numeros, 1)

if (numero_aleatorio >= 10) {
  print( paste(numero_aleatorio, "es mayor o igual que 10") )
} else if (numero_aleatorio > 5) {
  print( paste(numero_aleatorio, "es mayor o igual que 5") )
} else {
  print( paste(numero_aleatorio, "es menor que 5") )
}
```

    ## [1] "5 es menor que 5"

Otra manera: función `if_else` (como la del excel):

``` r
ifelse(numero_aleatorio <= 10,
       print(paste(numero_aleatorio, "es menor o igual que 10")),
       print(paste(numero_aleatorio, "es mayor que 10")))
```

    ## [1] "5 es menor o igual que 10"

    ## [1] "5 es menor o igual que 10"

``` r
# Menos clara
```

Condiciones
===========

`and` y `or`:

``` r
numero_aleatorio > 5 & numero_aleatorio < 10
```

    ## [1] FALSE

``` r
numero_aleatorio > 5 | numero_aleatorio < 10
```

    ## [1] TRUE

Bucles for
==========

``` r
calendario <- seq(2010, 2018 , by = 1)

for (ano in calendario){
  print(paste("El año es", ano))
}
```

    ## [1] "El año es 2010"
    ## [1] "El año es 2011"
    ## [1] "El año es 2012"
    ## [1] "El año es 2013"
    ## [1] "El año es 2014"
    ## [1] "El año es 2015"
    ## [1] "El año es 2016"
    ## [1] "El año es 2017"
    ## [1] "El año es 2018"

Creación de funciones
=====================

``` r
ano_actual <- as.numeric(format(Sys.Date(),'%Y'))  # obtenemos el año actual


busca_ano_actual <- function(ano) {
  if(ano == ano_actual) {  
    resultado <- paste( ano, "es el año actual")
  } else {
    resultado <- paste( ano, "no es el año actual")
  }
  return(resultado)
}

busca_ano_actual(2015)
```

    ## [1] "2015 no es el año actual"

Si quisiéramos hacer un return de varios valores -&gt; con una lista.

lapply y sapply
===============

Es una manera de hacer bucles for pero más limpia, con estructuras de R. Sobre algo iterable (por ejemplo, una lista) aplico una función y devuelvo el resultado.

`lapply`

``` r
lapply(calendario, function(ano) return (ano *2))  # Esto es como una función lambda
```

    ## [[1]]
    ## [1] 4020
    ## 
    ## [[2]]
    ## [1] 4022
    ## 
    ## [[3]]
    ## [1] 4024
    ## 
    ## [[4]]
    ## [1] 4026
    ## 
    ## [[5]]
    ## [1] 4028
    ## 
    ## [[6]]
    ## [1] 4030
    ## 
    ## [[7]]
    ## [1] 4032
    ## 
    ## [[8]]
    ## [1] 4034
    ## 
    ## [[9]]
    ## [1] 4036

`sapply` es la misma idea pero me devuelve un array en vez de una lista.

``` r
sapply(calendario, function(ano) return (ano *2))  # Esto es como una función lambda
```

    ## [1] 4020 4022 4024 4026 4028 4030 4032 4034 4036
