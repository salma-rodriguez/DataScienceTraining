library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Distribution of Rolling Two Dice"),
  
  # Sidebar with a slider input for the number of dice rolls
  sidebarLayout(
    sidebarPanel(
      sliderInput("trials",
                  "Number of rolls:",
                  min = 2,
                  max = 10000,
                  value = 5000),
      
      radioButtons("dist", "What is the distribution as the number of dice rolls approaches 10,000?",
                   c("Choose one" = "null",
                     "Normal" = "norm",
                     "Uniform" = "unif",
                     "Log-normal" = "lnorm",
                     "Exponential" = "exp")),
      submitButton(text = "Submit", icon = NULL),
      textOutput("distOkay_reactive")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))