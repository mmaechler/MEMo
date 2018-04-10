# Mixed Models := ((--| generalized | non-) Linear | Generalized Additive) Mixed-Effects Models
### i.e., LMM, GLMM, NLMM. GAMM

## Table of Contents -- Lectures

### Part I:  Linear MM

1. Introduction - 1- and 2-way ANOVA and beyond

#### 'The' book: Pinheiro, J.C., and Bates, D.M. (2000) *Mixed-Effects Models in S and S-PLUS*, Springer.
	available typically at https://link.springer.com/book/10.1007%2Fb98882

  a. `nlme` (book) chapter 1: Rail, ... .. "anova" notation: 1-way anova, 2-way
     R(markdown) script: [R/ch01.Rmd](R/ch01.Rmd) -- and nicely
     `rmarkdown::render()`ed [html](https://stat.ethz.ch/~maechler/MEMo-pages/ch01.html).

  b. `lMMwR` (not-yet-book by Doug Bates) chapter 1: sleepstudy --

  c. Comparison  `aov()`, `lme()`, `lmer()`.

  d. Classical solution: Assume given Sigma (called G).
	  --> https://en.wikipedia.org/wiki/Mixed_model

  e. Classical solution does not scale to large q (`q = ncol(Z)`)

  f. --> New approach to ML and REML


2. General Notation:  No "grouping" assumed

3. Inference: "No P values" vs `lmerTest` et al.

  a. `nlme` (book) chapter 2, notably 2.4
     R(markdown) script: [R/ch02.Rmd](R/ch02.Rmd),
     `rmarkdown::render()`ed [html](https://stat.ethz.ch/~maechler/MEMo-pages/ch02.html).

  b0. Browse the  `?pvalues` help page (in the `lme4` package).

  b. The `lmerTest` package has an accompanying publication in JSS (Dec, 2017):
	  https://www.jstatsoft.org/article/view/v082i13

     from which we use the (slightly extended/modified) R code,
	 [lmerTest_v82i13.R](R/lmerTest_v82i13.R).

  - When can we trust the confidence intervals / P values ??
  - Profiled Likelihood - based intervals; profile pairs
  - Bootstrap -- non-iid?


### Part II:  Generalized LMM, e.g. for Count Data (Ecology)

  - Model formulation; likelihood approximations
  - The new `glmmTMB` package: Zero-inflation, hurdle models, etc


### Part III: GAMM (Generalized Additive), *Non*linear MM;  Robust Linear MM

