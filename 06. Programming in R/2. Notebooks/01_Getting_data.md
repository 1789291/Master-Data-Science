Getting Data
================

Index
-----

1.  [Descargar datos de una dirección con R](#descargar-datos-de-una-dirección-con-r)
2.  [Web Scraping](#web-scraping)

Partimos de una página en la que tenemos datos de vuelos de 1987 a 2008. Veremos cómo descargarlos:

Descargar datos de una dirección con R
======================================

``` r
# Creamos una carpeta downloads en el working directory en el caso de que no exista
if(!file.exists("downloads")){
  dir.create("downloads")
}

tmp_dir <- "downloads"

tmp_file <- file.path(tmp_dir, '2007.csv')  # Creamos la ruta del archivo que queremos

download.file('http://stat-computing.org/dataexpo/2009/2007.csv.bz2', tmp_file)  # Descargamos el archivo

library(R.utils) # para bunzip2
bunzip2(tmp_file, "downloads/2007.csv", remove = FALSE, skip = TRUE)  # Descomprimimos el archivo

# Checks
file.info(tmp_file) # Archivo descargado?
utils:::format.object_size(file.info("downloads/2007.csv")$size, "auto") # Tamaño del archivo descomprimido
```

Esto es para únicamente uno de los archivos. Si quisiéramos descargarlos todos de forma automatizada:

Web Scraping
============

``` r
library(rvest) # for read_html, html_*, ...
library(stringr) # for str_*

page <- read_html("http://stat-computing.org/dataexpo/2009/the-data.html")

?html_nodes

(all_links <- html_nodes(page, "a"))  # Líneas del HTML con 'a'
(linked_resources <- html_attr(all_links, "href"))  # Nos quedamos con los atributos de href
(linked_bz2_files <- str_subset(linked_resources, "\\.bz2"))  # Me quedo con los .bz2
(bz2_files_links <- paste0("http://stat-computing.org/dataexpo/2009/", linked_bz2_files))  # Aquí tengo los links a todos los archivos

(bz2_files_links <- tail(bz2_files_links, 2)) # Nos quedamos con sólo los dos primeros 

(num_files <- length(bz2_files_links))


# Custom download function: función para descargar los archivos

download_flights_datasets <- function (link) {
  
  cat(link, "\n")
  
  this_file_link <- link
  
  this_file_name <- str_extract(basename(this_file_link), "^.{0,8}")
  
  this_tmp_file <- file.path(tmp_dir, this_file_name)
  
  download.file(this_file_link, this_tmp_file)
  
  bunzip2(this_tmp_file, file.path('downloads', this_file_name), remove = FALSE, skip = TRUE)
}

# Testing download_flights_datasets 

( link <- bz2_files_links[1] )

download_flights_datasets(link)
```

Para descargar los archivos en paralelo:

``` r
# Downloading all files in parallel
library("foreach") # for foreach
library("doParallel") # for makeCluster, registerDoParallel


detectCores()

cl <- makeCluster(detectCores() - 1) # create a cluster with x cores
registerDoParallel(cl) # register the cluster

res <- foreach(i = 1:num_files, 
               .packages = c("R.utils", "stringr")) %dopar% {
                 this_file_link <- bz2_files_links[i]
                 download_flights_datasets(this_file_link)
               }
```
