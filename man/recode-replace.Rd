\name{AA1-recode-replace}
\alias{AA1-recode-replace}
\alias{recode_num}
\alias{recode_char}
\alias{replace_NA}
\alias{replace_Inf}
\alias{replace_outliers}
\title{
Recode and Replace Values in Matrix-Like Objects
}
\description{
A small suite of functions to efficiently perform common recoding and replacing tasks in matrix-like objects (vectors, matrices, arrays, data frames, lists of atomic objects):
\itemize{
\item \code{recode_num} and \code{recode_char} can be used to efficiently recode multiple numeric or character values, respectively. The syntax is inspired by \code{dplyr::recode}, but the functionality is enhanced in the following respects: (1) they are faster than \code{dplyr::recode}, (2) when passed a data frame / list, all appropriately typed columns will be recoded. (3) They preserve the attributes of the data object and of columns in a data frame / list, and (4) \code{recode_char} also supports regular expression matching using \code{\link{grepl}}.
\item \code{replace_NA} efficiently replaces \code{NA/NaN} with a value. data frames can be multi-typed.
\item \code{replace_Inf} replaces \code{Inf/-Inf} (or optionally \code{NaN/Inf/-Inf}) with a value (default is \code{NA}). \code{replace_Inf} skips non-numeric columns in a data frame.
\item \code{replace_outliers} replaces values falling outside a 1- or 2-sided numeric threshold or outside a certain number of column- standard deviations with a value (default is \code{NA}). \code{replace_outliers} skips non-numeric columns in a data frame.
}
}
\usage{
recode_num(X, \dots, default = NULL, missing = NULL)

recode_char(X, \dots, default = NULL, missing = NULL, regex = FALSE)

replace_NA(X, value)

replace_Inf(X, value = NA, replace.nan = FALSE)

replace_outliers(X, limits, value = NA,
                 single.limit = c("SDs", "min", "max", "overall_SDs"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{a vector, matrix, array, data frame or list of atomic objects.}
  \item{\dots}{comma-separated recode arguments of the form: \code{value = replacement, `2` = 0, Secondary = "SEC"} etc.. \code{recode_char} with \code{regex = TRUE} also supports regular expressions i.e. \code{`^S|D$` = "STD"} etc.}
\item{default}{optional argument to specify a scalar value to replace non-matched elements with.}
\item{missing}{optional argument to specify a scalar value to replace missing elements with. \emph{Note} that to increase efficiency this is done before the rest of the recoding i.e. the recoding is performed on data where missing values are filled!}
\item{regex}{logical. If \code{TRUE}, all recode-argument names are (sequentially) passed to \code{\link{grepl}} as a pattern to search \code{X}. All matches are replaced. \emph{Note} that \code{NA}'s are also matched as strings by \code{grepl}. }
\item{value}{a single (scalar) value to replace matching elements with.}
  \item{replace.nan}{logical. \code{TRUE} replaces \code{NaN/Inf/-Inf}. \code{FALSE} (default) replaces only \code{Inf/-Inf}.}
  \item{limits}{either a vector of two-numeric values \code{c(minval, maxval)} constituting a two-sided outlier threshold, or a single numeric value constituting either a factor of standard deviations (default), or the minimum or maximum of a one-sided outlier threshold. See also \code{single.limit}.}

  \item{single.limit}{a character or integer (argument only applies if \code{length(limits) == 1}):
  \itemize{
  \item \code{1 - "SDs"} specifies that \code{limits} will be interpreted as a (two-sided) threshold in column standard-deviations. The underlying code is equivalent to \code{X[abs(fscale(X)) > limits] <- value} but faster. Since \code{fscale} is S3 generic with methods for \code{grouped_df}, \code{pseries} and \code{pdata.frame}, the standardizing will be grouped if such objects are passed (i.e. the outlier threshold is then measured in within-group standard deviations).
  \item \code{2 - "min"} specifies that \code{limits} will be interpreted as a (one-sided) minimum threshold. The underlying code is equivalent to \code{X[X < limits] <- value}.
  \item \code{3 - "max"} specifies that \code{limits} will be interpreted as a (one-sided) maximum threshold. The underlying code is equivalent to \code{X[X > limits] <- value}.
  \item \code{4 - "overall_SDs"} is equivalent to "SDs" but ignores groups when a \code{grouped_df}, \code{pseries} or \code{pdata.frame} is passed (i.e. standardizing and determination of outliers is by the overall column standard deviation).
}
}
}
% \details{
%%  ~~ If necessary, more details than the description above ~~
% }
% \value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% \dots
% }
% \references{
%% ~put references to the literature/web site here ~
% }
% \author{
%%  ~~who you are~~
% }
\note{
These functions are not generic and do not offer support for factors or date(-time) objects. see \code{dplyr::recode_factor}, \emph{forcats} and other appropriate packages for dealing with these classes.
}

%% ~Make other sections like Warning with \section{Warning }{\dots.} ~

\seealso{
\link[=collapse-documentation]{Collapse Overview}, \link[=AA2-small-helpers]{Small (Helper) Functions}
}
\examples{
recode_char(c("a","b","c"), a = "b", b = "c")
recode_char(month.name, ber = NA, regex = TRUE)
mtcr <- recode_num(mtcars, `0` = 2, `4` = Inf, `1` = NaN)
replace_Inf(mtcr)
replace_Inf(mtcr, replace.nan = TRUE)
replace_outliers(mtcars, c(2, 100))                 # Replace all values below 2 and above 100 w. NA
replace_outliers(mtcars, 2, single.limit = "min")   # Replace all value smaller than 2 with NA
replace_outliers(mtcars, 100, single.limit = "max") # Replace all value larger than 100 with NA
replace_outliers(mtcars, 2)                         # Replace all values above or below 2 column-
                                                    # standard-deviations from the column-mean w. NA
replace_outliers(fgroup_by(iris, Species), 2)       # Passing a grouped_df, pseries or pdata.frame
                                                    # allows to remove outliers according to
                                                    # in-group standard-deviation. see ?fscale
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip} % __ONLY ONE__ keyword per line % use one of  RShowDoc("KEYWORDS")
\keyword{documentation}
