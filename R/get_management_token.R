#' Title
#'
#' @param client_id
#' @param client_secret
#' @param domain
#'
#' @return
#' @export
#'
#' @examples
get_management_token <- function(client_id,client_secret,domain,DEBUG = F){



  api_audience <- paste0("https://",domain,"/api/v2/")

  body <- list(client_id = client_id,
               client_secret = client_secret,
               audience = api_audience,
               grant_type = "client_credentials"
  )




  url <- paste0("https://",domain,"/oauth/token")

  url <- URLencode(url)

  header <- c('Content-Type' = "application/json")

  if(DEBUG) {

    p<- httr::with_verbose( httr::POST(
      url = url,
      httr::add_headers(header),
      body = body,
      encode = "json"
    )) } else {
  p<- httr::POST(
    url = url,
    httr::add_headers(header),
    body = body,
    encode = "json"
    )
}
 if(DEBUG) print(  httr::content(p))

  #Create user

  management_token <- httr::content(p)$access_token



  list(management_token = management_token, response = p)

  }



