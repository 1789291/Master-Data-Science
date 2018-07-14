# Ejercicio GDP

library(shiny)

# Definimos Server
shinyServer(function(input, output) {
   
  # 
  datos <- reactive({ 
    df_sin_kuw %>% filter(year == input$year)
  }) 
  

  output$grafico_scatter <- renderPlot({
    
    
    ggplot(datos()) + 
      aes(x = gdpPercap, y = lifeExp, size = pop, color = continent) + 
      geom_text(x = 35000, y = 42.5, label = as.character(input$year), size = 20, alpha = .1, color = 'grey60') +
      geom_point() + 
      scale_y_continuous(limits = c(20, 85)) + scale_x_continuous(limits = c(300, 50000)) + 
      ggtitle("Relación entre GDP per cápita y Esperanza de vida") + 
      labs(x = "GDP per cápita", y = "Esperanza de vida", color = "Continente", size = "Población") + 
      guides(size=FALSE) + 
      theme_minimal()
    
  })
  
})

