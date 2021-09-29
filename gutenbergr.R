

# The gutenbergr package helps you download and process public domain works from the [Project Gutenberg](http://www.gutenberg.org/) collection. This includes both tools for downloading books (and stripping header/footer information), and a complete dataset of Project Gutenberg metadata that can be used to find words of interest. Includes:
#   
# * A function `gutenberg_download()` that downloads one or more works from Project Gutenberg by ID: e.g., `gutenberg_download(84)` downloads the text of Frankenstein.
# * Metadata for all Project Gutenberg works as R datasets, so that they can be searched and filtered:
# * `gutenberg_metadata` contains information about each work, pairing Gutenberg ID with title, author, language, etc
# * `gutenberg_authors` contains information about each author, such as aliases and birth/death year
# * `gutenberg_subjects` contains pairings of works with Library of Congress subjects and topics
# 
# ### Project Gutenberg Metadata
# 
# This package contains metadata for all Project Gutenberg works as R datasets, so that you can search and filter for particular works before downloading.
# 
# The dataset `gutenberg_metadata` contains information about each work, pairing Gutenberg ID with title, author, language, etc:
  
library(gutenbergr)

gutenberg_metadata
str(gutenberg_metadata)

# For example, you could find the Gutenberg ID of Wuthering Heights by doing:

library(dplyr)

gutenberg_metadata %>%
  filter(title == "Wuthering Heights")

# In many analyses, you may want to filter just for English works, avoid duplicates, and include only books that have text that can be downloaded. The `gutenberg_works()` function does this pre-filtering:

gutenberg_works()
?gutenberg_works

# It also allows you to perform filtering as an argument:

gutenberg_works(author == "Austen, Jane")

# or with a regular expression

library(stringr)
gutenberg_works(str_detect(author, "Austen"))

# different languages => see list of ISO codes (https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
unique(gutenberg_metadata$language)
gutenberg_works(languages = "no") # Norwegian books
 

#' ### Downloading books by ID

#' The function `gutenberg_download()` downloads one or more works from Project Gutenberg based on their ID. For example, we earlier saw that "Wuthering Heights" has ID 768 (see [the URL here](https://www.gutenberg.org/ebooks/768)), so `gutenberg_download(768)` downloads this text.

f768 <- system.file("extdata", "768.zip", package = "gutenbergr")
wuthering_heights <- gutenberg_download(768,
                                        files = f768,
                                        mirror = "http://aleph.gutenberg.org")

wuthering_heights <- gutenberg_download(768)

View(wuthering_heights)

#' Notice it is returned as a tbl_df (a type of data frame) including two variables: `gutenberg_id` (useful if multiple books are returned), and a character vector of the text, one row per line. Notice that the header and footer added by Project Gutenberg (visible [here](http://www.gutenberg.org/files/768/768.txt)) have been stripped away.

#' Provide a vector of IDs to download multiple books. For example, to download Jane Eyre (book [1260](https://www.gutenberg.org/ebooks/1260)) along with Wuthering Heights, do:

f1260 <- system.file("extdata", "1260.zip", package = "gutenbergr")
books <- gutenberg_download(c(768, 1260),
                            meta_fields = "title",
                            files = c(f768, f1260),
                            mirror = "http://aleph.gutenberg.org")

## books <- gutenberg_download(c(768, 1260), meta_fields = "title")

books

#' Notice that the `meta_fields` argument allows us to add one or more additional fields from the `gutenberg_metadata` to the downloaded text, such as title or author.

books %>%
  count(title)

#' ### Other meta-datasets

#' You may want to select books based on information other than their title or author, such as their genre or topic. `gutenberg_subjects` contains pairings of works with Library of Congress subjects and topics. "lcc" means [Library of Congress Classification](https://www.loc.gov/catdir/cpso/lcco/), while "lcsh" means [Library of Congress subject headings](https://id.loc.gov/authorities/subjects.html):

gutenberg_subjects
unique(gutenberg_subjects$subject)

#' This is useful for extracting texts from a particular topic or genre, such as detective stories, or a particular character, such as Sherlock Holmes. The `gutenberg_id` column can then be used to download these texts or to link with other metadata.

gutenberg_subjects %>%
  filter(subject == "Detective and mystery stories")

gutenberg_subjects %>%
  filter(grepl("Holmes, Sherlock", subject))

gutenberg_subjects %>%
   filter(str_detect(subject,"Holmes, Sherlock"))



### get the data directly from url
data_char_wh <- texts(readtext("https://www.gutenberg.org/files/768/768-0.txt"))
names(data_char_wh) <- "wuthering heights"
head(data_char_wh)


### create dtm/dfm
wuthering_heights <- gutenberg_download(768) 
wuthering_heights <- wuthering_heights[!(wuthering_heights$text==""), ] # remove the empty spaces 
wuthering_heights <- wuthering_heights[-c(1:2),] # remove first two rows. 

wuthering_heights_corpus <- corpus(wuthering_heights) # create a corpus at line level 


wuthering_heights_tokens <- tokens(wuthering_heights_corpus, remove_punct = TRUE)
kwic(tokens(wuthering_heights_tokens), "CHAPTER") # we can find where the chapters begin and use them to separate the text. Then perform chapter-level analyses.


dfm_wuthering_heights <- dfm(wuthering_heights_tokens, remove=stopwords("english"))
textstat_frequency(dfm_wuthering_heights,10) # find top 10 words in wuthering heights






