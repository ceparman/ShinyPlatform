
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
    ),
    box(
      h3("App Profile"),
      textOutput(ns("appdata"))
    )

  )

)


}


debugTab <- function(input,output,session)
  {

#print(session$userData$auth0_credentials)



output$creds<- renderPrint({session$userData$auth0_credentials})

output$clientinfo<- renderPrint(session$userData$auth0_info)

output$userdata <- renderPrint( session$userData$profile)

output$appdata <- renderPrint( session$userData$client)

}

