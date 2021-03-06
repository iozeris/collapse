context("fsum")

rm(list = ls())

x <- rnorm(100)
w <- abs(100*rnorm(100))
wdat <- abs(100*rnorm(32))
xNA <- x
wNA <- w
wdatNA <- wdat
xNA[sample.int(100,20)] <- NA
wNA[sample.int(100,20)] <- NA
wdatNA[sample.int(32, 5)] <- NA
f <- as.factor(sample.int(10, 100, TRUE))
g <- GRP(mtcars, ~ cyl + vs + am)
gf <- as.factor_GRP(g)
mtcNA <- na_insert(mtcars)
mtcNA[27,1] <- NA # single group NA !!
m <- as.matrix(mtcars)
mNA <- as.matrix(mtcNA)
mNAc <- mNA
storage.mode(mNAc) <- "character"

na20 <- function(x) {
  x[is.na(x)] <- 0
  x
}

wsum <- function(x, w, na.rm = FALSE) {
  if(na.rm) {
    cc <- complete.cases(x, w)
    if(!any(cc)) return(NA_real_)
    x <- x[cc]
    w <- w[cc]
  }
  sum(x*w)
}

wBY <- function(x, f, FUN, w, ...) {
  if(is.atomic(x) && !is.array(x)) return(mapply(FUN, split(x, f), split(w, f), ...))
  wspl <- split(w, f)
  if(is.atomic(x)) return(dapply(x, function(xi) mapply(FUN, split(xi, f), wspl, ...)))
  qDF(dapply(x, function(xi) mapply(FUN, split(xi, f), wspl, ...), return = "matrix"))
}


test_that("fsum performs like base::sum and base::colSums", {
  expect_equal(fsum(NA), sum(NA))
  expect_equal(fsum(NA, na.rm = FALSE), sum(NA))
  expect_equal(fsum(1), sum(1, na.rm = TRUE))
  expect_equal(fsum(1:3), sum(1:3, na.rm = TRUE))
  expect_equal(fsum(-1:1), sum(-1:1, na.rm = TRUE))
  expect_equal(fsum(1, na.rm = FALSE), sum(1))
  expect_equal(fsum(1:3, na.rm = FALSE), sum(1:3))
  expect_equal(fsum(-1:1, na.rm = FALSE), sum(-1:1))
  expect_equal(fsum(x), sum(x, na.rm = TRUE))
  expect_equal(fsum(x, na.rm = FALSE), sum(x))
  expect_equal(fsum(xNA, na.rm = FALSE), sum(xNA))
  expect_equal(fsum(xNA), sum(xNA, na.rm = TRUE))
  expect_equal(fsum(mtcars), fsum(m))
  expect_equal(fsum(m), colSums(m, na.rm = TRUE))
  expect_equal(fsum(m, na.rm = FALSE), colSums(m))
  expect_equal(fsum(mNA, na.rm = FALSE), colSums(mNA))
  expect_equal(fsum(mNA), colSums(mNA, na.rm = TRUE))
  expect_equal(fsum(mtcars), dapply(mtcars, sum, na.rm = TRUE))
  expect_equal(fsum(mtcars, na.rm = FALSE), dapply(mtcars, sum))
  expect_equal(fsum(mtcNA, na.rm = FALSE), dapply(mtcNA, sum))
  expect_equal(fsum(mtcNA), dapply(mtcNA, sum, na.rm = TRUE))
  expect_equal(fsum(x, f), BY(x, f, sum, na.rm = TRUE))
  expect_equal(fsum(x, f, na.rm = FALSE), BY(x, f, sum))
  expect_equal(fsum(xNA, f, na.rm = FALSE), BY(xNA, f, sum))
  expect_equal(na20(fsum(xNA, f)), BY(xNA, f, sum, na.rm = TRUE))
  expect_equal(fsum(m, g), BY(m, g, sum, na.rm = TRUE))
  expect_equal(fsum(m, g, na.rm = FALSE), BY(m, g, sum))
  expect_equal(fsum(mNA, g, na.rm = FALSE), BY(mNA, g, sum))
  expect_equal(na20(fsum(mNA, g)), BY(mNA, g, sum, na.rm = TRUE)) # error, sum(NA) give 0
  expect_equal(fsum(mtcars, g), BY(mtcars, g, sum, na.rm = TRUE))
  expect_equal(fsum(mtcars, g, na.rm = FALSE), BY(mtcars, g, sum))
  expect_equal(fsum(mtcNA, g, na.rm = FALSE), BY(mtcNA, g, sum))
  expect_equal(na20(fsum(mtcNA, g)), BY(mtcNA, g, sum, na.rm = TRUE)) # error, sum(NA) give 0
})

