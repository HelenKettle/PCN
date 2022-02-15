# Resistance: Note, no known potato varieties have complete resistance to pallida
resistanceFactor=c(rosto=0,'pallida'=0)

#fraction that hatch at the optimum temperature
optHatch=c('pallida'=0.88,'rosto'=0.65) # pallida 0.88

eggs_per_cyst=300

cyst.pause = 42

# DE 08/07 split to allow different stage durations for males and females
adultmaleStageDuration=21 #days
adultfemaleStageDuration=21 #days

plantingDOY=21
harvestingDOY=126

initialEggsPerGram = 10

N.plants=3

cystDeathRate = 0.0005

dormancy = 0.0005

#DE update 05/07/19 to add number of plants as a parameter
N.Plants = 3

#DE update 26/07/19 to add length of roots for a given potato plant
plant.max.root.length = 2860

half.root.growth = 50
root.growth.rate = 0.1

soil.density = 1.5
roots.per.cm = 1

#DE update 26/07/19 to add soil mass parameter.  Calculated as the total length of roots divided by 5 (cm root per gram soil from: 
#Junichi Yamaguchi & Akira Tanaka (1990) Quantitative observation on the rootsystem of various crops growing in the field, 
#Soil Science and Plant Nutrition, 36:3, 483-493, DOI:10.1080/00380768.1990.10416917) and multiplied by 1.5 to account for soil density.
soil.mass = N.Plants*plant.max.root.length/roots.per.cm*soil.density

#specify stage compartments
#in future write function to get k from mean time delay and std for each stage
#kEvec=c('pallida'=4,'rosto'=3)
kEvec=c('pallida'=20,'rosto'=3)
kJ = 20 #6
kA = 50

# DE 09/07 Add option to input temperature data
temperature.data = read.csv("//212.219.57.223/HomeDirVol/dewing/My_files/Research/PCN/Data/Harper Adams Soil Temperatures.csv")
#temperature.data = read.csv("//212.219.57.223/HomeDirVol/dewing/My_files/Research/PCN/Data/Luffness Soil Temperatures.csv")
temperature.data = na.omit(temperature.data)
spline.temp = smooth.spline(temperature.data$Observation, temperature.data$Temperature, cv=TRUE)
temperaturefile=spline.temp
#temperaturefile=NULL