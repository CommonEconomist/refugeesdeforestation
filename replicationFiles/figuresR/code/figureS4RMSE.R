# date created 2019.11.22
# last update  2019.12.12
par(mar=c(5,5,2,2), las = 1, bty ="n", pty="s")

# Parameters
rmse0<-0.00960
t.stat<-abs(c(-2.55501, -10.31078, 26.98257, 3.02787))
rmse<-c(0.00960,0.00930,0.00989,0.00813)
rmse.d<-(rmse0-rmse)/rmse

# Plot
plot(t.stat, rmse.d, log = "x", axes = FALSE, pch = 19, cex = 2,
     xlab = "Cell-clustered statistical significance (absolute t-value)",
     ylab = "Change in explanatory power (RMSE)")
axis(1, tick = F)
axis(2, tick =F, line=-.5)

text(t.stat+c(.2,.4,-12,.2), rmse.d, adj=0, cex=1.2,
     c("Conflict", "Temperature", "Precipitation", "Refugees"))
abline(h=0, lty=3)

## FIN