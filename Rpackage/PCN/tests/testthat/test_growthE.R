test_that("growthE >=0",{
    expect_gte(growthE(Temp=10),0)
})

test_that("growthE <= than when at Topt ",{
    expect_gt(growthE(Temp=18.7),growthE(Temp=15))
})

test_that("growthE <= than when at Topt ",{
    expect_gt(growthE(Temp=18.7),growthE(Temp=20))
})
