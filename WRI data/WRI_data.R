#For WRI Visualization

library(data.table)
library(ggplot)
library(tidyr)

#co2 <- read.csv(file.choose(),skip=2, stringsAsFactors=F)
GHG <- read.csv('C:/Users/TRM/Documents/GitHub/D3 projects/WRI data/CAIT Country GHG Emissions.csv',
                skip=2, stringsAsFactors=F)
econ <- read.csv('C:/Users/TRM/Documents/GitHub/D3 projects/WRI data/CAIT Country Socio-Economic Data.csv',
                 skip=1, stringsAsFactors=F)

setDT(GHG)
setDT(econ)
#setDT(co2)

#top countries c('China', 'Russian Federation', 'Canada', 'United States', 'Japan','Mexico','Brazil','India',
#                'Indonesia', 'EU','Rest of World')

EU <- c('Austria','Belgium','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark','Estonia','Finland',
        'France','Germany','Greece','Hungary','Ireland','Italy','Latvia','Lithuania','Luxembourg',
        'Malta','Netherlands','Poland','Portugal','Romania','Slovakia','Slovenia','Spain','Sweden',
        'United Kingdom')

#Clean econ
countries <- unique(econ$Country)
EU %in% countries
econ[Country %in% EU]$Country <- 'EU'
econ <- econ[Country != 'European Union (28)']
econ <- econ[Country != 'European Union (15)']
econ <- econ[Country != 'World']
countries <- unique(econ$Country)
econ[!(Country %in% c('China', 'Russian Federation', 'Canada', 'United States', 'Japan','Mexico','Brazil','India',
                      'Indonesia', 'EU'))]$Country <- 'Rest of World'
econ_final <- econ[,lapply(.SD, sum, na.rm=TRUE), by=.(Country, Year)]
econ_final <- econ_final[, c(1,2,3,4), with=F]
names(econ_final) <- c('Country','Year','Population','GDP-PPP (Million Intl$ (2011))')


#Clean GHG
countries <- unique(GHG$Country)
EU %in% countries
GHG[Country %in% EU]$Country <- 'EU'
GHG <- GHG[Country != 'European Union (28)']
GHG <- GHG[Country != 'European Union (15)']
GHG <- GHG[Country != 'World']
countries <- unique(GHG$Country)
GHG[!(Country %in% c('China', 'Russian Federation', 'Canada', 'United States', 'Japan','Mexico','Brazil','India',
                      'Indonesia', 'EU'))]$Country <- 'Rest of World'
GHG_final <- GHG[,lapply(.SD, sum, na.rm=TRUE), by=.(Country, Year)]
GHG_final <- GHG_final[, c(1,2,3), with=F]
names(GHG_final) <- c('Country','Year','GHG Emissions (MtCo2e)')


#Clean co2
#countries <- unique(co2$Country)
#EU %in% countries
#co2[Country %in% EU]$Country <- 'EU'
#co2 <- co2[Country != 'European Union (28)']
#co2 <- co2[Country != 'European Union (15)']
#countries <- unique(co2$Country)
#co2[!(Country %in% c('China', 'Russian Federation', 'Canada', 'United States', 'Japan','Mexico','Brazil','India',
#                     'Indonesia', 'EU'))]$Country <- 'Rest of World'
#co2_final <- co2[,lapply(.SD, sum, na.rm=TRUE), by=.(Country, Year)]
#co2_final <- co2_final[, c(1,2,4), with=F]
#names(co2_final) <- c('Country','Year','CO2_emissions')


##Get 2000-2012 data

econ_final <- econ_final[Year >= 2000]
GHG_final <- GHG_final[Year >= 2000]

final <- merge(econ_final,
               GHG_final,
               by=c('Country','Year'))
names(final) <- c('Country','Year','Population','GDP','GHG')

##Set amounts as percent of total
final[,lapply(.SD, sum), by=.(Year), .SDcols=c('Population','GDP','GHG')]

final_int <- merge(final,
                   final[,lapply(.SD, sum), by=.(Year), .SDcols=c('Population','GDP','GHG')],
                   by=c('Year'))

final_int[,Pop2:=Population.x/Population.y]
final_int[,GDP2:=GDP.x/GDP.y]
final_int[,GHG2:=GHG.x/GHG.y]



final_int <- final_int[,c(1,2,9,10,11)]
names(final_int) <- c('Year','Country','Population','GDP','GHG')

#Reshape data for export

#final2012 <- final_int[Year==2012]

final <- gather(final_int, Type, Amount, Population,GDP,GHG)
final$Amount <- final$Amount * 100
final <- spread(final, Country, Amount)

write.csv(final,file='C:/Users/TRM/Documents/GitHub/D3 projects/WRI data/data.csv', row.names=F)
rm(econ,final_int,final12,final2012,GHG)

finalSort <- final[,c(1,2,5,13,6,7,12,9,3,8,4,10,11)]

write.csv(finalSort,file='C:/Users/TRM/Documents/GitHub/D3 projects/WRI data/dataSorted.csv', row.names=F)








