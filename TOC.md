# Mixed Models := ((--| generalized | non-) Linear | Generalized Additive) Mixed-Effects Models
### i.e., LMM, GLMM, NLMM. GAMM

## Table of Contents -- Lectures

### Part I:  Linear MM

1. Introduction - 1- and 2-way ANOVA and beyond

#### 'The' book: Pinheiro, J.C., and Bates, D.M. (2000) *Mixed-Effects Models in S and S-PLUS*, Springer.
	available typically [here](https://link.springer.com/book/10.1007%2Fb98882)

  a. `nlme` (book) chapter 1: Rail, ... .. "anova" notation: 1-way anova, 2-way
     R(markdown) script: [R/ch01.Rmd](R/ch01.Rmd) -- and nicely
     `rmarkdown::render()`ed [html](R/ch01.html).

  b. `lMMwR` (not-yet-book by Doug Bates) chapter 1: sleepstudy --

  c. Comparison  `aov()`, `lme()`, `lmer()`.

  d. Classical solution: Assume given Sigma (called G).
	  --> https://en.wikipedia.org/wiki/Mixed_model

  e. Classical solution does not scale to large q (`q = ncol(Z)`)

  f. --> New approach to ML and REML


2. General Notation:  No "grouping" assumed

3. Inference: "No P values" vs `lmerTest` et al.

  - When can we trust the confidence intervals / P values ??
  - Profiled Likelihood - based intervals; profile pairs
  - Bootstrap -- non-iid?


### Part II:  Generalized LMM, e.g. for Count Data (Ecology)

  - Model formulation; likelihood approximations
  - The new `glmmTMB` package: Zero-inflation, hurdle models, etc


### Part III: GAMM (Generalized Additive), *Non*linear MM;  Robust Linear MM

