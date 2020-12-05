
debugTabUI <- function(id){

  ns <- NS(id)
 fluidPage(

  fluidRow(
    box(
      h3("Params"),
      textOutput(ns("params"))
    ),

    box(
      h3("Logout URL"),
      textOutput(ns("logouturl"))
    ),
    box(
      h3("user Data"),
      textOutput(ns("userdata"))
    )

  )

)


}


debugTab <- function(input,output,session,storedData)
  {



output$params <- renderPrint(print(storedData$params))

output$logouturl <- renderPrint(print(storedData$logouturl))

output$userdata <- renderPrint( print(storedData$user))


}

