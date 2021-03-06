\name{A7-time-series-panel-series} % \name{Time Series and Panel Computations}
\alias{A7-time-series-panel-series}
% \alias{tscomp}
\title{Time Series and Panel Series} % \emph{collapse}

\description{
\emph{collapse} provides the following functions to work with time-dependent data:
\itemize{
\item \code{\link{flag}}, and the lag- and lead- operators \code{\link{L}} and \code{\link{F}} are S3 generics to efficiently compute sequences of \bold{lags and leads} on ordered or unordered time series and panel data.
\item \code{\link{fdiff}}, \code{\link{fgrowth}}, and the operators \code{\link{D}}, \code{\link{Dlog}} and \code{\link{G}} are S3 generics to efficiently compute sequences of suitably lagged / leaded and iterated \bold{differences, log-differences and growth rates} on ordered or unordered time series and panel data. \code{\link[=fdiff]{fdiff/D/Dlog}} can also compute \bold{quasi-differences} of the form \eqn{x_t - \rho x_{t-1}} or \eqn{log(x_t) - \rho log(x_{t-1})} for log-differences.
\item \code{\link{psmat}} is an S3 generic to efficiently convert panel-vectors or \code{plm::pseries} and data frames or \code{plm::pdata.frame}'s to \bold{panel series matrices and 3D arrays}, respectively.
\item \code{\link{psacf}}, \code{\link{pspacf}} and \code{\link{psccf}} are S3 generics to compute estimates of the \bold{auto-, partial auto- and cross- correlation or covariance functions} for panel-vectors or \code{plm::pseries}, and multivariate versions for data frames or \code{plm::pdata.frame}'s.
}
}
\section{Table of Functions}{
  \tabular{lllll}{\emph{ S3 Generic }   \tab\tab \emph{ Methods }   \tab\tab \emph{ Description }  \cr % \Sexpr{"\u200B"} \Sexpr{"\u200B"} \Sexpr{"\u200B"} \Sexpr{"\u200B"}
                 \code{\link[=flag]{flag/L/F}} \tab\tab \code{default, matrix, data.frame, pseries, pdata.frame, grouped_df}  \tab\tab Compute (sequences of) lags and leads \cr
                 \code{\link[=fdiff]{fdiff/D/Dlog}} \tab\tab \code{default, matrix, data.frame, pseries, pdata.frame, grouped_df}  \tab\tab Compute (sequences of lagged / leaded and iterated) (quasi-)differences or (quasi-)log-differences \cr
                 \code{\link[=fgrowth]{fgrowth/G}} \tab\tab \code{default, matrix, data.frame, pseries, pdata.frame, grouped_df}  \tab\tab Compute (sequences of lagged / leaded and iterated) growth rates (exact or via log-differences, in percentage terms) \cr
                 \code{\link{psmat}} \tab\tab \code{default, pseries, data.frame, pdata.frame} \tab\tab Convert panel data to matrix / array \cr
                 \code{\link{psacf}} \tab\tab \code{default, pseries, data.frame, pdata.frame} \tab\tab Compute ACF on panel data \cr
                 \code{\link{pspacf}} \tab\tab \code{default, pseries, data.frame, pdata.frame} \tab\tab Compute PACF on panel data \cr
                 \code{\link{psccf}} \tab\tab \code{default, pseries, data.frame, pdata.frame} \tab\tab Compute CCF on panel data
}
}
\seealso{
\link[=collapse-documentation]{Collapse Overview}, \link[=A6-data-transformations]{Data Transformations}
}
\keyword{ts}
\keyword{manip}
\keyword{documentation}


