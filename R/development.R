#' Update Groupings data
#'
#' A function used for editing the internal package data "groupings".
#' When run, you will be prompted to give the file which you wish to
#' replace the internal data with. It will then be added to the package.
#' This function will only run if you are in the package.
#'
#'
#' @return Nothing is returned
#'
#' @examples
#' \dontrun{update_groupings()}
#'
#' @export
update_groupings <- function() {

  filepath <- file.choose()
  groupings <- read.csv(filepath)
  devtools::use_data(groupings, overwrite = TRUE)

}

#' Use Alternative Grouping
#'
#' A function used for overriding the internal package data "groupings" with your own
#' data file (csv format). This must be run before any file conversion to allow the
#' alternative groupings to be used.
#'
#' @param file  csv format file (with path) that you wish to use for Trax files groupings
#'
#' @return Nothing is returned but global variable of groupings created
#'
#' @examples
#' \dontrun{alternative_groupings()}
#'
#' @export
alternative_groupings <- function(file) {
  data <- read.csv(file)
  assign(x = "groupings", value = data, envir = globalenv())

}

######## Package Documentation #################

#' IHSTechTools: A package for all things IHS Technology
#'
#' Designed to make data ETL, analysis and visualisation easier,the
#' IHSTechTools package provides three categories of important functions:
#' Trax, Database and Visualisation.
#'
#' @section Trax functions:
#' The Trax functions are designed for creating Trax files from the database and
#' manipulating Trax files for other uses e.g. Power BI.
#'
#' @section Database functions:
#'
#' The database functions let users access, play and push data to the MySQL database
#' manually.
#'
#' @section Visualisation functions:
#'
#' Features and functions will be added for quick visualisation.
#'
#' @docType package
#' @name IHSTechTools
NULL
