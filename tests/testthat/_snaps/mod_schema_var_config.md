# mod_schema_var_config_ui config creates expected HTML

    Code
      mod_schema_var_config_ui("x", "test_var", "numeric")
    Output
      <div class="card bslib-card bslib-mb-spacing html-fill-item html-fill-container card-dropdown" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5">
        <div class="card-header">test_var</div>
        <div class="card-body bslib-gap-spacing html-fill-item html-fill-container card-dropdown" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;">
          <div class="bslib-grid bslib-mb-spacing html-fill-item" data-require-bs-caller="layout_column_wrap()" data-require-bs-version="5" style="grid-template-columns:repeat(2, minmax(0, 1fr));grid-auto-rows:1fr;--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;">
            <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
              <div class="form-group shiny-input-container">
                <label class="control-label" id="x-var_type-label" for="x-var_type">Variable Type</label>
                <div>
                  <select id="x-var_type" class="shiny-input-select"><option value="integer">integer</option>
      <option value="double">double</option>
      <option value="character">character</option>
      <option value="factor">factor</option>
      <option value="Date">Date</option>
      <option value="logical">logical</option></select>
                  <script type="application/json" data-for="x-var_type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
                </div>
              </div>
            </div>
            <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
              <div class="form-group shiny-input-container">
                <label class="control-label" id="x-unknown-label" for="x-unknown">Unknown Values</label>
                <input id="x-unknown" type="text" class="shiny-input-text form-control" value=""/>
              </div>
            </div>
          </div>
        </div>
        <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
      </div>

