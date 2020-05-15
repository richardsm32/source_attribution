# Source attribution for Campy Isolates
library(tidyverse)
library(ggthemes)
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
ggdata <- arrange(ggdata, desc(`sum(ratio_cattle)`),
                  desc(`sum(ratio_chicken)`),
                  desc(`sum(ratio_human)`),
                  desc(`sum(ratio_water)`))

# used as a guide during the data processing, not necessary in final code
# View(ggdata)

## Attempting to use pivot to format ggdata
final_data <- pivot_longer(ggdata, starts_with('sum'),
                           names_to = "Source", values_to = "Ratio") %>%
  select(-Subtype.ID) %>%
  rename(Subtype_ID = `unique(Subtype.ID)`)

final_data$Subtype_ID <- as.character(final_data$Subtype_ID)

final_data <- mutate(final_data, Subtype_ID = factor(
  Subtype_ID, levels=unique(Subtype_ID)))


g <- ggplot(final_data, aes(x = Subtype_ID, y = Ratio, fill=Source)) +
  geom_bar(stat = "identity", width = 0.95) +
  ggtitle("Source Attribution Analysis") + 
  theme_economist() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
        axis.line.x = element_blank())

g

