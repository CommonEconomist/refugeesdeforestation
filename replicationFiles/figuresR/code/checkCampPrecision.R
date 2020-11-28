# last update 2019.11.21
# previous update 2018.09.04
library(countrycode)
library(cshapes)
library(sp)

d<-read.csv("rawdata/camps.csv")

# Indicator African countries 
d$continent<-countrycode(d$Country.of.asylum,
                         'country.name','continent',warn=TRUE)
d$iso3c<-countrycode(d$Country.of.asylum,
                     'country.name','iso3c',warn=TRUE)

# Correct CAR error
d$continent[is.na(d$continent) & 
             d$Country.of.asylum=='Central Africa Rep.']<-'Africa'
d$iso3c[is.na(d$iso3c) & 
              d$Country.of.asylum=='Central Africa Rep.']<-'CAF'

# Subset data
d<-d[d$continent=='Africa',]  # 9356/15,457
length(unique(d$Location.ID)) # 810 camp locations
x<-unique(d[,c(1,4,5)])       # unique camp locations

# NO COORDINATES
# Identify camps without geographic coordinates (N=399)
n<-as.vector(na.omit(unique(as.character(d$Location.name[is.na(d$Long)]))))
d1<-d[is.na(d$Long),] # 2638/9356

# These camps were geolocated using code 'geolocate_camps.R'
# This code does not function anymore due to changes to Google's API
# Add coordinates and precision here
cl<-read.csv("data/latlon-checked.csv")
cl<-cl[,c(1,4:6)]
colnames(cl)<-c('Location.ID','Long','Lat','where_prec')
d1$Long<-d1$Lat<-NULL

d1<-na.omit(merge(d1,cl,all.x=TRUE)) #add coordinates

# DATA ENTRY ERRORS
# Long-Lat has been switched in some cases

# Drop camps without coordinates
d<-d[!is.na(d$Long),] # 6718/9356
length(unique(d$Location.ID)) #N=410

# Unique camp locations per country
u<-unique(d[,c(1,4,5,9,10,35)]) # 410 camps
table(factor(u$Country.of.asylum))

# Get country boundaries
iso3c<-unique(u$iso3c)
N=length(iso3c)
b<-cshp(date=as.Date('2015-01-01'))

id<-c()
error<-c()

# Use for-loop: subset data to country i; find points outside polygon
for(i in 1:N){
  print(i)
  
  # Susbet data to camps in country i
  d2<-u[u$iso3c==iso3c[i],]
  coordinates(d2)<-~Long+Lat

  # Subset shapefile to country i
  m<-b[b$ISO1AL3 %in% iso3c[i],]
  
  # Locate coordinates within polygon
  d2$i=over(SpatialPoints(d2),SpatialPolygons(m@polygons),
             returnlist=TRUE) 
  
  # Set error to 1 if point is not within polygon
  d2$error<-ifelse(is.na(d2$i),1,0)
  
  # Write results to vector
  id<-c(id,d2$Location.ID)
  error<-c(error,d2$error)
}

sum(error) # 117 locations with errors

# ADJUST DATA ENTRY ERRORS
# Adjust longitude-latitude errors
# There are 117 camps with error. 
# A check shows that in these cases latitude and longitude were changed.
# https://www.gps-coordinates.net
# Need to swap coordinates for camps with errors
p0<-u[u$Location.ID %in% id[error==0],]
p1<-u[u$Location.ID %in% id[error==1],]
colnames(p1)[4:5]<-c('Lat','Long')
p1<-p1[,c(1:3,5,4,6)]
pts<-rbind(p0,p1)

# Add to original data
d$Long<-d$Lat<-NULL
d<-merge(d,pts[,c(1,4,5)],all.x=TRUE)

# Subset data known locations; remove camps with remaining errors
cc<-codelist
af<-b[b$ISO1AL3 %in% na.omit(cc$iso3c[cc$continent=='Africa']),]

# Location camps
un<-d
coordinates(un)<-~Long+Lat
un$nrow=over(SpatialPoints(un),SpatialPolygons(af@polygons),
               returnlist=TRUE)
un<-un[!is.na(un$nrow),] # 409 unique locations

# PLOT DATA
plot(af,lwd=.5)
plot(af[af$ISO1AL3 %in% un$iso3c,], col = "grey90", add = TRUE)
points(un, pch=19)

# PRECISION PER COUNTRY
# First run 'geolocate-camps.R'
# Add indicator for precision
#x$where_prec<-NA
#x[x$Location.ID %in% un$Location.ID, ]$where_prec<-1
#names(x)<-c('id','country','location','where_prec')

# Add other data
#x2<-read.csv('output/latlon-checked.csv')
#x<-rbind(na.omit(x),x2[,c(-4,-5)]) # N=808
#save(x,file='output/camp-precision.RData')

# Aggregate to country level
#x$i<-ifelse(x$where_prec<=3,1,0)
#s<-ddply(x,.(country),summarise,p=sum(i)/length(country),N=length(country))
#s<-s[order(-s$p),]
#write.csv(s,file='output/precision.csv',row.names=FALSE)

# Cleaned data
d<-d[d$Location.ID %in% un$Location.ID,]
d$where_prec<-1
camps<-rbind(d,d1)
camps<-camps[camps$where_prec<3,] 

save(camps,file = "data/camps.rda")

## FIN