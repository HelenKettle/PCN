rm(list=ls())
graphics.off()

library(devtools)
library(roxygen2)

parent_f='~/PCN2022/Rpackage/'
package_f='~/PCN2022/Rpackage/PCN/'

setwd(paste0(parent_f,'Scripts/'))

load_all(package_f)

document(package_f)

build(package_f)

install(package_f)

#setwd('PCN')
#usethis::use_testthat()
#use_test()


#library(PCN)

?PCNmodel

### Model settings
numYears=1 #number of years to simulate
simStartDay=0 #day of the year the simulation starts

initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density - used to calculate initial cysts (derivs, initialCinditions.R)
plantingDOY=90 # potatoes planted on this day of the year
harvestingDOY=216 # potatoes harvested on this day of the year
noPotatoYearsList=list(c(start=2,fin=3)) # Choose years not to plant potatoes. Can compare the different strategies by adding more to this list. For continuous planting use c(start=0,fin=0).

# For the temperature inputs below there are a few options:
# 1. provide a spline fitted to an observed temperature species, which must be passed to temperaturefile
# 2. specify a fixed temperature in degrees celsius to the fixTemp argument. If specifying a fixed temperature then a vector can be input to study multiple temperatures.  A single value will run the model once for that value.
# 3. if both temperaturefile and fixTemp are left NULL then a sinusoidal temperature function will be assumed.  The sinusoidal function assumes a mean of 13 celsius and amplitude of 2 degrees.  To change this the user must do so in the tempFunc.R file.
temperaturefile=NULL # Can also input a spline through temperature datapoints
fixTemp = 14
deltaT = 0 # apply this temperature change over the baseline.  

out=PCNmodel(numYears=numYears,
    simStartDay=simStartDay,
    initialEggsPerGram=initialEggsPerGram,
    soil.density = soil.density)

