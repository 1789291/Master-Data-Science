#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Waiting ~ Eruptions cambiando el tamaño de los puntos"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("size_points",
                     "Tamaño de los puntos:",
                     min = 1,
                     max = 20,
                     value = 3)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("scatter")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$scatter <- renderPlot({  # Esto me pasa a java las cosas de dentro, y hay distintos tipos de render_ para cada cosa.
      # generate bins based on input$bins from ui.R
     
     ggplot(faithful) + 
       aes(x=eruptions, y=waiting) + 
       geom_point(size = input$size_points)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

