library(shiny)

shinyUI(fluidPage(
  titlePanel("MPG Predictor: How Efficient Would Your Car Be?"),
  sidebarLayout(
    sidebarPanel(
      h4("Describe the car"),
      sliderInput("wt", "Weight (1000 lbs):", min = 1.5, max = 5.5, value = 3.2, step = 0.1),
      sliderInput("hp", "Horsepower:", min = 50, max = 335, value = 150, step = 5),
      radioButtons("am", "Transmission:", choices = c("Automatic" = 0, "Manual" = 1), selected = 0),
      checkboxInput("showSimilar", "Highlight the 5 most similar real cars", value = TRUE),
      helpText("Move the sliders and the prediction updates instantly.")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction",
          br(),
          h3(textOutput("prediction")),
          textOutput("interval"),
          br(),
          plotOutput("plot", height = "350px"),
          tableOutput("similar")
        ),
        tabPanel("How to use",
          br(),
          h4("What this app does"),
          p("It estimates a car's fuel efficiency in miles per gallon (MPG) from three simple facts:
             its weight, its horsepower and whether it has a manual or automatic gearbox."),
          h4("Getting started"),
          tags$ol(
            tags$li("Use the ", strong("Weight"), " slider to set the car's weight in thousands of pounds (a typical sedan is around 3.0 to 3.5)."),
            tags$li("Use the ", strong("Horsepower"), " slider to set engine power."),
            tags$li("Pick ", strong("Automatic"), " or ", strong("Manual"), " transmission."),
            tags$li("Read the predicted MPG and its 95% prediction interval at the top of the Prediction tab."),
            tags$li("Tick the checkbox to see which real cars from the data are closest to yours, both in the table and as red points on the plot.")
          ),
          h4("How the prediction works"),
          p("Behind the scenes the app fits a linear regression on R's built-in ", code("mtcars"),
            " dataset (32 cars from 1974 Motor Trend magazine): ", code("mpg ~ wt + hp + am"),
            ". Every time you move an input, the server plugs your values into this model and
             returns the predicted MPG. The plot shows all 32 cars, weight against MPG, with
             your car as a large blue point."),
          h4("Things to keep in mind"),
          p("The data is from the 1970s, so modern cars will be more efficient than the app suggests.
             Treat the numbers as a way to see how weight, power and gearbox trade off against each other,
             not as an exact figure for a real car.")
        )
      )
    )
  )
))
