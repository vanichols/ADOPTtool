# ui.R
library(shiny)
library(shinydashboard)
library(ADOPTpkg)

# Gina Nichols, adapted from code created by
# Noé Vandevoorde octobre 2025


#### User Interface ############################################################

ui <- shinydashboard::dashboardPage(

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
    ,menuItem("  Qualitative Data Analyses", tabName = "qual_data", icon = icon("leaf"))
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
      # Add the adopt ipm logo (not working)
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
              ## First row
              fluidRow(

                # Substance selection box
                box(title = "Substance Selection",
                    status = "primary", # "info",
                    solidHeader = TRUE,
                    width = 4,
                    height = "275px",  # Added consistent height

          # Filter options
          selectizeInput("substance_category",
                         label = NULL,
                         choices = NULL,  # populated from data in the server
                         multiple = TRUE,
                         selected = NULL,
                         options = list(placeholder = "Filter by category")),
          selectizeInput("substance_origins",
                                 label = NULL,
                                 choices = NULL, # populated from data in the server
                                 multiple = TRUE,
                                 selected = NULL,
                                 options = list(placeholder = "Filter by origin")),

          # Substance selection
                  selectInput("substance_single",
                              "Select Substance:",
                              choices = NULL, # populated from data in the server
                              selected = NULL)
                ),

      # Substance information box
                box(title = "Substance Information",
                    status = "primary", # "info",
                    solidHeader = TRUE,
                    width = 4,
                    height = "275px",  # Added consistent height
                    verbatimTextOutput("substance_info")
                ),
      # Download Data box - replaced the data table
      box(title = "Download Load Score Details",
          status = "primary",
          solidHeader = TRUE,
          width = 4,
          height = "275px",  # Added consistent height
          div(
            style = "text-align: center; padding: 20px;",
            p("Download the detailed load score data for the selected substance:"),
            br(),
            downloadButton("download_data", 
                           "Download Data (TSV)", 
                           class = "btn-success btn-lg",  # Changed to green
                           icon = icon("download"),
                style = "background-color: #ffd74a; border-color: #ffd74a;")  # Custom green color
            # downloadButton("download_data", 
            #                "Download Data (TSV)", 
            #                class = "btn-primary btn-lg",
            #                icon = icon("download"))
          )
      )
              ),
      ## Second row, two graphs (one rose and one distribution), blank area not sure what to do with
              fluidRow(
                #--Rose plot box
                box(title = "Load Scores by Compartment",
                    status = "primary",
                    solidHeader = TRUE,
                    width = 4,
                    plotOutput("rose_plot",
                               height = "500px")
                ),
                #--Distribution box
                box(title = "Load Score Relative to All Substances",
                    status = "primary",
                    solidHeader = TRUE,
                    width = 4,
                    plotOutput("dist_plot",
                               height = "500px")
                ),
                # Information and links box
                box(title = "Additional Resources",
                    status = "info",
                    solidHeader = TRUE,
                    width = 4,
                    div(
                      style = "padding: 15px;",
                      h4("About Load Scores"),
                      p("Load scores represent a relative toxicity burden ."),
                      p("The visualization shows a substance's load scores for each compartment, as calculated by Vandervoode et al. (in review)"),
                      br(),
                      h4("Useful Links"),
                      tags$ul(
                        tags$li(tags$a("Pesticide Properties Database", href = "https://sitem.herts.ac.uk/aeru/ppdb/", target = "_blank")),
                        tags$li(tags$a("PhD manuscript with more details and background", 
                                       href = "https://sytra.be/publication/three-tools-reduction-pesticide-impacts/", target = "_blank"))
                        
                      ),
                      br(),
                      p(strong("To calculate the overall load, multiply the amount of substance applied by its load score."), 
                        "See A FORTHCOMING PUBLICATION for more details.")
                    )
                )
              )
      
      ), #--end of first tab 

###### Body: Two Substance Tab ######

