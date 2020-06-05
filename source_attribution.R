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
  filter(subtype_count > 14) %>%
  mutate(prop_chicken = 0, prop_human = 0,
         prop_cattle = 0, prop_water = 0)

# iterate through the data table and calculate the ratios for each
# source type. These are in the row for each sample (individual)
for (i in 1:nrow(data)) {
  if (data$Source[i] == "Chicken") {
    data$prop_chicken[i] = 1/data$subtype_count[i]
  } else if (data$Source[i] == "Human") {
    data$prop_human[i] = 1/data$subtype_count[i]
  } else if (data$Source[i] == "Cattle") {
    data$prop_cattle[i] = 1/data$subtype_count[i]
  } else if (data$Source[i] == "Water") {
    data$prop_water[i] = 1/data$subtype_count[i]
  } else {
    print("ERROR, row", i)
  }
}

# may need quick function to go through the source and select which is dominant
# and record the ratio --> no because then it's two things....

# get the unique Subtype.IDs and sum of the source ratios for each
data_summary <- summarize(data, unique(Subtype_ID), sum(prop_chicken),
                    sum(prop_human), sum(prop_cattle), 
                    sum(prop_water), mean(subtype_count)) %>%
  mutate(dom_source = 'string', dom_prop = 1)

data_summary <- data_summary %>%
  select(-Subtype_ID) %>%
  rename(Subtype_ID = `unique(Subtype_ID)`, sum_chicken = `sum(prop_chicken)`,
         sum_human = `sum(prop_human)`, sum_cattle = `sum(prop_cattle)`,
         sum_water = `sum(prop_water)`, repl_subtype = `mean(subtype_count)`)

# this feels pretty sloppy, look at more efficient max algorithm after
for (i in 1:nrow(data_summary)) {
  max = 0
  if (data_summary$sum_cattle[i] >= max) {
    max <- data_summary$sum_chicken[i]
    data_summary$dom_source[i] = "Chicken"
  }
  if (data_summary$sum_human[i] >= max) {
    max <- data_summary$sum_human[i]
    data_summary$dom_source[i] = "Human"
  } 
  if (data_summary$sum_cattle[i] >= max) {
    max <- data_summary$sum_cattle[i]
    data_summary$dom_source[i] = "Cattle"
  }
  if (data_summary$sum_water[i] >= max) {
    max <- data_summary$sum_water[i]
    data_summary$dom_source[i] = "Water"
  }
  data_summary$dom_prop[i] <- max
}

# sort according to chicken, human, cattle, then water
data_summary <- arrange(data_summary, desc(sum_cattle),
                  desc(sum_chicken),
                  desc(sum_human),
                  desc(sum_water))


# used as a guide during the data processing, not necessary in final code
# View(ggdata)

## Attempting to use pivot to format ggdata
source_prop <- pivot_longer(data_summary, starts_with('sum'),
                           names_to = "Source", values_to = "Ratio") %>%
  select(-dom_source, -dom_prop)

source_prop$Subtype_ID <- as.character(source_prop$Subtype_ID)

source_prop <- mutate(source_prop, Subtype_ID = factor(
  Subtype_ID, levels=unique(Subtype_ID)))

# barplot showing source attribution

g <- ggplot(source_prop, aes(x = Subtype_ID, y = Ratio, fill=Source)) +
  geom_bar(stat = "identity", width = 0.95) +
  ggtitle("Source Attribution Analysis") + 
  theme_economist() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
        axis.line.x = element_blank())

g

# bubble chart

h <- ggplot(data_summary, aes(x = sum_chicken, y = sum_human,
                              size = repl_subtype, color = dom_source,
                              fill = dom_prop)) + 
  geom_point(alpha = 0.7)

h

write_csv(source_prop, path = 'source_prop.csv')
write_csv(data_summary, path = 'data_summary.csv')

