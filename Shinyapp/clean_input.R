clean_input <- function(x){
    x <- replace_contraction(x)
    x <- replace_abbreviation(x)
    x <- tolower(x)
    x <- replace_number(x)
    x <- str_trim(x)
}