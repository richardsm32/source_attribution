# Source attribution for Campy Isolates
library(dplyr)
library(ggplot2)
library(tidyverse)
# set a working directory (windows - maybe switch to check linux)
setwd("C:/Users/richa/Documents/R/source_attribution")
getwd()

# read in the raw data file
raw_data <- read.csv("source_attribution_data.csv", fileEncoding = "UTF-8-BOM")

# convert to a data table for dplyr functions
tbl_data <- tbl_df(raw_data)

# group by Subtype ID, then remove all subtypes where there are less
# than 5 samples. Create ratio columns using mutate()
gdata <- group_by(tbl_data, Subtype.ID) %>%
  mutate(subtype_count = n()) %>%
  filter(subtype_count > 4) %>%
  mutate(ratio_chicken = 0, ratio_human = 0,
                 ratio_cattle = 0, ratio_water = 0)

# iterate through the data table and calculate the ratios for each
# source type. These are in the row for each sample (individual)
for (i in 1:nrow(gdata)) {
  if (gdata$Source[i] == "Chicken") {
    gdata$ratio_chicken[i] = 1/gdata$subtype_count[i]
  } else if (gdata$Source[i] == "Human") {
    gdata$ratio_human[i] = 1/gdata$subtype_count[i]
  } else if (gdata$Source[i] == "Cattle") {
    gdata$ratio_cattle[i] = 1/gdata$subtype_count[i]
  } else if (gdata$Source[i] == "Water") {
    gdata$ratio_water[i] = 1/gdata$subtype_count[i]
  } else {
    print("ERROR, row", i)
  }
}

# get the unique Subtype.IDs and sum of the source ratios for each
ggdata <- summarize(gdata, unique(Subtype.ID), sum(ratio_chicken),
                    sum(ratio_human), sum(ratio_cattle), 
                    sum(ratio_water))

# sort according to chicken, human, cattle, then water
ggdata <- arrange(ggdata, desc(ggdata$`sum(ratio_chicken)`),
                  desc(ggdata$`sum(ratio_human)`),
                  desc(ggdata$`sum(ratio_cattle)`))

# used as a guide during the data processing, not necessary in final code
View(ggdata)

# these methods were attempts to produce only the ratio data
# to be used in the y-axis
# ratios produces a list that combines all the columns into one
# 756 = 189*4
ratios <- c(ggdata$`sum(ratio_chicken)`, ggdata$`sum(ratio_human)`,
            ggdata$`sum(ratio_cattle)`, ggdata$`sum(ratio_water)`)

# sratios produces a list of 4 lists, each is 189 elements long
sratios <- c(ggdata[,3:6])

# this gives the 4 columns in a table form
tratios <- select(ggdata, starts_with("sum(ratio"))

View(ratios) # vector with 4*189 results
View(sratios) # list with length 4, each sub-list is 189
View(tratios) # 4 columns holding the ratio data in table

# I tried to use the columns/table format in the aes to graph all
# variable data, but this is not working

g <- ggplot(ggdata, aes(`unique(Subtype.ID)`, tratios)) +
  geom_bar(position = "fill", stat = "identity") +
  ggtitle("Source Attribution Analysis") +
  theme_gray()
  
g





# Below is junk from previous attempts, I didn't want to trash it yet

### need to plot the subtype ID as x, y is Source/count?

# g <- qplot(Subtype.ID, data = fdata, fill = Source)
# g

# better attempt, not ready yet
## g <- ggplot(fdata, aes(x = Subtype.ID, y = prop, fill = source_contribution))

