# Global setup - runs once when app starts


# Gina Nichols, adapted from Noé Vandevoorde code shared October 2025


#### Packages ##################################################################

library(shiny)
library(shinydashboard)
library(readxl)
library(janitor)

#--tidyverse packages
library(tidyverse)
#library(dplyr)
#library(tidyr)
#library(forcats)
#library(stringr)

#--ggplot things
library(ggplot2)
library(ggridges)
library(patchwork)
library(ggrepel)
library(ggnewscale)


# Source utility functions (rose plot, distribution plot)
source("R/utils.R")

# Load data

#--this is still called inside the server as well, sort of
data_hpli <- 
  read_rds("data/processed/data_hpli.RDS")

data_betas <- 
  read_rds("data/processed/data_betas.RDS")

data_example <- 
  read_rds("data/processed/data_example.RDS")


# Global configurations
# app_config <- list(
#   title = "My Modular Shiny App",
#   theme = bs_theme(bootswatch = "flatly")
# )