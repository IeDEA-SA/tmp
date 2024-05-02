# read_file works

    Code
      read_file(system.file("test-data", "stata", "01_previous", "tblART.dta",
        package = "MATCHA"))
    Output
      # A tibble: 18,555 x 14
         patient    merge_no art_id     art_sd     art_sd_a art_ed art_ed_a art_rs
         <chr>         <dbl> <chr>      <date>     <chr>    <date> <lgl>     <dbl>
       1 5d3dbc8ce2       11 593656D262 2015-11-12 D        NA     NA           NA
       2 5d3dbc8ce2       11 593656D262 2016-03-17 D        NA     NA           NA
       3 5d3dbc8ce2       11 593656D262 2016-11-29 D        NA     NA           NA
       4 5d3dbc8ce2       11 593656D262 2016-12-28 D        NA     NA           NA
       5 5d3dbc8ce2       11 593656D262 2012-12-12 D        NA     NA           NA
       6 5d3dbc8ce2       11 3431D875DB 2013-08-16 D        NA     NA           NA
       7 5d3dbc8ce2       11 3431D875DB 2013-10-16 D        NA     NA           NA
       8 5d3dbc8ce2       11 3431D875DB 2013-12-13 D        NA     NA           NA
       9 5d3dbc8ce2       11 3431D875DB 2014-10-29 D        NA     NA           NA
      10 5d3dbc8ce2       11 3431D875DB 2012-01-10 D        NA     NA           NA
      # i 18,545 more rows
      # i 6 more variables: art_rs2 <lgl>, art_rs3 <lgl>, art_rs4 <lgl>,
      #   art_form <dbl>, art_comb <dbl>, artstart_rs <lgl>

---

    Code
      read_file(system.file("test-data", "csv", "01_previous", "tblART.csv", package = "MATCHA"))
    Condition
      Warning:
      One or more parsing issues, call `problems()` on your data frame for details, e.g.:
        dat <- vroom(...)
        problems(dat)
    Output
      # A tibble: 18,555 x 14
         patient    merge_no art_id     art_sd art_sd_a art_ed art_ed_a art_rs art_rs2
         <chr>         <dbl> <chr>      <chr>  <chr>    <lgl>  <lgl>     <dbl> <lgl>  
       1 5d3dbc8ce2       11 593656D262 2015-~ D        NA     NA           NA NA     
       2 5d3dbc8ce2       11 593656D262 2016-~ D        NA     NA           NA NA     
       3 5d3dbc8ce2       11 593656D262 2016-~ D        NA     NA           NA NA     
       4 5d3dbc8ce2       11 593656D262 2016-~ D        NA     NA           NA NA     
       5 5d3dbc8ce2       11 593656D262 2012-~ D        NA     NA           NA NA     
       6 5d3dbc8ce2       11 3431D875DB 2013-~ D        NA     NA           NA NA     
       7 5d3dbc8ce2       11 3431D875DB 2013-~ D        NA     NA           NA NA     
       8 5d3dbc8ce2       11 3431D875DB 2013-~ D        NA     NA           NA NA     
       9 5d3dbc8ce2       11 3431D875DB 2014-~ D        NA     NA           NA NA     
      10 5d3dbc8ce2       11 3431D875DB 2012-~ D        NA     NA           NA NA     
      # i 18,545 more rows
      # i 5 more variables: art_rs3 <lgl>, art_rs4 <lgl>, art_form <dbl>,
      #   art_comb <dbl>, artstart_rs <lgl>

