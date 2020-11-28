

curl --request POST \
--url https://ngsanalytics.auth0.com/oauth/token \
--header 'content-type: application/json' \
--data '{"client_id":"ZlsCocO6jkEsdscWTf6UbdaiOYJOG8vK","client_secret":"57qfRfZFiRbNSbu9svzGNyzjB7Q1g_2QmV5f8gkKjpuV4p-f8hGfteM-Xd0sKftu",
        "audience":"https://ngsanalytics.auth0.com/api/v2/","grant_type":"client_credentials"}'


library(httr)

auth0_get_management_token <- function(url,client_id,client_secret,audience){

client_id <- "ZlsCocO6jkEsdscWTf6UbdaiOYJOG8vK"
client_secret <- "57qfRfZFiRbNSbu9svzGNyzjB7Q1g_2QmV5f8gkKjpuV4p-f8hGfteM-Xd0sKftu"



}


#Get token

client_id <- "ZlsCocO6jkEsdscWTf6UbdaiOYJOG8vK"
client_secret <- "57qfRfZFiRbNSbu9svzGNyzjB7Q1g_2QmV5f8gkKjpuV4p-f8hGfteM-Xd0sKftu"



body <- list(client_id = client_id,
             client_secret = client_secret,
             audience = "https://ngsanalytics.auth0.com/api/v2/",
             grant_type = "client_credentials"
             )


url <- URLencode("https://ngsanalytics.auth0.com/oauth/token")

header <- c('Content-Type' = "application/json")



p<-with_verbose(httr::POST(
                           url = url,
                           add_headers(header),
                            body = body,
                            encode = "json"
                          ))

httr::content(p)

#Create user

access_token <- httr::content(p)$access_token

url <- "https://ngsanalytics.auth0.com/api/v2/users"

user <- list( email =  "testmail@ngsanalytics.com",
              connection = "Username-Password-Authentication",
              password ="1234")

header <- c('Content-Type' = "application/json",
            'Authorization' = paste0("Bearer ", access_token ))


p2<-with_verbose(httr::POST(
  url = url,
  add_headers(header),
  body = user,
  encode = "json"
))

httr::content(p2)


#delete user
#curl -X DELETE  https://login.auth0.com/api/v2/users/5f8df250ea53e50075973597


user_id <- content(p2)$user_id

header <- c('Content-Type' = "application/json",
            'Authorization' = paste0("Bearer ", access_token ))


url <- paste0("https://ngsanalytics.auth0.com/api/v2/users/",user_id)

  p3<-with_verbose(httr::DELETE(
    url = url,
    add_headers(header)
  ))
content(p3)

#list users

#curl  https://login.auth0.com/api/v2/users?page=0&per_page=100&include_totals=true&search_engine=v1



header <- c('Content-Type' = "application/json",
            'Authorization' = paste0("Bearer ", access_token ))


url <- paste0("https://ngsanalytics.auth0.com/api/v2/users")

p4<-with_verbose(httr::GET(
  url = url,
  add_headers(header)
))
content(p4)

users <- content(p4)

