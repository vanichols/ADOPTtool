# server.R

# Gina Nichols, adopted from code created by
# Noé Vandevoorde octobre 2025


#### Server ####################################################################

server <- function(input, output, session) {

  #--max size is 160 MB
  #options(shiny.maxRequestSize = 160*1024^2) #--recommended based on a help website
  #--use the data from the ADOPTpkg...need to check
  #df <- data
  df <- adopt_hpli #--data for first tab
  #df1 <- adopt_hpli #--data for second tab, 1st choice
  #df2 <- adopt_hpli #--data for second tab, 2nd choice

  # First tab ====
    
###### Populate filter lists (runs once at app startup) ######


  observeEvent(TRUE, {
    # Substance origin filter
      updateSelectInput(
        session,
        "substance_origins",
        choices = unique(df$compound_origin) |>
          sort())
    # Substance type filter
        updateSelectInput(
          session,
          "substance_types",
          choices = unique(df$compound_category) |>
            sort())
    # Substance family filter
      updateSelectInput(
        session,
        "substance_groups",
        choices = unique(df$compound_group) |>
          sort())
    },
    once = TRUE)
  
  
  
###### Populate list of substance (reacts on filters) ######
#--data for second tab, 1st choice
  substance_choices <- reactive({
    
    df_filtered <- df

    # Filter by origin only if an origin is selected
      if (!is.null(input$substance_origins) && length(input$substance_origins) > 0) {
        df_filtered <- 
          df_filtered |>
          dplyr::filter(compound_origin %in% input$substance_origins)
      }

    # Filter by type only if a type is selected
      if (!is.null(input$substance_types) && length(input$substance_types) > 0) {
        df_filtered <- 
          df_filtered |>
          dplyr::filter(compound_category %in% input$substance_types)
      }

    # Filter by family only if a family is selected
      if (!is.null(input$substance_groups) && length(input$substance_groups) > 0) {
        df_filtered <- 
          df_filtered |>
          dplyr::filter(str_detect(tolower(compound_group), input$substance_groups))
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
    if (!is.null(selected)) selected <- selected[selected %in% choices]
    updateSelectInput(session, "substance_single",
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
      if (is.null(selected) || selected == "" || !selected %in% choices) {
        return("")
      }
    # Normal case (if a substance is selected)
      data_sub <- single_substance_data()
      if(nrow(data_sub) > 0) {
        paste0(
          "Substance: ", input$substance_single, "\n\n",
          "      CAS: ", unique(data_sub$cas), "\n",
          "Main type: ", unique(data_sub$compound_origin), " ", unique(data_sub$compound_category), "\n",
          #" Sub type: ", unique(data_sub$sub_compound_category), "\n",
          "   Family: ", unique(data_sub$compound_group), "\n\n",
          "     Load: ", round(unique(data_sub$load_score), 3)
        )
      }
    })

###### Display HPL visualisation graphh ######
  output$rose_plot <- renderPlot({
    req(input$substance_single)
    adopt_Make_Rose_and_Dist_Plot(compound = input$substance_single, 
                         #data = single_substance_data()
                         data = df)
  })

###### Display HPL data table ######
  output$score_details <- DT::renderDataTable({
    req(input$substance_single)
    data_sub <- single_substance_data()
    display_data <- 
      data_sub |>
      dplyr::mutate_if(is.numeric, round, 3) |> 
      #mutate(quality = ifelse(!is.na(missing), missing, quality)) |>
      #select(sub_compartment, attribute, value_chr, quality, index_value, weighted_index) |>
      dplyr::select(compound, compound_type, 
                    env_raw, eco.terr_raw, eco.aqua_raw, hum_raw,
             load_score, missing_share) #|>
      # rename(compartment = sub_compartment,
      #        metric = attribute,
      #        `metric value` = value_chr,
      #        `data quality` = quality,
      #        `metric load (unweighted)` = index_value,
      #        `metric load (weighted)` = weighted_index)
      # dplyr::rename(
      #   `environmental persistence index` = env_raw,
      #   `terrestrial ecological toxicity index` = eco.terr_raw,
      #   `aquatic ecological toxicity index` = eco.aqua_raw,
      #   `human health toxicity index` = hum_raw,
      #   `total load (weighted)` = load_score) |>
    #DT::datatable(
    renderTable(
      display_data,
      options = list(scrollX = TRUE,
                     pageLength = 2,
                     dom = 't')) # only show the table
  })
  
  # # Second tab (still working)====
  # ###### Populate filter lists (runs once at app startup) ######
  # 
  # 
  # observeEvent(TRUE, {
  #   # Substance origin filter
  #   updateSelectInput(
  #     session,
  #     "substance_origins1",
  #     choices = unique(df1$compound_origin) |>
  #       sort())
  #   updateSelectInput(
  #     session,
  #     "substance_origins2",
  #     choices = unique(df2$compound_origin) |>
  #       sort())
  #   # Substance type filter
  #   updateSelectInput(
  #     session,
  #     "substance_types1",
  #     choices = unique(df1$compound_category) |>
  #       sort())
  #   updateSelectInput(
  #     session,
  #     "substance_types2",
  #     choices = unique(df2$compound_category) |>
  #       sort())
  #   # Substance family filter
  #   updateSelectInput(
  #     session,
  #     "substance_groups1",
  #     choices = unique(df1$compound_group) |>
  #       sort())
  #   updateSelectInput(
  #     session,
  #     "substance_groups2",
  #     choices = unique(df2$compound_group) |>
  #       sort())
  # },
  # once = TRUE)
  # 
  # 
  # 
  # ###### Populate list of substance (reacts on filters) ######
  # #--
  # substance_choices1 <- reactive({
  #   
  #   df_filtered <- df1
  #   
  #   # Filter by origin only if an origin is selected
  #   if (!is.null(input$substance_origins1) && length(input$substance_origins1) > 0) {
  #     df_filtered <- 
  #       df_filtered |>
  #       filter(compound_origin %in% input$substance_origins1)
  #   }
  #   
  #   # Filter by type only if a type is selected
  #   if (!is.null(input$substance_types1) && length(input$substance_types1) > 0) {
  #     df_filtered <- 
  #       df_filtered |>
  #       filter(compound_category %in% input$substance_types1)
  #   }
  #   
  #   # Filter by family only if a family is selected
  #   if (!is.null(input$substance_groups1) && length(input$substance_groups1) > 0) {
  #     df_filtered <- 
  #       df_filtered |>
  #       filter(str_detect(tolower(compound_group), input$substance_groups1))
  #   }
  #   
  #   # Format final substance list
  #   df_filtered |>
  #     dplyr::pull(compound) |>
  #     unique() |>
  #     sort()
  # })
  # 
  # substance_choices2 <- reactive({
  #   
  #   df_filtered <- df2
  #   
  #   # Filter by origin only if an origin is selected
  #   if (!is.null(input$substance_origins2) && length(input$substance_origins2) > 0) {
  #     df_filtered <- 
  #       df_filtered |>
  #       filter(compound_origin %in% input$substance_origins2)
  #   }
  #   
  #   # Filter by type only if a type is selected
  #   if (!is.null(input$substance_types2) && length(input$substance_types2) > 0) {
  #     df_filtered <- 
  #       df_filtered |>
  #       filter(compound_category %in% input$substance_types2)
  #   }
  #   
  #   # Filter by family only if a family is selected
  #   if (!is.null(input$substance_groups2) && length(input$substance_groups2) > 0) {
  #     df_filtered <- 
  #       df_filtered |>
  #       filter(str_detect(tolower(compound_group), input$substance_groups2))
  #   }
  #   
  #   # Format final substance list
  #   df_filtered |>
  #     dplyr::pull(compound) |>
  #     unique() |>
  #     sort()
  # })
  # 
  # ###### Selected substance based on user choice ######
  # observe({
  #   choices <- substance_choices1()
  #   selected <- isolate(input$substance_single1)
  #   if (!is.null(selected)) selected <- selected[selected %in% choices]
  #   updateSelectInput(session, "substance_single1",
  #                     choices = choices,
  #                     selected = selected)
  #   updateSelectInput(session, "substances_compare1", choices = choices)
  # })
  # 
  # # If current selection is no longer valid (e.g. after a new filter is applied), clear it
  # observe({
  #   valid_choices <- substance_choices()
  #   current <- input$substance_single
  #   if (!is.null(current) && !current %in% valid_choices) {
  #     updateSelectInput(session, "substance_single", selected = "")
  #   }
  # })
  # 
  # ###### Reduce data based on selected substance ######
  # single_substance_data <- reactive({
  #   req(input$substance_single)
  #   df <- adopt_hpli
  #   df[df$compound == input$substance_single, ]
  # })
  # 
  # ###### Display substance data ######
  # output$substance_info <- renderText({
  #   # Make it reactive to both inputs
  #   choices <- substance_choices()
  #   selected <- input$substance_single
  #   # Clear out if nothing selected or selection invalid
  #   if (is.null(selected) || selected == "" || !selected %in% choices) {
  #     return("")
  #   }
  #   # Normal case (if a substance is selected)
  #   data_sub <- single_substance_data()
  #   if(nrow(data_sub) > 0) {
  #     paste0(
  #       "Substance: ", input$substance_single, "\n\n",
  #       "      CAS: ", unique(data_sub$cas), "\n",
  #       "Main type: ", unique(data_sub$compound_origin), " ", unique(data_sub$compound_category), "\n",
  #       #" Sub type: ", unique(data_sub$sub_compound_category), "\n",
  #       "   Family: ", unique(data_sub$compound_group), "\n\n",
  #       "     Load: ", round(unique(data_sub$load_score), 3)
  #     )
  #   }
  # })
  # 
  # ###### Display HPL visualisation graphh ######
  # output$rose_plot <- renderPlot({
  #   req(input$substance_single)
  #   adopt_Make_Rose_Plot(compound = input$substance_single, 
  #                        data = single_substance_data())
  # })
  # 
}
