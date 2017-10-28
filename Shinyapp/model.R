dict_2g <- readRDS("./data/dict_2g.Rds")
dict_3g <- readRDS("./data/dict_3g.Rds")
dict_4g <- readRDS("./data/dict_4g.Rds")
source("./data/clean_input.R")


pred <- function(x){
    
    ##Check Stupid back-off
    count <- wc(x)
    if(count == 1){
        dict <- dict_2g
    } else if (count == 2){
        dict <- dict_3g
    } else if (count >= 3){
        dict <- dict_4g
        x <- word(x, -3, -1)
    } 
    
    ##Cleaning inputs
    x <- clean_input(x)
    pattern <- paste0("^", x, "\\s+")
    index <- str_detect(dict$ngrams, pattern)
    
    ##Trigger Stupid back-off
    while(sum(index) == 0){
        x <- word(x, -(wc(x) - 1), -1)
        pattern <- paste0("^", x, "\\s+")
        count <- wc(x)
        if(count == 1){
            dict <- dict_2g
        } else if (count == 2){
            dict <- dict_3g
        }
        index <- str_detect(dict$ngrams, pattern)
    }
    
    ##Predict algorithm
    dict <- dict[index,]
    top <- dict %>%
        arrange(desc(freq))
    results <- word(str_extract(top$ngrams, paste0(x, "\\s+\\w+")), -1, -1)
    if(length(results) > 10){
        results <- results[1:10]
    }
    results <- str_trim(results)
    results <- as.data.frame(results)
    names(results) <- "Prediction"
    return(results)
}
