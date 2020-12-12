
usersTabUI <- function(id){

  ns <- NS(id)


   fluidPage(
     h3("Manage Users"),
    DT::DTOutput(ns("usertable")),
    actionButton(ns("add_user"),"Add New User"),
    actionButton(ns("refresh"),"Refresh Screen"),
)
}


usersTab <- function(input,output,session,storedData)
  {
ns <- session$ns

#functions

shinyInput <- function(FUN, len, id,ns,...) {
  inputs <- character(len)
  for (i in seq_len(len)) {
    inputs[i] <- as.character(FUN(ns(paste0(id, i)), ...))
  }
  inputs
}




#outputs
output$usertable <- DT::renderDT(user_table_data(),server = FALSE, escape = FALSE, selection = 'none')


editUserModal <- function(session,selectedRow){
               ns <- session$ns
               modalDialog(textInput(ns("modalTextInput"), paste("Edit me", selectedRow) ),
                           actionButton(ns("closeModalBtn"), "Close Modal"))
               }
deleteUserModal <- function(session,selectedRow){
  ns <- session$ns
  modalDialog(textInput( ns("deleteInput"),paste("delete me", selectedRow) ),
              actionButton(ns("closeModalBtn"), "Close Modal"))
}


suspendUserModal <- function(session,selectedRow){
  ns <- session$ns
  modalDialog(textInput( ns("suspendInput"),paste("Suspend me", selectedRow) ),
              actionButton(ns("closeModalBtn"), "Close Modal"))
}





#reactive data


user_table_data <- reactive( {

                           ul<-ShinyPlatform::list_users(client_id = client_id,client_secret = client_secret,domain = domain,DEBUG = F)$users

                            nusers <- length(ul)

                            print(nusers)

                           data.frame(Name=  unlist(lapply(ul,function(x) x$nickname)),
                                      Email = unlist(lapply(ul,function(x) x$email)),
                                      Status = unlist(lapply(ul,function(x){ ifelse(is.null(x$blocked),"Active",'Suspended')})),

                                     Edit = shinyInput(actionButton, nusers, 'button_',ns, label = "Edit",
                                                         onclick = paste0('Shiny.onInputChange(\"',ns("edit_button"),'\",  this.id)' )),

                                     Delete = shinyInput(actionButton, nusers, 'button_',ns, label = "Delete",
                                                       onclick = paste0('Shiny.onInputChange(\"',ns("delete_button"),'\",  this.id)' )),

                                     Suspend = shinyInput(actionButton, nusers, 'button_',ns, label ="Change Status",
                                                         onclick = paste0('Shiny.onInputChange(\"',ns("suspend_button"),'\",  this.id)' )),

                           stringsAsFactors = FALSE,
                           row.names = 1:nusers
                           )

                           })

observeEvent(input$edit_button, {
  selectedRow <- as.numeric(strsplit(input$edit_button, "_")[[1]][2])
  showModal(editUserModal(session,selectedRow) )
  print(selectedRow)

})

observeEvent(input$delete_button, {
  selectedRow <- as.numeric(strsplit(input$delete_button, "_")[[1]][2])
  showModal(deleteUserModal(session,selectedRow) )
  print(selectedRow)

})

observeEvent(input$suspend_button, {
  selectedRow <- as.numeric(strsplit(input$suspend_button, "_")[[1]][2])
  showModal(suspendUserModal(session,selectedRow) )
  print(selectedRow)

})



#observeEvent(input$openModalBtn,
#             ignoreNULL = TRUE,   # Show modal on start up
#             showModal(userModal(session))
#)
}
