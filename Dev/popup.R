library(shiny)
library(shinyalert)

ui <- fluidPage(
  useShinyalert(),
  textOutput("curName"),
  br(),
  textInput("newName", "Name of variable:", "myname"),
  br(),
  actionButton("BUTnew", "Change")
)
server = function(input, output, session) {
  values <- reactiveValues()
  values$name <- "myname"

  output$curName <- renderText({
    paste0("Current name: ", values$name)
  })

  observeEvent(input$BUTnew, {
    shinyalert("Change name", "Do you want to change the name?",
               confirmButtonText = "Yes", showCancelButton = TRUE,
               cancelButtonText = "No", callbackR = modalCallback)
  })

  modalCallback <- function(value) {
    if (value == TRUE) {
      values$name <- input$newName
    } else {
      updateTextInput(session, "newName", value=values$name)
    }
  }
}
runApp(list(ui = ui, server = server))