tabItem(tabName = "compare",
        fluidRow(
          
          # Substance1 selection
          box(title = "First substance selection",
              status = "primary", # "info",
              solidHeader = TRUE,
              width = 4,
              
              # Filter options
              selectizeInput("substance_category1",
                             label = NULL,
                             choices = NULL,  # populated from data in the server
                             multiple = TRUE,
                             selected = NULL,
                             options = list(placeholder = "Filter by category")),
              selectizeInput("substance_origins1",
                             label = NULL,
                             choices = NULL, # populated from data in the server
                             multiple = TRUE,
                             selected = NULL,
                             options = list(placeholder = "Filter by origin")),
              selectInput("substance_double1",
                          "Select Substance:",
                          choices = NULL, # populated from data in the server
                          selected = NULL)
          ),
          
          # Substance2 selection
          box(title = "Second substance selection",
              status = "primary", # "info",
              solidHeader = TRUE,
              width = 4,
              
              # Filter options
              selectizeInput("substance_category2",
                             label = NULL,
                             choices = NULL,  # populated from data in the server
                             multiple = TRUE,
                             selected = NULL,
                             options = list(placeholder = "Filter by category")),
              selectizeInput("substance_origins2",
                             label = NULL,
                             choices = NULL, # populated from data in the server
                             multiple = TRUE,
                             selected = NULL,
                             options = list(placeholder = "Filter by origin")),
             
              # Substance selection
              selectInput("substance_double2",
                          "Select Substance:",
                          choices = NULL, # populated from data in the server
                          selected = NULL)
          ),
          # Blank space
          column(width = 4)
          
          ),
        
        fluidRow(
          # Rose plot first substance
          box(title = "First Substance Load Scores",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              plotOutput("rose_plot1",
                         height = "500px")
          ),
          
          # Rose plot second substance
          box(title = "Second Substance Load Scores",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              plotOutput("rose_plot2",
                         height = "500px")
          ),
          #--figure with distributions
          box(title = "Load Score(s) Relative to All Substances",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              plotOutput("dist_plot_both",
                         height = "500px")
          ),
        )
        
       
), #--end of second tab
###### Body: Custom Data Upload Tab ######

tabItem(tabName = "qual_data",
        ## First row - Upload and template download controls
        fluidRow(
          
          # Download template box
          box(title = "Download Template",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              height = "275px",
              div(
                style = "text-align: center; padding: 20px;",
                p("Download a template file to fill in with your substance data:"),
                br(),
                downloadButton("download_template", 
                               "Download Template (TSV)", 
                               class = "btn-info btn-lg",
                               icon = icon("download"),
                               style = "background-color: #17a2b8; border-color: #17a2b8;"),
                br(), br(),
                p(style = "font-size: 12px; color: #666;", 
                  "Fill in the template with substance names and application amounts, then upload it back.")
              )
          ),
          
          # Upload data box
          box(title = "Upload Filled Template",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              height = "275px",
              div(
                style = "padding: 15px;",
                fileInput("upload_file",
                          "Choose TSV File",
                          accept = c(".tsv", ".txt"),
                          placeholder = "No file selected"),
                br(),
                conditionalPanel(
                  condition = "output.upload_status",
                  div(
                    style = "margin-top: 10px;",
                    verbatimTextOutput("upload_status")
                  )
                )
              )
          ),
          
          # Generate plot button box
          box(title = "Generate Visualization",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              height = "275px",
              div(
                style = "text-align: center; padding: 20px;",
                p("Create a plot using your uploaded data:"),
                br(),
                actionButton("generate_plot", 
                             "Generate Plot", 
                             class = "btn-success btn-lg",
                             icon = icon("chart-bar"),
                             style = "background-color: #28a745; border-color: #28a745;"),
                br(), br(),
                p(style = "font-size: 12px; color: #666;", 
                  "Click to create visualization from uploaded data.")
              )
          )
        ),
        
        ## Second row - Plot display
        fluidRow(
          box(title = "Custom Data Visualization",
              status = "primary",
              solidHeader = TRUE,
              width = 12,
              div(
                style = "min-height: 500px;",
                conditionalPanel(
                  condition = "output.custom_plot_available",
                  plotOutput("custom_plot", height = "500px")
                ),
                conditionalPanel(
                  condition = "!output.custom_plot_available",
                  div(
                    style = "text-align: center; padding: 50px; color: #999;",
                    h4("No plot available"),
                    p("Upload data and click 'Generate Plot' to display visualization here.")
                  )
                )
              )
          )
        )
) #--end of third tab
    )
  )
)
