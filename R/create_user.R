#' Title
#'
#' @param client_id
#' @param client_secret
#' @param domain
#' @param user_info
#' @param metadata
#'
#' @return
#' @export
#'
#' @examples
create_user <- function(client_id,client_secret,domain,user_info,DEBUG=F){


management_token <-  ShinyPlatform::get_management_token(client_id,client_secret,domain,DEBUG)$management_token


url <- paste0("https://",domain,"/api/v2/users")


header <- c('Content-Type' = "application/json",
            'Authorization' = paste0("Bearer ", management_token ))

if(DEBUG){
p2<-httr::with_verbose(httr::POST(
  url = url,
  httr::add_headers(header),
  body = user_info,
  encode = "json"
)) }else{p2<-httr::POST(
  url = url,
  httr::add_headers(header),
  body = user_info,
  encode = "json"
)

}

if(DEBUG){
print(httr::content(p2))
}



httr::content(p2)

list(user = httr::content(p2), response = p2)

}
