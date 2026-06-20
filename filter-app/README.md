# Interactive Linear Trend Filtering

This Shiny app provides an intuitive, hands-on way to explore linear filters and 
how they transform simple trends.  By adjusting filter weights and line parameters, 
you can immediately see how convolution affects a signal.

## Features

* Adjustable filter weights (`psi -2` through `psi 2`).
* Optional normalization (weights sum to one).
* Optional symmetry constraints.
* Interactive plotly visualization of linear trend and filtered trend.
* Real-time display of the effective linear weights.

## How to Run the App

Clone the repository and run the app from R:

```{r}
library("shinty")
shiny::runApp("path\to\this\folder")
```

The app is contained in a single file:

```{r}
app.R
```

## Concepts Demonstrated

* Linear filtering via convolution.
* Effect of weight symmetry.
* Normalization and its impact on trend preservation.
* How filters distort or smooth linear signals.
