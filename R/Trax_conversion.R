#' Change Directory
#'
#' A simple function for changing directory.
#'
#' @param dir the name of the file path
#'
#' @return Nothing is returned
#'
#' @examples
#' changeDir(dir = getwd())
#'
#' @export
changeDir <- function(dir = "M:/All Services Visualisation/Trax files to be converted/Files") {
  setwd(dir)
  message("Convert one of the files listed below using convertTraxFile or convertAll")
  list.files()
}


#' Check packages
#'
#' This function checks if the local copy of R has the dependent packakges
#' installed. If they are available, they will be attached. If the packages are
#' missing, this function installs them.
#'
#'
#' @examples
#' check_pkgs()
#'
#' @export
check_pkgs <- function() {

  if(!requireNamespace("tidyr")) {
    message("installing the 'tidyr' package")
    install.packages("tidyr")
  }
  if(!requireNamespace("data.table")) {
    message("installing the 'data.table' package")
    install.packages("data.table")
  }
  if(!requireNamespace("dplyr")) {
    message("installing the 'dplyr' package")
    install.packages("dplyr")
  }

}

#' Convert Trax File
#'
#' This is function converts Trax files to the wide format for use with
#' Power BI.
#'
#' @param filename the name along with the file path for the data
#' @param dir defaulted to the current working directory. This is the target
#' directory for your files.
#'
#'
#' @return returns a formatted file in your given location.
#'
#'
#' @export
convertTraxFile <- function(filename, dir = getwd()) {

  check_pkgs()
  data <- read.csv(filename, skip = 13, stringsAsFactors = FALSE, encoding = "UTF-8")

  #data$Measure <- gsub(pattern = "â€“", replacement = "-", x = data$Measure)
  # create dates from periods - needs to be made into a function
  data$PeriodActual <- sapply(data$PeriodCode, function(x){
    if (!is.na(strsplit(x, "Y")[[1]][2])) {
      paste0("31/12/", strsplit(x, "Y")[[1]][2])
    }
    else {
      y <- strsplit(x, "-")
      if (y[[1]][1] == "Q1") {
        paste0("31/3/20", y[[1]][2])
      }
      else if (y[[1]][1] == "Q2") {
        paste0("30/6/20", y[[1]][2])
      }
      else if (y[[1]][1] == "Q3") {
        paste0("30/9/20", y[[1]][2])
      }
      else {
        paste0("31/12/20", y[[1]][2])
      }
    }
  })

  data_unique <- unique(data)
  keys <- colnames(data_unique)[!grepl('Value',colnames(data_unique))]
  # Removes duplicate values
  data_unique <- data.table::as.data.table(data_unique)
  # sum repeat entries
  data_unique <- data_unique[,list(Value= sum(Value)),keys]

  # spread data to wide format
  #test <- merge(data_unique, groupings, by.x = "Measure", by.y = "Measure")
  #data_unique$Measure <- as.factor(data_unique$Measure)
  #groupings$Measure <- stringi::stri_conv(as.character(groupings$Measure), from = ""
  test <- dplyr::left_join(data_unique, groupings, by = c("Measure" = "Measure"))
  test_spread <- tidyr::spread(test, key = Value_Field, value = Value, fill = 0)

  # Apply multiplier
  v <- which(names(test_spread) == "Multiplier")
  columns <- c((v+1):length(names(test_spread)))
  c <- names(test_spread)[columns]
  class(test_spread) <- "data.frame"
  test_spread[c] <- test_spread[c] * test_spread$Multiplier
  test_spread$Multiplier <- NULL

  dir_name <-createPath(filename, dir)
  write.csv(file = dir_name, x = test_spread)
  cat(message(paste("Formatted file written in: ", dir)))
}

#' Create Converted File Name
#'
#' This is function creates a file name with the pre-fix "formatted - "
#' for passing to the file writing function
#'
#' @param filename name of original file
#' @param dir destination directory for converted file
#'
#'
#' @return returns full path of directory and file name for saving
#'
#'
#' @export
createPath <- function(filename, dir) {

  file_name <- strsplit(filename, "/")[[1]]
  name <- file_name[length(file_name)]
  name <- paste0("formatted - ", name)
  dir_name <- paste0(dir, "/", name)
  dir_name

}

