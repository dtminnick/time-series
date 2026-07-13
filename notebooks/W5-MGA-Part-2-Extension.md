    library("stats")

### Model Setup

Specify the MA(1) model parameter *θ* = 0.8 and the simulation length
*n* = 200.

    theta <- 0.8

    n <- 200

### Simulate MA(1) Process

The function `simulate_ma1` generates a realization of the MA(1) model
*X*<sub>*t*</sub> = *W*<sub>*t*</sub> + *θ**W*<sub>*t* − 1</sub>,
where *W*<sub>*t*</sub> is standard normal noise. The function returns a
numeric vector of length *n*.

    simulate_ma1 <- function(n, theta) {
        
        w <- rnorm(n)
        
        x <- w + theta * c(0, w[-n])
        
        return(x)
        
    }

The function is used to generate two independent datasets.

### Durbin-Levinson Recursion

The function `durlev_ma1` computes the lag-2 Durbin-Levinson
coefficients for the MA(1) model. It first computes the autocovariances
*γ*(0) = 1 + *θ*<sup>2</sup>,  *γ*(1) = *θ*,  *γ*(2) = 0,
then applies the recursion to obtain
*ϕ*<sub>1, 1</sub>, *ϕ*<sub>2, 1</sub>, *ϕ*<sub>2, 2</sub>. These
coefficients depend only on *θ*, not on the simulated data. The function
prints a labeled block and returns the coefficients.

    durlev_ma1 <- function(tag, theta) {

        gamma_0 <- 1 + theta^2
        gamma_1 <- theta
        gamma_2 <- 0

        phi_11 <- gamma_1 / gamma_0
        phi_22 <- -phi_11^2
        phi_21 <- phi_11 * (1 - phi_11^2)

        coeffs <- list(gamma = c(g0 = gamma_0, 
                                 g1 = gamma_1, 
                                 g2 = gamma_2),
                       phi = c(phi_11 = phi_11, 
                               phi_21 = phi_21, 
                               phi_22 = phi_22))

        cat("D-L Coefficients for", tag, "\n"); print(coeffs)

        return(coeffs)
        
    }

This function is called separately for each dataset.

### Generate Datasets

I generate two datasets using different seeds so the simulated values
differ.

    set.seed(123)
    xA <- simulate_ma1(n, theta)

    set.seed(456)
    xB <- simulate_ma1(n, theta)

These datasets will produce different predictions and recoveries.

### Compute Coefficients

I compute the recursion coefficients for each dataset. Even though the
labels differ, the coefficients themselves are identical because they
depend on on *θ*.

This code prints two labeled blocks showing the same coefficient values.

    coeffsA <- durlev_ma1("xA (Seed 123)", theta)

    ## D-L Coefficients for xA (Seed 123) 
    ## $gamma
    ##   g0   g1   g2 
    ## 1.64 0.80 0.00 
    ## 
    ## $phi
    ##     phi_11     phi_21     phi_22 
    ##  0.4878049  0.3717300 -0.2379536

    coeffsB <- durlev_ma1("xB (Seed 456)", theta)

    ## D-L Coefficients for xB (Seed 456) 
    ## $gamma
    ##   g0   g1   g2 
    ## 1.64 0.80 0.00 
    ## 
    ## $phi
    ##     phi_11     phi_21     phi_22 
    ##  0.4878049  0.3717300 -0.2379536

### One-Step-Ahead Prediction

The one-step-ahead predictor uses
*X̂*<sub>3</sub> = *ϕ*<sub>2, 1</sub>*X*<sub>2</sub> + *ϕ*<sub>2, 2</sub>*X*<sub>1</sub>.

Because *X*<sub>1</sub> and *X*<sub>2</sub> differ between `xA` and
`xB`, the predictions differ. This section demonstrates the
data‑dependent nature of the predictor.

    predict_X3 <- function(x, coeffs) {
        
        phi_21 <- coeffs$phi["phi_21"]
        
        phi_22 <- coeffs$phi["phi_22"]
        
        phi_21 * x[2] + phi_22 * x[1]
        
    }

    predA_X3 <- predict_X3(xA, coeffsA)

    predB_X3 <- predict_X3(xB, coeffsB)

    cat("Prediction of X3 (Seed 123)\n"); predA_X3

    ## Prediction of X3 (Seed 123)

    ##     phi_21 
    ## -0.1188731

    cat("Prediction of X3 (Seed 456)\n"); predB_X3

    ## Prediction of X3 (Seed 456)

    ##    phi_21 
    ## 0.1512866

### One-Step-Behind Recovery

Again, the coefficients are identical, but the recovered values differ
because the data differ.

    recover_X3 <- function(x, coeffs) {
        
        phi_21 <- coeffs$phi["phi_21"]
        
        phi_22 <- coeffs$phi["phi_22"]
        
        phi_21 * x[5] + phi_22 * x[4]
        
    }

    recA_X3 <- recover_X3(xA, coeffsA)

    recB_X3 <- recover_X3(xB, coeffsB)

    cat("Recovery of X3 (Seed 123)\n"); recA_X3

    ## Recovery of X3 (Seed 123)

    ##     phi_21 
    ## -0.2444697

    cat("Recovery of X3 (Seed 456)\n"); recB_X3

    ## Recovery of X3 (Seed 456)

    ##    phi_21 
    ## -0.500547

This confirms that Durbin-Levinson coefficients are model-fixed, while
predictions and recoveries are data-dependent.
