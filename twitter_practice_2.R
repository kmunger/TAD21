##### R Task


## load rtweet package
library(rtweet)

app_name <- "smapp"

## copy and pasted *your* keys (these are fake)
consumer_key <- "5y3RgYfTUOUWOGheskv4p7WWO"
consumer_secret <- "j5pszDQ4bddt4pLiwqwezuETPYi3f1PyugM3L4eJdxUVsdwIco"



access_token <- "89098361-YS0MquarADIDh5XvrMdMzASxzxy3apOEgzTpKZvPY"
access_secret <- "jhZgEZuBS1mzDvMIRAhjNb9aklVN4S6UoCP7eL8l3GGIM"


## create token
token <- create_token(
  app = app_name,
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_token,
  access_secret = access_secret
)
## print token
token

get_token() 






## Find the 5 Republican and 5 Democrats in Congress with the most Twitter followers

mcs<-c("@AOC", "@BernieSanders", "@EWarren", "@SpeakerPelosi", "@CoryBooker",
       "@TedCruz", "@RandPaul", "@MarcoRubio", "@dancrenshawtx", "@MittRomney")


## scrape their most recent 200 tweets 

tmls <- get_timelines(mcs, n = 200, token = token)


docs<-aggregate(text ~ user_id, data = tmls, paste, collapse = " ")

docs$class<-c(rep("D", 5), rep("R", 5))



### Create a DFM from the text of these tweets


xdfm <-dfm(docs$text, stem = F, remove_punct = T, tolower = T, remove_numbers = TRUE,
           remove = c(stopwords("english"),"¦","€","¥", "¯","~", "http","https","rt", "t.co"))

### Train a naive bayes classifier to predict the label of the tweets (use all the documents)


