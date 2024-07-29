# mod_plot_missing_ui generates expected html

    Code
      get_html_classes(html)
    Output
       [1] "card bslib-card bslib-mb-spacing html-fill-item html-fill-container"
       [2] "card-header"                                                        
       [3] "bslib-sidebar-layout bslib-mb-spacing html-fill-item"               
       [4] "main bslib-gap-spacing html-fill-container"                         
       [5] "shiny-html-output"                                                  
       [6] "sidebar-content bslib-gap-spacing"                                  
       [7] "shiny-html-output"                                                  
       [8] "form-group shiny-input-container"                                   
       [9] "checkbox"                                                           
      [10] "form-group shiny-input-container"                                   
      [11] "checkbox"                                                           
      [12] "card-body bslib-gap-spacing html-fill-item html-fill-container"     

# mod_plot_missing_server works

    Code
      exclude_ui_selectise
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label" id="proxy1-exclude-label" for="proxy1-exclude">Exclude columns</label>
        <div>
          <select class="shiny-input-select form-control" id="proxy1-exclude" multiple="multiple"><option value="patient">patient</option>
      <option value="merge_no">merge_no</option>
      <option value="art_id">art_id</option>
      <option value="art_sd">art_sd</option>
      <option value="art_sd_a">art_sd_a</option>
      <option value="art_ed">art_ed</option>
      <option value="art_ed_a">art_ed_a</option>
      <option value="art_rs">art_rs</option>
      <option value="art_rs2">art_rs2</option>
      <option value="art_rs3">art_rs3</option>
      <option value="art_rs4">art_rs4</option>
      <option value="art_form">art_form</option>
      <option value="art_comb">art_comb</option>
      <option value="artstart_rs">artstart_rs</option>
      <option value="tbl">tbl</option>
      <option value="tbl_name">tbl_name</option></select>
          <script type="application/json" data-for="proxy1-exclude">{"plugins":["selectize-plugin-a11y"]}</script>
        </div>
      </div>

---

    Code
      plot_output_div
    Output
      [1] "plotly html-widget html-widget-output shiny-report-size shiny-report-theme html-fill-item"

