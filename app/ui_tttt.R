#install.packages('leaflet.extras')
#install.packages("shinythemes")

library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library("shinythemes")


shinyUI(
  
  navbarPage("Rent for campus students", theme=shinythemes::shinytheme("sandstone"),fluid=T,
             
             #####################################1. Home##############################################           
             tabPanel("Home",
                      align="center",
                      br(),
                      br(),
                      br(),
                      br(),
                      br(),
                      
                      h5("Find housing around campus" ),
                      br(),
                      h3("Find housing around campus" ),
                      br(),
                      h4("Gourp6- Fall 2017"),
                      
                      tags$head(
                        # Include our custom CSS
                        includeCSS("styles.css")
                        
                      )
                      
                      
             ),
  
             #######################################2. Maps#############################################           
             tabPanel("Maps",
                      
                  sidebarLayout(#position = "left",
                  sidebarPanel(
                    top=60,
                    
                    h4("Filters"),
                               ######Housing filter######
                    selectInput("university",
                                label = "University",
                                choices = c("Columbia",
                                            "NYU",
                                            "Fordham")
                                
                    ),
                    
                    
                    actionButton("manual_bedR",
                                label = "2 -3 beds"
                    ),
                    br(),
                    
                    tags$ul(id="ul_top_hypers",
                      tags$li(
                        
                                 tags$select(
                                   id="minBedrooms",
                                   tags$option(value="0","No min"),
                                   tags$option(value="1","1"),
                                   tags$option(value="2","2"),
                                   tags$option(value="3","3"),
                                   tags$option(value="4","4"),
                                   tags$option(value="5","5")
                                   
                                  )
                                 
                      ),
                      tags$li("-"),
                      
                      tags$li(
                        
                                 tags$select(
                                   id="maxBedrooms",
                                   tags$option(value="0","No min"),
                                   tags$option(value="1","1"),
                                   tags$option(value="2","2"),
                                   tags$option(value="3","3"),
                                   tags$option(value="4","4"),
                                   tags$option(value="5","5")
                                   
                                 )
                        
                      )
                    ),
                    
                    selectInput("manual_bathR",
                                label = "Number of bathrooms",
                                choices = c("Studio" = 0,
                                            "1+" = 1,
                                            "2+" = 2,
                                            "3+" = 3,
                                            "4+" = 4)
                    ), 
                    sliderInput("manual_rent",
                                label = "Rent range",
                                min = 850,
                                max = 7900,
                                value = c(1200, 2000),
                                step = 100,
                                round = TRUE
                      ),
                    
                  
                                 ########Feature checkbox#######
                    checkboxInput("Crime", label = "Crime",value= FALSE),
                    checkboxInput("Bus", label = "Bus",value= FALSE),
                    checkboxInput("Subway",label="Subway",value = FALSE),
                    checkboxInput("Market", label = "Market",value = FALSE),
                    checkboxInput("Restaurant", label = "Restaurant",value= FALSE)

                              
                    ),#side bar panel
              
                    ############main map#########
                    mainPanel(
                    leafletOutput("map", width = "100%", height = 650)
                             )
                    
                    )#sidebar layout
                 ),#tabpanel
             
               #######################################3. Statistics######################################## 
             tabPanel("Statistics",
                      
                                  tabsetPanel(
                                  tabPanel("plot1",
                                           plotOutput('plot')
                                  )
                                  )#tabset panel

                      )#tab panel
)#navbar page
)#ui



