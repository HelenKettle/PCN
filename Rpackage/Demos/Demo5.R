#Using constant temperature, change number of plants

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


dev.new(width=13,height=6)
par(mfrow=c(1,3))

for (n in 1:3){

    out=PCNmodel(numYears=numYears,
        simStartDay=simStartDay,
        initialEggsPerGram=initialEggsPerGram,
        soil.density = soil.density,
        temperature.pars=list(
            temperatureSpline=NULL, 
            fixTemp = NA,
            deltaT = 0 
        ),
    plant.pars=list(
        resistanceFactor = 0, # resistance factor of potatoes
        N.plants = n, # Number of potato plants
        root.length = 500, # maximum length of plant roots (cm) in healthy plant
        roots.per.cm = 0.5 # root length density of potato plants
    )
                 )
    
    
    plotPCN(out$solution,out$parms,ylim=c(0,800),main=paste(n,'potato plants'))
    
    cysts.final=round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]))
    
    text(250,400,paste('Final number of cysts is',cysts.final),cex=1.5)

    print(paste('final number of cysts is',cysts.final))

}

dev.copy2eps(file='~/PCN2022/Rpackage/Demos/Demo5.eps')
