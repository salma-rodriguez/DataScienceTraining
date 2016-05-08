library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    x    <- ceiling(6 * runif(input$trials)) + ceiling(6 * runif(input$trials))
    hist(x, breaks = 1:12, col = 'darkgray', border = 'white', xlab = "Outcome")
  })
  
  dataInput <- reactive({
    if (input$dist == "norm")
      "Good job!"
    else
      "Wrong answer!"
  })
  
  output$distOkay_reactive <- renderText({dataInput()})
})