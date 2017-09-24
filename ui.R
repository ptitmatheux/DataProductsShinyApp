#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Exploring NHANES data and predicting"),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            h3("Select data to explore"),
            selectInput(inputId="varx",
                        label="x variable (predictor)",
                        choices = list("Age", "Weight", "Height", "BMI"),
                        selected="Weight"),
            selectInput(inputId="vary",
                        label="y variable (predictor)",
                        choices = list("Age", "Weight", "Height", "BMI"),
                        selected="Height"),
            selectInput(inputId="varz",
                        label="z variable (response)",
                        choices = list("Gender", "MaritalStatus", "HHIncome")),
            actionButton(inputId="go1", label="go !"),
            
            h3("What about you?"),
            
            conditionalPanel(condition = "input.varx == 'Age' | input.vary == 'Age'",
                             numericInput(inputId="yourage",
                                          label="Your age:",
                                          min = 1,
                                          max = 120,
                                          value = NULL)
            ),
            conditionalPanel(condition = "input.varx == 'Height' | input.vary == 'Height'",
                             numericInput(inputId="yourheight",
                                          label="Your height in cm:",
                                          min = 1,
                                          max = 250,
                                          value = NULL)
                             ),
            conditionalPanel(condition = "input.varx == 'Weight' | input.vary == 'Weight'",
                             numericInput(inputId="yourweight",
                                          label="Your weight in kg:",
                                          min = 1,
                                          max = 250,
                                          value = NULL)
            ),
            conditionalPanel(condition = "input.varx == 'BMI' | input.vary == 'BMI'",
                             numericInput(inputId="yourbmi",
                                          label="Your Body Mass Index:",
                                          min = 1,
                                          max = 250,
                                          value = NULL)
            ),
            actionButton(inputId="go2", label="go !")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            includeMarkdown("explanation.Rmd"),
            plotlyOutput("Plot1"),
            plotlyOutput("Plot2"),
            textOutput("BMI")
        )
    )
))
