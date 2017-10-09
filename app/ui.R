#install.packages('leaflet.extras')
#install.packages("shinythemes")
#install.packages("shinyWidgets")
#install.packages("htmltools")

library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library("shinythemes")
library(shinyWidgets)
#library(htmltools)
#"united"
#"sandstone"
shinyUI(
  
  navbarPage("Rent for campus students",theme=shinythemes::shinytheme("cerulean"),fluid=T,
            tags$head(includeCSS("styles.css")),
             #####################################1. Home##############################################           
             tabPanel("Home",
                      align="center",
                      br(),
                      br(),
                      br(),
                      br(),
                      br(),
                      
                      #h5("Find housing around campus" ),
                      br(),
                      h3("Find housing around campus" ),
                      br(),
                      h4("Gourp6- Fall 2017"),
                      br(),
                      #h4("")
                      
                      tags$head(
                        # Include our custom CSS
                        includeCSS("styles.css")
                        
                      )
                      
                      
             ),
             
  
             #######################################2. Maps#############################################           
             # tabPanel("Maps",
             #          
             #      sidebarLayout(
             #      sidebarPanel(
             #        top=60,
             #        
             #        textInput(inputId="place",label="", placeholder = "search your place..."),
             #        #actionButton("gobutton1","Enter"),
             #        verbatimTextOutput("test"),
             #        h4("Filters"),
             #                   ######Housing filter######
             #        # selectInput("university",
             #        #             label = "University",
             #        #             choices = c("Columbia",
             #        #                         "NYU",
             #        #                         "Fordham")
             #        #             
             #        # ),
             #        
             #        
             #        selectInput("manual_br",
             #                    label = "Number of bedrooms",
             #                    choices = c("Studio" = 0,
             #                                "1b" = 1,
             #                                "2b" = 2,
             #                                "3b" = 3,
             #                                "4b" = 4)
             #        ),
             #        
             #        sliderInput("manual_rent",
             #                    label = "Rent range",
             #                    min = 850,
             #                    max = 7900,
             #                    value = c(1200, 2000),
             #                    step = 100,
             #                    round = TRUE
             #          ),
             #      
             #                     ########Feature checkbox#######
             #        checkboxInput("Crime", label = "Crime",value= FALSE),
             #        checkboxInput("Bus", label = "Bus",value= FALSE),
             #        checkboxInput("Subway",label="Subway",value = FALSE),
             #        checkboxInput("Market", label = "Market",value = FALSE),
             #        checkboxInput("Restaurant", label = "Restaurant",value= FALSE)
             # 
             #                  
             #        ),#side bar panel
             #  
             #        ############main map#########
             #        mainPanel(
             #        leafletOutput("map", width = "100%", height = 650)
             #                 )
             #        
             #        )#sidebar layout
             #     ),#tabpanel
             ##################################2.2map###########################################
             tabPanel("Maps",
                    
                      fluidRow(
                       
                        column(width=3,style = "height:0px;width:330px;margin-top: 1px;display:inline-block;margin-right: 0px;",
                               textInput(inputId="location",label="", value="", placeholder = "search your location...")
                               ),
                         column(width=1,style = "margin-top: 25px;display:inline-block;margin-right: 0px;",
                                actionButton("button1",label="Search", icon = icon("search"),style="padding:12px; font-size:80%;color: #fff; background-color: #337ab7; border-color: #2e6da4")
                         ),
                        column(width=1,style = "margin-top: 25px;display:inline-block;margin-right: 10px;",
                               actionButton("button2",label="Clear search", style="padding:12px; font-size:80%;color: #fff; background-color: #337ab7; border-color: #2e6da4")
                        ),
                        column(width=1,style = "margin-top: 25px;display:inline-block",
                               dropdownButton(circle = FALSE,
                                              label="min price",  status = "primary",
                                 selectInput(inputId="min_price", label = "choose", choices = seq(0,10000,50))
                               )
                               ),
                        column(width=1,style = "margin-top: 25px;display:inline-block",
                               dropdownButton(circle = FALSE,
                                              label="max price",  status = "primary", 
                                              selectInput(inputId="max_price", label = "choose", choices = seq(0,20000,50))
                               )),
                        column(width=1, style="margin-top: 25px;display:inline-block;margin-right: 20px;",
                               dropdownButton(circle = FALSE,
                                              label = "Bathroom 1+", status = "primary", 
                                              checkboxGroupInput(inputId="check3", label="choose", choices = c("studio","1b","2b","3b","4b","5b","6b")
                                              ))
                                              ),
                        
                        column(width=1,style = "margin-top: 25px;;display:inline-block;margin-right: 20px;",
                               dropdownButton(circle = FALSE,
                                 label = "Bathroom 1+", status = "primary",
                                 checkboxGroupInput(inputId="check3", label="choose", choices = c("studio","1b","2b","3b","4b","5b","6b")
                                 )
                               )),
                        column(width=1, style = "margin-top: 25px;display:inline-block",
                               actionButton("button2",label="Clear choices" ,
                                            style="padding:12px; font-size:80%;color: #fff; background-color: #337ab7; border-color: #2e6da4"
                                            ))
                        ,
                        column(width=1,style = "margin-top: 25px;;display:inline-block;margin-right: 20px;",
                               dropdownButton(circle = FALSE,
                                              label = "Filters", status = "primary",
                                              checkboxGroupInput("filters", label = "choose", choices = c("Crime","Bus","Subway","Market","Restaurant"))
                                              )
                               )
                           ),
                       
                      # # checkboxInput("Crime", label = "Crime",value= FALSE),
                      # # checkboxInput("Bus", label = "Bus",value= FALSE),
                      # # checkboxInput("Subway",label="Subway",value = FALSE),
                      # # checkboxInput("Market", label = "Market",value = FALSE),
                      # # checkboxInput("Restaurant", label = "Restaurant",value= FALSE),
                      # checkboxInput("filters",label = "filters",value = FALSE,width=NULL),
                      mainPanel(
                                leafletOutput("map", width = "150%", height = 650)
                                )
                        
                      
                      
                      ),
               
             
             
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



