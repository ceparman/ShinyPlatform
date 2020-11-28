server <- function(input, output, session) {

  storedData <- reactiveValues()

  #Once redirected back to app parse the query string
   params <-  shiny::parseQueryString(isolate(session$clientData$url_search))

   storedData$params <- params

  if(DEBUG) print(paste("Params",  params  ))




  if (!has_auth_code(params)) {

        if(DEBUG) print("No code option")   #Returning with out proper Auth token probable need to stop application


     user <- "no auth code"


     } else{

#Update the header values


      storedData$logouturl <-logout_url

    #once we have a token we will get app and user info, and verify user is in user apps
     #Add code to send and check check state

   storedData$user <- renderText(get_app_and_user_info(session,app_url, app_client_id,app_secret,domain,storedData,debug=DEBUG))

    output$debug <-   renderMenu({
                       if(DEBUG) {
                         menuItem("Debug",tabName = "debug")
                       }
     })


   output$users <-   renderMenu({
     if(ADMIN) {
       menuItem("Manage Users",tabName = "users")
     }
   })



    callModule(module = homeTab, id = "home",session = session,storedData = storedData )
    callModule(module = usersTab,id = "user",session = session,storedData = storedData)
     callModule(module = debugTab, id = "debug",session = session,storedData= storedData)


    #callModule(dash,"dash",parent=session,parentInput=input,storedData)
    #callModule(samples,"samples",parent=session,parentInput=input,storedData)
    #callModule(reports,"reports",parent=session,parentInput=input,storedData)






  }





}
