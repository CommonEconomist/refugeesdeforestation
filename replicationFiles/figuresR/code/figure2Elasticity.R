# last update 2019.11.21
# Estimates
beta<-c(0.00586, 0.00733, 0.00496, 0.00485, 0.00591, 0.00954, 0.00528,0.00594)
beta.se<-c(0.00194, 0.00274, 0.00138, 0.00142, 0.00196, 
           0.00404, 0.00188, 0.00198)

# Sample averages
evi.avg<-c(0.2181785, 0.2181785, 0.2181785, 0.2181785, 0.2181678, 
          0.2189525, 0.2184058, 0.2181785)
refugees.avg<-c(1682.348, 1682.348, 1682.348, 1682.348, 1682.46,
                1853.241, 1712.812, 1682.348)

# Calculate elasticity
elasticity<- (beta/evi.avg) * ((refugees.avg)/sqrt(refugees.avg^2+1)) 

elasticity.lwr<-((beta-1.96*beta.se)/evi.avg) * 
  ((refugees.avg)/sqrt(refugees.avg^2+1)) 

elasticity.upr<-((beta+1.96*beta.se)/evi.avg) *
  ((refugees.avg)/sqrt(refugees.avg^2+1)) 

# PLOT
par(mar=c(5,5,2,2), las=1, bty='n', pty='s', cex.lab=1.8, cex.axis=1.5)
plot(elasticity, ylim=c(0, max(elasticity.upr)), axes=F, 
     xlab='Model specification', ylab='Elasticity', pch=19)
segments(1:8, elasticity.lwr, 1:8, elasticity.upr, lwd=2)
axis(2, tick=F, line=-1.2)
axis(1, tick=F, at=c(1:8), label=LETTERS[1:8])

## FIN