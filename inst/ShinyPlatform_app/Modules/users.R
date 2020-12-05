
usersTabUI <- function(id){

  ns <- NS(id)


   fluidPage(
     h3("users2"),
    DT::DTOutput(ns("usertable")),
    h3("users2")
   )

}


usersTab <- function(input,output,session,storedData)
  {
ns <- session$ns

#functions

shinyInput <- function(FUN, len, id, ...) {
  inputs <- character(len)
  for (i in seq_len(len)) {
    inputs[i] <- as.character(FUN(paste0(id, i), ...))
  }
  inputs
}




#outputs
output$usertable <- DT::renderDT(user_table_data(),server = FALSE, escape = FALSE, selection = 'none')



#reactive data


user_table_data <- reactive( {

                           ul<-ShinyPlatform::list_users(client_id = client_id,client_secret = client_secret,domain = domain,DEBUG = F)$users

                            nusers <- length(ul)
                           print(nusers)
                           data.frame(name=  unlist(lapply(ul,function(x) x$nickname)),
                                      email = unlist(lapply(ul,function(x) x$email)),
                                      Actions = shinyInput(actionButton, nusers, 'button_', label = "Fire",
                                                           onclick = 'Shiny.onInputChange(\"select_button\",  this.id)' ),

                           stringsAsFactors = FALSE,
                           row.names = 1:nusers
                           )

                           })

observeEvent(input$select_button, {
  selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
  myValue$employee <<- paste('click on ',df$data[selectedRow,1])
})



}
