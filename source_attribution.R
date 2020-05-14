# Source attribution for Campy Isolates
library(dplyr)
library(ggplot2)
library(tidyverse)
# set a working directory (windows - maybe switch to check linux)
setwd("C:/Users/richa/Documents/R/source_attribution")
getwd()

raw_data <- read.csv("source_attribution_data.csv", fileEncoding = "UTF-8-BOM")

tbl_data <- tbl_df(raw_data)

gdata <- group_by(tbl_data, Subtype.ID) %>%
  mutate(subtype_count = n()) %>%
  filter(subtype_count > 4) %>%
  mutate(ratio_chicken = 0, ratio_human = 0,
                 ratio_cattle = 0, ratio_water = 0)

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

gdata <- group_by(gdata, Subtype.ID)

ggdata <- summarize(gdata, unique(Subtype.ID), sum(ratio_chicken),
                    sum(ratio_human), sum(ratio_cattle), 
                    sum(ratio_water))

ggdata <- arrange(ggdata, desc(ggdata$`sum(ratio_chicken)`),
                  desc(ggdata$`sum(ratio_human)`),
                  desc(ggdata$`sum(ratio_cattle)`))

View(ggdata)

ratios <- c(ggdata$`sum(ratio_chicken)`, ggdata$`sum(ratio_human)`,
            ggdata$`sum(ratio_cattle)`, ggdata$`sum(ratio_water)`)

sratios <- c(ggdata[,3:6])

tratios <- select(ggdata, starts_with("sum(ratio"))

View(ratios) # list with length 4, each sub-list is 189
View(sratios) # vector with 4*189 results
View(tratios)

g <- ggplot(ggdata, aes(`unique(Subtype.ID)`, tratios)) +
  geom_bar(position = "fill", stat = "identity") +
  ggtitle("Source Attribution Analysis") +
  theme_gray()
  
g


### need to plot the subtype ID as x, y is Source/count?

# g <- qplot(Subtype.ID, data = fdata, fill = Source)
# g

# better attempt, not ready yet
## g <- ggplot(fdata, aes(x = Subtype.ID, y = prop, fill = source_contribution))

