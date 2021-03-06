context("cellwise logger")

test_that("cellwise logging",{
   iris$sleutel <- 1:nrow(iris)
   logfile <- tempfile()
    i2 <- start_log(iris, log=cellwise$new(key="sleutel")) 
    i2 <- i2 %>>%  identity()    
    i2 <- i2 %>>% {.$Sepal.Length <- .$Sepal.Length*2; .}  
    i2 <- dump_log(i2, file=logfile, stop=TRUE) 
    expect_equal(nrow(read.csv(logfile)),nrow(iris))
})

test_that("cellwise",{
  d1 <- data.frame(sl = 1:3, x=1:3,y=letters[1:3])
  d2 <- d1
  expect_equal(nrow(celldiff(d1,d2,"sl")),0)
  
  d2 <- rbind(d1,d1)
  d2$sl <- seq_len(nrow(d2))
  expect_equal(nrow(celldiff(d1,d2,"sl")),6) 
  
  d2 <- d1
  d2$foo <- 3:1
  expect_equal(nrow(celldiff(d1,d2,"sl")),3)
  d2 <- d1
  d2[1,2] <- 2
  expect_equal(nrow(celldiff(d1,d2,"sl")),1)
})

