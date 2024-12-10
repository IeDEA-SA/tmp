
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MATCHA

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/IeDEA-SA/MATCHA/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/IeDEA-SA/MATCHA/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of MATCHA is to provide an interface for producing data
consistency reports.

## Installation

> **MATCHA requires R version 4.4.0 or higher.**
>
> On Windows you may also need to install the corresponding version of
> [Rtools](https://cran.r-project.org/bin/windows/Rtools/) to install
> the package from GitHub.

You can install the development version of MATCHA from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("IeDEA-SA/MATCHA")
```

Alternatively, you can use package `pak`

``` r
# install.packages("pak")
pak::pak("IeDEA-SA/MATCHA")
```
## Execution

To run the app, load the library and run the `run_app()` function.

``` r
library(MATCHA)
run_app()
```

## Select previous & current data

The first step involves selecting the directories containing the
previous and current data to be compared. The directories can be
selected by clicking on the `Select a folder` button.

The file system navigator will open in the root of the demo data
contained within the package. You can use this data to explore app
functionality.

<img src="man/figures/select_directories_a.png" width="100%" />

### Select another root directory

To select another root directory, for example your home directory so you
can navigate other folders on your system, click on the `demo_data`
button in the top right corner of the file system navigator.

Selecting **home** will set the root to **your home directory** from
where you can navigate to your own directories containing the previous
and current data.

<img src="man/figures/select_directories_b.png" width="100%" />

## Overriding default Primary Key source settings

Some plots require primary key information to be provided. By default,
the app will attempt to infer the primary key from the data and store it
centrally. It is configured to consider:

- a **table named `tblBAS` as the primary source** of primary key
  information.
- within the primary table, the **column `patient` to contain the actual
  primary key values**.

However, you can override this at runtime through arguments
`pk_tbl_name` and `pk_col` in the `run_app()` function respectively.

For example, if you wanted to configure the app to use a table called
`tblKEYS` with a primary key column `id` as the source of primary key
information, you would run the app as follows:

``` r
run_app(pk_tbl_name = "tblKEYS", pk_col = "id")
```
