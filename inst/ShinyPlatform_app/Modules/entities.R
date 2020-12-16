
this_table <- reactiveVal(data.frame(bins = c(30, 50), cb = c(T, F)))

entitiesTabUI <- function(id){

  ns <- NS(id)


   fluidPage(

       sidebarLayout(
         sidebarPanel(
           sliderInput(ns("bins"),
                       "Number of bins:",
                       min = 1,
                       max = 50,
                       value = 30),
           checkboxInput(ns("cb"), "T/F"),
           actionButton(ns("add_btn"), "Add"),
           actionButton(ns("delete_btn"), "Delete")
         ),

         mainPanel(
           DTOutput(ns("shiny_table"))
         )
       )
   )

}


entitiesTab <- function(input,output,session,storedData)
  {
ns <- session$ns




observeEvent(input$add_btn, {

  t = rbind(data.frame(bins = input$bins,
                       cb = input$cb), this_table())
  this_table(t)
})

observeEvent(input$delete_btn, {
  t = this_table()
  print(nrow(t))
  if (!is.null(input$shiny_table_rows_selected)) {
    t <- t[-as.numeric(input$shiny_table_rows_selected),]
  }
  this_table(t)
})

output$shiny_table <- renderDT({
  datatable(this_table(), selection = 'single', options = list(dom = 't'),editable = TRUE)

})






}
