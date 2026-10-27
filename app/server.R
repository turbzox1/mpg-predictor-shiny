library(shiny)

data(mtcars)
fit <- lm(mpg ~ wt + hp + am, data = mtcars)

shinyServer(function(input, output, session) {

  newCar <- reactive({
    data.frame(wt = input$wt, hp = input$hp, am = as.numeric(input$am))
  })

  pred <- reactive({
    predict(fit, newdata = newCar(), interval = "prediction")
  })

  similarCars <- reactive({
    # distance on scaled weight and horsepower, same transmission first
    d <- sqrt(((mtcars$wt - input$wt) / sd(mtcars$wt))^2 +
              ((mtcars$hp - input$hp) / sd(mtcars$hp))^2) +
         (mtcars$am != as.numeric(input$am))
    mtcars[order(d)[1:5], c("mpg", "wt", "hp", "am")]
  })

  output$prediction <- renderText({
    sprintf("Predicted fuel efficiency: %.1f MPG", pred()[1, "fit"])
  })

  output$interval <- renderText({
    sprintf("95%% prediction interval: %.1f to %.1f MPG",
            pred()[1, "lwr"], pred()[1, "upr"])
  })

  output$plot <- renderPlot({
    plot(mtcars$wt, mtcars$mpg, pch = 19, col = "grey60",
         xlab = "Weight (1000 lbs)", ylab = "Miles per gallon",
         main = "Your car compared with the 32 cars in mtcars",
         xlim = c(1.5, 5.5), ylim = c(5, 36))
    if (input$showSimilar) {
      s <- similarCars()
      points(s$wt, s$mpg, pch = 19, col = "firebrick", cex = 1.4)
    }
    points(input$wt, pred()[1, "fit"], pch = 19, col = "steelblue", cex = 2.5)
    legend("topright", bty = "n", pch = 19,
           col = c("grey60", "firebrick", "steelblue"),
           legend = c("mtcars", "Most similar cars", "Your car"))
  })

  output$similar <- renderTable({
    if (!input$showSimilar) return(NULL)
    s <- similarCars()
    data.frame(Car = rownames(s), MPG = s$mpg, Weight = s$wt,
               Horsepower = s$hp,
               Transmission = ifelse(s$am == 1, "Manual", "Automatic"))
  })
})
