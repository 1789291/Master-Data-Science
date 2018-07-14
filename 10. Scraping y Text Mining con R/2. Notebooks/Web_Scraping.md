Web Scraping
================

Este notebook contiene los ejercicios realizados en clase. Para la explicación teórica ver apuntes pdf y html.

En primer lugar, leemos el contenido HTML de la página

``` r
require(rvest)
require(dplyr)
```

``` r
amanece <- read_html("http://www.imdb.com/title/tt0094641/")
```

Extraemos el título:

``` r
amanece %>% html_nodes('title')
```

    ## {xml_nodeset (1)}
    ## [1] <title>Amanece, que no es poco (1989) - IMDb</title>\n

Pero yo sólo quiero el texto:

``` r
amanece %>% html_nodes('title') %>% html_text()
```

    ## [1] "Amanece, que no es poco (1989) - IMDb"

Ahora, si queremos extraer un párrafo:

``` r
# Identifico lo que quiero con html_nodes (me da todos los párrafos)
# Elijo el párrafo que quiero
# Y me quedo con el texto

amanece %>% html_nodes('p') %>% .[19] %>% html_text(trim=TRUE) # Esto me quita los \n
```

    ## [1] "God decides to send another son to the earth to save the world. Jesus Christ disagrees because in such a case the history should be rewritten. To solve the dispute they decide to organise ...                See full summary »"

Extraemos la tabla del Cast:

``` r
amanece %>% html_nodes('table') %>% .[[1]] %>% html_table(header = TRUE) %>% .[[2]]
```

    ##  [1] "José Sazatornil"     "Carmen de Lirio"     "Francisco Martínez" 
    ##  [4] "Ovidi Montllor"      "Carmen Rodríguez"    "Rafael Díaz"        
    ##  [7] "Amada Tercero"       "Cassen"              "Manuel Alexandre"   
    ## [10] "María Ángeles Ariza" "Rafael Alonso"       "Fedra Lorente"      
    ## [13] "Cris Huerta"         "Elisa Belmonte"      "María I. González"

**Ejercicio**: Descargar el ultimo discurso del rey de España desde la siguiente dirección:

<http://www.casareal.es/ES/Actividades/Paginas/actividades_discursos_detalle.aspx?data=5738>