test_that("fsum with weights performs like wsum (defined above)", {
  # complete weights
  expect_equal(fsum(NA, w = 1), wsum(NA, 1))
  expect_equal(fsum(NA, w = 1, na.rm = FALSE), wsum(NA, 1))
  expect_equal(fsum(1, w = 1), wsum(1, w = 1))
  expect_equal(fsum(1:3, w = 1:3), wsum(1:3, 1:3))
  expect_equal(fsum(-1:1, w = 1:3), wsum(-1:1, 1:3))
  expect_equal(fsum(1, w = 1, na.rm = FALSE), wsum(1, 1))
  expect_equal(fsum(1:3, w = c(0.99,3454,1.111), na.rm = FALSE), wsum(1:3, c(0.99,3454,1.111)))
  expect_equal(fsum(-1:1, w = 1:3, na.rm = FALSE), wsum(-1:1, 1:3))
  expect_equal(fsum(x, w = w), wsum(x, w))
  expect_equal(fsum(x, w = w, na.rm = FALSE), wsum(x, w))
  expect_equal(fsum(xNA, w = w, na.rm = FALSE), wsum(xNA, w))
  expect_equal(fsum(xNA, w = w), wsum(xNA, w, na.rm = TRUE))
  expect_equal(fsum(mtcars, w = wdat), fsum(m, w = wdat))
  expect_equal(fsum(m, w = wdat), dapply(m, wsum, wdat, na.rm = TRUE))
  expect_equal(fsum(m, w = wdat, na.rm = FALSE), dapply(m, wsum, wdat))
  expect_equal(fsum(mNA, w = wdat, na.rm = FALSE), dapply(mNA, wsum, wdat))
  expect_equal(fsum(mNA, w = wdat), dapply(mNA, wsum, wdat, na.rm = TRUE))
  expect_equal(fsum(mtcars, w = wdat), dapply(mtcars, wsum, wdat, na.rm = TRUE))
  expect_equal(fsum(mtcars, w = wdat, na.rm = FALSE), dapply(mtcars, wsum, wdat))
  expect_equal(fsum(mtcNA, w = wdat, na.rm = FALSE), dapply(mtcNA, wsum, wdat))
  expect_equal(fsum(mtcNA, w = wdat), dapply(mtcNA, wsum, wdat, na.rm = TRUE))
  expect_equal(fsum(x, f, w), wBY(x, f, wsum, w))
  expect_equal(fsum(x, f, w, na.rm = FALSE), wBY(x, f, wsum, w))
  expect_equal(fsum(xNA, f, w, na.rm = FALSE), wBY(xNA, f, wsum, w))
  expect_equal(fsum(xNA, f, w), wBY(xNA, f, wsum, w, na.rm = TRUE))
  expect_equal(fsum(m, g, wdat), wBY(m, gf, wsum, wdat))
  expect_equal(fsum(m, g, wdat, na.rm = FALSE), wBY(m, gf, wsum, wdat))
  expect_equal(fsum(mNA, g, wdat, na.rm = FALSE),  wBY(mNA, gf, wsum, wdat))
  expect_equal(fsum(mNA, g, wdat), wBY(mNA, gf, wsum, wdat, na.rm = TRUE))
  expect_equal(fsum(mtcars, g, wdat), wBY(mtcars, gf, wsum, wdat))
  expect_equal(fsum(mtcars, g, wdat, na.rm = FALSE), wBY(mtcars, gf, wsum, wdat))
  expect_equal(fsum(mtcNA, g, wdat, na.rm = FALSE), wBY(mtcNA, gf, wsum, wdat))
  expect_equal(fsum(mtcNA, g, wdat), wBY(mtcNA, gf, wsum, wdat, na.rm = TRUE))
  # missing weights
  expect_equal(fsum(NA, w = NA), wsum(NA, NA))
  expect_equal(fsum(NA, w = NA, na.rm = FALSE), wsum(NA, NA))
  expect_equal(fsum(1, w = NA), wsum(1, w = NA))
  expect_equal(fsum(1:3, w = c(NA,1:2)), wsum(1:3, c(NA,1:2), na.rm = TRUE))
  expect_equal(fsum(-1:1, w = c(NA,1:2)), wsum(-1:1, c(NA,1:2), na.rm = TRUE))
  expect_equal(fsum(1, w = NA, na.rm = FALSE), wsum(1, NA))
  expect_equal(fsum(1:3, w = c(NA,1:2), na.rm = FALSE), wsum(1:3, c(NA,1:2)))
  expect_equal(fsum(-1:1, w = c(NA,1:2), na.rm = FALSE), wsum(-1:1, c(NA,1:2)))
  expect_equal(fsum(x, w = wNA), wsum(x, wNA, na.rm = TRUE))
  expect_equal(fsum(x, w = wNA, na.rm = FALSE), wsum(x, wNA))
  expect_equal(fsum(xNA, w = wNA, na.rm = FALSE), wsum(xNA, wNA))
  expect_equal(fsum(xNA, w = wNA), wsum(xNA, wNA, na.rm = TRUE))
  expect_equal(fsum(mtcars, w = wdatNA), fsum(m, w = wdatNA))
  expect_equal(fsum(m, w = wdatNA), dapply(m, wsum, wdatNA, na.rm = TRUE))
  expect_equal(fsum(m, w = wdatNA, na.rm = FALSE), dapply(m, wsum, wdatNA))
  expect_equal(fsum(mNA, w = wdatNA, na.rm = FALSE), dapply(mNA, wsum, wdatNA))
  expect_equal(fsum(mNA, w = wdatNA), dapply(mNA, wsum, wdatNA, na.rm = TRUE))
  expect_equal(fsum(mtcars, w = wdatNA), dapply(mtcars, wsum, wdatNA, na.rm = TRUE))
  expect_equal(fsum(mtcars, w = wdatNA, na.rm = FALSE), dapply(mtcars, wsum, wdatNA))
  expect_equal(fsum(mtcNA, w = wdatNA, na.rm = FALSE), dapply(mtcNA, wsum, wdatNA))
  expect_equal(fsum(mtcNA, w = wdatNA), dapply(mtcNA, wsum, wdatNA, na.rm = TRUE))
  expect_equal(fsum(x, f, wNA), wBY(x, f, wsum, wNA, na.rm = TRUE))
  expect_equal(fsum(x, f, wNA, na.rm = FALSE), wBY(x, f, wsum, wNA))
  expect_equal(fsum(xNA, f, wNA, na.rm = FALSE), wBY(xNA, f, wsum, wNA))
  expect_equal(fsum(xNA, f, wNA), wBY(xNA, f, wsum, wNA, na.rm = TRUE))
  expect_equal(fsum(m, g, wdatNA), wBY(m, gf, wsum, wdatNA, na.rm = TRUE))
  expect_equal(fsum(m, g, wdatNA, na.rm = FALSE), wBY(m, gf, wsum, wdatNA))
  expect_equal(fsum(mNA, g, wdatNA, na.rm = FALSE),  wBY(mNA, gf, wsum, wdatNA))
  expect_equal(fsum(mNA, g, wdatNA), wBY(mNA, gf, wsum, wdatNA, na.rm = TRUE))
  expect_equal(fsum(mtcars, g, wdatNA), wBY(mtcars, gf, wsum, wdatNA, na.rm = TRUE))
  expect_equal(fsum(mtcars, g, wdatNA, na.rm = FALSE), wBY(mtcars, gf, wsum, wdatNA))
  expect_equal(fsum(mtcNA, g, wdatNA, na.rm = FALSE), wBY(mtcNA, gf, wsum, wdatNA))
  expect_equal(fsum(mtcNA, g, wdatNA), wBY(mtcNA, gf, wsum, wdatNA, na.rm = TRUE))
})

