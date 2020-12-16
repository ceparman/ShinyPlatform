#' list_meta_data_documents
#'
#' @param database
#' @param creds
#' @param dbscheme
#' @param dbinstance
#'
#' @return
#' @export
#'
#' @examples
list_meta_data_documents<- function(database,creds,dbscheme,dbinstance)
{

  url_path = paste0(dbscheme ,creds$user,":",creds$pass,dbinstance ,"/",database)
  metadb <- mongo(db=database,url = url_path ,collection = "metadb",verbose = T)

  metadb$find('{}')
}
