#' @title get_app_client_profile
#' @description Get app client profile.  Used to read app metadata.
#' @param access_token Auth0 app api access token.
#' @param app_client_id app client id.
#' @param domain Auth0 domain.
#' @return returns client response for app.
#' @details Details
#' @examples
#' \dontrun{
#' if(interactive(){
#'
#'  api_tokens<-ShinyPlatform::get_app_api_token(app_client_id,app_secret,domain)
#'  client<-  ShinyPlatform::get_app_client_profile(api_tokens$access_token,app_client_id,domain)
#'
#' }
#' }
#' @seealso
#'  \code{\link[jsonlite]{toJSON, fromJSON}}
#'  \code{\link[httr]{GET}},\code{\link[httr]{content}}
#' @rdname get_app_client_profile
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content
get_app_client_profile <- function(access_token,client_id,domain){

  # id_strings <- strsplit(id_token, ".", fixed = TRUE)

  id_strings <- strsplit(access_token, ".", fixed = TRUE)

  user_info<-jsonlite::fromJSON(rawToChar(base64url_decode(id_strings[[1]][2])))



  client_url<- URLencode(paste0("https://",domain,"/api/v2/clients/",app_client_id))

  header<-  c( Authorization =  paste0("Bearer ", access_token))


  i<-with_verbose(httr::GET(url = client_url,add_headers(header)))

  httr::content(i)


}
