


ui_app <-  function() {
  dashboardPage(
    dashboardHeader(
      title = "ShinyPlatform Demo Instance",


      tags$li(class = "dropdown",  HTML(paste(
        "User", textOutput("user")
      ))),


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

}
