shinyInput <- function(FUN, len, ns,id, ...) {
  
  inputs <- character(len)
  for (i in seq_len(len)) {
   # print( as.character(FUN(ns(paste0(id, i)), ...)))
    inputs[i] <- as.character(FUN(ns(paste0(id, i)), ...))
  }
  inputs
}