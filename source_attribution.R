# Source attribution for Campy Isolates
library(dplyr)

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

# isolate a list of the subtype IDs
sub <- data$Subtype.ID

# remove any single values from this list - only subtypes with multiple results remain
sub1 <- sub[duplicated(sub) | duplicated(sub, fromLast = TRUE)]

gdata <- group_by(tdata, Subtype.ID)

gdata

gdata_summary <- mutate(gdata,
                        count = n(),
                        unique = n_distinct(Source))
gdata_summary

gdata_filtered <- filter(gdata_summary, count > 1)

gdata_filtered

fdata <- ungroup(gdata_filtered)

View(fdata)

# NOT WORKING tdata1 <- filter(tdata, Subtype.ID == sub1)

# maybe combine the commands?

# NOT WORKING tdata2 <- filter(tdata, Subtype.ID == sub[duplicated(sub) | duplicated(sub, fromLast = TRUE)])

# create data for each source as proportion of itself
# plot(x = data$Key, y = data$Source)
# now work on ggplot2 to plot the data

