
# x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
# y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
#
# (ind <- earcut(cbind(x, y)))
# # [1] 2 1 7 7 6 5 5 4 3 2 7 5 5 3 2
# plot_ears(cbind(x, y), ind)
#
# mat <- cbind(x,y)
# sfg <- sfheaders::sfg_polygon( mat, close = F )
# (ind <- decido:::earcut_sfc( sfg )) + 1
# # [1] 2 1 7 7 6 5 5 4 3 2 7 5 5 3 2
# plot_ears(cbind(x, y), ind + 1)




# x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
#      0.2, 0.5, 0.5, 0.3, 0.2)
# y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
#      0.2, 0.2, 0.4, 0.6, 0.4)
#
# (ind <- earcut(cbind(x, y), holes = 8))
# plot_ears(cbind(x, y), ind)
#
# mat <- cbind(c(rep(1,7),rep(2,5)), x, y)
# sfg <- sfheaders::sfg_polygon(obj = mat, linestring_id = 1)
#
# (ind <- decido:::earcut_sfc( sfg ))
# plot_ears(cbind(x, y), ind )
