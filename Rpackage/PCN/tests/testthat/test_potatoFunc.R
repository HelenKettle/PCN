simStartDay=0
plantingDOY=15
harvestingDOY=30

test_that("potato: no potatoes before planting in first year", {
    expect_equal(potatoFunc(10,simStartDay,plantingDOY,harvestingDOY),0)
})


test_that("potato: potatoes after planting", {
    expect_equal(potatoFunc(20,simStartDay,plantingDOY,harvestingDOY),1)
})


t=365+plantingDOY+1
test_that("potato: no potatoes in fallow year", {
    expect_equal(potatoFunc(t,simStartDay,plantingDOY,harvestingDOY,plantingYears=c(1,3)),0)
})

t=365*2+plantingDOY+1
test_that("potato: potatoes after fallow year", {
    expect_equal(potatoFunc(t,simStartDay,plantingDOY,harvestingDOY,plantingYears=c(1,3)),1)
})





