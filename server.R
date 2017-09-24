#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
options(shiny.sanitize.errors=FALSE)

library(shiny)
library(plotly)
library(dplyr)
library(NHANES)
library(rpart)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    #load("data/nhanes.Rdata")
    data(NHANES)
    DATA <- NHANES %>%
        select(Weight, Height, Gender, Age, HHIncome, HHIncomeMid, BMI, MaritalStatus) %>%
        filter(complete.cases(.))
    
    # Exploratory part:
    p <- eventReactive(input$go1, {
        
        outputplot <- plot_ly() %>%
            add_markers(x= ~as.vector(t(DATA[, isolate(input$varx)])),
                        y= ~as.vector(t(DATA[, isolate(input$vary)])),
                        color= ~as.vector(t(DATA[, isolate(input$varz)])),
                        alpha=0.7) %>%
            layout(xaxis=list(title=input$varx), yaxis=list(title=input$vary))
        return(list(outputplot))
        
    } )
    
    # Predicitive part:
    q <- eventReactive(input$go2, {
        
        age <- isolate(input$yourage)
        weight <- isolate(input$yourweight)
        height <- isolate(input$yourheight)
        bmi <- isolate(input$yourbmi)
        predictors <- c(age, weight, height, bmi)
        names(predictors) <- c("Age", "Weight", "Height", "BMI")
        predictors <- predictors[!is.na(predictors)]
        formula <- as.formula(paste0(isolate(input$varz), " ~ ", isolate(input$varx), " + ", isolate(input$vary)))
        fit <- rpart(formula, method="class", data=DATA)
        
        df <- data.frame(predictors[1], predictors[2])
        names(df)[1] <- names(predictors)[1]
        names(df)[2] <- names(predictors)[2]
        pred <- predict(fit, df, type="class")
        outputplot <- plot_ly() %>%
            add_markers(x= ~as.vector(t(DATA[, isolate(input$varx)])),
                        y= ~as.vector(t(DATA[, isolate(input$vary)])),
                        color= ~as.vector(t(DATA[, isolate(input$varz)])),
                        alpha=0.7) %>%
            add_markers(x= ~predictors[1], y= ~predictors[2], color=I("black"), symbol=I(15), name="you") %>%
            layout(xaxis=list(title=input$varx), yaxis=list(title=input$vary))
        
        return(list(outputplot, pred))
    } )
    
    
    output$Plot1 <- renderPlotly({
        p()[[1]]
    })
    
    output$Plot2 <- renderPlotly({
        q()[[1]]
    })
    
    output$BMI <- renderText({ 
        paste0("prediction for the response variable according to your input : ", q()[[2]])
    })
    
})
