# {shinytest2} GET_VANILLA_REPORT

    "report_2024-07-02.html"

# {shinytest2} GENERATE_PLOT

    Code
      app$get_value(output = "tbl_tab-tblBAS_4oncnyz0e01i28hz-valid_cols")
    Output
      [1] "merge_no, patient, program, birth_d, birth_d_a, enrol_d, enrol_d_a, sex, mode, mode_oth, naive_y, proph_y, recart_y, recart_d, recart_d_a, aids_y, aids_d, aids_d_a, hiv_pos_d, hiv_pos_d_a, center_enrol, center_last"

# {shinytest2} GET_PLOT_REPORT

    Code
      xml2::xml_find_all(html_obj, ".//div")
    Output
      {xml_nodeset (5)}
      [1] <div class="container-fluid main-container">\n\n\n\n\n<div id="header">\n ...
      [2] <div id="header">\n\n\n\n<h1 class="title toc-ignore">Data consistency re ...
      [3] <div id="tblbas" class="section level2">\n<h2>tblBAS</h2>\n<div id="merge ...
      [4] <div id="merge_no-histogram" class="section level3">\n<h3>merge_no: Histo ...
      [5] <div class="plotly html-widget html-fill-item" id="htmlwidget-a4873249b16 ...

