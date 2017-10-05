#########################################################################################################load library
library("shiny")
library("shinydashboard")
library("highcharter")
library("dplyr")
library("viridisLite")
library("markdown")
library("quantmod")
library("tidyr")
library("treemap")
library("forecast")
library("DT")
library("shiny")
library("leaflet")
library("plotly")
library("wordcloud2")
library('scatterD3')

#########################################################################################################clear environment
rm(list = ls())

#########################################################################################################main page begin
dashboardPage(
  dashboardHeader(title = "Renting in Manhattan", disable = FALSE),
  dashboardSidebar(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search..."),
    # sidebarPanel(
    #   checkboxGroupInput("Cateogry", label = "Category",
    #                      choices = c("Crime", "Resteruant", "Super Market",
    #                                  "Subway", "Bus"),
    #                      selected = c("Crime", "Resteruant", "Super Market",
    #                                   "Subway", "Bus")
    #   )
    # ),
    sidebarMenu(
      #menuItem("Map", tabName = "map", icon = icon("map-marker")),
      menuItem("Transportation", tabName = "trans", icon = icon("subway")),
      menuItem("Crime",tabName = "crime", icon= icon("exclamation-triangle")),
      menuItem("Markets",tabName = "markets", icon = icon("shopping-cart")),
      menuItem("Restaurant", tabName = "restaurant", icon = icon("cutlery")),
      menuItem("University", tabName = "university", icon = icon("university")),
      menuItem("Entertainment",tabName = "entertainment", icon = icon("paper-plane-o")),
      menuItem("Recommendation System",tabName = "Recommendation System", icon = icon("thumbs-up")))
  ),
  dashboardBody(
    tags$head(tags$script(src = "js/ga.js")),
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "css/custom_fixs.css")),
    tabItems
    (
      
      ################################################################################################ transportation
      tabItem
      (
        tabName = "trans", 
        sidebarLayout(position = "right", 
                      sidebarPanel
                      (
                        checkboxGroupInput("Transportation Type", label = "Transportation Type",
                                           choices = c("Bus","Subway"),
                                           selected = c("Bus","Subway"))
                        ),
                        mainPanel(leafletOutput("map", width = "100%", height = 650))
      )),

      ################################################################################################  crime
      tabItem(tabName = "crime",
             sidebarLayout(position="right",
                           sidebarPanel=NULL,
                           mainPanel(leafletOutput("map", width = "100%", height = 650))
                           )),

      ################################################################################################   markets
      tabItem(tabName = "markets",
              sidebarLayout(position="right",
                            sidebarPanel=NULL,
                            mainPanel(leafletOutput("map", width = "100%", height = 650))
              )),

      ################################################################################################    restuarants
      tabItem(tabName = "restaurant",
              sidebarLayout(position="right",
                            sidebarPanel=NULL,
                            mainPanel(leafletOutput("map", width = "100%", height = 650))
                            )),

      ################################################################################################  university
      tabItem(tabName = "university",
              sidebarLayout(position="right",
                            sidebarPanel=NULL,
                            mainPanel(leafletOutput("map", width = "100%", height = 650))
                    )),
      ################################################################################################ entertainment
      tabItem(tabName = "entertainment",
              sidebarLayout(position="right",
                            sidebarPanel=NULL,
                            mainPanel(leafletOutput("map", width = "100%", height = 650))
                            )),
      ###############################################################################################recommendation system
      tabItem(tabName = "Recommendation System",
              sidebarLayout(position="right",
                            sidebarPanel=NULL,
                            mainPanel(leafletOutput("map", width = "100%", height = 650))
                            ))
              )
    )
 )