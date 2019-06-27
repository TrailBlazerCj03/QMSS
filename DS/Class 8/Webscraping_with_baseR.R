#--------------Webscraping with base R using readLines()-------------#

#Activity: Use string operations to extract Special Interest Group links
#from the following page:

mail_lists = readLines("http://www.r-project.org/mail.html")

fix(mail_lists)

mail_lists_http<-grep("http", mail_lists, value=TRUE)

fix(mail_lists_http)

#use strsplit to split out unwanted data
mail_lists_SPLIT<-strsplit(mail_lists_http, split="http", fixed=TRUE) #fixed=exact match split

#keep second element
mail_lists_secondelement = unlist(lapply(mail_lists_SPLIT, function(x) x[[2]]))

#resplit data to keep text you want
mail_lists_SPLIT2<-strsplit(mail_lists_secondelement, split=">", fixed=TRUE) #fixed=exact match split

mail_lists_linkelement = unlist(lapply(mail_lists_SPLIT2, function(x) x[[1]]))

#subset to links you want

grep("r-sig",mail_lists_linkelement, value=TRUE) #sig links


#This works, but it is pretty ugly. The rvest package provides a more elegant solution
#to webscraping