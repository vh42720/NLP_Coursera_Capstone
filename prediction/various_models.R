library(ngram)
library(dplyr)
library(readr)
library(qdap)
library(tm)
library(stringr)

##Reading in clean data
con <- file("./final_sample.txt")
final_sample <- read_lines(con)

##Cleaning
source("./clean.R")
final_sample <- odd_clean(final_sample)
final_sample <- replace_clean(final_sample)
final_sample <- remove_clean(final_sample)
final_sample_clean <- final_sample
write_lines(final_sample_clean, "./final_sample_clean.txt")
rm(final_sample)

##n-grams
final_sample_clean <- concatenate(final_sample_clean)
bigram <- ngram(final_sample_clean, n = 2)
trigram <- ngram(final_sample_clean, n = 3)
fourgram <- ngram(final_sample_clean, n = 4)

##Storing
dict_2g <- tbl_df(get.phrasetable(bigram))[1:2]
dict_2g$ngrams <- str_trim(dict_2g$ngrams)
eosTag <- str_detect(dict_2g$ngrams, "<EOS>")
dict_2g <- dict_2g[!eosTag,]
saveRDS(dict_2g, "dict_2g.Rds")

dict_3g <- tbl_df(get.phrasetable(trigram))[1:2]
dict_3g$ngrams <- str_trim(dict_3g$ngrams)
eosTag <- str_detect(dict_3g$ngrams, "<EOS>")
dict_3g <- dict_3g[!eosTag,]
saveRDS(dict_3g, "dict_3g.Rds")

dict_4g <- tbl_df(get.phrasetable(fourgram))[1:2]
dict_4g$ngrams <- str_trim(dict_4g$ngrams)
eosTag <- str_detect(dict_4g$ngrams, "<EOS>")
dict_4g <- dict_4g[!eosTag,]
saveRDS(dict_4g, "dict_4g.Rds")

rm(list=ls())

##Model with 3 dictionaries and back off
dict_2g <- readRDS("dict_2g.Rds")
dict_3g <- readRDS("dict_3g.Rds")
dict_4g <- readRDS("dict_4g.Rds")

pred <- function(x){
    
    ##Check Stupid back-off 
    count <- wc(x)
    if (count >= 3){
        x <- word(x, -3, -1)
    }
    
    ##Cleaning inputs
    x <- tolower(x)
    x <- str_trim(x)
    x <- replace_contraction(x)
    x <- replace_abbreviation(x)
    index <- str_detect(dict_4g$ngrams, x)
    
    ##Trigger Stupid back-off
    while(sum(index) == 0){
        x <- word(x, -(wc(x) - 1), -1)
        index <- str_detect(dict_4g$ngrams, x)
    }
    
    ##Predict algorithm
    dict <- dict_4g[index,]
    top <- dict %>%
        arrange(desc(freq))
    results <- word(str_extract(top$ngrams, paste0(x, "\\s+\\w+")), -1, -1)
    results <- unique(results)
    results <- results[!is.na(results)]
    if(length(results) > 10){
        results <- results[1:10]
    }
    return(str_trim(results))
}


## Model with only 4grams library
pred <- function(x){
    
    ##Check Stupid back-off 
    count <- wc(x)
    if (count >= 3){
        x <- word(x, -3, -1)
    }
    
    ##Cleaning inputs
    x <- tolower(x)
    x <- str_trim(x)
    x <- replace_contraction(x)
    x <- replace_abbreviation(x)
    index <- str_detect(dict_4g$ngrams, x)
    
    ##Trigger Stupid back-off
    while(sum(index) == 0){
        x <- word(x, -(wc(x) - 1), -1)
        index <- str_detect(dict_4g$ngrams, x)
    }
    
    ##Predict algorithm
    dict <- dict_4g[index,]
    top <- dict %>%
        arrange(desc(freq))
    results <- word(str_extract(top$ngrams, paste0(x, "\\s+\\w+")), -1, -1)
    results <- unique(results)
    results <- results[!is.na(results)]
    if(length(results) > 10){
        results <- results[1:10]
    }
    return(str_trim(results))
}

##Model uses which instead of str_detect (SLOW!!!)
dict_2g$uni <- word(dict_2g$ngrams, 1, 1)
dict_3g$uni <- word(dict_3g$ngrams, 1, 1)
dict_3g$bi <- word(dict_3g$ngrams, 2, 2)

pred2 <- function(x){
    
    x <- clean_input(x)
    
    ##Check Stupid back-off
    count <- wc(x)
    if (count >= 2) {
        x <- word(x, -2, -1)
        dict <- dict_3g
    }
    
    index <- which(dict_3g$bi == x)
    
    ##Trigger Stupid back-off
    if(sum(index) == 0){
        x <- word(x, -(wc(x) - 1), -1)
        index <- which(dict_3g$uni == x)
        if(sum(index) == 0){
            dict <- dict_2g
            index <- which(dict_2g$uni == x)
        }
    }
    
    ##Predict algorithm
    dict <- dict[index,]
    top <- dict %>%
        arrange(desc(freq))%>%
        select(ngrams)
    results <- word(str_extract(top, paste0(x, "\\s+\\w+")), -1, -1)
    if(length(results) > 10){
        results <- results[1:10]
    }
    return(str_trim(results))
}
