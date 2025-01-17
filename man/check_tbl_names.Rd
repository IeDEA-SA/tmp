% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_tbls.R
\name{check_tbl_names}
\alias{check_tbl_names}
\title{Check current & previous tables for shared variables.}
\usage{
check_tbl_names(x)
}
\arguments{
\item{x}{a list containing tibble of the \code{previous} and \code{current} versions of
a table.}
}
\value{
a list containing the results of checks and associated metadata:
\itemize{
\item \code{check}: Check name
\item \code{valid}: Logical. Whether the table has any valid columns that can be compared.
\item \code{msg}: check result message
\item \code{valid_cols}: Names of shared columns across previous and current tbls.
\item \code{clean_names}: Logical. Whether names require cleaning to match.
}
}
\description{
Check current & previous tables for shared variables.
}
