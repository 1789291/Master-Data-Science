# Definición de la parte server
shinyServer(function(input, output) {
  
  datos <- reactive({  # Aquí le hago algo a la tabla con el reactive (el subset en función de lo que me diga el usuario)
						subset(gapminder,continent==input$continent)						
					}) 
  
# Esto podría hacerlo en ambos gráficos ahora, una vez en cada uno. Lo bueno del reactive es que hago el filtro globalmente.
# Así gano velocidad.
  
# Siempre que el usuario hace algo con los datos (más alla de cambiar el color, etc...), como en este caso, tenemos que poner reactive
  
  output$evolucion <- renderPlot({ 
    isolate({color=input$color})  # Con esto lo que hago es que si cambia el color, el gráfico de arriba no va a cambiar
                                  # hasta que no cambie el continente
	ggplot(datos(),aes(x=year,y=lifeExp,group=country)) + 
		geom_line(stat="smooth",method="loess",alpha=.2,color=color)
	})
	
  output$bigotes <- renderPlot({ 
	fill=input$color
	ggplot(datos(),aes(x=factor(year),y=lifeExp)) + 
		geom_boxplot(fill=fill)
	}) 	
})
