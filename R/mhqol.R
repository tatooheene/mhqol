#' A function to calculate the utility  of the MHQoL
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' This function calculates the utility of the MHQoL based on the scores of the different dimensions.
#'
#' @param dimensions A dataframe, character vector, numeric vector, or list containing the dimensions of the MHQoL.
#' Must contain the following dimensions: SI (Self-Image), IN (INdependence),
#' MO (MOod), RE (RElationships), DA (Daily Activities), PH (Physical Health), FU (FUture).
#'
#' @param metric A character value indicating whether to calculate the "total" or "average" utility.
#'
#' @param ignore.invalid If TRUE, the function will ignore missing dimensions and continue processing.
#' If FALSE, the function will stop and throw an error.
#'
#' @param ignore.NA If TRUE, the function will ignore NA values in the input data.
#' If FALSE, the function will stop and throw an error.
#'
#'
#' @return A dataframe containing the utilities based on the MHQoL valuesets
#'
#' @keywords MHQoL, Utility, Dimensions
#'
#' @examples
#' # Example usage of the mhqol_utilities function
#' # Get the utility based on a numeric vector and calculate the total utility, not all dimensions are present
#' mhqol(dimensions = c(IN = 2, MO = 3, RE = 2, DA = 1, PH = 2, FU = 3), metric = "total", ignore.invalid = TRUE)
#'
#' # Get the utility based on a dataframe and calculate the average utility
#' mhqol(dimensions = data.frame(SI = 1, IN = 2, MO = 3, RE = 2, DA = 1, PH = 2, FU = 3), metric = "average")








#HIER NOG TATOOHEENE VOORZETTEN!
mhqol     <- function(dimensions,
                      country = "Netherlands",
                      metric = c("average", "total"),
                      ignore.invalid = FALSE,
                      ignore.NA = TRUE) {


  # Check if metric is a single value
  if (length(metric) != 1) {
    stop("The 'metric' argument must be a single value. Please choose either 'total' or 'average' ")
  }

  # Check if metric is either "total" or "average"
  if (!metric %in% c("total", "average")) {
    stop("Invalid metric chosen. Please choose either 'total' or 'average'.")
  }

  # Check whether the input are characters or numeric

  data <-  mhqol::mhqol_utilities(dimensions = dimensions,
                           country = country,
                           ignore.invalid = ignore.invalid,
                           ignore.NA = ignore.NA,
                           retain_old_variables = FALSE)


  # If the chosen metric is "total", provide a total score per participant
  if(metric == "total"){
    data <- data |>
      dplyr::mutate(
        utility = 1 + rowSums(dplyr::across(dplyr::everything()), na.rm = TRUE)
      )

    return(data)

    # If the chosen metric is "average", provide an average score per dimension and overall
  } else if(metric == "average"){

    data <- data |>
      dplyr::mutate(
        utility = 1 + rowSums(dplyr::across(dplyr::everything()), na.rm = TRUE)
      )

    SI_u_average <- mean(data$SI_u, na.rm = TRUE)
    IN_u_average <- mean(data$IN_u, na.rm = TRUE)
    MO_u_average <- mean(data$MO_u, na.rm = TRUE)
    RE_u_average <- mean(data$RE_u, na.rm = TRUE)
    DA_u_average <- mean(data$DA_u, na.rm = TRUE)
    PH_u_average <- mean(data$PH_u, na.rm = TRUE)
    FU_u_average <- mean(data$FU_u, na.rm = TRUE)
    utility_average <- mean(data$utility, na.rm = TRUE)

    df <- data.frame(SI_u_average,
                     IN_u_average,
                     MO_u_average,
                     RE_u_average,
                     DA_u_average,
                     PH_u_average,
                     FU_u_average,
                     utility_average)

    return(df)
  }

}
