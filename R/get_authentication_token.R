#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param app_url Auth0 app url
#' @param app_client_id Auth0 app client id
#' @param app_secret Auth0 app secret
#' @param domain Auth0 app domain
#' @param code Auth0 app authorization code
#' @return Returns authorization token used to read user and app data
#' @details Details
#' @examples
#' \dontrun{
#' if(interactive()){
#'   params <- shiny::parseQueryString(isolate(session$clientData$url_search))
#'   t<- get_authentication_token(app_url, app_client_id,app_secret,Domain,params$code)
#'  }
#' }
#' @seealso
#'  \code{\link[jsonlite]{toJSON, fromJSON}}
#'  \code{\link[httr]{POST}}
#' @rdname get_authentication_token
#' @export
#' @importFrom jsonlite toJSON
#' @importFrom httr POST
get_authentication_token <- function(app_url, app_client_id,client_secret,domain,code){


  jdata <- list(
    "grant_type" ="authorization_code",
    "code"= code,
    "client_id" = app_client_id,
    "client_secret" = client_secret,
    "redirect_uri" = app_url
  )


  jsonlite::toJSON(jdata,pretty = T)

  header <- "content-type: application/json"


   url <- paste0("https://",domain,"/oauth/token")

  r<- with_verbose( httr::POST(url=url,body = jdata,encode="json",header=add_headers(header) ))

  r
}

