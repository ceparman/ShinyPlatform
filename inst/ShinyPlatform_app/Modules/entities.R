

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
                  textInput(ns("e_table"),"Table"),
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

#Existing Entities Tab

configuted_entities <- reactiveVal(
                      list_meta_data_documents(dbname,session$userData$db$creds ,
                                               dbscheme,dbinstance)[,c("name","table","type")]

                      )

output$existing_entities <- DT::renderDT(DT::datatable(configuted_entities()))


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
                 textAreaInput(ns(paste0("filed_vocab_", btn)),label = "Controlled Vocabulary",
                               placeholder="Enter comma separated values, string types only")
          ), column(1,
                    checkboxInput(ns(paste0("field_req_", btn)),label = "Required",value = T)
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

}





