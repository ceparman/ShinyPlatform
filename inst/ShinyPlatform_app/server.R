auth0_server(function(input, output, session) {


 observe({

#Store authoization data
    auth0::auth0_info()
#get user details

   session$userData$profile <-
     ShinyPlatform::get_user_profile(session$userData$auth0_credentials$access_token, session$userData$auth0_credentials$id_token, domain)

   print(session$userData$profile)

 output$users <-   renderMenu({
        if(session$userData$profile$app_metadata == "admin")  {
          menuItem("Manage Users",tabName = "users")
         }
        })


#get app details


   api_tokens <-
     ShinyPlatform::get_client_api_token(client_id, client_secret, domain)


   client_url<- URLencode(paste0("https://",domain,"/api/v2/clients/",client_id))

   header<-  c( Authorization =  paste0("Bearer ", api_tokens$access_token))


   i<-with_verbose(httr::GET(url = client_url,add_headers(header)))

    session$userData$client <- httr::content(i)


})


  #if (!has_auth_code(params)) {

 #       if(DEBUG) print("No code option")   #Returning with out proper Auth token probable need to stop application


 #    user <- "no auth code"


  #   } else{

#Update the header values


 #      if(DEBUG) {print("going to get_app_and_user_info \n")}


   #   storedData$logouturl <-logout_url

    #once we have a token we will get app and user info, and verify user is in user apps
     #Add code to send and check check state

   #storedData$user <- renderText(get_app_and_user_info(session,app_url, app_client_id,app_secret,domain,storedData,DEBUG=DEBUG))

   #   get_app_and_user_info(session,app_url, app_client_id,app_secret,domain,storedData,DEBUG=DEBUG)

 #  if(DEBUG) {print("returned from get_app_and_user_info \n")}

    output$debug <-   renderMenu({
                      if(DEBUG) {
                         menuItem("Debug",tabName = "debug")
                       }
     })


  # output$users <-   renderMenu({
 #    if(ADMIN) {
  #     menuItem("Manage Users",tabName = "users")
 #    }
#   })



    callModule(module = homeTab,  id = "home" )
    callModule(module = usersTab, id = "users")
    callModule(module = debugTab, id = "debug")



 # }





}, info = a0_info)
