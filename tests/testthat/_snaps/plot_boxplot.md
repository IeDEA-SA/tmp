# plot_boxplot works

    Code
      purrr::map(pltly_no_outl$x$data, ~ .x$marker)
    Output
      [[1]]
      [[1]]$opacity
      [1] 0
      
      
      [[2]]
      [[2]]$opacity
      [1] 0
      
      

---

    Code
      purrr::map(pltly_outl$x$data, ~ .x$marker)
    Output
      [[1]]
      [[1]]$opacity
      [1] NA
      
      [[1]]$outliercolor
      [1] "rgba(248,118,109,1)"
      
      [[1]]$line
      [1] "rgba(248,118,109,1)"
      
      [[1]]$size
      [1] 5.669291
      
      [[1]]$color
      [1] "rgba(248,118,109,1)"
      
      
      [[2]]
      [[2]]$opacity
      [1] NA
      
      [[2]]$outliercolor
      [1] "rgba(0,191,196,1)"
      
      [[2]]$line
      [1] "rgba(0,191,196,1)"
      
      [[2]]$size
      [1] 5.669291
      
      [[2]]$color
      [1] "rgba(0,191,196,1)"
      
      

---

    Code
      str(pltly_full$x$data)
    Output
      List of 6
       $ :List of 13
        ..$ x          : 'mapped_discrete' num [1:19316] 1.089 0.975 1.043 0.894 1.171 ...
        ..$ y          : num [1:19316] 52 40.6 69 48.8 52 ...
        ..$ text       : chr [1:19316] "tbl: previous<br />weigh:  52.0<br />tbl: previous" "tbl: previous<br />weigh:  40.6<br />tbl: previous" "tbl: previous<br />weigh:  69.0<br />tbl: previous" "tbl: previous<br />weigh:  48.8<br />tbl: previous" ...
        ..$ type       : chr "scatter"
        ..$ mode       : chr "markers"
        ..$ marker     :List of 6
        .. ..$ autocolorscale: logi FALSE
        .. ..$ color         : chr "rgba(248,118,109,1)"
        .. ..$ opacity       : num 0.05
        .. ..$ size          : num 5.67
        .. ..$ symbol        : chr "circle"
        .. ..$ line          :List of 2
        .. .. ..$ width: num 1.89
        .. .. ..$ color: chr "rgba(248,118,109,1)"
        ..$ hoveron    : chr "points"
        ..$ name       : chr "previous"
        ..$ legendgroup: chr "previous"
        ..$ showlegend : logi TRUE
        ..$ xaxis      : chr "x"
        ..$ yaxis      : chr "y"
        ..$ hoverinfo  : chr "text"
       $ :List of 13
        ..$ x          : 'mapped_discrete' num [1:26881] 1.92 1.84 2.09 2.15 1.95 ...
        ..$ y          : num [1:26881] 52 40.6 69 48.8 52 ...
        ..$ text       : chr [1:26881] "tbl: current<br />weigh:  52.0<br />tbl: current" "tbl: current<br />weigh:  40.6<br />tbl: current" "tbl: current<br />weigh:  69.0<br />tbl: current" "tbl: current<br />weigh:  48.8<br />tbl: current" ...
        ..$ type       : chr "scatter"
        ..$ mode       : chr "markers"
        ..$ marker     :List of 6
        .. ..$ autocolorscale: logi FALSE
        .. ..$ color         : chr "rgba(0,191,196,1)"
        .. ..$ opacity       : num 0.05
        .. ..$ size          : num 5.67
        .. ..$ symbol        : chr "circle"
        .. ..$ line          :List of 2
        .. .. ..$ width: num 1.89
        .. .. ..$ color: chr "rgba(0,191,196,1)"
        ..$ hoveron    : chr "points"
        ..$ name       : chr "current"
        ..$ legendgroup: chr "current"
        ..$ showlegend : logi TRUE
        ..$ xaxis      : chr "x"
        ..$ yaxis      : chr "y"
        ..$ hoverinfo  : chr "text"
       $ :List of 15
        ..$ x          : num [1:1025] 1 1 1 1 1 ...
        ..$ y          : num [1:1025] 0.6 0.837 1.074 1.312 1.549 ...
        ..$ text       : chr [1:1025] "tbl: previous<br />weigh:   0.600000<br />tbl: previous<br />density: 1.546069e-05" "tbl: previous<br />weigh:   0.837182<br />tbl: previous<br />density: 1.523667e-05" "tbl: previous<br />weigh:   1.074364<br />tbl: previous<br />density: 1.456987e-05" "tbl: previous<br />weigh:   1.311546<br />tbl: previous<br />density: 1.352900e-05" ...
        ..$ type       : chr "scatter"
        ..$ mode       : chr "lines"
        ..$ line       :List of 3
        .. ..$ width: num 1.89
        .. ..$ color: chr "transparent"
        .. ..$ dash : chr "solid"
        ..$ fill       : chr "toself"
        ..$ fillcolor  : chr "rgba(248,118,109,0.2)"
        ..$ hoveron    : chr "points"
        ..$ name       : chr "(previous,1)"
        ..$ legendgroup: chr "(previous,1)"
        ..$ showlegend : logi TRUE
        ..$ xaxis      : chr "x"
        ..$ yaxis      : chr "y"
        ..$ hoverinfo  : chr "text"
       $ :List of 15
        ..$ x          : num [1:1025] 2 2 2 2 2 ...
        ..$ y          : num [1:1025] 0.6 0.837 1.074 1.312 1.549 ...
        ..$ text       : chr [1:1025] "tbl: current<br />weigh:   0.600000<br />tbl: current<br />density: 1.197077e-05" "tbl: current<br />weigh:   0.837182<br />tbl: current<br />density: 1.177237e-05" "tbl: current<br />weigh:   1.074364<br />tbl: current<br />density: 1.116747e-05" "tbl: current<br />weigh:   1.311546<br />tbl: current<br />density: 1.021706e-05" ...
        ..$ type       : chr "scatter"
        ..$ mode       : chr "lines"
        ..$ line       :List of 3
        .. ..$ width: num 1.89
        .. ..$ color: chr "transparent"
        .. ..$ dash : chr "solid"
        ..$ fill       : chr "toself"
        ..$ fillcolor  : chr "rgba(0,191,196,0.2)"
        ..$ hoveron    : chr "points"
        ..$ name       : chr "(current,1)"
        ..$ legendgroup: chr "(current,1)"
        ..$ showlegend : logi TRUE
        ..$ xaxis      : chr "x"
        ..$ yaxis      : chr "y"
        ..$ hoverinfo  : chr "text"
       $ :List of 12
        ..$ x          : 'mapped_discrete' num [1:19316] 1 1 1 1 1 1 1 1 1 1 ...
        ..$ y          : num [1:19316] 52 40.6 69 48.8 52 67.2 48.7 59.1 63.1 85.2 ...
        ..$ hoverinfo  : chr "y"
        ..$ type       : chr "box"
        ..$ fillcolor  : chr "rgba(248,118,109,0.3)"
        ..$ marker     :List of 1
        .. ..$ opacity: num 0
        ..$ line       :List of 2
        .. ..$ color: chr "rgba(248,118,109,1)"
        .. ..$ width: num 1.89
        ..$ name       : chr "previous"
        ..$ legendgroup: chr "previous"
        ..$ showlegend : logi FALSE
        ..$ xaxis      : chr "x"
        ..$ yaxis      : chr "y"
       $ :List of 12
        ..$ x          : 'mapped_discrete' num [1:26881] 2 2 2 2 2 2 2 2 2 2 ...
        ..$ y          : num [1:26881] 52 40.6 69 48.8 52 67.2 48.7 59.1 63.1 85.2 ...
        ..$ hoverinfo  : chr "y"
        ..$ type       : chr "box"
        ..$ fillcolor  : chr "rgba(0,191,196,0.3)"
        ..$ marker     :List of 1
        .. ..$ opacity: num 0
        ..$ line       :List of 2
        .. ..$ color: chr "rgba(0,191,196,1)"
        .. ..$ width: num 1.89
        ..$ name       : chr "current"
        ..$ legendgroup: chr "current"
        ..$ showlegend : logi FALSE
        ..$ xaxis      : chr "x"
        ..$ yaxis      : chr "y"

