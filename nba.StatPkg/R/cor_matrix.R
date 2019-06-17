#' cor_matrix
#'
#' This function helps to return a correlation matrix of numeric value of an individual year.
#' @param year What is the correlation matrix of numeric-only data look like in a specific year?
#' @keywords cor_matrix
#' @export
#' @examples
#' cor_matrix()






cor_matrix<-function(x){
    datafilter<-filter(nbadata,nbadata$Year==1950)
    datanum<-keep(datafilter, is.numeric)
    cor(datanum)
}