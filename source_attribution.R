# Source attribution for Campy Isolates
library(tidyverse)
library(ggthemes)

### Need to implement the 'here' library
# set a working directory (windows - maybe switch to check linux)
setwd("C:/Users/richa/Documents/R/source_attribution")

# read in the raw data file
### Change to readr function read_csv
data <- read_csv("source_attribution_data.csv")

# group by Subtype ID, then remove all subtypes where there are less
# than 5 samples. Create ratio columns using mutate()
data <- group_by(data, Subtype_ID) %>%
  mutate(subtype_count = n()) %>%
  filter(subtype_count > 24) %>%
  mutate(prop_chicken = 0, prop_human = 0,
         prop_cattle = 0, prop_water = 0,
         human_count = 0, other_count = 0)

# iterate through the data table and calculate the ratios for each
# source type. These are in the row for each sample (individual)
for (i in 1:nrow(data)) {
  if (data$Source[i] == "Chicken") {
    data$prop_chicken[i] = 1/data$subtype_count[i]
    data$other_count[i] = 1
  } else if (data$Source[i] == "Human") {
    data$prop_human[i] = 1/data$subtype_count[i]
    data$human_count[i] = 1
  } else if (data$Source[i] == "Cattle") {
    data$prop_cattle[i] = 1/data$subtype_count[i]
    data$other_count[i] = 1
  } else if (data$Source[i] == "Water") {
    data$prop_water[i] = 1/data$subtype_count[i]
    data$other_count[i] = 1
  } else {
    print("ERROR, row", i)
  }
}

# get the unique Subtype.IDs and sum of the source ratios for each
ggdata <- summarize(data, unique(Subtype_ID), sum(prop_chicken),
                    sum(prop_human), sum(prop_cattle), 
                    sum(prop_water), sum(human_count), 
                    sum(other_count))

# sort according to chicken, human, cattle, then water
ggdata <- arrange(ggdata, desc(`sum(prop_cattle)`),
                  desc(`sum(prop_chicken)`),
                  desc(`sum(prop_human)`),
                  desc(`sum(prop_water)`))


# used as a guide during the data processing, not necessary in final code
# View(ggdata)

## Attempting to use pivot to format ggdata
source_prop <- pivot_longer(ggdata, starts_with('sum(prop'),
                           names_to = "Source", values_to = "Ratio") %>%
  select(-Subtype_ID) %>%
  rename(Subtype_ID = `unique(Subtype_ID)`)

source_prop$Subtype_ID <- as.character(source_prop$Subtype_ID)

source_prop <- mutate(source_prop, Subtype_ID = factor(
  Subtype_ID, levels=unique(Subtype_ID)))


g <- ggplot(source_prop, aes(x = Subtype_ID, y = Ratio, fill=Source)) +
  geom_bar(stat = "identity", width = 0.95) +
  ggtitle("Source Attribution Analysis") + 
  theme_economist() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
        axis.line.x = element_blank())

g

# Now for the 2nd figure - the assignment
# >>A bubble graph showing the degree of non-human
# and human source association among chicken subtypes.
# In our case, for a bubble graph, we would be 
# interested in the ratio of human vs other.
# need proportion of human for y-axis
# need ratio of human vs. other for x-axis

# both can be obtained from ggdata...
# ratio human is already calculated
# ratio_human vs other is number of human sources vs NON-HUMAN
# ie. if no human --> add to other
# if human (any) --> count in human
# ratio is other vs human??? or human vs other??
# had already done this.
## needs to go back a bit farther





