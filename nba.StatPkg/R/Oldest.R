
#'oldest
#'
#' This function helps to find out who is the oldest player in a specific year.
#' @param year Which year do you want to know the oldest player?Defaults to 2000
#' @keywords age
#' @export
#' @examples
#' oldest()





oldest<-function(x){
    yr_2<-filter(nba_data,nba_data$Year==x)
    old<-arrange(yr_2,desc(Age))
    output_2<-old[1,2]
    returnValue(output_2)
}
