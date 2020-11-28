# last update 2019.11.22
library(cshapes)
library(countrycode)
b<-cshp(date=as.Date('2015-01-01'))
cc<-codelist
af<-b[b$ISO1AL3 %in% na.omit(cc$iso3c[cc$continent=='Africa']),]
load("data/camps.rda")
coordinates(camps)<-~Long+Lat

par(mar=c(0,0,0,0))
plot(af,lwd=.5)
plot(af[af$ISO1AL3 %in% camps$iso3c,], col = "grey90", add = TRUE)
points(camps, pch=19)
