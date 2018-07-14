# Definción del UI
shinyUI(fluidPage(
  
	# Titulo
	titlePanel("Una regresión"),
  
	sidebarLayout(
	# Barra lateral
		sidebarPanel(
		  sliderInput("grosor","Tamaño de los puntos:",min = 0,max = 20,value = 10,step=2),
		  selectInput('colorin', 'Color de los puntos', choices = c('Rojo' = 'red3', 'Azul' = 'blue3', 'Naranja' = 'orange3'), selected = 'blue3')
		),
    
	# Muestra el grafico en el panel principal
		mainPanel(
			plotOutput("grafico"),
			plotOutput('histograma')
		)
  )
))
