import sys
import numpy as np
data=np.loadtxt(sys.argv[1])
median = np.median(data)
upper_quartile = np.percentile(data, 75)
lower_quartile = np.percentile(data, 25)
iqr = upper_quartile - lower_quartile
upper_whisker = data[data<=upper_quartile+1.5*iqr].max()
lower_whisker = data[data>=lower_quartile-1.5*iqr].min()

print lower_whisker,lower_quartile,median,upper_quartile,upper_whisker

