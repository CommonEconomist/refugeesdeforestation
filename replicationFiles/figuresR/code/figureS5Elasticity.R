# date created 2019.11.27
# last update  2019.11.27
beta<-c(0.00586, 0.00688,0.00374,0.00474, 
        7.77362, 7.67168, 5.66575, 5.22723,
        476.58792, 476.58792, 326.24699, 933.68188)
beta.se<-c(0.00194,0.00227,0.00215,0.00283,
           5.24677, 5.67591, 8.76125, 10.61321,
           215.78907, 215.78907, 296.50516, 496.01441)

y.avg<-c(0.2181785, 0.2183618,0.2179097,0.2181904,
         30.37524, 30.29832, 30.51675,30.5291,
         5020.411, 5020.411, 5156.953, 5030.829)
refugees.avg<-c(1682.348, 1570.455, 1277.712, 1284.611,
                1682.348, 1570.455, 1277.712, 1284.611,
                1768.938, 1768.938, 1531.458, 1538.185)


elasticity <- (beta/y.avg) * ((refugees.avg)/sqrt(refugees.avg^2+1)) 
elasticity.lwr<-((beta-1.96*beta.se)/y.avg) * 
  ((refugees.avg)/sqrt(refugees.avg^2+1)) 

elasticity.upr<-((beta+1.96*beta.se)/y.avg) *
  ((refugees.avg)/sqrt(refugees.avg^2+1)) 

# PLOT
par(mar=c(4,5,2,2), mfrow = c(1,3), las=1, bty='n', pty='s', 
    cex.main=2, cex.lab=1.8, cex.axis=1.5)

#
plot(elasticity[4:1], 1:4,
     xlim=c(min(elasticity.lwr[1:4]), max(elasticity.upr[1:4])), axes=F, 
     xlab="Elasticity", ylab="", main = "(a) EVI", pch=19, cex=2)
segments(elasticity.lwr[4:1], 1:4, elasticity.upr[4:1], 1:4,lwd=2)
axis(1, tick=F)
axis(2, tick=F, at=1:4, line =-1.5,
     label=rev(c("2000-16", "2000-15", "2000-12", "2001-12")))
abline(v=0)

#
plot(elasticity[8:5], 1:4,
     xlim=c(min(elasticity.lwr[5:8]), max(elasticity.upr[5:8])), axes=F, 
     xlab="Elasticity", ylab ="" ,main="(b) BAI", pch=19, cex=2)
segments(elasticity.lwr[8:5], 1:4, elasticity.upr[8:5], 1:4, lwd=2)
axis(1, tick=F)
abline(v=0)

#
plot(elasticity[12:9], 1:4,
     xlim=c(min(elasticity.lwr[9:12]), max(elasticity.upr[9:12])), axes=F, 
     xlab="Elasticity", ylab ="" ,main="(c) NPP", pch=19, cex=2)
segments(elasticity.lwr[12:9], 1:4, elasticity.upr[12:9], 1:4, lwd=2)
axis(1, tick=F)
abline(v=0)

## FIN