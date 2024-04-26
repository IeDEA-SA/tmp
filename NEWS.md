# MATCHA 0.2.0

* Added the following new plot types with associated modules:
  - `plot_stacked_bar`: Plots comparisons of stacked bar chart of percentages or counts of the top `n` categories of a categorical variable.
  - `plot_cat_count_by_year`: Plots faceted comparisons of the counts of top `n` categories of a categorical variable by year.
* Fixed bug in loading of new tables which was causing previously generated plots in other tabs to be lost (thanks @AleKoure)

# MATCHA 0.0.1

* Added hash to link source file to table tabs.

* Added e2e smoke test using `shinytest2`.

* Added a `NEWS.md` file to track changes to the package.