test_that("fsum performs numerically stable", {
  expect_true(all_obj_equal(replicate(50, fsum(1), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(NA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(NA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, f), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, f, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, f, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, f), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, g), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, g, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, g, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, g), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, g), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, g, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, g, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, g), simplify = FALSE)))
})

test_that("fsum with complete weights performs numerically stable", {
  expect_true(all_obj_equal(replicate(50, fsum(1, w = 1), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(NA, w = 1), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(NA, w = 1, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, w = w), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, w = w, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, w = w, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, w = w), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, w = wdat), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, w = wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, w = wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, w = wdat), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, w = wdat), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, w = wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, w = wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, w = wdat), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, f, w), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, f, w, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, f, w, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, f, w), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, g, wdat), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, g, wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, g, wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, g, wdat), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, g, wdat), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, g, wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, g, wdat, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, g, wdat), simplify = FALSE)))
})

test_that("fsum with missing weights performs numerically stable", {
  expect_true(all_obj_equal(replicate(50, fsum(1, w = NA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(NA, w = NA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(NA, w = NA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, w = wNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, w = wNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, w = wNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, w = wNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, w = wdatNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, w = wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, w = wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, w = wdatNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, w = wdatNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, w = wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, w = wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, w = wdatNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, f, wNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(x, f, wNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, f, wNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(xNA, f, wNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, g, wdatNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(m, g, wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, g, wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mNA, g, wdatNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, g, wdatNA), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcars, g, wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, g, wdatNA, na.rm = FALSE), simplify = FALSE)))
  expect_true(all_obj_equal(replicate(50, fsum(mtcNA, g, wdatNA), simplify = FALSE)))
})

test_that("fsum handles special values in the right way", {
  expect_equal(fsum(NA), NA_real_)
  expect_equal(fsum(NaN), NaN)
  expect_equal(fsum(Inf), Inf)
  expect_equal(fsum(-Inf), -Inf)
  expect_equal(fsum(TRUE), 1)
  expect_equal(fsum(FALSE), 0)
  expect_equal(fsum(NA, na.rm = FALSE), NA_real_)
  expect_equal(fsum(NaN, na.rm = FALSE), NaN)
  expect_equal(fsum(Inf, na.rm = FALSE), Inf)
  expect_equal(fsum(-Inf, na.rm = FALSE), -Inf)
  expect_equal(fsum(TRUE, na.rm = FALSE), 1)
  expect_equal(fsum(FALSE, na.rm = FALSE), 0)
  expect_equal(fsum(c(1,NA)), 1)
  expect_equal(fsum(c(1,NaN)), 1)
  expect_equal(fsum(c(1,Inf)), Inf)
  expect_equal(fsum(c(1,-Inf)), -Inf)
  expect_equal(fsum(c(FALSE,TRUE)), 1)
  expect_equal(fsum(c(TRUE,TRUE)), 2)
  expect_equal(fsum(c(1,Inf), na.rm = FALSE), Inf)
  expect_equal(fsum(c(1,-Inf), na.rm = FALSE), -Inf)
  expect_equal(fsum(c(FALSE,TRUE), na.rm = FALSE), 1)
  expect_equal(fsum(c(TRUE,TRUE), na.rm = FALSE), 2)
})

test_that("fsum with weights handles special values in the right way", {
  expect_equal(fsum(NA, w = 1), NA_real_)
  expect_equal(fsum(NaN, w = 1), NaN)
  expect_equal(fsum(Inf, w = 1), Inf)
  expect_equal(fsum(-Inf, w = 1), -Inf)
  expect_equal(fsum(TRUE, w = 1), 1)
  expect_equal(fsum(FALSE, w = 1), 0)
  expect_equal(fsum(NA, w = 1, na.rm = FALSE), NA_real_)
  expect_equal(fsum(NaN, w = 1, na.rm = FALSE), NaN)
  expect_equal(fsum(Inf, w = 1, na.rm = FALSE), Inf)
  expect_equal(fsum(-Inf, w = 1, na.rm = FALSE), -Inf)
  expect_equal(fsum(TRUE, w = 1, na.rm = FALSE), 1)
  expect_equal(fsum(FALSE, w = 1, na.rm = FALSE), 0)
  expect_equal(fsum(NA, w = NA), NA_real_)
  expect_equal(fsum(NaN, w = NA), NA_real_)
  expect_equal(fsum(Inf, w = NA), NA_real_)
  expect_equal(fsum(-Inf, w = NA), NA_real_)
  expect_equal(fsum(TRUE, w = NA), NA_real_)
  expect_equal(fsum(FALSE, w = NA), NA_real_)
  expect_equal(fsum(NA, w = NA, na.rm = FALSE), NA_real_)
  expect_equal(fsum(NaN, w = NA, na.rm = FALSE), NA_real_)
  expect_equal(fsum(Inf, w = NA, na.rm = FALSE), NA_real_)
  expect_equal(fsum(-Inf, w = NA, na.rm = FALSE), NA_real_)
  expect_equal(fsum(TRUE, w = NA, na.rm = FALSE), NA_real_)
  expect_equal(fsum(FALSE, w = NA, na.rm = FALSE), NA_real_)
  expect_equal(fsum(1:3, w = c(1,Inf,3)), Inf)
  expect_equal(fsum(1:3, w = c(1,-Inf,3)), -Inf)
  expect_equal(fsum(1:3, w = c(1,Inf,3), na.rm = FALSE), Inf)
  expect_equal(fsum(1:3, w = c(1,-Inf,3), na.rm = FALSE), -Inf)
})

test_that("fsum sumuces errors for wrong input", {
  expect_error(fsum("a"))
  expect_error(fsum(NA_character_))
  expect_error(fsum(mNAc))
  expect_error(fsum(mNAc, f))
  expect_error(fsum(1:2,1:3))
  expect_error(fsum(m,1:31))
  expect_error(fsum(mtcars,1:31))
  expect_error(fsum(mtcars, w = 1:31))
  expect_error(fsum("a", w = 1))
  expect_error(fsum(1:2, w = 1:3))
  expect_error(fsum(NA_character_, w = 1))
  expect_error(fsum(mNAc, w = wdat))
  expect_error(fsum(mNAc, f, wdat))
  expect_error(fsum(mNA, w = 1:33))
  expect_error(fsum(1:2,1:2, 1:3))
  expect_error(fsum(m,1:32,1:20))
  expect_error(fsum(mtcars,1:32,1:10))
  expect_error(fsum(1:2, w = c("a","b")))
  expect_error(fsum(wlddev))
  expect_error(fsum(wlddev, w = wlddev$year))
  expect_error(fsum(wlddev, wlddev$iso3c))
  expect_error(fsum(wlddev, wlddev$iso3c, wlddev$year))
})

