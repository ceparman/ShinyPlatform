#' list_collections
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
list_collections<- function(database,creds,dbscheme,dbinstance)
{

  url_path = paste0(dbscheme ,creds$user,":",creds$pass,dbinstance ,"/admin")

  db <- mongo(db=database,url = url_path )

  collections <- db$run('{"listCollections":1}')

  collections$cursor$firstBatch$name

}

