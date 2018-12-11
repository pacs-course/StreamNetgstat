% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/emp_semivario_and_torg.R
\name{emp_semivario_and_torg}
\alias{emp_semivario_and_torg}
\title{Compute the Empirical Semivariogram for a Spatial Stream Network object}
\usage{
emp_semivario_and_torg(ssn, ResponseName, maxlag_Torg = NULL,
  nlag_Torg = 6, inc_Torg = 0, nlagcutoff_Torg = 15,
  maxlag_EmpVar = 1e+32, nlag_EmpVar = 20, inc_EmpVar = 0,
  nlagcutoff_EmpVar = 1, directions = c(0, 45, 90, 135),
  tolerance = 22.5, EmpVarMeth = "MethMoment")
}
\arguments{
\item{ssn}{a \link[SSN]{SpatialStreamNetwork-class} object.}

\item{ResponseName}{the name of the response variable.}

\item{maxlag_Torg}{the maximum lag distance to consider when binning pairs of locations by the hydrologic distance that separates them. The default is the median distance between all pairs of locations.}

\item{nlag_Torg}{the number of lag bins to create for computing the Torgegram. The hydrologic distance between endpoints that define a bin will have equal lengths for all bins. The bin sizes are then determined from the minimum lag in the data, and the specification of maxlag_Torg.}

\item{inc_Torg}{the bin hydrologic distance between endpoints. It is possible to specify the bin distance rather than nlag_Torg. In this case, the number of bins is determined by the bin distance and the hydrologic distance between the mininum and maximum (maxlag_Torg) lag in the data.}

\item{nlagcutoff_Torg}{the minimum number of pairs needed to estimate the semivariance for a bin in the Torgegram computation. If the sample sizes is less than this value, the semivariance for the bin is not calculated.}

\item{maxlag_EmpVar}{the maximum lag distance to consider when binning pairs of locations by the Euclidean distance that separates them. If the specified maxlag is larger than the maximum Euclidean distance among pairs of points, then maxlag_EmpVar is set to the maximum distance among pairs. If inc_EmpVar is greater than 0, then maxlag_EmpVar is disregarded.}

\item{nlag_EmpVar}{the number of lag bins to create for computing the Empirical Semivariogram, by direction if directions are specified. The distance between endpoints that define a bin will have equal lengths for all bins. The bin sizes are then determined from the minimum lag in the data, and the specification of maxlag_EmpVar.}

\item{inc_EmpVar}{the Euclidean distance increment for each bin class. Default is 0, in which case maxlag and nclasses determine the distance increments.}

\item{nlagcutoff_EmpVar}{the minimum number of pairs needed to estimate the semivariance for a bin in the Empirical Semivariogram. If the sample size is less than this value, the semivariance for the bin is not calculated.}

\item{directions}{directions in degrees clockwise from north that allow lag binning to be directional. Default is \code{c(0, 45, 90, 135)}. Values should be between 0 and 180, as there is radial symmetry in orientation between two points.}

\item{tolerance}{the angle on either side of the directions to determine if a pair of points falls in that direction class. Note, a pair of points may be in more than one lag bin if tolerances for different directions overlap.}

\item{EmpVarMeth}{method for computing semivariances. The default is "MethMoment", the classical method of moments, which is just the average difference-squared within bin classes. "Covariance" computes covariance rather than semivariance, but may be more biased because it subtracts off the simple mean of the response variable. "RobustMedian" and "RobustMean" are robust estimators proposed by Cressie and Hawkins (1980). If v is a vector of all pairwise square-roots of absolute differences within a bin class, then RobustMedian computes median(v)^4/.457. "RobustMean" computes mean(v)^4/(.457 + .494/length(v)).}
}
\value{
A list.
}
\description{
Given a \link[SSN]{SpatialStreamNetwork-class} object, computes the Torgegram and the Empirical Semivariogram and provides the plots.
}
\details{
This function works on objects of \link[SSN]{SpatialStreamNetwork-class}.
}
\references{
Peterson, E.E. and Ver Hoef, J.M. (2010) A mixed-model moving-average approach to geostatistical modeling in stream networks. Ecology 91(3), 644–651.

Ver Hoef, J.M. and Peterson, E.E. (2010) A moving average approach for spatial statistical models of stream networks (with discussion). Journal of the American Statistical Association 105, 6–18. DOI: 10.1198/jasa.2009.ap08248. Rejoinder pgs. 22–24.
}