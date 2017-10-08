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
                    
                    
                    selectInput("min_bedrooms",
                                label = "min number of bedrooms",
                                choices = c("Studio" = 0,
                                            "1b" = 1,
                                            "2b" = 2,
                                            "3b" = 3,
                                            "4b" = 4)
                    ),
                    selectInput("max_bedrooms",
                                label = "max number of bedrooms",
                                choices = c("Studio" = 0,
                                            "1b" = 1,
                                            "2b" = 2,
                                            "3b" = 3,
                                            "4b" = 4)
                    ),
                    selectInput("min_bath",
                                label = "Number of bathrooms",
                                choices = c("Studio" = 0,
                                            "1b" = 1,
                                            "2b" = 2,
                                            "3b" = 3,
                                            "4b" = 4)
                    ),
                    selectInput("max_bath",
                                label = "Number of bathrooms",
                                choices = c("Studio" = 0,
                                            "1b" = 1,
                                            "2b" = 2,
                                            "3b" = 3,
                                            "4b" = 4)
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
                    #checkboxInput("Crime", label = "Crime",value= FALSE),
                    #checkboxInput("Bus", label = "Bus",value= FALSE),
                    #checkboxInput("Subway",label="Subway",value = FALSE),
                    #checkboxInput("Market", label = "Market",value = FALSE),
                    #checkboxInput("Restaurant", label = "Restaurant",value= FALSE),
                    
                    selectInput("sortBy",
                                label = "sortBy",
                                choices = c("price(Low To High)" = "price_low_high",
                                            "price(High To Low)" = "price_high_low",
                                            "bedrooms" = "bedrooms",
                                            "restrooms" = "restrooms"
                                            )
                    ),
                    absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                  draggable = TRUE, top = "auto", left = "20", right = "auto", bottom = 60,
                                  width = 300, height = "auto",
                                  
                                  h5("current rank"),
                                  verbatimTextOutput("rank")
                    )
                              
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



