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

#housing<- read.csv("../data/truliaRentPrice/housing_geo.csv",header=TRUE, stringsAsFactors =FALSE)
#housing<- subset(housing, !is.na(lng))
#price=gsub(",","",housing$price)
#price=as.numeric(price)
#housing$price=price
#housing=housing[!is.na(housing$price),]
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

shinyServer(function(input, output) {

  #Esri.WorldTopoMap
    #########main map######
    output$map <- renderLeaflet({
      leaflet() %>%
        addProviderTiles('Esri.WorldTopoMap') %>%
        setView(lng = -73.971035, lat = 40.775659, zoom = 12)
     
    })
    
    ############# housing #############
    
    # filter housing data:
    
    housingFilter=reactive({
      bedroom_filter=housing$bedrooms>=input$min_bedrooms & housing$bedrooms<=input$max_bedrooms 
      bathroom_filter=housing$bathrooms>=input$min_bath & housing$bathrooms<=input$max_bath
      price_filter=housing$price>=input$manual_rent[1] & housing$price<=input$manual_rent[2]
      filter=bedroom_filter & bathroom_filter & price_filter
      return(housing[filter,])
    })
    
    # show data in the map:
    observe({leafletProxy("map")%>%
    addMarkers(data=housingFilter(),
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
        if(nrow(marksInBounds())!=0){
          leafletProxy("map")%>%clearGroup(group="new_added")%>% 
            addLabelOnlyMarkers(data=marksInBounds(),
                                lat=~lat,
                                lng=~lng,
                                label=~as.character(price),
                                group="new_added",
                                labelOptions = labelOptions(
                                                noHide = T,
                                                offset=c(20,-15),
                                                opacity=0.7,
                                                style=list(
                                                  background="green",
                                                  color="white"  
                                                  )
                                                )
                                )
        }
        else{
          leafletProxy("map")%>%clearGroup(group="new_added")
        }
        
        
                                          
        
      }
      
      
      
      
    })
    
    # get the housing data in the bounds
    marksInBounds <- reactive({
      if (is.null(input$map_bounds))
        return(housing[FALSE,])
      bounds <- input$map_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      return(
        subset(housingFilter(),
          lat>= latRng[1] & lat <= latRng[2] &
          lng >= lngRng[1] & lng <= lngRng[2])
      )
    })
    
    # sort housing in current zoom level
    
    observe({
      sortBy=input$sortBy
      housing_filtered=marksInBounds()
      if(nrow(housing_filtered)==0){
       housing_top10=housing_filtered 
      }
      else if(sortBy=="price_low_high"){
        housing_top10=housing_filtered[order(housing_filtered$price),]
      }
      else if(sortBy=="price_high_low"){
        housing_top10=housing_filtered[order(housing_filtered$price,decreasing = TRUE),]
      }
      
      else if(sortBy=="bedrooms"){
        housing_top10=housing_filtered[order(housing_filtered$bedrooms,decreasing = TRUE),]
      }
      else if(sortBy=="restrooms"){
        housing_top10=housing_filtered[order(housing_filtered$bathrooms,decreasing = TRUE),]
      }
      
      if(nrow(housing_top10)!=0){
        show_num=ifelse(nrow(housing_top10)>10,10,nrow(housing_top10))
        top10info=apply(housing_top10[1:show_num,],1,function(r){
        
        paste0("address:",r["addr"],
               "price:",r["price"],
               " bedrooms:",r["bedrooms"],
               " bathrooms:",r["bathrooms"],"\n")  
         
         
        }
       )
        output$rank=renderText(paste(top10info,collapse = ""))
        
      }
      else{
        output$rank=renderText('')
      }
      
     
      
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
            iconWidth = 7, iconHeight = 7),group="bus")
      }
      else proxy%>%clearGroup("bus")
        
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
