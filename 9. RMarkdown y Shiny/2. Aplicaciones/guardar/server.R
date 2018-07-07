# Definición de la parte server
shinyServer(function(input, output) {
  
    #Datos para cálculo tendencia por provincia
	datos<-reactive({ 
		trimestres=input$trimestre
		if(trimestres=="Todos") trimestres=c("I","II","III","IV")
		subset(paro,Sexo==input$sexo & Trimestre %in% trimestres)	
	})	
  
	output$tendencia <- renderPlot({ evolucion(datos(),input$alpha/100) })
	
	output$datos <-  renderDataTable(datos(),options = list(pageLength = 10))	
	
	output$guardarTendencia <- downloadHandler(  # Función para guardar
		filename = function() { paste0("tendencia",Sys.Date(), '.pdf') },  # Le doy como nombre tendencia + fecha + pdf
		content = function(file) {  # Defino una función para guardar
			p<-evolucion(datos(),input$alpha/100)
			ggsave(file,p,width=12,height=8)
		})		
		
	output$guardarTabla <- downloadHandler(  # Misma idea
    filename = function() { paste0("datos_paro", '.csv') },
    content = function(file) {
			write_excel_csv(datos(),file)
		})	
  			
})
