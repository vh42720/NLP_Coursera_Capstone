suppressPackageStartupMessages(c(
    library(shinythemes),
    library(shiny),
    library(ngram),
    library(dplyr),
    library(readr),
    library(qdap),
    library(tm),
    library(stringr)))


shinyUI(fluidPage(
    theme = shinytheme("cerulean"),
    titlePanel("Word Predictor"),
    h4("Author: Vinh Hang"),
    hr(),
    
    ##Information
    sidebarLayout(
        sidebarPanel(
            h3(textInput("text", label = h3("Your input:"), value = "Welcome", width = 800), align="left"),
            submitButton("enter"),
            p(""),
            p("Type a sentence and hit enter. The algorithm will guess your next word."),
            p("You can see list of top 10 possibilities."),
            p("The algorithm use n-gram model, with quadgrams dictionary from a dataset of Twitter, news articles, 
               and blog posts. It uses Katz back-off to smooth predictions."),
            p("This is the model with the highest accuracy. However, this conscious choice makes the model slower to execute."),
            p("Other implementation with much faster prediction time can be found at link below."),
            a(href="", "All the code to create this app.")
        ),
        mainPanel(
            flowLayout(
                h4(textOutput("sentence"), align="left"),
                div(tableOutput("results"), align="right")
            )
        )
    )
))