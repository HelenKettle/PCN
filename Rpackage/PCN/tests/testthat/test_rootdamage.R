max.root.length=100
P.i=1000


test_that("root damage for no pcn", {
    expect_equal(rootdamage(max.root.length, P.i=0),max.root.length)
})

test_that("root damage 1", {
    expect_lt(rootdamage(max.root.length, P.i=10),max.root.length)
})


test_that("root length decreases with Pi", {
    expect_gt(rootdamage(max.root.length, P.i=10),rootdamage(max.root.length, P.i=100))
})
