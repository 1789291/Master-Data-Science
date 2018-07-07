# Definición del UI
shinyUI(fluidPage(
  
	# Titulo
	titlePanel("Una regresión"),


	# Diseño de la interfaz
	fluidRow(  # Cada vez que defino un fluidRow tengo una fila con 12 divisiones
		column(2,  # Asigno 2 divisiones a esto
			selectInput("regresor",h4("Elegir variable de regresión:"),choices=names(mtcars)[2:5],selected="hp")  # h4 me define el tamaño de los caracteres
			),
		column(6,  # Y 6 a esto
			textInput("titulo",h4("Titulo del gráfico:"),value = "Regresión") 	  
			),
		column(4,		
			sliderInput("grossor",h4("Tamaño de los puntos:"), min = 1,max = 20,value = 2,step=1) 	  
			)
		),
	fluidRow( 	
		hr(), #linea horizontal
		br(), #salto de linea
		column(8,offset = 2,align="center",plotOutput("grafico"))  # El offset es como una sangría
		),
	fluidRow( 	
		br(),
		br(),
		column(12,offset = 10,img(src="kschool.png",width=100))  # Insertamos una imagen. Tiene que estar en una carpeta "www"
		)	
		
) )


########### Ejercicio
# organizar verticalmente los widgets con la función sidebarPanel
# Añadir en la interfaz un histograma de la distribución del consumo de los coches