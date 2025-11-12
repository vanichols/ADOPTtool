# ui.R

# Gina Nichols, adapted from code created by
# Noé Vandevoorde octobre 2025


#### User Interface ############################################################

ui <- dashboardPage(

  #skin = "green", # Try: "blue", "black", "purple", "yellow", "red", "green"
  

###### Header ##################################################################

  dashboardHeader(title = "ADOPT-IPM online tool"),


###### Sidebar #################################################################

  dashboardSidebar(

### Menu ###

    sidebarMenu(
      menuItem("  Single Substance View", tabName = "single", icon = icon("flask"))
    ## Other tabs could be added, such as a comparison View, detailed data table,
    ## product level visualisation/info, data sources (PPDB) and link to the publication.
    ## E.g.: (idea to develop, or not … not linked to any further UI or Server code)
     ,menuItem("  Substance Comparison View", tabName = "compare", icon = icon("flask-vial"))
      # ,menuItem("  Strategy View", tabName = "data", icon = icon("magnifying-glass-plus"))
      # ,menuItem("  Strategy Comparison View", tabName = "source", icon = icon("balance scale"))
    ),

    ### Credit info, ADOPT IPM logo ###
    
    div(
      style = "position: fixed;
               bottom: 15px;
               left: 15px;
               font-size: 12px;
               color: #888;
               z-index: 1000;",
      # Add the image
      #img(src = "adopt-ipm_logo-clean.png", height = "50px", width = "auto", style = "margin-bottom: 5px;"),
      br(),
      HTML("<a href='https://adopt-ipm.eu/' target='_blank'>adopt-ipm.eu</a><br>
             Nichols and Vandevoorde (2025)<br>
            Last updated: Nov 2025<br>")
    )
  ),


###### Body ####################################################################

  dashboardBody(
    
    tabItems(

###### Body: Single Substance Tab ######

      tabItem(tabName = "single",
              fluidRow(

      # Substance selection
                box(title = "Substance Selection",
                    status = "primary", # "info",
                    solidHeader = TRUE,
                    width = 4,

          # Filter options
                  selectizeInput("substance_origins",
                                 label = NULL,
                                 choices = NULL, # populated from data in the server
                                 multiple = TRUE,
                                 selected = NULL,
                                 options = list(placeholder = "Filter by origin")),
                  selectizeInput("substance_types",
                                 label = NULL,
                                 choices = NULL,  # populated from data in the server
                                 multiple = TRUE,
                                 selected = NULL,
                                 options = list(placeholder = "Filter by type")),
                  selectizeInput("substance_groups",
                                 label = NULL,
                                 choices = NULL,  # populated from data in the server
                                 multiple = TRUE,
                                 selected = NULL,
                                 options = list(placeholder = "Filter by family")),
          # Substance selection
                  selectInput("substance_single",
                              "Select Substance:",
                              choices = NULL, # populated from data in the server
                              selected = NULL)
                ),

      # Substance information
                box(title = "Substance Information",
                    status = "primary", # "info",
                    solidHeader = TRUE,
                    width = 8,
                    verbatimTextOutput("substance_info")
                )
              ),

      # HPL graph
              fluidRow(
                box(title = "Harmonised Pesticide Load Score",
                    status = "primary",
                    solidHeader = TRUE,
                    width = 12,
                    plotOutput("rose_plot",
                               height = "500px")
                )
              ),

      # # Data table
      #         fluidRow(
      #           box(title = "Load Score Details",
      #               status = "primary", # "info", "success", "warning",
      #               solidHeader = TRUE,
      #               width = 12,
      #               shiny::renderDataTable("score_details")
      #           )
      #         )
      #   )
      
      # Download Data section - replaced the data table
      fluidRow(
        box(title = "Download Load Score Details",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            div(
              style = "text-align: center; padding: 20px;",
              p("Download the detailed load score data for the selected substance:"),
              br(),
              downloadButton("download_data", 
                             "Download Data (TSV)", 
                             class = "btn-primary btn-lg",
                             icon = icon("download"))
            )
        )
      )
      )
    )
  )
)
