z <- volcano
x <- 1:nrow(z)
y <- 1:ncol(z)
library(isoband)
lo <- c(90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190)
l <- isolines(x, y, t(z), lo)
b <- isobands(x, y, t(z), lo, lo + 10)
iso_data <- list(line = l, band = b, lo = lo, hi = lo + 10, xyz = list(x = x, y = y, z = z))
usethis::use_data(iso_data, internal = FALSE)