``` r
discurso <- read_html("http://www.casareal.es/ES/Actividades/Paginas/actividades_discursos_detalle.aspx?data=5000")

discurso %>% html_nodes('p') %>% html_text() %>% paste(collapse = " ") %>% head
```

    ## [1] "M ucho me alegra estar hoy de nuevo en Sevilla, junto a la Reina, en esta apertura del Curso Académico Universitario 2004-2005. Y ello, no sólo por encontrarnos en esta gran ciudad por la que sentimos un especial afecto, sino también por coincidir esta inauguración con la celebración del Quinto Centenario de su prestigiosa Universidad. Este acto nos permite reunirnos con la comunidad universitaria, compartir sus afanes e ilusiones, y transmitir el tributo de gratitud y el mensaje de aliento que la sociedad española debe a su Universidad. La elección de la Universidad de Sevilla para la apertura del nuevo curso nos permite destacar su valiosa aportación a la fecunda tradición de la Universidad española, y expresar nuestro deseo de que tan rica trayectoria secular se reafirme de cara al futuro. En 1505, el Papa Julio II otorgó al Colegio de Santa María de Jesús, fundado unos años antes, la facultad de inferir grados en Teología, Filosofía, Derecho, Medicina y Artes. Desde entonces, a lo largo de nuestra Historia, la Universidad de Sevilla ha sido centro de progreso de las ciencias, las artes y las letras. Pero el prestigio de las instituciones no sólo reposa en su brillante pasado, sino en la firme voluntad de afianzarlo día a día. La Universidad española se encuentra hoy ante un reto importante. En este curso se inicia la etapa final que habrá de conducir en 2010 a la convergencia de la Enseñanza Superior en Europa, en el marco del llamado \"Proceso de Bolonia\". Un proceso que nos llevará a potenciar la sinergia de las Universidades europeas, en su rica aportación a la Ciencia y al Humanismo, y a una unificación de las titulaciones, favoreciendo una mayor movilidad y competencia. Supondrá, sin duda, un cambio fundamental para el conjunto de nuestra comunidad universitaria. Y, aún cuando todo cambio pueda producir una cierta desazón, hemos de verlo como un paso adelante en el desarrollo de la Universidad europea, y por ende, también de la española. Faltan pocos años para que ese Espacio Europeo de Educación Superior se convierta en realidad. Alentamos a la Universidad española a alcanzar dicha meta con ilusión y confianza, afrontando con esfuerzo, dedicación y esperanza esta adaptación a los requerimientos del presente y a las necesidades del futuro. Es fundamental asegurar que la formación que ofrezcan nuestras Universidades proporcione a España, tanto el nivel científico y docente que necesita, como los profesionales que requiere. Esa formación debe concentrarse en el ámbito de las nuevas tecnologías y en sus aplicaciones, sin perder nunca de vista que su objetivo último sigue siendo la formación integral, científica y humanística, de nuestros estudiantes. Cumplir este designio será, en última instancia, resultado del trabajo de todos. Los profesores, en su doble función docente e investigadora, han logrado un avance notable y generalizado de la Universidad española, que hoy compite en situación de plena igualdad con las de nuestros socios europeos. Estamos orgullosos de este progreso y seguros de que nuestros profesores sabrán afrontar con éxito el reto de la convergencia europea. Orgullosos también del personal de administración y servicios, sin cuyo concurso la Universidad no habría conseguido alcanzar su actual nivel de desarrollo. Y, por supuesto, orgullosos de nuestros estudiantes universitarios, que constituyen la mejor esperanza de futuro para España. Contamos con su esfuerzo, con su entrega al estudio, su dedicación y disciplina para obtener los mejores resultados posibles. Quiero dirigir unas palabras de afecto a los estudiantes con discapacidad. Su esfuerzo y tesón merecen nuestro mayor reconocimiento y nos recuerdan nuestra obligación de facilitarles su plena integración social y laboral. La Universidad europea se ha enriquecido con su actual dinámica de intercambios. Dirigimos un cordial saludo al creciente número de alumnos de otros países que acuden a España para estudiar. Su aumento, que es una prueba más del prestigio de nuestra Universidad, se ha facilitado gracias al desarrollo de programas como el Erasmus, cuyos éxitos le han valido el Premio Príncipe de Asturias de Cooperación Internacional. La Universidad, columna vertebral de toda sociedad, tiene una vocación permanente de servicio como factor clave de promoción personal, cambio social y progreso cultural. Es mucho lo que la España de hoy debe a su Universidad. Más allá de su labor de investigación y formación global, le corresponde también un papel crucial en la promoción de los valores y principios que sustentan nuestra convivencia en democracia y libertad. No quiero dejar de manifestar hoy nuestro más emocionado recuerdo a los universitarios que fueron víctimas de la barbarie terrorista el pasado 11 de marzo en Madrid. Siempre estarán presentes en nuestra memoria. La Corona desea manifestar su fe y confianza en la capacidad de la Universidad española para cumplir con creciente eficacia su importantísima tarea y para superar con éxito los desafíos que le corresponde afrontar, todo ello al servicio de una España mejor. Estoy seguro de que, con el esfuerzo de todos, comunidad universitaria, familias, poderes públicos y demás entidades, conseguiremos perfeccionar este ámbito básico de investigación, formación integral y convivencia que es nuestra Universidad. Concluyo mis palabras reiterando mi felicitación más sincera a la Universidad de Sevilla por su Quinto Centenario. Declaro inaugurado el Curso Académico Universitario 2004-2005. Muchas gracias"

**Ejercicio**: Extraer los votos:

``` r
p <- read_html("https://resultados.elpais.com/resultats/eleccions/2016/generals/congreso/")

p %>% html_nodes('table') %>% .[[2]] %>% html_table(header=TRUE) %>% head
```

    ##          Partido Escaños     Votos   Votos
    ## 1             PP     137 7.906.185 33,03 %
    ## 2           PSOE      85 5.424.709 22,66 %
    ## 3 UNIDOS PODEMOS      71 5.049.734  21,1 %
    ## 4            C's      32 3.123.769 13,05 %
    ## 5      ERC-CATSÍ       9   629.294  2,63 %
    ## 6            CDC       8   481.839  2,01 %

