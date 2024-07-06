# {shinytest2} GET_VANILLA_REPORT

    Code
      all_classes
    Output
      [1] "container-fluid main-container" NA                              

# {shinytest2} READ_TABLES

    Code
      valid_cols
    Output
      <div class="card bslib-card bslib-mb-spacing html-fill-item html-fill-container" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5">
        <div class="card-header bg-dark">Valid shared variables</div>
        <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;"><p>The following variables are valid and shared between the <code>previous</code> and <code>current</code> tables:</p>
      <p><strong><code>merge_no</code></strong>,<strong><code>patient</code></strong>,<strong><code>program</code></strong>,<strong><code>birth_d</code></strong>,<strong><code>birth_d_a</code></strong>,<strong><code>enrol_d</code></strong>,<strong><code>enrol_d_a</code></strong>,<strong><code>sex</code></strong>,<strong><code>mode</code></strong>,<strong><code>mode_oth</code></strong>,<strong><code>naive_y</code></strong>,<strong><code>proph_y</code></strong>,<strong><code>recart_y</code></strong>,<strong><code>recart_d</code></strong>,<strong><code>recart_d_a</code></strong>,<strong><code>aids_y</code></strong>,<strong><code>aids_d</code></strong>,<strong><code>aids_d_a</code></strong>,<strong><code>hiv_pos_d</code></strong>,<strong><code>hiv_pos_d_a</code></strong>,<strong><code>center_enrol</code></strong>,<strong><code>center_last</code></strong></p>
      </div>
        <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
      </div>

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

