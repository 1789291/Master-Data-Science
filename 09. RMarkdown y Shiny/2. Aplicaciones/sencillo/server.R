# Definición de la parte server
shinyServer(function(input, output) {
  
  output$grafico <- renderPlot({
    ggplot(cars,aes(x=dist,y=speed))+
		geom_point(size=input$grosor,color=input$colorin,alpha=.3) +
		geom_smooth(method='lm')
  })
    
  output$histograma <- renderPlot({
    ggplot(cars,aes(x=dist))+
      geom_histogram(color= "white", fill = input$colorin )
    
    
    
    
    
    
  })

})
