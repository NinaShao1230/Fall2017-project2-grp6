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
                      h4("Gourp6- Fall 2017")
                      
                      
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
                                choices = c("columbia",
                                            "nyu",
                                            "fordham")
                                
                    ),
                    
                    
                    selectInput("manual_br",
                                label = "Number of bedrooms",
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
                    checkboxGroupInput("Crime", label = "Crime",
                                       choices = c("Crime"),
                                       selected = c("Crime")
                    ),
                    
                    
                    checkboxGroupInput("Transportation", label = "Transportation",
                                       choices = c("Subway","Bus"),
                                       selected = c("Subway","Bus")
                    ),
                    
                    
                    checkboxGroupInput("Market", label = "Market",
                                       choices = c("Market"),
                                       selected = c("Market")
                    ),
                    
                    
                    checkboxGroupInput("Entertainment", label = "Entertainment",
                                       choices = c("Market"),
                                       selected = c("Market")
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



