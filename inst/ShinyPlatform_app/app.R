# simple UI with user info
source("./global.R")

ui <-
  dashboardPage(
    dashboardHeader(
      title = "ShinyPlatform Demo Instance",


      tags$li(class = "dropdown",  HTML(paste(
        "User", textOutput("user")
      )))

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

    ),



    dashboardSidebar(
      h3("Menu"),

      sidebarMenu(
        menuItem("Home", tabName = "home"),
        menuItemOutput("users"),
        menuItemOutput("debug")
      )
    ),
    dashboardBody(
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
          "debug",
          debugTabUI("debug")
        )
      )

    )


  )

server <- function(input, output, session) {

#get User Profile

  session$userData$profile <-
         ShinyPlatform::get_user_profile(session$userData$auth0_credentials$access_token, session$userData$auth0_credentials$id_token, domain)

#Set ADMIN flag

   if( session$userData$profile$app_metadata$role == "admin") {ADMIN <- TRUE} else {ADMIN <- FALSE}

#get App metadata


  api_tokens <- ShinyPlatform::get_client_api_token(client_id, client_secret, domain)

  session$userData$client <- ShinyPlatform::get_app_client_profile(api_tokens$access_token,client_id,domain)




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


  callModule(module = homeTab,  id = "home" )
  callModule(module = usersTab, id = "users")
  callModule(module = debugTab, id = "debug",session = session)




}

shinyAppAuth0(ui, server)
