#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)

shinyUI(
    fluidPage(
        titlePanel("FINAL PROJECT - Using NLP Techniques to predict next word."),
        sidebarLayout(
            sidebarPanel(
                helpText("Enter a word, text or a sentence to preview the next word prediction."),
                hr(),
                textInput("inputText", "Enter here : ",value = ""),
                hr(),
                helpText("1 - After the input given by the user, the prediction of the next word will be displayed.", 
                         hr(),
                         "2 - The next word will be displayed in the right (the text box)."),
                hr(),
                hr()
            ),
            mainPanel(
                h2("Here is our prediction for the next word."),
                verbatimTextOutput("prediction"),
                strong("Input given by the User :"),
                strong(code(textOutput('sentence1'))),
                br(),
                strong("How are we predicting it?"),
                strong(code(textOutput('sentence2'))),
                hr(),
                hr()
            )
        )
    )
)