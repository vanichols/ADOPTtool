# app.R
# Gina Nichols, adapted from 
# Noé Vandevoorde, October 2025


#### Packages ##################################################################

library(shiny)
library(shinydashboard)
#library(readxl)
#library(DT)
#devtools::install_github("vanichols/ADOPTpkg")
library(ADOPTpkg)
options(shiny.legacy.datatable = TRUE)

#### Sources ###################################################################

#source("R/prep_utils.R")
source("R/ui.R")
source("R/server.R")


#### Run the app ###############################################################

shinyApp(ui = ui, server = server)
