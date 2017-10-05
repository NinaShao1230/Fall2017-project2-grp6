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
  dashboardHeader(title = "Renting in Manhattan",disable=FALSE),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map-marker")),
      menuItem("Transportation", tabName = "trans", icon = icon("subway")),
      menuItem("Crime",tabName = "crime", icon= icon("exclamation-triangle")),
      menuItem("Markets",tabName = "markets", icon = icon("shopping-cart")),
      menuItem("Restaurant", tabName = "restaurant", icon = icon("cutlery")),
      menuItem("University", tabName = "university", icon = icon("university")),
      menuItem("Entertainment",tabName = "entertainment", icon = icon("paper-plane-o"))
    ),
  dashboardBody(
    
  )
)




dashboardPage(
  dashboardHeader(title = "Renting in Manhattan",disable=FALSE),
  dashboardSidebar(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search..."),
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map-marker")),
      menuItem("Transportation", tabName = "trans", icon = icon("subway")),
      menuItem("Crime",tabName = "crime", icon= icon("exclamation-triangle")),
      menuItem("Markets",tabName = "markets", icon = icon("shopping-cart")),
      menuItem("Restaurant", tabName = "restaurant", icon = icon("cutlery")),
      menuItem("University", tabName = "university", icon = icon("university")),
      menuItem("Entertainment",tabName = "entertainment", icon = icon("paper-plane-o"))
    ),
    dashboardBody(
    )
  )
  
  
  
  tabName = "trans", 
  sidebarLayout(position = "right", 
                sidebarPanel(
                  checkboxGroupInput("Transportation_Type", label = "Transportation_Type",
                                     choices = c("Bus","Subway"),
                                     selected = c("Bus","Subway")),
                  mainPanel(
                    leafletOutput("map", width = "100%", height = 650)