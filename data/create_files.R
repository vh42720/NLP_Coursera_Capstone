library(ngram)
library(dplyr)
library(readr)
library(qdap)
library(tm)
library(stringr)

##Create Massive Datasets 
## Do this if only you got enough computing power and time!
con <- file("./Coursera/John Hopskin R/Capstone/en_US/en_US.blogs.txt")
temp <- read_lines(con)
train <- round(0.6 * length(temp))
blogs <- temp[1:train]
blogs_test <- temp[(train+1):(train + train/3)]

con <- file("./Coursera/John Hopskin R/Capstone/en_US/en_US.twitter.txt")
temp <- read_lines(con)
train <- round(0.6 * length(temp))
twitter <- temp[1:train]
twitter_test <- temp[(train+1):(train + train/3)]

con <- file("./Coursera/John Hopskin R/Capstone/en_US/en_US.news.txt")
temp <- read_lines(con)
train <- round(0.6 * length(temp))
news <- temp[1:train]
news_test <- temp[(train+1):(train + train/3)]

final_corp <- c(blogs, twitter, news)
final_test <- c(blogs_test, twitter_test, news_test)

##Save corpus
write_lines(final_corp, "./final_corp.txt")
write_lines(final_test, "./final_test.txt")
rm(list=ls())

##Final Sample
con <- file("./en_US/en_US.blogs.txt")
temp <- read_lines(con)
blogs <- sample(temp, 70000)

con <- file("./en_US/en_US.twitter.txt")
temp <- read_lines(con)
twitter <- sample(temp, 70000)

con <- file("./en_US/en_US.news.txt")
temp <- read_lines(con)
news <- sample(temp, 70000)

final_sample <- c(blogs, twitter, news)
write_lines(final_sample, "./final_sample.txt")