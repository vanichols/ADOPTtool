# ui.R

# Gina Nichols, adapted from code created by
# Noé Vandevoorde octobre 2025


#### User Interface ############################################################

ui <- dashboardPage(


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

### Credit info, should link to adopt ipm website i suppose ###

    div(
      style = "position: fixed;
               bottom: 15px;
               left: 15px;
               font-size: 12px;
               color: #888;
               z-index: 1000;",
      HTML(#"<a href='https://sytra.be' target='_blank'>sytra.be</a><br>
           "<a href='https://adopt-ipm.eu/' target='_blank'>adopt-ipm.eu</a><br>
             Nichols and Vandevoorde (2025)<br>
            Last updated: Nov 2025<br>"
            #<a href='mailto:noe.vandevoorde@uclouvain.be'>noe.vandevoorde@uclouvain.be</a>"
           )
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

      # Data table
              fluidRow(
                box(title = "Load Score Details",
                    status = "primary", # "info", "success", "warning",
                    solidHeader = TRUE,
                    width = 12,
                    shiny::renderDataTable("score_details")
                )
              )
        )

# ###### Body: Substance comparison tab ######
# ,
# tabItem(tabName = "compare",
#         fluidRow(
#           
#           # Substance 1 selection
#           box(title = "Substance #1 Selection",
#               status = "primary", # "info",
#               solidHeader = TRUE,
#               width = 4,
#               
#               # Filter options
#               selectizeInput("substance_origins1",
#                              label = NULL,
#                              choices = NULL, # populated from data in the server
#                              multiple = TRUE,
#                              selected = NULL,
#                              options = list(placeholder = "Filter by origin")),
#               selectizeInput("substance_types1",
#                              label = NULL,
#                              choices = NULL,  # populated from data in the server
#                              multiple = TRUE,
#                              selected = NULL,
#                              options = list(placeholder = "Filter by type")),
#               selectizeInput("substance_groups1",
#                              label = NULL,
#                              choices = NULL,  # populated from data in the server
#                              multiple = TRUE,
#                              selected = NULL,
#                              options = list(placeholder = "Filter by family")),
#               # Substance selection
#               selectInput("substance_single1",
#                           "Select Substance:",
#                           choices = NULL, # populated from data in the server
#                           selected = NULL)
#           ),
#           
#           # Substance 2 selection
#           box(title = "Substance #2 Selection",
#               status = "primary", # "info",
#               solidHeader = TRUE,
#               width = 4,
#               
#               # Filter options
#               selectizeInput("substance_origins2",
#                              label = NULL,
#                              choices = NULL, # populated from data in the server
#                              multiple = TRUE,
#                              selected = NULL,
#                              options = list(placeholder = "Filter by origin")),
#               selectizeInput("substance_types2",
#                              label = NULL,
#                              choices = NULL,  # populated from data in the server
#                              multiple = TRUE,
#                              selected = NULL,
#                              options = list(placeholder = "Filter by type")),
#               selectizeInput("substance_groups2",
#                              label = NULL,
#                              choices = NULL,  # populated from data in the server
#                              multiple = TRUE,
#                              selected = NULL,
#                              options = list(placeholder = "Filter by family")),
#               # Substance selection
#               selectInput("substance_single2",
#                           "Select Substance:",
#                           choices = NULL, # populated from data in the server
#                           selected = NULL)
#           ),
#         
#         # HPL graph
#         fluidRow(
#           box(title = "Harmonised Pesticide Load Score Comparison",
#               status = "primary",
#               solidHeader = TRUE,
#               width = 12,
#               plotOutput("paired_rose_plots",
#                          height = "500px")
#           )
#         ),
#         
#         # Data table
#         fluidRow(
#           box(title = "Load Score Details",
#               status = "primary", # "info", "success", "warning",
#               solidHeader = TRUE,
#               width = 12,
#               DT::dataTableOutput("score_details")
#           )
#         )
# )

###### Body: Other Tab ######

# Other tabs to be added here, e.g.:

    )
  )
)
