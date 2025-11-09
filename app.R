# app.R
# Gina Nichols, adapted from 
# Noé Vandevoorde, October 2025


#### Packages ##################################################################

load_packages <- function(pkgs) {
  for (pkg in pkgs) {
    if (!require(
        pkg,
        character.only = TRUE,
        quietly = TRUE,
        warn.conflicts = FALSE)) {
      install.packages(
        pkg,
        dependencies = TRUE)
      library(
        pkg,
        character.only = TRUE,
        warn.conflicts = FALSE)
    }
  }
}

load_packages(c(
   "tidyverse",
   "shiny",
   "shinydashboard",
   "readxl",
   "ggnewscale",
   "ggpattern",
   "devtools",
   "DT"
))

#devtools::install_github("vanichols/ADOPTpkg")
library(ADOPTpkg)

#### Sources ###################################################################

#source("R/prep_utils.R")
source("R/ui.R")
source("R/server.R")


#### Run the app ###############################################################

shinyApp(ui = ui, server = server)
