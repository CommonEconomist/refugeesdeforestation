# last update 2019.11.21
# previous update 2018.03.23
library(plyr)
library(reshape2)
load("data/camps.rda")

# ORIGIN/DESTINATION | factor to character
camps$D<-as.character(camps$Country.of.asylum.code..UNHCR.)
camps$O<-as.character(camps$Origin.code..UNHCR)

# Indicator for situation type
camps$IDP<-ifelse(camps$D==camps$O,1,0) #212
camps$refugees<-ifelse(camps$Population=='Refugees' |
                         camps$Population=='People in refugee-like situations',
                       1,0)
camps$asylum<-ifelse(camps$Population=='Asylum-seekers',1,0)

# Aggregate
camp_population<-ddply(camps, .(Location.ID,Reporting.year), summarise,
                       total_camp = sum(grand.total, na.rm=TRUE),
                       refugees = sum(grand.total*refugees, na.rm = TRUE),
                       IDPs = sum(grand.total*IDP, na.rm = TRUE),
                       asylum = sum(grand.total*asylum, na.rm = TRUE))
# Housekeeping
colnames(camp_population)[2]<-'year'
camp_population$active<-1 #indicator reporting year

save(camp_population, file = "data/camp_population.rda")

## FIN