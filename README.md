

# 506 Group Project

Group 11 <br />

Members:  Xiaolin Cao, Yinuo Chen, Zheng Jing<br />



## Question: 

In terms of demographic features, alcohol use and dietary habits, what features are most associated with the prevalence of diabetes? <br />



## Variable selection:

### Data source:

 <https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx>

Here we use survey data in the 2015 - 2016 cycle.

### Response variable: 

| Variable | Description                   | Data Type        | Dataset   |
| -------- | ----------------------------- | ---------------- | --------- |
| DIQ010   | Doctor told you have diabetes | Categorical. 0/1 | DIQ_I.XPT |

### Predictor variables:

| Variable  | Description                                         |         Data Type         | Dataset      |
| --------- | --------------------------------------------------- | :-----------------------: | ------------ |
| RIAGENDER | Gender(1: male;  2: female)                         |     Categorical. 1/2      | DEMO_I.XPT   |
| RIDAGEYR  | Age in years at screening                           | Positive Integer. [18,80] | DEMO_I.XPT   |
| ALQ130    | Average alcoholic drinks/day  in the past 12 months | Positive Integer. [0,15]  | ALQ_I.XPT    |
| DR1TSUGR  | Total sugar (gm)                                    |  Double. [0.33, 533.44]   | DR1TOT_I.XPT |
| DR1TTFAT  | Total fat (gm)                                      |  Double. [3.54, 498.63]   | DR1TOT_I.XPT |
| OCQ260    | Description of job/work situation                   |    Categorical. 1/2/3     | OCQ_I.XPT    |
| SLD012    | Sleep hours                                         |    Double. [3.0, 2.0]     | SLQ_I.XPT    |



## Method Introduction:

In statistics, the logistic model is used to model the probability of a certain class, such as pass/fail, win/lose, alive/dead or healthy/sick. <br /> 

Here, our response variable is binary (diabetes or not). In ordinary linear model, the response variable range from negative infinite to positive infinite. In order to  model a binary dependent variable, we need to use a logistic function as a link function: <br />
<div align="center"><a href="https://www.codecogs.com/eqnedit.php?latex=\\log(\frac{p}{1-p})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\\log(\frac{p}{1-p})" title="\\log(\frac{p}{1-p})" /></a></div>


Then we can use logistic regression to fit our model: <br />
<div align="center"><a href="https://www.codecogs.com/eqnedit.php?latex=\\log(\frac{p}{1-p})&space;=\eta&space;=&space;\beta_0&plus;\sum_{i=1}^{n}\beta_iX_{i}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\\log(\frac{p}{1-p})&space;=\eta&space;=&space;\beta_0&plus;\sum_{i=1}^{n}\beta_iX_{i}" title="\\log(\frac{p}{1-p}) =\eta = \beta_0+\sum_{i=1}^{n}\beta_iX_{i}" /></a></div>

Use maximum likelihood approach to find parameters that maximize the likelihood of the data:  <br />
<div align="center"><a href="https://www.codecogs.com/eqnedit.php?latex=\ell(\beta)&space;=&space;\sum_{i=1}^{n}[y_i({x_i}^\intercal\beta)-n_i\log(1&plus;exp({x_i}^\intercal\beta))]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\ell(\beta)&space;=&space;\sum_{i=1}^{n}[y_i({x_i}^\intercal\beta)-n_i\log(1&plus;exp({x_i}^\intercal\beta))]" title="\ell(\beta) = \sum_{i=1}^{n}[y_i({x_i}^\intercal\beta)-n_i\log(1+exp({x_i}^\intercal\beta))]" /></a></div>

Then we can get the probability of success (here means being told you have diabetes):  <br />
<div align="center"><a href="https://www.codecogs.com/eqnedit.php?latex=p&space;=&space;P(Y&space;=&space;1)&space;=&space;\frac{e^{\beta_0&space;&plus;&space;\sum_{i=1}^{n}\beta_iX_{i}}}{&space;1&space;&plus;&space;e^{\beta_0&space;&plus;&space;\sum_{i=1}^{n}\beta_iX_{i}}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p&space;=&space;P(Y&space;=&space;1)&space;=&space;\frac{e^{\beta_0&space;&plus;&space;\sum_{i=1}^{n}\beta_iX_{i}}}{&space;1&space;&plus;&space;e^{\beta_0&space;&plus;&space;\sum_{i=1}^{n}\beta_iX_{i}}}" title="p = P(Y = 1) = \frac{e^{\beta_0 + \sum_{i=1}^{n}\beta_iX_{i}}}{ 1 + e^{\beta_0 + \sum_{i=1}^{n}\beta_iX_{i}}}" /></a></div>

## File description & Collaboration:

Our group uses three kinds of tools to carry out the core analysis: R, python and Stata.

1. .R file: Using R to clean data and fit model. Basically Wrote by Yinuo Chen, reviewed by other 2 group members

2. .do file: Using Stata to clean data and fit model.  Basically Wrote by Xiaolin Cao, reviewed by other 2 group members

3. .ipynb file: Using python to clean data and fit model. Basically wrote by Zheng Jing, reviewed by other 2 group members.

4. .Rmd file: Describe data, summarize model and interpret model conclusion. All of us work on it.

5. .html file: knit the .Rmd file and create a html file.





## References:

1. Faraway, Julian J. *Extending the linear model with R: generalized linear, mixed effects and nonparametric regression models*. Chapman and Hall/CRC, 2016.

