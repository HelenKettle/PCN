simStartDay=0
plantingDOY=15
harvestingDOY=30
noPotatoYearsStart=2
noPotatoYearsFinish=3

test_that("potato 1", {
    expect_equal(potato(10,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsStart,noPotatoYearsFinish),0)
})


test_that("potato 2", {
    expect_equal(potato(20,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsStart,noPotatoYearsFinish),1)
})



