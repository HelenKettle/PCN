speciesVec=c('rosto','pallida')[2]#[1:2]#[1] etc
tempChangeVec=0#c(0,2)#[1:2]#[2] etc

#Choose years not to plant potatoes. Can compare the different strategies by adding more to this list. For automatic plotting, only run for one PCN species at a time (make sure length(speciesVec)=1). For continuous planting use c(start=0,fin=0).
noPotatoYearsList=list(c(start=2,fin=6))#list(c(start=2,fin=6))#,c(start=2,fin=6))#,c(start=2,fin=15))

numYears=30#20/52 #number of years to simulate
simStartDay=0 #day of the year the simulation starts (Dave 182.5) (note time in equations always runs from 0 but simulation can start on any day)

#Choose what to plot
plotAbundance=1
plotStages=1
comparePotatoPresence=1
compareSpeciesAndTemp=0
runQuickPlot=1

runModel=1

saveFig=TRUE
figType='png'

# DE 09/07 Add option to input temperature data
temperature.data = read.csv("./Data/Harper_Adams_Soil_Temperatures.csv")
#temperature.data = read.csv("./Data/Luffness_Soil_Temperatures.csv")
temperature.data = na.omit(temperature.data)
spline.temp = smooth.spline(temperature.data$Observation, temperature.data$Temperature, cv=TRUE)
temperaturefile=spline.temp

N.Plants = 3