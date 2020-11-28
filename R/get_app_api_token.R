

#' @title get_app_api_token
#' @description Get app api token used to read app profile
#' @param client_id Auth0 app client id
#' @param client_secret Auth0 app secret
#' @param Domain Auth0 app domain
#' @return Returns full api token response
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  api_tokens<-get_app_api_token(app_client_id,app_secret,Domain)
#'
#'client<-  get_client_profile(api_tokens$access_token,app_client_id,Domain)
#'
#' }
#' }
#' @seealso
#'  \code{\link[httr]{POST}},\code{\link[httr]{content}}
#'  \code{\link[jsonlite]{toJSON, fromJSON}}
#' @rdname get_app_api_token
#' @export
#' @importFrom httr POST content
#' @importFrom jsonlite toJSON
get_app_api_token <- function(client_id,client_secret,domain){



  url <- paste0("https://",domain,"/oauth/token")

  header<-  c( 'content-type' =  "application/json",  Authorization = "")


  body <- list( client_id = client_id,
                client_secret = client_secret,
                #audience = "https://ngsanalytics.auth0.com/api/v2/",
                audience =  paste0("https://",domain,"/api/v2/"),
                grant_type = "client_credentials"
                )


  i<-with_verbose(httr::POST(url = url,body = jsonlite::toJSON(body,pretty=T,auto_unbox = T),add_headers(header)))

  httr::content(i)



}



