

delete_user <- function(client_id,client_secret,domain,user_id,DEBUG=F){


  management_token <-  get_management_token(client_id,client_secret,domain,DEBUG=F)$management_token


  url <- paste0("https://",domain,"/api/v2/users/",user_id)


  header <- c('Content-Type' = "application/json",
              'Authorization' = paste0("Bearer ", management_token ))

  if(DEBUG){
    d<-httr::with_verbose(httr::DELETE(
      url = url,
      httr::add_headers(header)
    )) }else{d<-httr::POST(
      url = url,
      httr::add_headers(header)
    )

    }

  if(DEBUG){
    print(httr::content(d))
  }


status <- httr::http_status(d)$category

  list(status = status, response = d)

}
