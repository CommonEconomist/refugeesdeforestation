# last update 2019.11.21
# Estimates
beta<-c(-0.00130, -0.00141, -0.00359, -0.00313,
        0.01150, 0.01169, 0.01755, 0.01178)
beta.se<-c(0.00143, 0.00132, 0.00155, 0.00152, 
           0.00560, 0.00568, 0.01015, 0.00778)

# Sample averages
evi.avg<-c(0.2164842, 0.2168393, 0.2169862, 0.2171596,
           0.2193645, 0.2193689, 0.2195199, 0.2196341)
refugees.avg<-c(1078.666, 1062.383, 1052.142, 1044.496,
                2104.926, 2233.429, 2391.331, 2593.565)

# Calculate elasticity
elasticity<- (beta/evi.avg) * ((refugees.avg)/sqrt(refugees.avg^2+1)) 
elasticity.lwr<-((beta-1.96*beta.se)/evi.avg) *
  ((refugees.avg)/sqrt(refugees.avg^2+1)) 
elasticity.upr<-((beta+1.96*beta.se)/evi.avg) *
  ((refugees.avg)/sqrt(refugees.avg^2+1)) 

# PLOT
par(mar=c(5,5,2,2), las=1, bty='n', pty='s', cex.lab=1.8, cex.axis=1.5)
plot(rev(elasticity), 1:8, xlim=c(min(elasticity.lwr), max(elasticity.upr)),
     axes=F, xlab='Elasticity', ylab='', type="n")
abline(v=0, lty=3, lwd=2)
segments(rev(elasticity.lwr), 1:8, rev(elasticity.upr), 1:8, lwd=2)
points(rev(elasticity), 1:8, pch=19)
axis(2, tick=F, at=1:8, 
     label=rev(c("2000-06", "2000-07", "2000-08", "2000-09",
                 "2007-16", "2008-16", "2009-16", "2010-16")))
axis(1, tick=F)

## FIN