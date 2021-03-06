#' Plot the Torgegram and the Empirical Semivariogram for a Spatial Stream Network object 
#'
#' @param ssn a \link[SSN]{SpatialStreamNetwork-class} object.
#' @param ResponseName the name of the response variable.
#' @param Euclidean If \code{TRUE} the Empirical Semivariogram based on Euclidean distances is also plotted.
#' @param singleNet an interger, indicating the network ID that is to be analysed. Default to \code{NULL}, so that the analysis is carried on the entire dataset.
#' @param maxlag_Torg the maximum lag distance to consider when binning pairs of locations by the hydrological distance that separates them. The default is the median distance between all pairs of locations.
#' @param nlag_Torg the number of lag bins to create for computing the Torgegram. The hydrological distance between endpoints that define a bin will have equal lengths for all bins. The bin sizes are then determined from the minimum lag in the data, and the specification of maxlag_Torg.
#' @param inc_Torg the bin hydrological distance between endpoints. It is possible to specify the bin distance rather than nlag_Torg. In this case, the number of bins is determined by the bin distance and the hydrological distance between the mininum and maximum (maxlag_Torg) lag in the data. 
#' @param nlagcutoff_Torg the minimum number of pairs needed to estimate the semivariance for a bin in the Torgegram computation. If the sample sizes is less than this value, the semivariance for the bin is not calculated.
#' @param maxlag_EmpVar the maximum lag distance to consider when binning pairs of locations by the Euclidean distance that separates them. If the specified maxlag is larger than the maximum Euclidean distance among pairs of points, then maxlag_EmpVar is set to the maximum distance among pairs. If inc_EmpVar is greater than 0, then maxlag_EmpVar is disregarded.
#' @param nlag_EmpVar the number of lag bins to create for computing the Empirical Semivariogram, by direction if directions are specified. The distance between endpoints that define a bin will have equal lengths for all bins. The bin sizes are then determined from the minimum lag in the data, and the specification of maxlag_EmpVar. 
#' @param inc_EmpVar the Euclidean distance increment for each bin class. Default is 0, in which case maxlag and nclasses determine the distance increments. 
#' @param nlagcutoff_EmpVar the minimum number of pairs needed to estimate the semivariance for a bin in the Empirical Semivariogram. If the sample size is less than this value, the semivariance for the bin is not calculated.
#' @param directions directions in degrees clockwise from north that allow lag binning to be directional. Default is \code{c(0, 45, 90, 135)}. Values should be between 0 and 180, as there is radial symmetry in orientation between two points.
#' @param tolerance the angle on either side of the directions to determine if a pair of points falls in that direction class. Note, a pair of points may be in more than one lag bin if tolerances for different directions overlap.
#' @param EmpVarMeth method for computing semivariances. The default is "MethMoment", the classical method of moments, which is just the average difference-squared within bin classes. "Covariance" computes covariance rather than semivariance, but may be more biased because it subtracts off the simple mean of the response variable. "RobustMedian" and "RobustMean" are robust estimators proposed by Cressie and Hawkins (1980). If v is a vector of all pairwise square-roots of absolute differences within a bin class, then RobustMedian computes median(v)^4/.457. "RobustMean" computes mean(v)^4/(.457 + .494/length(v)).
#' @return A list of distance matrices, containing the flow-connection binary matrix, the hydrological distance matrix and, not necessarily, the Euclidean distance matrix. These matrices consider the relationships between observed points..
#' @description Given a \link[SSN]{SpatialStreamNetwork-class} object, computes the Torgegram (empirical semivariogram from the data based on hydrological distance) and the empirical semivariogram from the data based on the Euclidean distance. It provides the plots, useful for a complete spatial analysis of a stream network.
#' @references 
#' Peterson, E.E. and Ver Hoef, J.M. (2010) A mixed-model moving-average approach to geostatistical modeling in stream networks. Ecology 91(3), 644–651.
#' 
#' Ver Hoef, J.M. and Peterson, E.E. (2010) A moving average approach for spatial statistical models of stream networks (with discussion). Journal of the American Statistical Association 105, 6–18.
#' @useDynLib StreamNetgstat
#' @export


get_plots = function(ssn, ResponseName, Euclidean = FALSE, singleNet = NULL,
                     maxlag_Torg = NULL, nlag_Torg = 6, inc_Torg = 0, nlagcutoff_Torg = 15, 
                     maxlag_EmpVar = 1e32, nlag_EmpVar = 20, inc_EmpVar = 0, nlagcutoff_EmpVar = 1, 
                     directions = c(0,45,90,135), tolerance = 22.5, EmpVarMeth = "MethMoment")
{
  
  if(Euclidean){
   result = emp_semivario_and_torg(ssn = ssn, ResponseName = ResponseName, singleNet = singleNet,
                                   maxlag_Torg = maxlag_Torg, nlag_Torg = nlag_Torg, inc_Torg = inc_Torg, nlagcutoff_Torg = nlagcutoff_Torg, 
                                   maxlag_EmpVar = maxlag_EmpVar, nlag_EmpVar = nlag_EmpVar, inc_EmpVar = inc_EmpVar, nlagcutoff_EmpVar = nlagcutoff_EmpVar, 
                                   directions = directions, tolerance = tolerance, EmpVarMeth = EmpVarMeth)
   par(mfrow=c(1,2))
   plot.torg(result$Torg, main = "Torgegram", ylab = "", leg.auto = FALSE)
   colr = c("blue","green2")
   plch = c(19,19)
   legend(x = (2/5)*max(result$Torg$distance.connect,result$Torg$distance.unconnect),
          y = min(result$Torg$gam.connect,result$Torg$gam.unconnect),
          legend = c("Flow-connected", "Flow-unconnected"), bty = "n",
          pch = plch,
          col = c(colr[1], colr[2]), y.intersp = 1.5)
   plot(c(0, max(result$EmpSemiVar$distance)), c(0, max(result$EmpSemiVar$gamma)),
        type = "n", xlab = "Euclidean Distance", ylab = "",
        main = "Empirical Semivariogram")
   nlag <- length(result$EmpSemiVar$distance)
   maxnp <- max(result$EmpSemiVar$np)
   minnp <- min(result$EmpSemiVar$np)
   np.range <- maxnp - minnp
   min.cex = 1.5
   max.cex = 6
   cex.inc <- max.cex - min.cex
   points(result$EmpSemiVar$distance,
          result$EmpSemiVar$gamma, pch = 19,
          cex = min.cex + cex.inc*result$EmpSemiVar$np/maxnp,
          col = "orangered")
   
  }
  
  else {
    result = torgegram(ssn = ssn, ResponseName, singleNet = singleNet, maxlag = maxlag_Torg, nlag = nlag_Torg, 
                       inc = inc_Torg, nlagcutoff = nlagcutoff_Torg, EmpVarMeth = "MethMoment")
    plot(result$Torg, main = "Torgegram") 
  }
  
  return(result$distMatrices)
}