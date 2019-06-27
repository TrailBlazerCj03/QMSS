
# Conversion to and from json

library(jsonlite)


#fromJSON(txt, simplifyVector = TRUE,
#         simplifyDataFrame = simplifyVector, simplifyMatrix = simplifyVector,
#         flatten = FALSE, ...)

#toJSON(x, dataframe = c("rows", "columns", "values"),
#       matrix = c("rowmajor", "columnmajor"), Date = c("ISO8601", "epoch"),
#       POSIXt = c("string", "ISO8601", "epoch", "mongo"),
#       factor = c("string", "integer"), complex = c("string", "list"),
#       raw = c("base64", "hex", "mongo"), null = c("list", "null"),
#       na = c("null", "string"), auto_unbox = FALSE, digits = 4,
#       pretty = FALSE, force = FALSE, ...)




# Stringify some data
jsoncars <- toJSON(mtcars, pretty=TRUE)
cat(jsoncars)

# Parse it back
fromJSON(jsoncars)
class(fromJSON(jsoncars))

# Parse escaped unicode
fromJSON('{"city" : "Z\\u00FCrich"}')

# Decimal 
toJSON(pi, digits=3)


#retrieve data frame
data1 <- fromJSON("https://api.github.com/users/hadley/orgs")
names(data1)
data1$login

# Nested data frames:
data2 <- fromJSON("https://api.github.com/users/hadley/repos")
names(data2)
names(data2$owner)
data2$owner$login

# Flatten the data into a regular non-nested dataframe
names(flatten(data2))

# Flatten directly (more efficient):
data3 <- fromJSON("https://api.github.com/users/hadley/repos", flatten = TRUE)
identical(data3, flatten(data2))



#  How do diff't packages in R compare?

# A biased comparsion of JSON packages in R
# Some simple examples to compare behavior and performance of JSON packages in R.
# Via: RJSONIO, rjson, jsonlite docs and RPubs examples.


