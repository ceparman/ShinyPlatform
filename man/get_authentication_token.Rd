% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_authentication_token.R
\name{get_authentication_token}
\alias{get_authentication_token}
\title{FUNCTION_TITLE}
\usage{
get_authentication_token(app_url, app_client_id, client_secret, domain, code)
}
\arguments{
\item{app_url}{Auth0 app url}

\item{app_client_id}{Auth0 app client id}

\item{domain}{Auth0 app domain}

\item{code}{Auth0 app authorization code}

\item{app_secret}{Auth0 app secret}
}
\value{
Returns authorization token used to read user and app data
}
\description{
FUNCTION_DESCRIPTION
}
\details{
Details
}
\examples{
\dontrun{
if(interactive()){
  params <- shiny::parseQueryString(isolate(session$clientData$url_search))
  t<- get_authentication_token(app_url, app_client_id,app_secret,Domain,params$code)
 }
}
}
\seealso{
\code{\link[jsonlite]{toJSON, fromJSON}}
 \code{\link[httr]{POST}}
}
