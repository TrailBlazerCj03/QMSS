
highest_ast<-function(x){
    yr_1<-filter(nba_data,nba_data$Year==x)
    ast_1<-arrange(yr_1,desc(AST))
    output_1<-ast_1[1,2]
    return(output_1)
}