Matrix
(x <- matrix(1:6, 2))
[,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6


rjson::fromJSON(rjson::toJSON(x))
[1] 1 2 3 4 5 6


RJSONIO::fromJSON(RJSONIO::toJSON(x))
[[1]]
[1] 1 3 5

[[2]]
[1] 2 4 6


jsonlite::fromJSON(jsonlite::toJSON(x))
[,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6


Lists

x <- list(foo = 123, bar= 456)
rjson::fromJSON(rjson::toJSON(x))

$foo
[1] 123

$bar
[1] 456


RJSONIO::fromJSON(RJSONIO::toJSON(x))
foo bar 
123 456 


jsonlite::fromJSON(jsonlite::toJSON(x))
$foo
[1] 123

$bar
[1] 456



Missing values
rjson::fromJSON(rjson::toJSON(c(1,2,NA,4)))


[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] "NA"

[[4]]
[1] 4


RJSONIO::fromJSON(RJSONIO::toJSON(c(1,2,NA,4)))
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
NULL

[[4]]
[1] 4


jsonlite::fromJSON(jsonlite::toJSON(c(1,2,NA,4)))
[1]  1  2 NA  4


Escaping
x <- list("\b\f\n\r\t" = "\b\f\n\r\t")

identical(x, rjson::fromJSON(rjson::toJSON(x)))
[1] TRUE
identical(x, RJSONIO::fromJSON(RJSONIO::toJSON(x)))
[1] FALSE
identical(x, jsonlite::fromJSON(jsonlite::toJSON(x)))
[1] TRUE


Parser error handling

rjson::fromJSON('[1,2,boo",4]')
Error: unexpected character 'b'

RJSONIO::fromJSON('[1,2,boo",4]')
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
NULL

jsonlite::fromJSON('[1,2,boo",4]')
Error: lexical error: invalid char in json text.
[1,2,boo",4]
  (right here) ------^
  
  
  Unicode
  
  json = '["\\u5bff\u53f8","Z\\u00fcrich", "\\u586B"]'
  rjson::fromJSON(json)
  [1] "寿司"   "Zürich" "填"    
  
  RJSONIO::fromJSON(json)
  [1] "\xff司"    "Z\xfcrich" "k"        
  
  jsonlite::fromJSON(json)
  [1] "寿司"   "Zürich" "填"    
  
  Prettify, validate
  Only RJSONIO and jsonlite have functionality to validate or prettify JSON:
  
  x <- list(foo = c("hi", "hello"), bar=1:3)
  cat(RJSONIO::toJSON(x, pretty = TRUE))
  {
  "foo" : [
  "hi",
  "hello"
  ],
  "bar" : [
  1,
  2,
  3
  ]
  }
  
  cat(jsonlite::toJSON(x, pretty = TRUE))
  {
  "foo": [
  "hi",
  "hello"
  ],
  "bar": [
  1,
  2,
  3
  ]
  }
  
  
  RJSONIO::isValidJSON(RJSONIO::toJSON(x), asText = TRUE)
  [1] TRUE
  
  
  jsonlite::validate(jsonlite::toJSON(x))
  [1] TRUE
  
  
  Digits
  RJSONIO and jsonlite have functionality to limit decimal digits. rjson does not support this.
  
  rjson::toJSON(pi)
  [1] "3.14159265358979"
  
  RJSONIO::toJSON(pi, digits=4)
  [1] "[ 3.142 ]"
  
  jsonlite::toJSON(pi, digits=4)
  [3.1416] 
  
  Controlling conversion of vector from/to list
  Only RJSONIO and jsonlite give control over vector conversion from/to lists. rjson always simplifies if possible.
  
  json <- '[1,2,3,4]'
  RJSONIO::fromJSON(json)
  [1] 1 2 3 4
  
  RJSONIO::fromJSON(json, simplify = FALSE)
  [[1]]
  [1] 1
  
  [[2]]
  [1] 2
  
  [[3]]
  [1] 3
  
  [[4]]
  [1] 4
  
  jsonlite::fromJSON(json)
  [1] 1 2 3 4
  
  jsonlite::fromJSON(json, simplifyVector = FALSE)
  
  [[1]]
  [1] 1
  
  [[2]]
  [1] 2
  
  [[3]]
  [1] 3
  
  [[4]]
  [1] 4
  
  rjson::fromJSON(json)
  [1] 1 2 3 4
  Performance 1: generating JSON
  Comparing performance is a bit difficult because different packages do different things. The rjson package has no options to control conversion, so the only way to benchmark common functionality is by trying to mimic rjson:
  
  library(microbenchmark)
  data(diamonds, package="ggplot2")
  microbenchmark(
  rjson::toJSON(diamonds),
  RJSONIO::toJSON(diamonds),
  jsonlite::toJSON(diamonds, dataframe = "column"),
  times = 10
  )
  
  Unit: milliseconds
  expr   min    lq median    uq    max neval
  rjson::toJSON(diamonds) 294.9 296.5  297.4 298.5  326.5    10
  RJSONIO::toJSON(diamonds) 857.9 867.5  884.2 893.7 1022.2    10
  jsonlite::toJSON(diamonds, dataframe = "column") 317.8 319.9  328.5 342.6  350.9    10
  
  
  What if we throw some missing values in the mix:
  
  diamonds2 <- diamonds
  diamonds2[1,] <- NA;
  microbenchmark(
  rjson::toJSON(diamonds2),
  RJSONIO::toJSON(diamonds2),
  jsonlite::toJSON(diamonds2, dataframe = "column"),
  times = 10
  )
  
  Unit: milliseconds
  expr    min     lq median     uq    max neval
  rjson::toJSON(diamonds2)  294.9  297.0  308.6  327.0  356.4    10
  RJSONIO::toJSON(diamonds2) 1448.6 1476.2 1513.8 1578.2 1716.5    10
  jsonlite::toJSON(diamonds2, dataframe = "column")  317.7  322.6  331.6  355.1  391.6    10
  Performance 2: Parsing JSON
  
  For parsing, comparing performance gets even trickier because rjson does not give any control over simplification. 
  The following settings in RJSONIO and jsonlite are roughly equivalent to rjson:
  
  json <- rjson::toJSON(diamonds)
  microbenchmark(
  rjson::fromJSON(json),
  RJSONIO::fromJSON(json, simplifyWithNames=FALSE),
  jsonlite::fromJSON(json, simplifyDataFrame = FALSE, simplifyMatrix = FALSE),
  times = 10
  )
  Unit: milliseconds
  expr    min    lq median    uq   max neval
  rjson::fromJSON(json)  99.73 105.8  108.2 142.5 168.1    10
  RJSONIO::fromJSON(json, simplifyWithNames = FALSE) 399.30 415.7  426.1 442.5 491.3    10
  jsonlite::fromJSON(json, simplifyDataFrame = FALSE, simplifyMatrix = FALSE) 182.90 204.3  229.1 254.3 321.7    10