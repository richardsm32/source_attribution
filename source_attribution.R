# Source attribution for Campy Isolates
library(dplyr)
library(ggplot2)
library(tidyverse)
# set a working directory (windows - maybe switch to check linux)
setwd("C:/Users/richa/Documents/R/source_attribution")
getwd()

data <- read.csv("source_attribution_data.csv", fileEncoding = "UTF-8-BOM")

tdata <- tbl_df(data)

colnames(tdata)

gdata <- group_by(tdata, Subtype.ID) %>%
  mutate(subtype_count = n()) %>%
  filter(subtype_count > 4)

gdata <- mutate(gdata, ratio_chicken = 0, ratio_human = 0,
                 ratio_cattle = 0, ratio_water = 0)

dim(gdata)[1]

nrow(gdata)

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
    print("Something is wrong, row", i)
  }
}

ggdata <- summarize(gdata, unique(Subtype.ID))

View(ggdata)

View(gdata)

# sort according to proportion of chicken??


# create data for each source as proportion of itself -> NO

### need to plot the subtype ID as x, y is Source/count?

# g <- ggplot(fdata, aes(ID, Source, density))+geom_histogram(stat = "count")
# g <- qplot(Subtype.ID, data = fdata, fill = Source)
# g

# better attempt, not ready yet
## g <- ggplot(fdata, aes(x = Subtype.ID, y = prop, fill = source_contribution))

