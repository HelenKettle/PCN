Temp=10
tauE=8

test_that("growthJ >=0",{
    expect_gte(growthJ(Temp,tauE),0)
})

test_that("growthJ >=0",{
    expect_gte(growthJ(Temp,tauE=1000),0)
})

test_that("growthJ is less at not T_opt",{
    expect_gte(growthJ(Temp=20.7,tauE),growthJ(Temp=10,tauE))
})

test_that("growthJ is less at not T_opt",{
    expect_gte(growthJ(Temp=20.7,tauE),growthJ(Temp=30,tauE))
})

test_that("growthJ faster for longer tauE",{ #as less time for tauJ
    expect_gt(growthJ(Temp=20.7,tauE=10),growthJ(Temp=20.7,tauE=1))
})