Volvemos con las películas:

Tenemos que conocer los selectores CSS: <https://www.w3schools.com/cssref/css_selectors.asp>

``` r
amanece %>% html_nodes("table a")
```

    ## {xml_nodeset (41)}
    ##  [1] <a href="/name/nm0768574/?ref_=tt_cl_i1"><img height="44" width="32 ...
    ##  [2] <a href="/name/nm0768574/?ref_=tt_cl_t1" itemprop="url"> <span clas ...
    ##  [3] <a href="/title/tt0094641/characters/nm0768574?ref_=tt_cl_t1">Cabo  ...
    ##  [4] <a href="/name/nm0513922/?ref_=tt_cl_i2"><img height="44" width="32 ...
    ##  [5] <a href="/name/nm0513922/?ref_=tt_cl_t2" itemprop="url"> <span clas ...
    ##  [6] <a href="/name/nm1771790/?ref_=tt_cl_i3"><img height="44" width="32 ...
    ##  [7] <a href="/name/nm1771790/?ref_=tt_cl_t3" itemprop="url"> <span clas ...
    ##  [8] <a href="/name/nm0600120/?ref_=tt_cl_i4"><img height="44" width="32 ...
    ##  [9] <a href="/name/nm0600120/?ref_=tt_cl_t4" itemprop="url"> <span clas ...
    ## [10] <a href="/name/nm1771909/?ref_=tt_cl_i5"><img height="44" width="32 ...
    ## [11] <a href="/name/nm1771909/?ref_=tt_cl_t5" itemprop="url"> <span clas ...
    ## [12] <a href="/name/nm0246717/?ref_=tt_cl_i6"><img height="44" width="32 ...
    ## [13] <a href="/name/nm0246717/?ref_=tt_cl_t6" itemprop="url"> <span clas ...
    ## [14] <a href="/name/nm1773519/?ref_=tt_cl_i7"><img height="44" width="32 ...
    ## [15] <a href="/name/nm1773519/?ref_=tt_cl_t7" itemprop="url"> <span clas ...
    ## [16] <a href="/name/nm0144107/?ref_=tt_cl_i8"><img height="44" width="32 ...
    ## [17] <a href="/name/nm0144107/?ref_=tt_cl_t8" itemprop="url"> <span clas ...
    ## [18] <a href="/title/tt0094641/characters/nm0144107?ref_=tt_cl_t8">Cura  ...
    ## [19] <a href="/name/nm0018872/?ref_=tt_cl_i9"><img height="44" width="32 ...
    ## [20] <a href="/name/nm0018872/?ref_=tt_cl_t9" itemprop="url"> <span clas ...
    ## ...

Y de esto, nos quedamos con los atributos que queremos: alt

``` r
amanece %>% html_nodes("table a") %>% html_nodes('img') %>% html_attr('alt')
```

    ##  [1] "José Sazatornil"     "Carmen de Lirio"     "Francisco Martínez" 
    ##  [4] "Ovidi Montllor"      "Carmen Rodríguez"    "Rafael Díaz"        
    ##  [7] "Amada Tercero"       "Cassen"              "Manuel Alexandre"   
    ## [10] "María Ángeles Ariza" "Rafael Alonso"       "Fedra Lorente"      
    ## [13] "Cris Huerta"         "Elisa Belmonte"      "María I. González"

**Ejercicio**: extraer la lista de provincias de España de la Wikipedia

``` r
provincias <- read_html("https://es.wikipedia.org/wiki/Provincia_de_Espa%C3%B1a")

# Sabemos que hay tablas:

provincias %>% html_nodes("table")
```

    ## {xml_nodeset (2)}
    ## [1] <table style="border: 1px solid #ccc; background-color: #F9F9F9; mar ...
    ## [2] <table class="wikitable sortable" border="1"><tbody>\n<tr>\n<th>Prov ...

``` r
# Me cojo la segunda

tabla_provincias <- provincias %>% html_nodes("table") %>% .[[2]] %>% html_table(header=TRUE, fill = TRUE)

head(tabla_provincias)
```

    ##   Provincia   Nombre Oficial  Capital   Comunidad autónoma Municipios
    ## 1     Álava      Araba-Álava  Vitoria           País Vasco Municipios
    ## 2  Albacete         Albacete Albacete   Castilla-La Mancha Municipios
    ## 3  Alicante Alicante-Alacant Alicante Comunidad Valenciana Municipios
    ## 4   Almería          Almería  Almería            Andalucía Municipios
    ## 5  Asturias         Asturias   Oviedo             Asturias   Concejos
    ## 6     Ávila            Ávila    Ávila      Castilla y León Municipios

