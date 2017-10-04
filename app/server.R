
  library(shiny)
  library(leaflet)
  library(data.table)
 # library(choroplethrZip)
  library(devtools)
  library(MASS)
  #library(vcd)
  #library(zipcode)
  library(dplyr)
  #install_github('arilamstein/choroplethrZip@v1.5.0')
  
  
  shinyServer(function(input, output) {
    
    
    #########main map######
    output$map <- renderLeaflet({
      leaflet() %>% 
        addProviderTiles('Stamen.TonerLite') %>% 
        setView(lng = -73.971035, lat = 40.775659, zoom = 12) 

    })
    
    #######for statistics#####
    
    output$plot=renderPlot({
      hist(islands)
    })
    

    
    
  })
