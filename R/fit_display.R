#' Plot the fitting results of an object of class \code{fit_result}.
#' @param x fit_result object.
#' @param xlim the range of values to display on the x-axis, eg xlim = c(4,1).
#' @param plt_title title to add to the plot.
#' @param data_only display only the processed data (logical).
#' @param label character string to add to the top left of the plot window.
#' @param plot_sigs a character vector of signal names to add to the plot.
#' @param dyn the dynamic index to plot.
#' @param x_pos the x index to plot.
#' @param y_pos the y index to plot.
#' @param z_pos the z index to plot.
#' @param coil the coil element number to plot.
#' @param n single index element to plot (overides other indices when given).
#' @param sub_bl subtract the baseline from the data and fit (logical).
#' @param ... further arguments to plot method.
#' @export
plot.fit_result <- function(x, xlim = NULL, plt_title = FALSE,
                           data_only = FALSE, label = NULL, 
                           plot_sigs = NULL, dyn = 1, x_pos = 1,
                           y_pos = 1, z_pos = 1, coil = 1, n = NULL,
                           sub_bl = FALSE, ...) {
  
  if (is.null(n)) {
    ind <- (x$res_tab$X == x_pos) & (x$res_tab$Y == y_pos) & 
           (x$res_tab$Z == z_pos) & (x$res_tab$Dynamic == dyn) &
           (x$res_tab$Coil == coil) 
    
    n <- which(ind)
  }
  
  x <- x$fits[[n]]
  
  if (is.null(xlim)) {
    xlim <- rev(range(x$PPMScale))
  }
  
  graphics::par("xaxs" = "i", "yaxs" = "i") # tight axes limits
  
  if ( plt_title == FALSE ) {
    graphics::par(mar = c(3.5, 1.2, 1.2, 1.2)) # space around the plot
  } else {
    graphics::par(mar = c(3.5, 1.2, 2, 1.2)) # space around the plot
  }
  
  graphics::par(mgp = c(1.8, 0.5, 0)) # distance between axes and labels
  
  if (xlim[1] > xlim[2]) {
    ind <- x$PPMScale < xlim[1] & x$PPMScale > xlim[2]
  }
  else {
    ind <- x$PPMScale < xlim[2] & x$PPMScale > xlim[1]
  }
  
  if (data_only) {
    max_dp <- max(x$Data[ind])
    min_dp <- min(x$Data[ind])
    marg = (max_dp - min_dp) * 0.02
    graphics::plot(x$PPMScale, x$Data, type = 'l', xlim = xlim, 
         ylim = c(min_dp - marg, max_dp + marg), yaxt = "n", ylab = "",
         xlab = "Chemical Shift (ppm)", ...)
    
    if (!is.null(label)) {
      graphics::par(xpd = TRUE)
      graphics::text(xlim[1], max_dp, label, cex = 2.5)
      graphics::par(xpd = FALSE) 
    }
    
  } else {
    if (sub_bl) {
      x$Data <- x$Data - x$Baseline
      x$Baseline <- rep(0,length(x$Baseline))
    }
    
    fit_line <- x$Fit + x$Baseline
    max_dp <- max(x$Data[ind],fit_line[ind])
    min_dp <- min(x$Data[ind],fit_line[ind],x$Baseline[ind])
    
    res <- x$Data - fit_line
    res_range <- max(res[ind]) - min(res[ind])
    offset <- max_dp - min(res[ind])
    
    graphics::plot(x$PPMScale, x$Data, type = 'l', xlim = xlim, 
         ylim = c(min_dp,max_dp + res_range), yaxt = "n", ylab = "",
         xlab = "Chemical Shift (ppm)", ...)
    graphics::lines(x$PPMScale, fit_line, col = 'Red', lw = 2)
    if (!sub_bl) {
      graphics::lines(x$PPMScale, x$Baseline)
    }
    graphics::lines(x$PPMScale, res + offset)
    graphics::abline(h = max_dp)
  }
  
  for (sig in plot_sigs) {
    graphics::lines(x$PPMScale, x[sig][[1]] + x$Baseline, col = "blue")
  }
}

