
debugTabUI <- function(id){

  ns <- NS(id)
 fluidPage(

  fluidRow(
    box(
      h3("auth credentials"),
      verbatimTextOutput(ns("creds"))
    ),

    box(
      h3("Client Info"),
      textOutput(ns("clientinfo"))
    ),
    box(
      h3("User Profile"),
      textOutput(ns("userdata"))
    )

  )

)


}


debugTab <- function(input,output,session)
  {

print(session$userData$auth0_credentials)



output$creds<- renderPrint(print(session$userData$auth0_credentials))

output$clientinfo<- renderPrint(print(session$userData$client))

output$userdata <- renderPrint( print(session$userData$profile))



}

