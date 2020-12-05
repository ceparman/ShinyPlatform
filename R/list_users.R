
#' Title
#'
#' @param client_id
#' @param client_secret
#' @param domain
#' @param DEBUG
#'
#' @return
#' @export
#'
#' @examples
list_users <- function(client_id,client_secret,domain,DEBUG=F){


management_token <-  get_management_token(client_id,client_secret,domain,DEBUG)$management_token


  url <- paste0("https://",domain,"/api/v2/users")


  header <- c('Content-Type' = "application/json",
              'Authorization' = paste0("Bearer ", management_token ))

  if(DEBUG){
    g<-httr::with_verbose(httr::GET(
      url = url,
      httr::add_headers(header)
    )) }else{g<-httr::GET(
      url = url,
      httr::add_headers(header)
    )

    }

  if(DEBUG){
    print(httr::content(g))
  }







  list(users = httr::content(g), response = g)

}