#' Plot the fitting results of an object of class \code{fit_result} with 
#' individual basis set components shown.
#' @param x fit_result object.
#' @param xlim the range of values to display on the x-axis, eg xlim = c(4,1).
#' @param y_offset separate basis signals in the y-axis direction by this value.
#' @param plt_title title to add to the plot.
#' @param dyn the dynamic index to plot.
#' @param x_pos the x index to plot.
#' @param y_pos the y index to plot.
#' @param z_pos the z index to plot.
#' @param coil the coil element number to plot.
#' @param n single index element to plot (overides other indices when given).
#' @param sub_bl subtract the baseline from the data and fit (logical).
#' @param ... further arguments to plot method.
#' @export
stackplot.fit_result <- function(x, xlim = NULL, y_offset = 0.04,
                                 plt_title = FALSE, dyn = 1, x_pos = 1,
                                 y_pos = 1, z_pos = 1, coil = 1,
                                 n = NULL, sub_bl = FALSE, ...) {
  
  
  if (is.null(n)) {
    ind <- (x$res_tab$X == x_pos) & (x$res_tab$Y == y_pos) & 
           (x$res_tab$Z == z_pos) & (x$res_tab$Dynamic == dyn) &
           (x$res_tab$Coil == coil) 
    
    n <- which(ind)
  }
  
  x <- x$fits[[n]]
  
  if (is.null(xlim)) {
    xlim <- rev(range(x$PPMScale))
  }
  
  graphics::par("xaxs" = "i", "yaxs" = "i") # tight axes limits
  
  if ( plt_title == FALSE ) {
    graphics::par(mar = c(3.5, 1.2, 1.2, 1.2)) # space around the plot
  } else {
    graphics::par(mar = c(3.5, 1.2, 2, 1.2)) # space around the plot
  }
  
  graphics::par(mgp = c(1.8, 0.5, 0)) # distance between axes and labels
  
  if (xlim[1] > xlim[2]) {
    ind <- x$PPMScale < xlim[1] & x$PPMScale > xlim[2]
  }
  else {
    ind <- x$PPMScale < xlim[2] & x$PPMScale > xlim[1]
  }
  
  if (sub_bl) {
    x$Data <- x$Data - x$Baseline
    x$Baseline <- rep(0,length(x$Baseline))
  }
  
  fit_line <- x$Fit + x$Baseline
  max_dp <- max(x$Data[ind],fit_line[ind])
  min_dp <- min(x$Data[ind],fit_line[ind],x$Baseline[ind])
  
  res <- x$Data - fit_line
  res_range <- max(res[ind]) - min(res[ind])
  offset <- max_dp - min(res[ind])
  
  basis_yoff <- (max_dp - min_dp) * y_offset
  
  min_basis <- Inf
  for (p in 5:ncol(x)) {
    x[,p] <- x[,p] - (p - 4) * basis_yoff + min_dp
    if (min(x[ind, p]) < min_basis) min_basis <- min(x[ind, p])
  }
  
  graphics::plot(x$PPMScale, x$Data, type = 'l', xlim = xlim, 
       ylim = c(min_basis - basis_yoff, max_dp + res_range), yaxt = "n", ylab = "",
       xlab = "Chemical Shift (ppm)", ...)
  graphics::lines(x$PPMScale, fit_line, col = 'Red', lw = 2)
  
  if (!sub_bl) {
    graphics::lines(x$PPMScale, x$Baseline)
  }
  
  graphics::lines(x$PPMScale, res + offset)
  graphics::abline(h = max_dp)
  
  for (p in 5:ncol(x)) {
    graphics::lines(x$PPMScale, x[,p])
  }
}

#' Print a summary of an object of class \code{fit_result}.
#' @param x \code{fit_result} object.
#' @param ... further arguments.
#' @export
print.fit_result <- function(x, ...) {
  print(summary(x$res_tab))
}

#' Print fit coordinates from a single index.
#' @param n fit index.
#' @param fit_res \code{fit_result} object.
#' @export
n2coord <- function(n, fit_res) {
  print(fit_res$res_tab[n, 1:5])
}

#' Write fit results table to a csv file.
#' @param x fit results table.
#' @param fname filename of csv file.
#' @param pvc output PVC or raw results (logical).
#' @export
fit_tab2csv <- function(x, fname, pvc = FALSE) {
  utils::write.csv(x, fname, quote = FALSE, row.names = FALSE)
}

#' Plot a 2D slice from an MRSI fit result object
#' @param fit_res \code{fit_result} object
#' @param name name of the quantity to plot, eg "TNAA"
#' @param slice slice to plot in the z direction
#' @param zlim range of values to plot
#' @param interp interpolation factor
#' @export
plot_fit_slice <- function(fit_res, name, slice = 1, zlim = NULL, interp = 1) {
  result_map <- fit_res$res_tab[[name]]
  dim(result_map) <- dim(fit_res$data$data)[2:6]
  col <- viridisLite::viridis(64)
  plot_map <- result_map[,, slice, 1, 1]
  plot_map <- pracma::fliplr(plot_map)
  plot_map <- mmand::rescale(plot_map, interp, mmand::mnKernel())
  
  if (is.null(zlim)) { 
    fields::image.plot(plot_map, col = col, useRaster = TRUE, 
                       asp = 1, axes = FALSE, legend.shrink = 0.8)
  } else {
    plot_map <- crop_range(plot_map, zlim[1], zlim[2])
    breaks <- seq(from = zlim[1], to = zlim[2], length.out = 65)
    fields::image.plot(plot_map, col = col, useRaster = TRUE, 
                       asp = 1, axes = FALSE, legend.shrink = 0.8, breaks = breaks)
  }
}

#' Get a data array from a fit result
#' @param fit_res \code{fit_result} object
#' @param name name of the quantity to plot, eg "TNAA"
#' @export
get_fit_map <- function(fit_res, name) {
  result_map <- fit_res$res_tab[[name]]
  dim(result_map) <- c(1, dim(fit_res$data$data)[2:6])
  result_map
}