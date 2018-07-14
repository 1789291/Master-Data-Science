# Ejercicio GDP

library(shiny)

# Definimos UI
shinyUI(fluidPage(
  
  # Título
  titlePanel("Evolución del GDP con la LifeExp"),
  
  # Definimos la barra
  sidebarLayout(
    sidebarPanel(
       sliderInput("year",
                   "Año:",
                   min = 1952,
                   max = 2007,
                   value = 1952,
                   step = 5,  # Queremos valores discretos
                   sep = "", # Para que el año no salga 1,952, sino 1952
                   animate = TRUE)  # Para el botón de play
    ),
    
    # Gráfico
    mainPanel(
       plotOutput("grafico_scatter")
    )
  )
))
