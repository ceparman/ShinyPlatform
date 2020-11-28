# OAuth setup --------------------------------------------------------

# Most OAuth applications require that you redirect to a fixed and known
# set of URLs. Many only allow you to redirect to a single URL: if this
# is the case for, you'll need to create an app for testing with a localhost
# url, and an app for your deployed app.


# Shiny -------------------------------------------------------------------



# A little-known feature of Shiny is that the UI can be a function, not just
# objects. You can use this to dynamically render the UI based on the request.
# We're going to pass this uiFunc, not ui, to shinyApp(). If you're using
# ui.R/server.R style files, that's fine too--just make this function the last
# expression in your ui.R file.
ui <- function(req) {
  if(DEBUG) print("Query String")
  if(DEBUG) print(req$QUERY_STRING)
  if(DEBUG) print(ls(req))


  if (!ShinyPlatform::has_auth_code(parseQueryString(req$QUERY_STRING))) {

    #create url for Auth0 login

    auth_url <- paste0("https://",domain,"/authorize?response_type=code&client_id=",app_client_id,
                       "&redirect_uri=",app_url,"&scope=openid%20profile&state=xyzABC123")



    #go to login

    redirect <- sprintf("location.replace(\"%s\");", auth_url)
    tags$script(HTML(redirect))
  }


  else {
    #we have authcode parmamter display app ui
    ui_app()
  }
}
