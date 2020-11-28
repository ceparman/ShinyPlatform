
#' @title get_user_profile
#' @description Get Auth0 user profile
#' @param access_token Auth0 access token
#' @param id_token Auth0 id token
#' @param domain auth0 Domain
#' @return OUTPUT_DESCRIPTION
#' @details return Auth0 user profile
#' @examples
#' \dontrun{
#' if(interactive()){
#'   profile <-  ShinyPlatform::get_user_profile(token$access_token,token$id_token,domain)
#'  }
#' }
#' @seealso
#'  \code{\link[jsonlite]{toJSON, fromJSON}}
#'  \code{\link[jose]{base64url_encode}}
#'  \code{\link[httr]{GET}},\code{\link[httr]{content}}
#' @rdname get_user_profile
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom jose base64url_decode
#' @importFrom httr GET content
get_user_profile <- function(access_token,id_token,domain){

  id_strings <- strsplit(id_token, ".", fixed = TRUE)

  user_info<-jsonlite::fromJSON(rawToChar(jose::base64url_decode(id_strings[[1]][2])))


  user_url<- URLencode(paste0(domain,"/api/v2/users/",user_info$sub,"?include_fields=true"))

  header<-  c( Authorization =  paste0("Bearer ", id_token))


  i<-with_verbose(httr::GET(url = user_url,add_headers(header)))

  httr::content(i)


}



