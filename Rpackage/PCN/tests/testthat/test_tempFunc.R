t=10
simStartDay=0


test_that("tempFunc sine wave: increases with deltaT",{
    expect_lt(tempFunc(t,deltaT=1,simStartDay),tempFunc(t,deltaT=3,simStartDay))
})

test_that("tempFunc sine wave: winter colder than summer",{
    expect_gt(tempFunc(t=150,deltaT=0,simStartDay),tempFunc(t=10,deltaT=0,simStartDay))
})

#tests for spline temperature-----------------------
time.data=seq(0,numYears*365+10)
temp.data=NA*time.data
for (i in 1:length(time.data)){
    temp.data[i]= 13 + 2*sin(2*pi*(time.data[i]%%365-100)/365)+rnorm(1,0,5)
}
temp.spline=smooth.spline(temp.data)

test_that("tempFunc spline: winter colder than summer",{
    expect_gt(tempFunc(t=150,deltaT=0,simStartDay=0,temperatureSpline=temp.spline),tempFunc(t=10,deltaT=0,simStartDay=0,temperatureSpline=temp.spline))
})

test_that("tempFunc spline: increases with deltaT",{
    expect_gt(tempFunc(t=100,deltaT=3,simStartDay=0,temperatureSpline=temp.spline),tempFunc(t=100,deltaT=0,simStartDay=0,temperatureSpline=temp.spline))
})
