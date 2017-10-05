library(shiny)
library(leaflet)
library(data.table)
#library(choroplethrZip)
library(devtools)
library(MASS)
#library(vcd)
#library(zipcode)
library(dplyr)
#install_github('arilamstein/choroplethrZip@v1.5.0')

  
#markets<- read.csv("../data/markets.csv",header=TRUE, stringsAsFactors =FALSE)
#markets<- subset(markets, !is.na(longitude))
#markets<- markets[(markets$Square.Footage>=1500)&(markets$City=="NEW YORK"), ]
#save(markets, file="../output/markets.RData")
#restaurant=read.csv("../data/restaurant_data.csv",header=TRUE, stringsAsFactors =FALSE)
#save(restaurant, file="../output/restaurant.RData")
load("../output/markets.RData")
load("../output/restaurant.RData")
load("../output/sub.station.RData")
load("../output/bus.stop.RData")
  
shinyServer(function(input, output) {

  #Esri.WorldTopoMap
    #########main map######
    output$map <- renderLeaflet({
      leaflet() %>%
        addProviderTiles('Esri.WorldTopoMap') %>%
        setView(lng = -73.971035, lat = 40.775659, zoom = 12) 
    })
  
  ############Subway##############
    observeEvent(input$Subway,{
      p<-input$Subway
      proxy<-leafletProxy("map")
      
      if(p==TRUE){
          proxy %>% 
          addMarkers(data=sub.station, ~lng, ~lat,label = ~info,icon=icons(
            iconUrl = "../output/metro.png",
            iconWidth = 7, iconHeight = 7),layerId=as.character(sub.station$info))
        }
      else proxy%>%removeMarker(layerId=as.character(sub.station$info))
        
    })
  
  ###############bus###############
    observeEvent(input$Bus,{
      p<-input$Bus
      proxy<-leafletProxy("map")
      
      if(p==TRUE){
        proxy %>% 
          addMarkers(data=bus.stop, ~lng, ~lat,label = ~info,icon=icons(
            iconUrl = "../output/bus.png",
            iconWidth = 7, iconHeight = 7),layerId=as.character(bus.stop$info))
      }
      else proxy%>%removeMarker(layerId=as.character(bus.stop$info))
        
    })
  
  
  ##############Market#####################
    observeEvent(input$Market,{
      p<- input$Market
      proxy<-leafletProxy("map")
      if(p==TRUE){
        proxy%>%
         addMarkers(lat=markets$latitude, lng=markets$longitude,icon=icons(
            iconUrl = "../output/icons8-Shopping Cart-48.png",
            iconWidth = 7, iconHeight = 7, shadowWidth = 7, shadowHeight = 7),layerId=as.character(markets$License.Number))
      }
      else{
        proxy %>%
          removeMarker(layerId=as.character(markets$License.Number))
      }
    })

  ##############Resturant#####################
    observeEvent(input$Restaurant,{
      p<- input$Restaurant
      proxy<-leafletProxy("map")
      if(p==TRUE){
        proxy%>%
          addMarkers(lat=restaurant$lat, lng=restaurant$lon,icon=icons(
            iconUrl = "../output/icons8-French Fries-96.png",
            iconWidth = 7, iconHeight = 7, shadowWidth = 7, shadowHeight = 7),layerId=as.character(restaurant$CAMIS))
      }
      else{
        proxy %>%
          removeMarker(layerId=as.character(restaurant$CAMIS))
      }
    })
    

    
    #######for statistics#####
    
    output$plot=renderPlot({
      hist(islands)
    })
    

    
    
})
