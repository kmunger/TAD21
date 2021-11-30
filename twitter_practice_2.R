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




library(quanteda)
library(quanteda.textmodels)

nb_model <- textmodel_nb(xdfm, docs$class, smooth = 1, prior = "uniform")


### Which terms are most predictive?

posterior <- data.frame(feature = rownames(t(nb_model$param)), 
                        post_D = t(nb_model$param)[,1],
                        post_R = t(nb_model$param)[,2])


head(arrange(posterior, -post_D))
head(arrange(posterior, -post_R), n = 20)
### Now find a political commentator on the left and right (eg Rachel Maddow and Tucker Carlson)


ppl<-c("@TuckerCarlson", "@maddow")


## scrape their most recent 200 tweets 

tmls_ppl <- get_timelines(ppl, n = 200, token = token)


docs_ppl<-aggregate(text ~ user_id, data = tmls_ppl, paste, collapse = " ")


##download their 200 most recent tweets -- use the model to predict whether they are D or R


dfm_ppl <-dfm(docs_ppl$text, stem = F, remove_punct = T, tolower = T, remove_numbers = TRUE, remove = c(stopwords("english"),"¦","€","¥", "¯","~", "http","https","rt", "t.co"))

dfm_ppl <- dfm_match(dfm_ppl, features = featnames(xdfm))


## was it correct?  


predicted_class <- predict(nb_model, newdata = dfm_ppl)


predicted_class
