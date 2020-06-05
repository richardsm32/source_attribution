import plotly.graph_objects as go
import plotly.io as pio
import plotly.express as px
import pandas as pd
import numpy as np

# px.defaults.template = 'plotly_dark'

# also import the OG data for some work with pandas
df = pd.read_csv('source_attribution_data.csv')
df.head()

# PROCESS FROM R: 
# group_by Subtype_ID
# mutate to add subtype_count
# FILTER OUT LOW COUNTS (slider???!?!?)
# mutate to add columns

# for loop through data, calculate the proportion for EACH isolate
# summarize into data_summary
# mutate to add col for dom source and proportion
# rename for simplicity
# for loop to determine dom source and proportion
# arrange data
# pivot
# as characters
# set factor levels


'''
sp = pd.read_csv('source_prop.csv') 
sp.Subtype_ID = sp.Subtype_ID.apply(str)
sp.head()
sp.dtypes

ds = pd.read_csv('data_summary.csv')

data = {'x': [0, 1, 4, 5, 7, 9], 
        'y': [1, 2, 3, 4, 5, 6]}
sample = pd.DataFrame(data)
sample.head()

test_fig = px.bar(sample, x='x', y='y')

test_fig.show()

fig1 = px.bar(sp, x='Subtype_ID', y='Ratio', color='Source',
              barmode='stack')

fig1.show()

fig2 = px.scatter_3d(ds, x='sum_chicken', y='sum_human', z='sum_cattle',
 color='dom_source', size='repl_subtype', size_max=80,
 labels={'sum_chicken':'Ratio chicken vs. other', 'sum_human':'Proportion Human'})

fig2.show()


# work through tutorials then generate the same graphs as in R
'''
'''JUNKYARD

# iterate through the Subtype_ID column, adding any missing values?
# find the missing subtype numbers, create a list then add to df
# with NaN as entry values
sp = pd.concat([pd.DataFrame([i], columns=['Subtype_ID']) for i in range(2281)],
              ignore_index=True)
sp.head()
sp.describe()

# opacity='dom_prop'

# fig1.update_layout(xaxis=)
# category_orders={'trace':'Subtype_ID'})

g <- ggplot(source_prop, aes(x = Subtype_ID, y = Ratio, fill=Source)) +
  geom_bar(stat = "identity", width = 0.95) +

'''
