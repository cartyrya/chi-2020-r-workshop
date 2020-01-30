## Introduction ####



## R and RStudio ####



## Text Analysis ####

## I took the following code from Taylor Arnold and Lauren Tilton, "Basic Text Processing in R," The Programming Historian 6 (2017), https://programminghistorian.org/en/lessons/basic-text-processing-in-r.

## The goal is to turn a corpus of text into numbers and see what happens.

## Install Packages

install.packages("tidyverse")
install.packages("tokenizers")

## Load packages

library(tidyverse)
library(tokenizers)

## Load corpus of text. The state of the union addresses by US presidents.

files <- dir(path = "data/sotu-text", full.names = TRUE)
text <- c()
for (f in files) {
  text <- c(text, paste(readLines(f), collapse = "\n"))
}

view(text)
print(text[1])

metadata <- read_csv(file = "data/sotu-text-metadata.csv")
view(metadata)
summary(metadata)

## Stylometric analysis

sentences <- tokenize_sentences(text)
print(sentences[1])

sentence_words <- sapply(sentences, tokenize_words)
print(sentence_words[1])

sentence_length <- list()
for (i in 1:nrow(metadata)) {
  sentence_length[[i]] <- sapply(sentence_words[[i]], length)
}
print(sentence_length[1])

sentence_length_median <- sapply(sentence_length, median)
view(sentence_length_median)

qplot(metadata$year, sentence_length_median)

qplot(metadata$year, sentence_length_median) +
  geom_smooth()

## Remove objects

rm(list=ls())

## Tabular Data ####

## The goal is to look through a large dataset and see what could be interesting.

## Install packages

install.packages("jsonlite")

## Load packages

library("tidyverse")
library("jsonlite")

## Load data

actd <- read.csv("data/actd_edit.csv", header=TRUE)

view(actd)
summary(actd)

## Find something interesting

summary(actd$product.description, maxsum = 10)
summary(actd$country.description[actd$product.description == "Groundnuts"], maxsum = 10)
summary(actd$unit.metric[actd$product.description == "Groundnuts"], maxsum = 5)

## Groundnut Exports from all African Territories

groundnuts <- droplevels(subset(actd, product.description == "Groundnuts" & unit.metric == "KG"))

ggplot(groundnuts, aes(x = year, y = quantity.metric)) + geom_point()

## Groundnut Exports from the Gambia

ggplot(subset(groundnuts, country.description == "Gambia, The"), aes(x = year, y = quantity.metric)) + geom_point(color = "black")

## Groundnut Exports from Senegal

ggplot(subset(groundnuts, country.description == "Senegal"), aes(x = year, y = quantity.metric)) + geom_point(color = "black")

## Export

write.csv(subset(groundnuts, country.description == "Senegal"), "output/groundnuts-senegal.csv", row.names = FALSE)

write_lines(toJSON(subset(groundnuts, country.description == "Senegal")), "output/groundnuts-senegal.json")

## Remove objects

rm(list=ls())
