# Load the package required to read JSON files.
library("rjson")

library(lubridate)


setwd("C:/Users/kevin/Documents/GitHub/TAD21")


# Give the input file name to the function.

maga <- fromJSON(file = "hash_vids_maga.json")


liberal <- fromJSON(file = "hash_vids_liberal.json")





extract_df_from_hashtag <- function(tiktok_list) {
  plays<-numeric()
  shares<-numeric()
  likes<-numeric()
  comments<-numeric()
  tt_id<-numeric()
  times<-character()
  text<-character()
  
  for(i in 1:length(tiktok_list)){
    
    plays[i]<-tiktok_list[[i]][1]$itemInfos$playCount
    shares[i]<-tiktok_list[[i]][1]$itemInfos$shareCount
    likes[i]<-tiktok_list[[i]][1]$itemInfos$diggCount
    comments[i]<-tiktok_list[[i]][1]$itemInfos$commentCount
    times[i]<-tiktok_list[[i]][1]$itemInfos$createTime
    text[i]<-tiktok_list[[i]][1]$itemInfos$text
    tt_id[i]<-tiktok_list[[i]][1]$itemInfos$id
    
    
  }  
  times<-as_datetime(as.numeric(times))
  
  tiktok_df<-data.frame(plays, shares, likes, comments, times, text, tt_id)
  
  return(tiktok_df)
}


liberal_hash_df<-extract_df_from_hashtag(liberal)


##looks like it's returning the most popular---but it's not a strict "plays" list
plot(liberal_hash_df$plays)

plot(liberal_hash_df$likes)
##plot looks better for likes but it's less squished


##nothing here


maga_hash_df<-extract_df_from_hashtag(maga)









### user level analysis

rep_hh <- fromJSON(file = "tiktok_vids400.json")



extract_df_from_user <- function(tiktok_list) {
  plays<-numeric()
  shares<-numeric()
  likes<-numeric()
  comments<-numeric()
  tt_id<-numeric()
  times<-character()
  text<-character()
  
  for(i in 1:length(tiktok_list)){
    
    plays[i]<-tiktok_list[[i]]$stats$playCount
    shares[i]<-tiktok_list[[i]]$stats$shareCount
    likes[i]<-tiktok_list[[i]]$stats$diggCount
    comments[i]<-tiktok_list[[i]]$stats$commentCount
    times[i]<-tiktok_list[[i]]$createTime
    text[i]<-tiktok_list[[i]]$desc
    tt_id[i]<-tiktok_list[[i]]$id
    
    
  }  
  times<-as_datetime(as.numeric(times))
  
  tiktok_df<-data.frame(plays, shares, likes, comments, times, text, tt_id)
  
  return(tiktok_df)
}


rep_hh_df<-extract_df_from_user(rep_hh)



plot( rep_hh_df$times, (rep_hh_df$plays),  main="@therepublicanhypehouse")


maga_hash_df$text[1:10]


####

####in-class assignment


###read a few of the texts on the liberal and conservative tiktoks

### look at 20 of each. How many are *actually* liberal or conservative?


### What are the hashtags that are most commonly used by liberal and conservative tiktokers?

### Conduct a sentiment analysis using this -- on average, is there a difference? 

in_path <- "XXXXX YOU PATH"

pos <- read.table(paste0(in_path, "positive-words.txt"), stringsAsFactors = F)
neg <- read.table(paste0(in_path, "negative-words.txt"), stringsAsFactors = F)

# create dictionary object (a quanteda object)
sentiment_dict <- dictionary(list(pos = pos$V1, neg = neg$V1))


# create document feature matrix with pre-processing options
yelp_dfm <- dfm(samp$text, tolower = TRUE, stem = FALSE, dictionary = sentiment_dict)



 
### plot the relationship between the sentiment and the number of comments (in the whole dataset) --- is there a relationship?





