# as_bk_data warns for unknown classes

    Code
      (expect_pkg_warning_classes({
        test_result <- as_bk_data("a")
      }, "beekeeper", "bk_data", "missing_method"))
    Output
      <warning/beekeeper-warning-bk_data-missing_method>
      Warning in `method(as_bk_data, class_any)`:
      No method for as_bk_data() for class <character>.

