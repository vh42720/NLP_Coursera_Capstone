suppressPackageStartupMessages(c(
    library(shinythemes),
    library(shiny),
    library(ngram),
    library(dplyr),
    library(readr),
    library(qdap),
    library(tm),
    library(stringr)))
source("./data/model.R")

shinyServer(function(input, output) {
    
    results <- reactive({pred(input$text)})
    
    output$sentence <- renderText({input$text})
    output$results <- renderTable({results()})
})