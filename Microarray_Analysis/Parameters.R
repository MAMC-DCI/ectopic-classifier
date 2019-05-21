param <- tibble::lst(
  # Define metadata paths.
  meta_dir = tibble::lst(
    MAMC_DCI__Train = file.path("Data","Arrays","MAMC_DCI","Train",
                                "metadata.xls"),
    MAMC_DCI__Test = file.path("Data","Arrays","MAMC_DCI","Test",
                               "metadata.xls"),
    MAMC_DCI__Test_RepOfTrain = file.path("Data","Arrays","MAMC_DCI",
                                          "Test_RepOfTrain","metadata.xls"),
    Horne_Lab = file.path("Data","Arrays","Horne_Lab","conditions.txt")
  ),
  # Define directories containing CEL files.
  cel_dir = tibble::lst(
    MAMC_DCI__Train = file.path("Data","Arrays","MAMC_DCI","Train","CEL_files"),
    MAMC_DCI__Test = file.path("Data","Arrays","MAMC_DCI","Test","CEL_files"),
    MAMC_DCI__Test_RepOfTrain = file.path("Data","Arrays","MAMC_DCI",
                                          "Test_RepOfTrain","CEL_files"),
    Horne_Lab = file.path("Data", "Arrays", "Horne_Lab", "E-MTAB-680",
                          "E-MTAB-680.raw.1")
  ),
  # Define array types.
  array_type = tibble::lst(
    MAMC_DCI__Train = "HuGene-2_0",
    MAMC_DCI__Test = "HuGene-2_0",
    MAMC_DCI__Test_RepOfTrain = "HuGene-2_0",
    Horne_Lab = "HG-U133_Plus_2"
  ),
  # Define probe_map save locations.
  probe_map = tibble::lst(
    "HuGene-2_0" = file.path("Cache","hg2_probe_map.rds"),
    "HG-U133_Plus_2" = file.path("Cache","u133_probe_map.rds")
  ),
  # Vector of ENSEMBL IDs found in both array types.
  valid_ensembl = file.path("Cache","valid_ensembl.rds")
)
