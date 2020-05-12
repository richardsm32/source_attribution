# Source attribution for Campy Isolates
library(dplyr)
library(ggplot2)
# set a working directory (windows? - maybe switch to check linux)
setwd("C:/Users/richa/Documents/R/source_attribution")
getwd()

data <- read.csv("source_attribution_data.csv", fileEncoding = "UTF-8-BOM")

tdata <- tbl_df(data)

colnames(tdata)

# filter the data, removing subtypes only found once
# can use index positions....
# perhaps function to see if subtype id is repeated more than once?
# subset function, duplicated function

# to remove unique Subtype.Id -> a[duplicated(a) | duplicated(a, fromLast=TRUE)]

# Notes after finishing plyr and tidyr tutorial
# Use unique() and potentially include commands like - (negative)
# select for columns and filter for rows --> I will need filter
# also convert the df to a data table for better processing
# ALSO the chance to use group_by

# group by Subtype.ID
gdata <- group_by(tdata, Subtype.ID) %>% 
  mutate(Subtype_count = n()) %>% # add a column to find count of each Subtype.ID
  filter(Subtype_count > 1) %>% # filter out the unique subtypes
  group_by(Source) %>%
  mutate(Source_count = n()) %>%
  View() %>%
  mutate(prop = 1) # create a column for proportional data based on count??

fdata <- ungroup(gdata)

colnames(fdata)

# create data for each source as proportion of itself -> NO

### need to plot the subtype ID as x, y is Source/count?

# g <- ggplot(fdata, aes(ID, Source, density))+geom_histogram(stat = "count")
# g <- qplot(Subtype.ID, data = fdata, fill = Source)
# g

# better attempt, not ready yet
## g <- ggplot(fdata, aes(x = Subtype.ID, y = prop, fill = source_contribution))

