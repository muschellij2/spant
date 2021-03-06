% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/amp_scaling.R
\name{scale_amp_ratio}
\alias{scale_amp_ratio}
\title{Scale fitted amplitudes to a ratio of signal amplitude.}
\usage{
scale_amp_ratio(fit_result, name)
}
\arguments{
\item{fit_result}{a result object generated from fitting.}

\item{name}{the signal name to use as a denominator (usually, "TCr" or
"TNAA").}
}
\value{
a \code{fit_result} object with a res_tab_ratio data table added.
}
\description{
Scale fitted amplitudes to a ratio of signal amplitude.
}
