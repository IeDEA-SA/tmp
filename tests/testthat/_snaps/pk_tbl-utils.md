# subset_pk_tbl_cols works

    Code
      pk_tbl
    Output
      # A tibble: 1,900 x 3
         patient    tbl     pk        
         <chr>      <fct>   <chr>     
       1 a9b144efd0 current a9b144efd0
       2 06645dd7c5 current 06645dd7c5
       3 a77c80e964 current a77c80e964
       4 475a7b0866 current 475a7b0866
       5 d09d6a72e5 current d09d6a72e5
       6 77998ebea4 current 77998ebea4
       7 437fcd72d4 current 437fcd72d4
       8 e5e7ca563f current e5e7ca563f
       9 74d498c39b current 74d498c39b
      10 f5395985bb current f5395985bb
      # i 1,890 more rows

---

    Code
      pk_tbl_nopk
    Output
      # A tibble: 1,900 x 2
         patient    tbl    
         <chr>      <fct>  
       1 a9b144efd0 current
       2 06645dd7c5 current
       3 a77c80e964 current
       4 475a7b0866 current
       5 d09d6a72e5 current
       6 77998ebea4 current
       7 437fcd72d4 current
       8 e5e7ca563f current
       9 74d498c39b current
      10 f5395985bb current
      # i 1,890 more rows

# join_pk works

    Code
      joined
    Output
      # A tibble: 45,714 x 16
         patient    merge_no art_id     art_sd     art_sd_a art_ed art_ed_a art_rs
         <chr>         <dbl> <chr>      <date>     <chr>    <date> <lgl>     <dbl>
       1 12694bf7b6       11 C8E2505A22 2027-02-26 D        NA     NA           NA
       2 12694bf7b6       11 23CA343E52 2016-08-24 D        NA     NA           NA
       3 12694bf7b6       11 C8E2505A22 2018-10-18 D        NA     NA           NA
       4 12694bf7b6       11 24D3A67D15 2012-06-08 D        NA     NA           NA
       5 12694bf7b6       11 C8E2505A22 2011-07-06 D        NA     NA           NA
       6 12694bf7b6       11 C8E2505A22 2015-05-29 D        NA     NA           NA
       7 12694bf7b6       11 24D3A67D15 2018-05-17 D        NA     NA           NA
       8 12694bf7b6       11 24D3A67D15 2019-07-15 D        NA     NA           NA
       9 12694bf7b6       11 24D3A67D15 2019-10-07 D        NA     NA           NA
      10 12694bf7b6       11 23CA343E52 2019-01-16 D        NA     NA           NA
      # i 45,704 more rows
      # i 8 more variables: art_rs2 <lgl>, art_rs3 <lgl>, art_rs4 <lgl>,
      #   art_form <dbl>, art_comb <dbl>, artstart_rs <lgl>, tbl <fct>,
      #   tbl_name <chr>