#' Convert All Trax Files
#'
#' This is function file handler is for converting all files in the
#' given directory.
#'
#' @inheritParams changeDir
#' @param dest The path where your converted files will be saved.
#'
#'
#' @return returns a formatted version of all the files in the directory
#'
#'
#' @export
convertAll <- function(dir = getwd(), dest) {
  setwd(dir)
  files <- list.files()

  for (i in 1:length(files)) {
    convertTraxFileBeta(files[i], dest)

  }
}

#' Convert Quarters to dates
#'
#' This is a function for converting the Trax quarter format to a date of the
#' form dd/mm/yyyy.
#'
#' @param data this function takes a data frame created from a Trax file.
#'
#'
#' @return Nothing is returned. An additional column is added to the inputted
#' data frame.
#'
#'
#' @export
quarter_to_date <- function(data) {

  # create dates from periods
  data$PeriodActual <- sapply(data$PeriodCode, function(x){
    if (!is.na(strsplit(x, "Y")[[1]][2])) {
      paste0("31/12/", strsplit(x, "Y")[[1]][2])
    }
    else {
      y <- strsplit(x, "-")
      if (y[[1]][1] == "Q1") {
        paste0("31/3/20", y[[1]][2])
      }
      else if (y[[1]][1] == "Q2") {
        paste0("30/6/20", y[[1]][2])
      }
      else if (y[[1]][1] == "Q3") {
        paste0("30/9/20", y[[1]][2])
      }
      else {
        paste0("31/12/20", y[[1]][2])
      }
    }
  })
  data
}

#' Convert Trax File without encoding
#'
#' This is function converts Trax files to the wide format for use with
#' Power BI.
#'
#' @param filename the name along with the file path for the data
#' @param dir defaulted to the current working directory. This is the target
#' directory for your files.
#'
#'
#' @return returns a formatted file in your given location.
#'
#'
#' @export
convertTraxFileBeta <- function(filename, dir = getwd()) {

  check_pkgs()
  data <- read.csv(filename, skip = 13, stringsAsFactors = FALSE)#, encoding = "UTF-8")

  data$Measure <- gsub(pattern = "â€“", replacement = "-", x = data$Measure)
  # create dates from periods - needs to be made into a function
  data$PeriodActual <- sapply(data$PeriodCode, function(x){
    if (!is.na(strsplit(x, "Y")[[1]][2])) {
      paste0("31/12/", strsplit(x, "Y")[[1]][2])
    }
    else {
      y <- strsplit(x, "-")
      if (y[[1]][1] == "Q1") {
        paste0("31/3/20", y[[1]][2])
      }
      else if (y[[1]][1] == "Q2") {
        paste0("30/6/20", y[[1]][2])
      }
      else if (y[[1]][1] == "Q3") {
        paste0("30/9/20", y[[1]][2])
      }
      else {
        paste0("31/12/20", y[[1]][2])
      }
    }
  })

  data_unique <- unique(data)
  keys <- colnames(data_unique)[!grepl('Value',colnames(data_unique))]
  # Removes duplicate values
  data_unique <- data.table::as.data.table(data_unique)
  # sum repeat entries
  data_unique <- data_unique[,list(Value= sum(Value)),keys]

  # spread data to wide format
  #test <- merge(data_unique, groupings, by.x = "Measure", by.y = "Measure")
  #data_unique$Measure <- as.factor(data_unique$Measure)
  #groupings$Measure <- stringi::stri_conv(as.character(groupings$Measure), from = ""
  test <- dplyr::left_join(data_unique, groupings, by = c("Measure" = "Measure"))
  test_spread <- tidyr::spread(test, key = Value_Field, value = Value, fill = 0)

  # Apply multiplier
  v <- which(names(test_spread) == "Multiplier")
  columns <- c((v+1):length(names(test_spread)))
  c <- names(test_spread)[columns]
  class(test_spread) <- "data.frame"
  test_spread[c] <- test_spread[c] * test_spread$Multiplier
  test_spread$Multiplier <- NULL

  dir_name <-createPath(filename, dir)
  write.csv(file = dir_name, x = test_spread)
  cat(message(paste("Formatted file written in: ", dir)))
}
