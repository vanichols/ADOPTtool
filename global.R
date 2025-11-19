# Global setup - runs once when app starts


# Gina Nichols, adapted from Noé Vandevoorde code shared October 2025


#### Packages ##################################################################

library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)


# Source utility functions
source("R/utils.R")

# Load data
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