# app.R
# Gina Nichols, adapted from 
# Noé Vandevoorde, October 2025


#### Packages ##################################################################

library(tidyverse)
library(shiny)
library(shinydashboard)
library(readxl)
library(ggnewscale)
library(ggpattern)
library(devtools)
library(DT)
library(patchwork)
#devtools::install_github("vanichols/ADOPTpkg")
library(ADOPTpkg)

#### Sources ###################################################################

#source("R/prep_utils.R")
source("R/ui.R")
source("R/server.R")


#### Run the app ###############################################################

shinyApp(ui = ui, server = server)
