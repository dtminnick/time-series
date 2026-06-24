# Exploratory Notes: Building Intuition for Linear Filters

I used Microsoft Copilot to help me work through two simple examples to build intuition about how 
linear filters behave.  The examples and explanations in this notebook were 
generated collaboratively with AI as a learning aid.  After working through these 
examples, I created [this Shiny app](https://dtminnick.shinyapps.io/filter-app/) 
to build my intuition.

## Example 1: A Filter That Does Not Distort a Line

I chose a simple line $x_t = t$ with the following values:

| $t$ | $x_t$ |
| --- | ----- |
| -2  | -2    |
| -1  | -1    |
| 0   | 0     |
| 1   | 1     |
| 2   | 2     |
| 3   | 3     |

This is a straight line through the origin.

I use the symmetric filter:

$$
\psi(B)x_t = \frac{1}{4} x_{t+1} + \frac{1}{2} x_t + \frac{1}{4} x_{t-1}.
$$

This means:

* Look one step ahead,
* Look at the current value,
* Look one step behind, and
* Mix them with weights 0.25, 0.5, 0.25.

This is a centered moving average.

Now apply the filter to the line by computing the filtered value at each time $t$.

### At $t = 0$

* $x_1 = 1$
* $x_0 = 0$
* $x_{-1} = -1$

$$
\psi(b)x_0 = \frac{1}{4}(1) + \frac{1}{2}(0) + \frac{1}{4}(-1) = \frac{1}{4} - \frac{1}{4} = 0
$$

The original value is $x_0 = 0$ and the filtered value is $0$.

### At $t = 1$

* $x_2 = 2$
* $x_1 = 1$
* $x_0 = 0$

$$
\psi(b)x_1 = \frac{1}{4}(2) + \frac{1}{2}(1) + \frac{1}{4}(0) = \frac{1}{2} + \frac{1}{2} = 1
$$

The original value is $x_1 = 1$ and the filtered value is 1.

### At $t = 2$

* $x_3 = 3$
* $x_2 = 2$
* $x_1 = 1$

$$
\psi(b)x_2 = \frac{1}{4}(3) + \frac{1}{2}(2) + \frac{1}{4}(1) = \frac{3}{4} + 1 + \frac{1}{4} = 2
$$

The original value is $x_2 = 2$ and the filtered value is 2.

For this filter and this line:

$$
\psi(B)x_t = x, \qquad \text{for all } t.
$$

So the filter passes through the line without distortion.  The filter did not change 
the intercept or the slope, and it did not shift the line right or left.  This is 
because the weights are symmetric and sum to one.

## Symmetry

A symmetric filter means:

$$
\psi_{-j} = \psi_j
$$

So the center of mass of the weights is exactly at zero.  This forces:

$$
\sum^2_{j=-2} j\psi_j = 0.
$$

This is the condition that prevents the line from being shifted left or right.

If this sum were positive, the line would shift one way.  If negative, it would 
shift the other way.  Symmetry makes it exactly zero.

## Summing to One

If the weights sum to one:

$$
\sum^2_{j=-2} \psi_j = 1,
$$

then the filter preserves the intercept and the slope because the filtered value becomes:

$$
\psi(b)(a + bt) = a(1) + bt(0) = a + bt.
$$

So the line stays exactly the same.

Therefore:

$$
\psi(B)(a + bt) = a + bt \text{ for all } a, b, t.
$$

## Example 2: A Filter That Does Distort a Line

I use the same line for this example: 

$$
x_t = t
$$

| $t$ | $x_t$ |
| --- | ----- |
| -2  | -2    |
| -1  | -1    |
| 0   | 0     |
| 1   | 1     |
| 2   | 2     |
| 3   | 3     |

And I use the simplest asymmetric filter possible:

* $\psi_{-2} = 0$
* $\psi_{-1} = 0$
* $\psi_0 = 0$
* $\psi_1 = 1$
* $\psi_2 = 0$

This filter is $\psi(B)x_t = x_{t-1}$.  This is the backshift.  It breaks symmetry 
because all the weight is on one side, even though the weights sum to one. So I 
expect the filter to distort the line.

Now apply the filter to the line.

### At $t = 0$

* $x_0 = 0$
* $x_{-1} = -1$

$$
\psi(b)x_0 = x_{t-1} = -1
$$

The original value is $x_0 = 0$ and the filtered value is $-1$.

### At $t = 1$

* $x_1 = 1$
* $x_0 = 0$

$$
\psi(B)x_1 = x_0 = 0
$$

The original value is $x_1 = 1$ and the filtered value is $0$.

### At $t = 2$

* $x_2 = 2$
* $x_1 = 1$

$$
\psi(B)x_2 = x_1 = 1
$$

The original value is $x_2 = 2$ and the filtered value is $1$.

To confirm the distortion, I compare the original and filtered values:

| $t$ | Original $x_t$ | Filtered $\psi(B)x_t$ |
| --- | -------------- | --------------------- |
| 0   | 0              | -1                    |
| 1   | 1              | 0                     |
| 2   | 2              | 1                     |

The filtered line is:

$$
\psi(B)x_t = t - 1.
$$

This is the same slope, but the line is shifted down by one.  That is an example of 
distortion. This happened because the filter violated the symmetry condition:

$$
\sum j\psi_j = 0.
$$

Instead:

$$
\sum j\psi_j = 1.
$$

This means the filter has a center of mass shifted to the right, so it pulls the 
line left (or down, depending on how you visualize it).

## Example 3: Another Distortion

| $t$ | $x_t$ |
| --- | ----- |
| -2  | -2    |
| -1  | -1    |
| 0   | 0     |
| 1   | 1     |
| 2   | 2     |
| 3   | 3     |

And I use the simplest asymmetric filter possible:

* $\psi_{-2} = 0$
* $\psi_{-1} = 1$
* $\psi_0 = 0$
* $\psi_1 = 0$
* $\psi_2 = 0$

This filter is $\psi(B)x_t = x_{t+1}$.

Now apply the filter to the line.

### At $t = 0$

* $x_0 = 0$
* $x_1 = 1$

$$
\psi(B)x_0 = x_1 = 1
$$

The original value is $x_0 = 0$ and the filtered value is $1$.

### At $t = 1$

* $x_1 = 1$
* $x_2 = 2$

$$
\psi(B)x_1 = x_2 = 2
$$

The original value is $x_1 = 1$ and the filtered value is $2$.

### At $t = 2$

* $x_2 = 2$
* $x_3 = 3$

$$
\psi(B)x_2 = x_3 = 3
$$

The original value is $x_2 = 2$ and the filtered value is $3$.

To confirm the distortion, I compare the original and filtered values:

| $t$ | Original $x_t$ | Filtered $\psi(B)x_t$ |
| --- | -------------- | --------------------- |
| 0   | 0              | 1                     |
| 1   | 1              | 2                     |
| 2   | 2              | 3                     |

The filtered line is:

$$
\psi(B)x_t = t + 1.
$$

This is the same slope, but the line is shifted up by one.  That is an example of 
distortion. This happened because the filter violated the symmetry condition:

$$
\sum_j j\psi_j = 0.
$$

Instead:

$$
\sum_j j\psi_j = -1.
$$

This means the filter has a center of mass shifted to the left, so it pulls the 
line left (or up, depending on how you visualize it).

## Observations

After experimenting with filters using a Shiny app, I noted the following behaviors.

**Asymmetry shifts the line.**

The amount of shift is controlled by:

$$
\sum_j j\psi_j.
$$

That sum is the average position of the weights relative to the center.  If it's 
not zero, the filter pulls the line in that direction.

**Moving weight farther from the center increases the shift.**

When you put more weight on $j = 2$ instead of $j = 1$, you increase the contribution 
of $2 \psi_2$ in:

$$
\sum_j j \psi_j,
$$

so the effective shift gets larger.  The same is true on the negative side.

**There is a limit to how much the line can shift with this filter design.**

Because the filter only uses lags from -2 to 2, the center of mass can't move 
beyond that range.  Even if you pull all the weight to $j = 2$, the shift is 
bounded by that maximum lag.  The support of the filter caps how far you can 
push the line.

**Some negative weights can be allowed and still preserve the line.**

For example, a filter like [-0.1, 0.3, 0.6, 0.3, -0.1] is symmetric, sums to one, 
includes negative weights, and preserves any $a + bt$ line.

## Question

If any symmetric filter whose weights sum to one will pass a line perfectly, 
why would I choose one symmetric filter over another?

All of these filters leave the straight line we started with:

* [0, 0, 1, 0, 0]
* [0.5, 0, 0, 0, 0.5]
* [0.25, 0.5, 0.25]
* [0.1, 0.2, 0.4, 0.2, 0.1]

They all sum to one will pass a line unchanged, but they differ in how they treat 
everything else. The choice of filter determines:

* how much smoothing you get,
* how aggressively noise is removed,
* how much curvature is preserved or destroyed,
* how sharply peaks and turning points are damped,
* how wide the effective averaging window is, and
* how much high‑frequency content is suppressed.

So even though these filters agree on straight lines, they disagree on everything 
that isn’t a straight line.






