# {shinytest2} GET_VANILLA_REPORT

    "report_2024-07-03.html"

# {shinytest2} READ_TABLES

    Code
      valid_cols
    Output
      [1] "merge_no, patient, program, birth_d, birth_d_a, enrol_d, enrol_d_a, sex, mode, mode_oth, naive_y, proph_y, recart_y, recart_d, recart_d_a, aids_y, aids_d, aids_d_a, hiv_pos_d, hiv_pos_d_a, center_enrol, center_last"

# {shinytest2} GENERATE_PLOT

    Code
      plot_class
    Output
      [1] "plotly html-widget html-widget-output shiny-report-size shiny-report-theme html-fill-item"

# {shinytest2} GET_PLOT_REPORT

    Code
      all_classes
    Output
      [1] "container-fluid main-container"    NA                                 
      [3] "section level2"                    "section level3"                   
      [5] "plotly html-widget html-fill-item"

