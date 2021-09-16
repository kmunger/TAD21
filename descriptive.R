# Descriptive Analysis of Texts

#quateda has a number of descriptive statistics available for reporting on texts.  
#The **simplest of these** is through the `summary()` method:
install.packages("quanteda")
require(quanteda)
txt <- c(sent1 = "This is an example of the summary method for character objects.",
         sent2 = "The cat in the hat swung the bat.")
summary(txt)

#This also works for corpus objects:

summary(corpus(data_char_ukimmig2010))

#To access the **syllables** of a text, we use `syllables()`:

nsyllable(c("Superman.", "supercalifragilisticexpialidocious", "The cat in the hat."))

#We can even compute the **Scabble value** of English words, using `scrabble()`:

nscrabble(c("cat", "quixotry", "zoo"))

#We can analyze the **lexical diversity** of texts, using `lexdiv()` on a dfm:
summary(data_corpus_inaugural)


myDfm <- dfm(corpus_subset(data_corpus_inaugural, Year > 1980))
textstat_lexdiv(myDfm, "R")

#We can analyze the **readability** of texts, using `readability()` on a vector of texts or a corpus:

readab <- textstat_readability(corpus_subset(data_corpus_inaugural, Year > 1980), 
                               measure = "Flesch.Kincaid")

#We can **identify documents and terms that are similar to one another**, using `similarity()`:

## Presidential Inaugural Address Corpus
presDfm <- dfm(data_corpus_inaugural, remove = stopwords("english"))
# compute some document similarities
textstat_simil(presDfm, "1985-Reagan",  margin = "documents")

##erorr!!


textstat_simil(presDfm, c("2009-Obama", "2013-Obama"), margin = "documents", method = "cosine")

#And this can be used for **clustering documents**:

presDfm <- dfm(corpus_subset(data_corpus_inaugural, Year > 1900), stem = TRUE,
               remove = stopwords("english"))
presDfm <- dfm_trim(presDfm, min_count = 5, min_docfreq = 3)
# hierarchical clustering - get distances on normalized dfm

presDistMat <- dist(as.matrix(dfm_weight(presDfm, "relFreq")))
# hiarchical clustering the distance object
presCluster <- hclust(presDistMat)
# label with document names
presCluster$labels <- docnames(presDfm)
# plot as a dendrogram

plot(presCluster)

  