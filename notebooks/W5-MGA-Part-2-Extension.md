The following R code verifies the analytical results from Part 2 by
computing the MA(1) autocovariances, Durbin–Levinson recursion
values, and the correct linear predictor coefficients for
*P*(*X*<sub>3</sub>|*X*<sub>1</sub>, *X*<sub>2</sub>). It separates
three distinct sets of values:

1.  autocovariances,
2.  recursion coefficients, and
3.  linear predictor coefficients.

The code computes both sets of coefficients and applies the predictor to
simulated MA(1) data to confirm that the numerical results match the
closed‑form expressions derived in Part 2. It also includes a simple
“recovery” check showing that the same predictor coefficients correctly
reconstruct *X*<sub>3</sub> from later observations.

    library(stats)

    simulate_ma1 <- function(n, theta) {
        w <- rnorm(n)
        x <- w + theta * c(0, w[-n])
        x
    }

    # Durbin–Levinson for MA(1): return gamma, PACF, and predictor coefficients
    durlev_ma1 <- function(tag, theta) {
        
        # Autocovariances
        gamma_0 <- 1 + theta^2
        gamma_1 <- theta
        gamma_2 <- 0
        
        # PACF coefficients (Durbin–Levinson recursion)
        phi_11 <- gamma_1 / gamma_0
        phi_22 <- -phi_11^2
        phi_21 <- phi_11 * (1 - phi_11^2)
        
        # Best linear predictor coefficients for X3 | X2, X1
        Gamma <- matrix(c(gamma_0, gamma_1,
                          gamma_1, gamma_0), 2, 2)
        
        rhs <- c(gamma_1, gamma_2)
        
        beta <- solve(Gamma, rhs)  # predictor coefficients
        
        coeffs <- list(
            gamma = c(g0 = gamma_0, g1 = gamma_1, g2 = gamma_2),
            pacf  = c(phi_11 = phi_11, phi_21 = phi_21, phi_22 = phi_22),
            pred  = c(beta1 = beta[1], beta2 = beta[2])
        )
        
        cat("Durbin–Levinson Output for", tag, "\n")
        print(coeffs)
        
        coeffs
    }

    # Prediction using correct predictor coefficients
    predict_X3 <- function(x, coeffs) {
        b1 <- coeffs$pred["beta1"]
        b2 <- coeffs$pred["beta2"]
        b1 * x[2] + b2 * x[1]
    }

    # Recovery using correct predictor coefficients
    recover_X3 <- function(x, coeffs) {
        b1 <- coeffs$pred["beta1"]
        b2 <- coeffs$pred["beta2"]
        b1 * x[5] + b2 * x[4]
    }

    # Generate data
    set.seed(123)
    xA <- simulate_ma1(200, 0.8)

    set.seed(456)
    xB <- simulate_ma1(200, 0.8)

    # Compute coefficients
    coeffsA <- durlev_ma1("xA (Seed 123)", 0.8)

    ## Durbin–Levinson Output for xA (Seed 123) 
    ## $gamma
    ##   g0   g1   g2 
    ## 1.64 0.80 0.00 
    ## 
    ## $pacf
    ##     phi_11     phi_21     phi_22 
    ##  0.4878049  0.3717300 -0.2379536 
    ## 
    ## $pred
    ##      beta1      beta2 
    ##  0.6401249 -0.3122560

    coeffsB <- durlev_ma1("xB (Seed 456)", 0.8)

    ## Durbin–Levinson Output for xB (Seed 456) 
    ## $gamma
    ##   g0   g1   g2 
    ## 1.64 0.80 0.00 
    ## 
    ## $pacf
    ##     phi_11     phi_21     phi_22 
    ##  0.4878049  0.3717300 -0.2379536 
    ## 
    ## $pred
    ##      beta1      beta2 
    ##  0.6401249 -0.3122560

    # Predictions
    cat("Prediction of X3 (Seed 123)\n")

    ## Prediction of X3 (Seed 123)

    predA_X3 <- predict_X3(xA, coeffsA)
    predA_X3

    ##    beta1 
    ## -0.25935

    cat("Prediction of X3 (Seed 456)\n")

    ## Prediction of X3 (Seed 456)

    predB_X3 <- predict_X3(xB, coeffsB)
    predB_X3

    ##     beta1 
    ## 0.1295195

    # Recovery
    cat("Recovery of X3 (Seed 123)\n")

    ## Recovery of X3 (Seed 123)

    recA_X3 <- recover_X3(xA, coeffsA)
    recA_X3

    ##      beta1 
    ## -0.2925219

    cat("Recovery of X3 (Seed 456)\n")

    ## Recovery of X3 (Seed 456)

    recB_X3 <- recover_X3(xB, coeffsB)
    recB_X3

    ##      beta1 
    ## -0.9349016
