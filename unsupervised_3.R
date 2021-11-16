
# -----------------------------------------------
# Structural Topic Models                       ---
# -----------------------------------------------
rm(list = ls())
libraries <- c("topicmodels", "dplyr", "stm", "quanteda")

lapply(libraries, require, character.only = TRUE)


setwd("C:/Users/kevin/Documents/GitHub/TAD21")


# Loading data: Political blogs from the 2008 election on a conservative-liberal dimension
data(poliblog5k)
head(poliblog5k.meta)
head(poliblog5k.voc)
?stm
# Fits an STM model with 3 topics
system.time(
  blog_stm <- stm(poliblog5k.docs, poliblog5k.voc, 3, prevalence = ~rating + s(day), data = poliblog5k.meta))

# A plot that summarizes the topics by what words occur most commonly in them
plot(blog_stm, type = "labels")

# A summary plot of the topics that ranks them by their average proportion in the corpus
plot(blog_stm, type = "summary")

# A visualization of what words are shared and distinctive to two topics
plot(blog_stm, type="perspectives", topics = c(1,2))

# Estimates a regression with topics as the dependent variable and metadata as the independent variables
# s() is a wrapper for bs() from the splines package
# A spline of degree D is a function formed by connecting polynomial segments of degree D
prep <- estimateEffect(1:3 ~ rating + s(day) , blog_stm, meta = poliblog5k.meta)

# Plots the distribution of topics over time
plot(prep, "day", blog_stm, topics = c(1,2), 
     method = "continuous", xaxt = "n", xlab = "Date")

# Plots the Difference in coverage of the topics according to liberal or conservative ideology
plot(prep, "rating", model = blog_stm,
     method = "difference", cov.value1 = "Conservative", cov.value2 = "Liberal")


# A summary plot of the topics that ranks them by their average proportion in the corpus
plot(blog_stm, type = "summary")

# A visualization of what words are shared and distinctive to two topics
plot(blog_stm, type="perspectives", topics = c(1,2))





######modification


# take the code from unsupervised_2.R and read in the BLM tweet dataset

## use "dfm_trim" to take the dfm created and only keep terms that apepar in at least 30 documents

## run STM on this dfm, setting K = 0 so that it searches for the optimal number of topics (you may need to install more packages!)

## plot the top topics and their distribution in the corpus

##plot using "perspectives" the top two topics and see which words are most distinctive


# Load data
blm_tweets <- read.csv("blm_samp.csv", stringsAsFactors = F)

# Create date vectors
blm_tweets$datetime <- as.POSIXct(strptime(blm_tweets$created_at, "%a %b %d %T %z %Y",tz = "GMT")) # full date/timestamp
blm_tweets$date <- mdy(paste(month(blm_tweets$datetime), day(blm_tweets$datetime), year(blm_tweets$datetime), sep = "-")) # date only

# Collapse tweets so we are looking at the total tweets at the day level
blm_tweets_sum <- blm_tweets %>% group_by(date) %>% summarise(text = paste(text, collapse = " "))

# Remove non ASCII characters
blm_tweets_sum$text <- stringi::stri_trans_general(blm_tweets_sum$text, "latin-ascii")

# Removes solitary letters
blm_tweets_sum$text <- gsub(" [A-z] ", " ", blm_tweets_sum$text)

# As always we begin with a DFM.
# Create DFM
blm_dfm <-dfm(blm_tweets_sum$text, stem = F, remove_punct = T, tolower = T, remove_twitter = T, remove_numbers = TRUE, remove = c(stopwords("english"),"¦","€","¥", "¯","~", "http","https","rt", "t.co"))
              
              

blm_dfm<-dfm_trim(blm_dfm, min_docfreq = 30)

s<-stm(blm_dfm, K = 0) 



# A summary plot of the topics that ranks them by their average proportion in the corpus
plot(s, type = "summary")

# A visualization of what words are shared and distinctive to two topics
plot(s, type="perspectives", topics = c(28,7))


