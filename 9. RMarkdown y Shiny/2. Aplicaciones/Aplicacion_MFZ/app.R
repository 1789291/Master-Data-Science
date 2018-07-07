#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(  # Esto es una función que dentro tiene las cosas relativas a UI
   
   # Application title
     titlePanel("Datos de géiseres"),  # Título
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(  # Barra lateral. Siempre contiene sidebarPanel y mainPanel
      sidebarPanel(  # Panel de la barra lateral
         sliderInput("barras",  # Etiqueta
                     "Número de barras:",  # Nombre que aparece en pantalla
                     min = 1,  # Rangos del slider
                     max = 50,
                     value = 20)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(  # Tenemos un panel principal
         plotOutput("grafico")  # Etiqueta 
      )
   )
)

# Hasta aquí lo único que he definido es el "estilo", la "distribución" o interfaz. Sólo los he declarado.
# Ahora diré qué voy a hacer con ello -> en el Server



# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$grafico <- renderPlot({  # Le doy un nombre al histograma que estoy generando -> el mismo que la etiqueta de la UI. Así los asocio.
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      barras <- seq(min(x), max(x), length.out = input$barras + 1)  # Defino los límites de los bins (que estará en base al input)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = barras, col = 'darkgray', border = 'white',main = "Histograma de los géiseres")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

