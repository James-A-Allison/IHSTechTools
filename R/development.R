#' Add new groupings data
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
#' \dontrun{add_new_groupings()}
#'
#' @export
add_new_groupings <- function() {

  filepath <- file.choose()
  groupings <- read.csv(filepath)
  devtools::use_data(groupings, overwrite = TRUE)

}