**Ejercicio**: Descargar las cotizaciones del IBEX 35 en tiempo real desde la siguiente página:

``` r
ibex35 <- "http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000"

ibex <- read_html(ibex35)

ibex %>% html_nodes("table") %>% .[[5]] %>% html_table(header=TRUE, fill = TRUE) %>% head
```

    ##        Nombre     Últ. % Dif.     Máx.     Mín. Volumen Efectivo (miles €)
    ## 1     ACCIONA  68,6000  -1,15  69,5000  68,4600 136.612           9.419,54
    ## 2    ACERINOX  11,1250  -0,13  11,2450  11,0750 581.911           6.486,83
    ## 3         ACS  35,7000   0,22  35,8600  35,5000 484.295          17.271,82
    ## 4        AENA 157,9000  -0,06 158,8000 157,2000 112.687          17.793,98
    ## 5     AMADEUS  71,8000   1,10  72,0000  71,3600 689.367          49.486,27
    ## 6 ARCELORMIT.  25,4600  -0,02  25,7400  25,3000 218.825           5.583,20
    ##        Fecha   Hora
    ## 1 13/07/2018 Cierre
    ## 2 13/07/2018 Cierre
    ## 3 13/07/2018 Cierre
    ## 4 13/07/2018 Cierre
    ## 5 13/07/2018 Cierre
    ## 6 13/07/2018 Cierre

Cuando tenemos muchas tablas y no sabemos cuál es la que queremos:

``` r
# Podemos ver cuáles son las dimensiones de las tablas 

ibex %>% html_nodes("table") %>%html_table(fill = TRUE) %>% lapply(dim)
```

    ## [[1]]
    ## [1]  46 351
    ## 
    ## [[2]]
    ## [1] 1 1
    ## 
    ## [[3]]
    ## [1] 1 7
    ## 
    ## [[4]]
    ## [1] 1 9
    ## 
    ## [[5]]
    ## [1] 35  9

``` r
# O los nombres de las columnas

# ibex %>% html_nodes("table") %>%html_table(fill = TRUE) %>% lapply(names)
```

### Navegación

``` r
sesion <- html_session('http://www.imdb.com')
```

``` r
sesion %>% jump_to('boxoffice')
```

    ## <session> https://www.imdb.com/chart/boxoffice
    ##   Status: 200
    ##   Type:   text/html;charset=UTF-8
    ##   Size:   110884

``` r
sesion %>% jump_to('boxoffice') %>% html_nodes('table')
```

    ## {xml_nodeset (2)}
    ## [1] <table class="chart full-width" data-caller-name="chart-boxoffice">\ ...
    ## [2] <table class="footer" id="amazon-affiliates">\n<tr>\n<td colspan="8" ...

Así me puedo ir moviendo por la página web desde R.

### html\_form (formularios)

``` r
# Mostrar los formularios de una página web

html_form(sesion)
```

    ## [[1]]
    ## <form> 'navbar-form' (GET /find)
    ##   <button submit> '<unnamed>
    ##   <input hidden> 'ref_': nv_sr_fn
    ##   <input text> 'q': 
    ##   <select> 's' [0/6]
    ## 
    ## [[2]]
    ## <form> 'ue_backdetect' (GET get)
    ##   <input hidden> 'ue_back': 1

Podemos desde aquí rellenar formularios (como si lo hiciéramos en el navegador):

``` r
# Lo relleno
busqueda <-html_form(sesion)[[1]] %>% set_values(`q` = "hunting", s="Titles") 
# En el formulario puedo meter texto (q) y si es título, actor... (s)

busqueda %>% submit_form(session=sesion) %>% html_nodes("table") %>% html_table() %>% .[[1]]
```

    ## Submitting with '<unnamed>'

    ##   X1                              X2
    ## 1 NA La cacería (1991) aka "Hunting"
    ## 2 NA                  Hunting (2015)
