#' @title has_auth_code
#' @description checks for authorization code in url
#' @param params session URL
#' @return Tru eor False
#' @details  params is a list object containing the parsed URL parameters. Return TRUE if
#' based on these parameters, it looks like auth codes are present that we can
#' use to get an access token. If not, it means we need to go through the OAuth
#' flow.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  has_auth_code(parseQueryString(req$QUERY_STRING))
#'  }
#' }
#' @rdname has_auth_code
#' @export

has_auth_code <- function(params) {

  return(!is.null(params$code))
}
