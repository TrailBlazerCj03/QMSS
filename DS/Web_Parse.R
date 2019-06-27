mail_lists=readLines("http://www.r-project.org/mail.html")
fix(mail_lists)

mail_lists_http <- grep("http", mail_lists,value=TRUE)
fix(mail_lists_http)
class(mail_lists_http)

mail_lists_split <-strsplit(mail_lists_http,split="http",fixed=TRUE)
fix(mail_lists_split)
class(mail_lists_split)

#keep sec elem
mail_lists_secElem <- unlist(lapply(mail_lists_split,function(x) x[[2]]))
class(mail_lists_secElem)
fix(mail_lists_secElem)

#Resplit
mail_lists_split_2 <-strsplit(mail_lists_secElem, split = ">", fixed=TRUE)
class(mail_lists_split_2)
fix(mail_lists_split_2)



#handling Json File
