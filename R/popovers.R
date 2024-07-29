file_access_info <- popover(
  icon("info-circle"),
  markdown(
    "Allowed file formats include **`.csv`**, **`.rds`**, **`.dta`**, **`.sav`**, **`.por`**, **`.sas7bdat`** and **`.sas7bcat`**.

    Please ensure that **directories do not contain files with the same name but different extension/formats**.

    Please ensure CSV files have ISO date format (**`YYYY-MM-DD`**)"
  ),
  title = "Data requirements"
)
