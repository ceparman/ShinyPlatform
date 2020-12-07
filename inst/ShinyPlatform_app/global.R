
library(shiny)
library(shinydashboard)
library(ShinyPlatform)
library(httr)
library(shinyjs)
library(httr)
library(digest)
library(jose)
library(config)
library(auth0)





source("R_Code/sourceDir.R")
sourceDir("R_Code/")
sourceDir("Modules/")
source("ui_app.R")

# print("config")
# print(is_active("default"))
# print(is_active("local"))
# print(is_active("shinyapps"))

#print(config::get())

options(shiny.port = 8100)



#read app information

app_url <- URLencode(config::get("app_url"))
client_id  <- config::get("client_id")
client_secret <-  config::get("client_secret")
domain <- config::get("domain")
logout_url <- URLencode(config::get("logout_url"))
timeout <- config::get("timeoput")
DEBUG <- config::get("debug")
api_audence <- config::get("api_audience")

ADMIN = config::get("admin")


#JS to timeout app

inactivity <- paste0(
  "function idleTimer() {
  var t = setTimeout(logout, 50000);
  window.onmousemove = resetTimer; // catches mouse movements
  window.onmousedown = resetTimer; // catches mouse movements
  window.onclick = resetTimer;     // catches mouse clicks
  window.onscroll = resetTimer;    // catches scrolling
  window.onkeypress = resetTimer;  //catches keyboard actions
 ",

  "function logout() {
  location.replace('",
  logout_url,
  "')}",
  "
  function resetTimer() {
    clearTimeout(t);
    t = setTimeout(logout,'","50000","');  // time is in milliseconds (1000 is 1 second)
  }
}
idleTimer();"
) #end paste



