#Using constant temperature, run multiple years

rm(list=ls())
#graphics.off()

library(devtools)
library(roxygen2)

parent_f='~/PCN2022/Rpackage/'
package_f='~/PCN2022/Rpackage/PCN/'

setwd(paste0(parent_f,'Demos/'))

load_all(package_f)


### Model settings
numYears=7 #number of years to simulate
simStartDay=90 #day of the year the simulation starts e.g. 1st April
initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density - used to calculate initial cysts (derivs, initialCinditions.R)


dev.new()

out=PCNmodel(numYears=numYears,
    simStartDay=simStartDay,
    initialEggsPerGram=initialEggsPerGram,
    soil.density = soil.density,
    plantingYears=seq(1,numYears,by=3),
    temperature.pars=list(
        temperatureSpline=NULL, 
        fixTemp = 14,
        deltaT = 0 
    ),
             )

    
plotPCN(out$solution,out$parms)
    
cysts.final=round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]))

#text(250,150,paste('Final number of cysts is',cysts.final),cex=1.5)

print(paste('final number of cysts is',cysts.final))


dev.copy2eps(file='~/PCN2022/Rpackage/Demos/Demo7.eps')

dev.new()
time=out$solution[,'time']
cysts=rowSums(out$solution[,c('C.pre','C','C.d')])
plot(time,cysts,type='l')
