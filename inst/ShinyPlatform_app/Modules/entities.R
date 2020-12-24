

entitiesTabUI <- function(id){

  ns <- NS(id)


   fluidPage(
     h3("Manage Entities"),
     fluidRow(
       tabBox(
         id = "tabset1", height = "250px",
         tabPanel("Configured Entities",

                  "Existing Entites",
                  DT::DTOutput(ns("existing_entities"))

                  ),


         tabPanel("Edit Entities", "Edit Entity"),



         tabPanel("Add Entitiy",
                  "Add Entity",
                  textInput(ns("e_name"),"Name"),
                  selectInput(ns("e_table"),"Table",choices =  paste0(lims_types,"db")),
                  textInput(ns("e_type"),"Type"),
                  textInput(ns("e_bcprefix"),"Bar Code Prefix"),
                  actionButton(ns("insertBtn"), "Add Attribute"),
                  actionButton(ns('removeBtn'), 'Remove Selected Attribute'),
                  actionButton(ns('e_create'), 'Create Entity'),
                  actionButton(ns("all_reset"),"Reset All Fields"),
                  tags$div(id = 'fields')
     )

   )
   )
   )

}


entitiesTab <- function(input,output,session,storedData)
{

ns <- session$ns

inserted <- c()

Shiny.setInputValue(\"select_button\", this.id, {priority: \"event\"})

#Existing Entities Tab

configuted_entities <- reactiveVal({

                         entities <- list_meta_data_documents(dbname,session$userData$db$creds ,
                                               dbscheme,dbinstance)[,c("name","table","type")]
                 n_entities <- nrow(entities)

                 entities$Edit = shinyInputModules(actionButton, n_entities, 'button_',ns, label = "Edit",
                                               onclick = paste0('Shiny.onInputChange(\"',ns("edit_button"),'\",  this.id)' ))

                 entities$Delete = shinyInputModules(actionButton, n_entities, 'button_',ns, label = "Delete",
                                                 onclick = paste0('Shiny.onInputChange(\"',ns("delete_button"),'\",  this.id)' ))

                   entities
                     }

  )

deleteUserModal <- function(session,entity_name){
  ns <- session$ns
  modalDialog(paste("Do you wantp to delete enitity" ,entity_name,"?"),
         actionButton(ns("deleteEntityBtn"), "Delete"))
}

observeEvent(input$delete_button, {
  selectedRow <- as.numeric(strsplit(input$delete_button, "_")[[1]][2])
  entity_name <- list_meta_data_documents(dbname,session$userData$db$creds ,
                           dbscheme,dbinstance)$name[selectedRow]

  showModal(deleteUserModal(session, entity_name))
  print(selectedRow)

})

observeEvent(input$deleteEntityBtn,{

  selectedRow <- as.numeric(strsplit(input$delete_button, "_")[[1]][2])
  entity_name <- list_meta_data_documents(dbname,session$userData$db$creds ,
                                          dbscheme,dbinstance)$name[selectedRow]
  print(entity_name)

  #Remove entry
  remove_meta_data_document(database,session$userData$db$creds,
                            dbscheme,dbinstance,entity_name)


  #update configured entities

  entities <- list_meta_data_documents(dbname,session$userData$db$creds ,
                                       dbscheme,dbinstance)[,c("name","table","type")]
  n_entities <- nrow(entities)

  entities$Edit = shinyInputModules(actionButton, n_entities, 'button_',ns, label = "Edit",
                                    onclick = paste0('Shiny.onInputChange(\"',ns("edit_button"),'\",  this.id)' ))

  entities$Delete = shinyInputModules(actionButton, n_entities, 'button_',ns, label = "Delete",
                                      onclick = paste0('Shiny.onInputChange(\"',ns("delete_button"),'\",  this.id)' ))

  configuted_entities( entities)



  #remove modal
  removeModal()
})


output$existing_entities <- DT::renderDT(configuted_entities() ,
                            server = FALSE, escape = FALSE, selection = 'none'
                                 )



#Add Entity

##Insert Attribute

observeEvent(input$insertBtn, {
  btn <- input$insertBtn
  id <- btn

  insertUI(
    selector = '#fields',
    ## wrap element in a div with id for ease of removal
    ui = tags$div(
      fluidPage(
        fluidRow(
          column(2,
                 checkboxInput(ns(paste0("field_remove_", btn)),label = "Remove")
          ),
          column(2,
                 textInput(ns(paste0("fieldname_", btn)), label= "Name",
                           placeholder="Must be unique")
          ),
          column(2,
                 selectInput(ns(paste0("fieldtype_", btn)),label = "Type",choices = data_types)
          ),

          column(4,
                 textAreaInput(ns(paste0("fieldvocab_", btn)),label = "Controlled Vocabulary",
                               placeholder="Enter comma separated values, string types only")
          ), column(1,
                    checkboxInput(ns(paste0("fieldreq_", btn)),label = "Required",value = T)
          )
        )
      ),
      id = id
    )
  )
  inserted <<- c(inserted,id)

})

##Remove Selected Attribute



observeEvent(input$removeBtn, {
  #find rows with remove selected


  removes <-  paste0("field_remove_",inserted)

  if(DEBUG) print(removes)



  for(row in inserted) {


    if( input[[paste0("field_remove_",row)]]){
      if(DEBUG)  print(paste("removing ", row))

      removeUI(
        ## pass in appropriate div id
        # selector = paste0('#', inserted[length(inserted)])
        selector = paste0('#',row)

      )
      inserted <<- inserted[-which(inserted == row)]

    }

  }

})


##Remove selected Rows
observeEvent(input$removeBtn, {
  #find rows with remove selected


  removes <-  paste0("field_remove_",inserted)

  if(DEBUG) print(removes)



  for(row in inserted) {


    if( input[[paste0("field_remove_",row)]]){
      if(DEBUG)  print(paste("removing ", row))

      removeUI(
        ## pass in appropriate div id
        # selector = paste0('#', inserted[length(inserted)])
        selector = paste0('#',row)

      )
      inserted <<- inserted[-which(inserted == row)]

    }

  }

})



##Remove all attributes

for(row in inserted) {

  removeUI(
    ## pass in appropriate div id
    # selector = paste0('#', inserted[length(inserted)])
    selector = paste0('#',row)
  )

}


##Reset
observeEvent(input$all_reset, {
  #reset text values
  reset("e_name")
  reset("e_table")
  reset("e_type")
  reset("e_bcprefix")

  for(row in inserted) {

    removeUI(
      ## pass in appropriate div id
      # selector = paste0('#', inserted[length(inserted)])
      selector = paste0('#',row)
    )

  }


})


##Create new Entity in db

observeEvent(input$e_create,{

#Validate entry
  #Are all fields filled in?

  #Does the name exist

  existing_entries <- list_meta_data_documents(dbname, session$userData$db$creds,dbscheme,dbinstance)


  if(input$e_name == "" ) {

    showModal(modalDialog(h3("Entity Name Required"),title = "Error"))

  }

  if(input$e_name %in%  existing_entries$name ) {

    showModal(modalDialog(h3("Entity Name Already Exixts"),title = "Error"))

  }

  #Does the BC prefix exist

  if(input$e_bcprefix == "" ) {

    showModal(modalDialog(h3("Bar Code Prefix Required"),title = "Error"))

  }


  if(input$e_bcprefix %in%  existing_entries$bcprefix ) {

    showModal(modalDialog(h3("Entity Bar Code Prefix Already Exixts"),title = "Error"))

  }


  #Do all fileds have different names

  #Create fields json object
if(!is.null(inserted)){

   fields <- list()

   for(i in 1:length(inserted)){

   field <- list(

                name = input[[ paste0("fieldname_", inserted[i]) ]],
                fieldtype=  input[[ paste0("fieldtype_",inserted[i]) ]],
                fieldreq =  input[[ paste0("fieldreq_",inserted[i]) ]] ,
                controled_vocab =  input[[ paste0("fieldvocab_",inserted[i]) ]]
              )

           fields[[ paste0("field",i)]] <-  field

   }




} else fields <- ""



  #insert


fieldList <- toJSON(fields,auto_unbox = T)


result  <- create_metadb_entry(session$userData$db$metadb ,input$e_name,input$e_table,input$e_type,fieldList,input$e_bcprefix)


configuted_entities(
  list_meta_data_documents(dbname,session$userData$db$creds ,
                           dbscheme,dbinstance)[,c("name","table","type")])


})




}





