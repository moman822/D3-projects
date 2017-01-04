#For WRI Visualization

library(data.table)
library(ggplot)
library(tidyr)

GHG <- read.csv(file.choose(),skip=2, stringsAsFactors=F)
co2 <- read.csv(file.choose(),skip=1, stringsAsFactors=F)
econ <- read.csv(file.choose(),skip=1, stringsAsFactors=F)

setDT(GHG)
setDT(econ)
setDT(co2)

























