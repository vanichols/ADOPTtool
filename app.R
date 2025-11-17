# app.R
# Gina Nichols, adapted from 
# Noé Vandevoorde, October 2025


#### Packages ##################################################################

library(shiny)
library(shinydashboard)
library(rhandsontable)
library(DT)
#devtools::install_github("vanichols/ADOPTpkg", force = T)
library(ADOPTpkg)

#### Sources ###################################################################

source("R/ui.R")
source("R/server.R")

#--use the data from the ADOPTpkg
df <- adopt_hpli #--data for single and comparing substances tabs, pesticide table,

#### Run the app ###############################################################

shinyApp(ui = ui, server = server)
