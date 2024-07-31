# tab-validation-boxes works

    Code
      tab_validation_boxes(c("var1", "var2"), NULL, integer(0))
    Output
      <div class="container-fluid">
        <bslib-layout-columns class="bslib-grid grid bslib-mb-spacing html-fill-item" data-require-bs-caller="layout_columns()" data-require-bs-version="5">
          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
            <div class="card bslib-card bslib-mb-spacing html-fill-container bslib-value-box showcase-top-right" data-bslib-card-init data-require-bs-caller="card() value_box()" data-require-bs-version="5 5" style="color:#000000;background-color:#54C9A4;--bslib-color-fg:#000000;--bslib-color-bg:#54C9A4;">
              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto; padding:0;">
                <div class="value-box-grid html-fill-item" style="--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;---bslib-value-box-showcase-w:40%;---bslib-value-box-showcase-w-fs:1fr;---bslib-value-box-showcase-max-h:75px;---bslib-value-box-showcase-max-h-fs:67%;">
                  <div class="value-box-showcase html-fill-item html-fill-container">
                    <i class="far fa-square-check" role="presentation" aria-label="square-check icon"></i>
                  </div>
                  <div class="value-box-area html-fill-item html-fill-container">
                    <p class="value-box-title"> </p>
                    <p class="value-box-value">2 Valid</p>
                    <p>Variables that were shared and merged without coercion</p>
      <ul>
      <li><code>var1</code></li>
      <li><code>var2</code></li>
      </ul>
      
                  </div>
                </div>
              </div>
              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
            </div>
          </div>
          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
            <div class="card bslib-card bslib-mb-spacing html-fill-container bslib-value-box showcase-top-right" data-bslib-card-init data-require-bs-caller="card() value_box()" data-require-bs-version="5 5" style="color:#000000;background-color:#DB865C;--bslib-color-fg:#000000;--bslib-color-bg:#DB865C;">
              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto; padding:0;">
                <div class="value-box-grid html-fill-item" style="--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;---bslib-value-box-showcase-w:40%;---bslib-value-box-showcase-w-fs:1fr;---bslib-value-box-showcase-max-h:75px;---bslib-value-box-showcase-max-h-fs:67%;">
                  <div class="value-box-showcase html-fill-item html-fill-container">
                    <i class="fas fa-circle-exclamation" role="presentation" aria-label="circle-exclamation icon"></i>
                  </div>
                  <div class="value-box-area html-fill-item html-fill-container">
                    <p class="value-box-title"> </p>
                    <p class="value-box-value">0 Coerced</p>
                    <p>Variables that required data type coercion to be merged</p>
      
                  </div>
                </div>
              </div>
              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
            </div>
          </div>
          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
            <div class="card bslib-card bslib-mb-spacing html-fill-container bslib-value-box showcase-top-right" data-bslib-card-init data-require-bs-caller="card() value_box()" data-require-bs-version="5 5" style="color:#000000;background-color:#F08787;--bslib-color-fg:#000000;--bslib-color-bg:#F08787;">
              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto; padding:0;">
                <div class="value-box-grid html-fill-item" style="--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;---bslib-value-box-showcase-w:40%;---bslib-value-box-showcase-w-fs:1fr;---bslib-value-box-showcase-max-h:75px;---bslib-value-box-showcase-max-h-fs:67%;">
                  <div class="value-box-showcase html-fill-item html-fill-container">
                    <i class="far fa-rectangle-xmark" role="presentation" aria-label="rectangle-xmark icon"></i>
                  </div>
                  <div class="value-box-area html-fill-item html-fill-container">
                    <p class="value-box-title"> </p>
                    <p class="value-box-value">0 Invalid</p>
                    <p>Variables that cannot be merged because of conflicting data types</p>
      
                  </div>
                </div>
              </div>
              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
            </div>
          </div>
        </bslib-layout-columns>
      </div>

