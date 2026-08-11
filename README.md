# PK Plot & Metrics

Temporary documentation for the R-based PK plotting and metrics utilities.

## Overview

This project provides two main functions:

* `pkplot()` — generates and saves PK plots from PK-Sim output.
* `pkmetrics()` — calculates and saves PK metrics from PK-Sim output.

The input `pkData` is read directly from a **PK-Sim output file** using `read_pksim()`.

## Folder Structure

```text
R/
├── add_title.R
├── argument_validator.R
├── compute_metrics.R
├── determine_plot_type.R
├── individual_plot.R
├── legend_layout.R
├── pkmetrics.R
├── pkplot.R
├── population_plot.R
├── read_pksim.R
├── remove_legend.R
├── save_csv.R
├── save_plot.R
├── set_font.R
└── set_theme.R
```

## `pkplot()`

Generates a PK plot based on either an individual or population simulation.

```r
pkplot(
  filePath,
  outputPath,
  simType,
  legend = TRUE,
  greyscale = FALSE,
  plotTitle = ""
)
```

### Arguments

| Argument     | Description                                                     |
| ------------ | --------------------------------------------------------------- |
| `filePath`   | Path to the PK-Sim output file.                                 |
| `outputPath` | Directory/path where the plot should be saved.                  |
| `simType`    | Simulation type: `"individual"` or `"population"`.              |
| `legend`     | Whether to include the plot legend. Defaults to `TRUE`.         |
| `greyscale`  | Whether to generate the plot in greyscale. Defaults to `FALSE`. |
| `plotTitle`  | Optional plot title.                                            |

### Workflow

1. Validate function arguments.
2. Read the PK-Sim output using `read_pksim()`.
3. Determine the required plot specification using `determine_plot_type()`.
4. Generate an individual or population plot.
5. Apply the project theme and font.
6. Configure or remove the legend.
7. Optionally add a title.
8. Save the plot using `save_plot()`.

Example:

```r
pkplot(
  filePath = "path/to/pksim_output.csv",
  outputPath = "output/",
  simType = "population",
  legend = TRUE,
  greyscale = FALSE,
  plotTitle = "PK Profile"
)
```

## `pkmetrics()`

Calculates PK metrics for the data contained in a PK-Sim output file and saves the results as CSV files.

```r
pkmetrics(
  filePath,
  outputPath,
  simType
)
```

### Arguments

| Argument     | Description                                            |
| ------------ | ------------------------------------------------------ |
| `filePath`   | Path to the PK-Sim output file.                        |
| `outputPath` | Directory/path where metric CSV files should be saved. |
| `simType`    | Simulation type: `"individual"` or `"population"`.     |

### Workflow

The function:

1. Validates the arguments.
2. Reads the PK-Sim output using `read_pksim()`.
3. Determines the plot/data specification.
4. Iterates over the relevant datasets.
5. Calculates metrics using `compute_metrics()`.
6. Saves the results using `save_csv()`.

For **individual simulations**, metrics are calculated for each measurement column other than the `Time` column.

For **population simulations**, metrics are calculated for each non-`range` layer using its `Time` and `Concentration` columns. The resulting CSV is named using the corresponding `Curve Caption`.

Example:

```r
pkmetrics(
  filePath = "path/to/pksim_output.csv",
  outputPath = "output/",
  simType = "individual"
)
```

## PK-Sim Input

The input data is expected to originate directly from **PK-Sim**. The `read_pksim()` function is responsible for reading and structuring this data.

The downstream functions currently expect PK-Sim-derived columns such as:

* `Time...`
* `Concentration...`
* `Curve Caption...`

The exact column structure may vary depending on the simulation type and PK-Sim output.

## Dependencies

The project currently uses functionality from packages including:

* `ggplot2`
* `fs`

Additional dependencies may be required by individual scripts.

## Current Limitations / TODOs

This is temporary documentation and the API and data validation may change.

Known TODOs include:

* Add explicit validation of the data returned by `read_pksim()`.
* Add more robust validation of required columns.
* Improve error handling for unexpected PK-Sim output structures.
* Review and clean up column-detection logic in `pkmetrics()`.
* Further document the metrics calculated by `compute_metrics()`.
* Confirm and document the expected `outputPath` format.
* Add tests for individual and population simulations.

## General Usage

The scripts are currently designed to be sourced directly:

```r
source("R/pkplot.R")
source("R/pkmetrics.R")
```

The supporting `.R` files should be available in the same `R/` directory as shown above.
