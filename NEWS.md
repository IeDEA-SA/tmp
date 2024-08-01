# MATCHA 1.0.0

First stable release of MATCHA for project completion.   
* Added minimum requirement of R version 4.4.0
* Check for valid data type variables in data for plot args in plotting dialog box and disable `ok` button if non detected (#48)
* Added pkgdown documentation website (#70).
* Added titles to plots (#96)
* App now opens directly in a new browser window (#98)
* Added popovers with information on dataset requirements (#99).
* Added choice to render PDF report (#100).
* Improved `plot_count_by_date` function to work with few observations and use better axes (#89).
* Added table `skim::skimr()` summaries (collapsible in HTML) to reports (#9).
* Improved theme and layout of the app.
* Added additional module tests
* Handled missing `tblBAS` and `pk_col`s more formally.



# MATCHA 0.7.0

* Added boxplot
* Named and ordered plot types in the drop down menu
* Added spinners when plotting and downloading the report.
* Various plot and layout improvements (e.g. #88, #87)

# MATCHA 0.6.2

* Minor bug fixes
* `"."` in the directory drop down menu now returns the working directory instead of the result of `here::here()`.

# MATCHA 0.6.1

* Added a new `plot_events_by_year` plot type that allows users to superimpose and compare the counts of two variables recording dates of events by year.
* Fixed issues with the plotly tooltip hover text and caption (#68 & #81).
* Added button to close app

# MATCHA 0.6.0

* Streamlined and added progress bar to data set load module and a spinner to the schema widget (#76).
* Added Variable validation boxes to show valid, invalid and coerced variables and corrected bug in variable data type checks (#75).
* Added option to toggle between fixed and free_y axes in `plot_cat_count_by_year`.
* Plot `plot_count_by_date` handles NAs properly (#73).
* Coercion issues (i.e. creation of NAs) are propagated as warning pop ups in the schema widget.
* `plot_count_by_date` and `plot_cat_count_by_year` plots are now available for integers also (#14 & #66).
* Added an `na.rm` argument to `plot_stacked_bar` to allow users to control whether NAs are removed from the data before plotting.
* Added a `log` argument to `plot_histogram` to allow users to log transform data before plotting.


# MATCHA 0.5.0

* Added scaffolding for collecting primary key information from all open tables and making it available for use on a new summary tab.

# MATCHA 0.2.0

* Added the following new plot types with associated modules:
  - `plot_stacked_bar`: Plots comparisons of stacked bar chart of percentages or counts of the top `n` categories of a categorical variable.
  - `plot_cat_count_by_year`: Plots faceted comparisons of the counts of top `n` categories of a categorical variable by year.
* Fixed bug in loading of new tables which was causing previously generated plots in other tabs to be lost (thanks @AleKoure)

# MATCHA 0.0.1

* Added hash to link source file to table tabs.

* Added e2e smoke test using `shinytest2`.

* Added a `NEWS.md` file to track changes to the package.
