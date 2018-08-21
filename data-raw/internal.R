
## the outer Antarctic continent polygon
ant_cont <- sfdct::antarctica$geometry[[1]][[97]][[1]]
#usethis::use_data(ant_cont, internal = TRUE)

## an inner circle, used for illustration in sfdct
ant_circle <- sfdct::antarctica$geometry[[2]][[1]]
usethis::use_data(ant_cont, ant_circle, internal = TRUE)
