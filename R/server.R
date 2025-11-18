# server.R
library(shiny)
library(shinydashboard)
library(ADOPTpkg)

#### Server ####################################################################

server <- function(input, output, session) {
  #--max size is 160 MB
  #options(shiny.maxRequestSize = 160*1024^2) #--recommended based on a help website
  #--use the data from the ADOPTpkg
  df <- adopt_hpli #--data for first tab at least...
  
  # First tab ====
  
  ###### Populate filter lists (runs once at app startup) ######
  
  
  observeEvent(TRUE, {
    # Substance category filter
    updateSelectInput(session,
                      "substance_category",
                      choices = unique(df$compound_category) |>
                        sort())
    # Substance origin filter
    updateSelectInput(session,
                      "substance_origins",
                      choices = unique(df$compound_origin) |>
                        sort())
  }, once = TRUE)
  
  
  
  ###### Populate list of substance (reacts on filters) ######
  #--data for second tab, 1st choice
  substance_choices <- reactive({
    df_filtered <- df
    
    # Filter by origin only if an origin is selected
    if (!is.null(input$substance_origins) &&
        length(input$substance_origins) > 0) {
      df_filtered <-
        df_filtered |>
        dplyr::filter(compound_origin %in% input$substance_origins)
    }
    
    # Filter by category only if a category is selected
    if (!is.null(input$substance_category) &&
        length(input$substance_category) > 0) {
      df_filtered <-
        df_filtered |>
        dplyr::filter(compound_category %in% input$substance_category)
    }
    
    
    # Format final substance list
    df_filtered |>
      dplyr::pull(compound) |>
      unique() |>
      sort()
  })
  
  ###### Selected substance based on user choice ######
  observe({
    choices <- substance_choices()
    selected <- isolate(input$substance_single)
    if (!is.null(selected))
      selected <- selected[selected %in% choices]
    updateSelectInput(session,
                      "substance_single",
                      choices = choices,
                      selected = selected)
    updateSelectInput(session, "substances_compare", choices = choices)
  })
  
  # If current selection is no longer valid (e.g. after a new filter is applied), clear it
  observe({
    valid_choices <- substance_choices()
    current <- input$substance_single
    if (!is.null(current) && !current %in% valid_choices) {
      updateSelectInput(session, "substance_single", selected = "")
      #updateSelectInput(session, "substances_compare", selected = "")
    }
  })
  
  ###### Reduce data based on selected substance ######
  single_substance_data <- reactive({
    req(input$substance_single)
    df <- adopt_hpli
    df[df$compound == input$substance_single, ]
  })
  
  ###### Display substance data ######
  output$substance_info <- renderText({
    # Make it reactive to both inputs
    choices <- substance_choices()
    selected <- input$substance_single
    # Clear out if nothing selected or selection invalid
    if (is.null(selected) ||
        selected == "" || !selected %in% choices) {
      return("")
    }
    # Normal case (if a substance is selected)
    data_sub <- single_substance_data()
    if (nrow(data_sub) > 0) {
      paste0(
        "Substance: ",
        input$substance_single,
        "\n\n",
        "      CAS: ",
        unique(data_sub$cas),
        "\n",
        " Category: ",
        unique(data_sub$compound_type),
        "\n",
        "   Origin: ",
        unique(data_sub$compound_origin),
        "\n",
        #" Sub type: ", unique(data_sub$sub_compound_category), "\n",
        "   Family: ",
        unique(data_sub$compound_group),
        "\n\n",
        "     Load: ",
        round(unique(data_sub$load_score), 3)
      )
    }
  })
  
  ###### Display load visualization as rose plot ######
  output$rose_plot <- renderPlot({
    req(input$substance_single)
    adopt_Make_Rose_Plot(compound_name = input$substance_single,
                         data = df)
  })
  
  ###### Display load on distribution ######
  output$dist_plot <- renderPlot({
    req(input$substance_single)
    adopt_Make_Distribution_Plot(compound_names = input$substance_single,
                                 data = df)
  })
  ###### Download data option ######
  output$download_data <- downloadHandler(
    filename = function() {
      req(input$substance_single)
      paste0(
        "load_score_details_",
        gsub("[^A-Za-z0-9]", "_", input$substance_single),
        "_",
        Sys.Date(),
        ".tsv"
      )
    },
    content = function(file) {
      req(input$substance_single)
      data_sub <- single_substance_data()
      display_data <-
        data_sub |>
        dplyr::mutate_if(is.numeric, round, 3) |>
        dplyr::select(
          compound,
          compound_type,
          env_raw,
          eco.terr_raw,
          eco.aqua_raw,
          hum_raw,
          load_score,
          missing_share
        )
      
      write.table(
        display_data,
        file,
        sep = "\t",
        row.names = FALSE,
        col.names = TRUE,
        quote = FALSE
      )
    }
  )
  
  # Second tab ====
  
  ###### Populate filter lists (runs once at app startup) ######
  
  observeEvent(TRUE, {
    # Substance category filter
    updateSelectInput(session,
                      "substance_category1",
                      choices = unique(df$compound_category) |>
                        sort())
    # Substance origin filter
    updateSelectInput(session,
                      "substance_origins1",
                      choices = unique(df$compound_origin) |>
                        sort())
    
  }, once = TRUE)
  
  observeEvent(TRUE, {
    # Substance type filter
    updateSelectInput(session,
                      "substance_category2",
                      choices = unique(df$compound_category) |>
                        sort())
    # Substance origin filter
    updateSelectInput(session,
                      "substance_origins2",
                      choices = unique(df$compound_origin) |>
                        sort())
    
  }, once = TRUE)
  
  
  
  ###### Populate list of substance (reacts on filters) ######
  #--data for second tab, 1st choice
  substance_choices1 <- reactive({
    df_filtered1 <- df
    
    # Filter by origin only if an origin is selected
    if (!is.null(input$substance_origins1) &&
        length(input$substance_origins1) > 0) {
      df_filtered1 <-
        df_filtered1 |>
        dplyr::filter(compound_origin %in% input$substance_origins1)
    }
    
    # Filter by type only if a category is selected
    if (!is.null(input$substance_category1) &&
        length(input$substance_category1) > 0) {
      df_filtered1 <-
        df_filtered1 |>
        dplyr::filter(compound_category %in% input$substance_category1)
    }
    
    
    
    # Format final substance list
    df_filtered1 |>
      dplyr::pull(compound) |>
      unique() |>
      sort()
  })
  
  #--data for second tab, 2nd choice
  substance_choices2 <- reactive({
    df_filtered2 <- df
    
    # Filter by origin only if an origin is selected
    if (!is.null(input$substance_origins2) &&
        length(input$substance_origins2) > 0) {
      df_filtered2 <-
        df_filtered2 |>
        dplyr::filter(compound_origin %in% input$substance_origins2)
    }
    
    # Filter by type only if a category is selected
    if (!is.null(input$substance_category2) &&
        length(input$substance_category2) > 0) {
      df_filtered2 <-
        df_filtered2 |>
        dplyr::filter(compound_category %in% input$substance_category2)
    }
    
    
    
    # Format final substance list
    df_filtered2 |>
      dplyr::pull(compound) |>
      unique() |>
      sort()
  })
  
  ###### Selected substance1 based on user choice ######
  observe({
    choices1 <- substance_choices1()
    selected1 <- isolate(input$substance_double1)
    if (!is.null(selected1))
      selected1 <- selected1[selected1 %in% choices1]
    updateSelectInput(session,
                      "substance_double1",
                      choices = choices1,
                      selected = selected1)
  })
  
  # If current selection is no longer valid (e.g. after a new filter is applied), clear it
  observe({
    valid_choices <- substance_choices1()
    current <- input$substance_double1
    if (!is.null(current) && !current %in% valid_choices) {
      updateSelectInput(session, "substance_double1", selected = "")
    }
  })
  
  ###### Selected substance2 based on user choice ######
  observe({
    choices2 <- substance_choices2()
    selected2 <- isolate(input$substance_double2)
    if (!is.null(selected2))
      selected2 <- selected2[selected2 %in% choices2]
    updateSelectInput(session,
                      "substance_double2",
                      choices = choices2,
                      selected = selected2)
  })
  
  # If current selection is no longer valid (e.g. after a new filter is applied), clear it
  observe({
    valid_choices <- substance_choices2()
    current <- input$substance_double2
    if (!is.null(current) && !current %in% valid_choices) {
      updateSelectInput(session, "substance_double2", selected = "")
    }
  })
  
  
  ###### Display HPL visualisation graph ######
  output$rose_plot1 <- renderPlot({
    req(input$substance_double1)
    adopt_Make_Rose_Plot(compound_name = input$substance_double1,
                         data = df)
  })
  
  output$dist_plot_both <- renderPlot({
    req(input$substance_double1)
    adopt_Make_Distribution_Plot(
      compound_names = c(input$substance_double1, input$substance_double2),
      data = df
    )
  })
  
  output$rose_plot2 <- renderPlot({
    req(input$substance_double2)
    adopt_Make_Rose_Plot(compound_name = input$substance_double2,
                         data = df)
  })
  
  
  
}
