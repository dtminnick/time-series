    library("knitr")

I define a function that computes the components of the sample
autocorrelation at lag 1 with the sample size *n*, the numerator

$$
\sum^n\_{t=2} (x\_t - \bar{x})(x\_{t-1} - \bar{x}),
$$

the denominator
$$
\sum^n\_{t=1} (x\_t - \bar{x})^2,
$$

and the sample ACF
$$
\rho\_1 = \frac{numerator}{denominator}
$$

    acf_components <- function(x) {
        
        n <- length(x)
        
        xbar <- mean(x)
        
        num <- sum((x[2:n] - xbar) * (x[1:(n-1)] - xbar))
        
        denom <- sum((x - xbar)^2)
        
        rho1 <- num / denom
        
        list(n = n,
             numerator = num,
             denominator = denom,
             acf1 = rho1)
        
    }

I apply the function to four datasets of increasing size.

    x_small <- c(2, 3, 1, 4, 2)

    res_small <- acf_components(x_small)

    x_large <- c(2, 3, 1, 4, 2, 3, 2, 1, 4, 3)

    res_large <- acf_components(x_large)

    x_20 <- c(2,3,1,4,2,3,2,1,4,3,2,3,1,4,2,3,2,1,4,3)

    res_20 <- acf_components(x_20)

    x_50 <- rep(c(2,3,1,4,2,3,2,1,4,3), 5)

    res_50 <- acf_components(x_50)

    x_100 <- rep(c(2,3,1,4,2,3,2,1,4,3), 10)

    res_100 <- acf_components(x_100)

And present the results in table form.

    results_df <- data.frame(
        
        sample = c("x_small", 
                   "x_large", 
                   "x_20", 
                   "x_50",
                   "x_100"),
        
        n = c(res_small$n, 
              res_large$n, 
              res_20$n, 
              res_50$n,
              res_100$n),
        
        numerator = c(res_small$numerator, 
                      res_large$numerator, 
                      res_20$numerator, 
                      res_50$numerator,
                      res_100$numerator),
        
        denominator = c(res_small$denominator, 
                        res_large$denominator, 
                        res_20$denominator, 
                        res_50$denominator,
                        res_100$denominator),
        
        acf1 = c(res_small$acf1, 
                 res_large$acf1, 
                 res_20$acf1, 
                 res_50$acf1,
                 res_100$acf1)
        
    )

    kable(results_df, caption = "ACF Components at Lag 1 for Each Sample")

<table>
<caption>ACF Components at Lag 1 for Each Sample</caption>
<thead>
<tr>
<th style="text-align: left;">sample</th>
<th style="text-align: right;">n</th>
<th style="text-align: right;">numerator</th>
<th style="text-align: right;">denominator</th>
<th style="text-align: right;">acf1</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">x_small</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-3.96</td>
<td style="text-align: right;">5.2</td>
<td style="text-align: right;">-0.7615385</td>
</tr>
<tr>
<td style="text-align: left;">x_large</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">-5.25</td>
<td style="text-align: right;">10.5</td>
<td style="text-align: right;">-0.5000000</td>
</tr>
<tr>
<td style="text-align: left;">x_20</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">-10.75</td>
<td style="text-align: right;">21.0</td>
<td style="text-align: right;">-0.5119048</td>
</tr>
<tr>
<td style="text-align: left;">x_50</td>
<td style="text-align: right;">50</td>
<td style="text-align: right;">-27.25</td>
<td style="text-align: right;">52.5</td>
<td style="text-align: right;">-0.5190476</td>
</tr>
<tr>
<td style="text-align: left;">x_100</td>
<td style="text-align: right;">100</td>
<td style="text-align: right;">-54.75</td>
<td style="text-align: right;">105.0</td>
<td style="text-align: right;">-0.5214286</td>
</tr>
</tbody>
</table>

As the sample grows, the estimates converge to −0.52. The table shows
the expected behavior of the autocorrelation estimator. Small samples
produce volatile ACF estimates because the numerator and denominator are
sensitive to individual observations. Larger samples produce more
consistent ACF estimates and converge to the true autocorrelation. The
lag-1 estimator becomes more reliable as *n* increases.
