library(shiny)
library(leaflet)
library(data.table)
#library(choroplethrZip)
library(devtools)
library(MASS)
#library(vcd)
#library(zipcode)
library(dplyr)
library(tigris)
library(sp)
library(maptools)
library(broom)
library(httr)
library(rgdal)
library(RColorBrewer)

#install_github('arilamstein/choroplethrZip@v1.5.0')

#housing<- read.csv("../data/truliaRentPrice/housing_geo.csv",header=TRUE, stringsAsFactors =FALSE)
#housing<- subset(housing, !is.na(lng))
#save(housing, file="../output/housing.RData")
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
load("../output/housing.RData")  
load("../output/crimedata.RData")
#### data processing for crime data
r<-GET('http://catalog.civicdashboards.com/dataset/11fd957a-8885-42ef-aa49-5c879ec93fac/resource/28377e88-8a50-428f-807c-40ba1f09159b/download/nyc-zip-code-tabulation-areas-polygons.geojson')
nyc <- readOGR(content(r,'text'), 'OGRGeoJSON', verbose = F)
data<-crimedata
nyc@data$count = data$num_points
pal = colorBin(color[[1]], bins = bin[[1]])


shinyServer(function(input, output) {
  
  #Esri.WorldTopoMap
  #########main map######
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles('Esri.WorldTopoMap') %>%
      setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>%
      addMarkers(data=housing,
                 lng=~lng,
                 lat=~lat,
                 clusterOptions=markerClusterOptions(),
                 group="housing_cluster"
                 
                 
                 
      )
  })
  # show current status of icons:
  
  showStatus=reactive({
    if (is.null(input$map_bounds)){
      return("cloud")
      
    }
    else{
      if(input$map_zoom<16){
        return('cloud')
      }
      else{
        return('details')
      }
    }
  })
  # hide and show clouds 
  observe({
    if(showStatus()=="cloud"){
      
      leafletProxy("map") %>%showGroup("housing_cluster")%>%clearGroup("new_added")
    }
    else{
      leafletProxy("map") %>%hideGroup("housing_cluster")
      
    }
  })
  
  # show housing details when zoom to one specific level
  
  observe({
    if(showStatus()=="details"){
      leafletProxy("map")%>%clearGroup(group="new_added")%>% 
        addLabelOnlyMarkers(data=marksInBounds(),
                            lat=~lat,
                            lng=~lng,
                            label=~as.character(price),
                            group="new_added",
                            labelOptions = labelOptions(noHide = T,offset=c(20,-15),opacity=0.7)
                            
        )
      
    }
    
    
    
    
  })
  
  # get the housing data in the bounds
  marksInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(data[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(housing,
           lat>= latRng[1] & lat <= latRng[2] &
             lng >= lngRng[1] & lng <= lngRng[2])
    
  })
  
  ############Subway##############
  observeEvent(input$Subway,{
    p<-input$Subway
    proxy<-leafletProxy("map")
    
    if(p==TRUE){
      proxy %>% 
        addMarkers(data=sub.station, ~lng, ~lat,label = ~info,icon=icons(
          iconUrl = "../output/metro.png",
          iconWidth = 7, iconHeight = 7),group="subway")
    }
    else proxy%>%clearGroup(group="subway")
    
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
   ##############Crime#####################
    observeEvent(input$Crime,{
      p<-input$Crime
      proxy<-leafletProxy("map")
      
      if(p==TRUE){
        proxy %>% 
          addPolygons(data=nyc, fillColor = ~pal(count), color = 'grey', weight = 1,
                      fillOpacity = .6) 
      }
      else proxy%>%clearShapes()
      
    })
  
  ##############Market#####################
  observeEvent(input$Market,{
    p<- input$Market
    proxy<-leafletProxy("map")
    if(p==TRUE){
      proxy%>%
        addMarkers(lat=markets$latitude, lng=markets$longitude,label=markets$DBA.Name, icon=icons(
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
        addMarkers(lat=restaurant$lat, lng=restaurant$lon,label=restaurant$DBA,icon=icons(
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
