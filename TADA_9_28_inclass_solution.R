
# 1. Find all the books by William Shakespeare. 
library(gutenbergr)

gutenberg_works(author == "Shakespeare, William") 
gutenberg_works(str_detect(author, "Shakespeare"))


# 2. Get the number of Italian, German and French books in the Gutenberg project. Use the filtered gutenberg_works dataset
library(dplyr)

gutenberg_works(languages = c("it","de", "fr") ) %>%  
  count(language)


# 3. Using gutenberg_subjects dataset, find the books that have "Classical literature" as a genre/subject.

gutenberg_subjects %>%
  filter(grepl("Classical literature", subject)) 

# 4. Find the books with with "Classical literature" subjects in the gutenberg_works dataset. Use the identifiers (ids) from previous question.

classics <- gutenberg_subjects %>%
  filter(grepl("Classical literature", subject)) 

gutenberg_works() %>% 
  filter(gutenberg_id %in% classics$gutenberg_id)