# simple UI with user info
source("./global.R")

ui <-
  dashboardPage(

    dashboardHeader(

      title = "ShinyPlatform Demo Instance",


      dropdownMenuOutput("statusmenu")
      ,


      tags$li(
      class = "dropdown",
         actionButton(
           "logout",
           "Log Out",
           class = "btn btn-success",
           onclick = paste0("location.href='", logout_url, "';")
         )
      )

    )
    ,



    dashboardSidebar(
      h3("Menu"),

      sidebarMenu(
        menuItem("Home", tabName = "home"),
        menuItemOutput("users"),
        menuItemOutput("entities"),
        menuItemOutput("debug")
      )
    ),
    dashboardBody(
      useShinyjs(),
      tagList(tags$script(inactivity)),

      tabItems(
        tabItem(
          "home",
          homeTabUI("home")),
        tabItem(
          "users",
          usersTabUI("users")
        ),

        tabItem(
          "entities",
          entitiesTabUI("entities")
        ),
        tabItem(
          "debug",
          debugTabUI("debug")
        )
      )

    )


  )

server <- function(input, output, session) {

#local reactive values

status_info <-  reactiveValues()

#get User Profile

  session$userData$profile <-
         ShinyPlatform::get_user_profile(session$userData$auth0_credentials$access_token, session$userData$auth0_credentials$id_token, domain)

#Set ADMIN flag

   if( session$userData$profile$app_metadata$role == "admin") {ADMIN <- TRUE} else {ADMIN <- FALSE}

#get App metadata

  api_tokens <- ShinyPlatform::get_client_api_token(client_id, client_secret, domain)

  session$userData$client <- ShinyPlatform::get_app_client_profile(api_tokens$access_token,client_id,domain)

# Create database connection

  db_creds <- jsonlite::fromJSON(safer::decrypt_string(session$userData$client$client_metadata$creds))[[session$userData$profile$app_metadata$role]]

  session$userData$db$creds <-  db_creds


  ####Remove hard coded db connections

  url_path = paste0("mongodb+srv://",db_creds$user,":",db_creds$pass,"@cluster0-wz8ra.mongodb.net/",dbname)

  db_connection <- mongo(db=dbname,url = url_path ,collection = "metadb",verbose = T)

  session$userData$db$metadb <-  db_connection

#Add Debug Tab

  output$debug <-   renderMenu({
    if(DEBUG) {
      menuItem("Debug",tabName = "debug")
    }
  })

#Add Users Tab

  output$users <-   renderMenu({
        if(ADMIN) {
         menuItem("Manage Users",tabName = "users")
        }
       })

#Add entities Tab

  output$entities <-   renderMenu({
    if(ADMIN) {
      menuItem("Manage Entities",tabName = "entities")
    }
  })


#Header Data outputs


output$statusmenu <- renderMenu({
 dropdownMenu(type = "notifications",

   notificationItem(
    text = paste("User:",session$userData$profile$nickname),
    icon("users")
  ),

  notificationItem(
    text = paste("Role:",session$userData$profile$app_metadata$role),
    icon("user-tag")
  ),

  notificationItem(
    text = paste("db Connection:",
                 ifelse(exists("db_connection"),
                 "dB Connected",
                 "No db Connection")
                ),
    icon("database")
  )
)
})



#Call Modules

  callModule(module = homeTab,  id = "home" )
  callModule(module = usersTab, id = "users")
  callModule(module = entitiesTab, id = "entities")
  callModule(module = debugTab, id = "debug")




}

shinyAppAuth0(ui, server)
