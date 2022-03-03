#use temperature measurements (splined)

rm(list=ls())
#graphics.off()

library(devtools)
library(roxygen2)

parent_f='~/PCN2022/Rpackage/'
package_f='~/PCN2022/Rpackage/PCN/'

setwd(paste0(parent_f,'Demos/'))

load_all(package_f)


### Model settings
numYears=1 #number of years to simulate
simStartDay=50 #day of the year the simulation starts e.g. 1st April
initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density - used to calculate initial cysts (derivs, initialCinditions.R)

#make up some temperature data
time.data=seq(0,numYears*365+10)
temp.data=NA*time.data
for (i in 1:length(time.data)){
    temp.data[i]= 15 + 3*sin(2*pi*(time.data[i]%%365-100)/365)+rnorm(1,0,5)
}
#fit spline
temp.spline=smooth.spline(temp.data)

dev.new(width=10,height=6)
par(mfrow=c(1,2))
    
plot(time.data,temp.data,type='l',xlab='Julian days',ylab='soil temperature (oC)')
lines(temp.spline$x,temp.spline$y,col='red',lwd=2)
legend('bottom',legend=c('data','spline'),col=c('black','red'),lty=1)

out=PCNmodel(numYears=numYears,
    simStartDay=simStartDay,
    initialEggsPerGram=initialEggsPerGram,
    soil.density = soil.density,
    temperature.pars=list(
        temperatureSpline=temp.spline, 
        fixTemp = NA,
        deltaT = 0 # apply this temperature change over the baseline.  
    )
             )

plotPCN(out$solution,out$parms)
cysts.final=round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]))   
text(250,100,paste('Final number of cysts is',cysts.final),cex=1.2)
print(paste('final number of cysts is',cysts.final))

dev.copy2eps(file='~/PCN2022/Rpackage/Demos/Demo3.eps')
