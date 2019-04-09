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
	 [Wikipedia Mixed_model](https://en.wikipedia.org/wiki/Mixed_model)

  e. Classical solution does not scale to large q (`q = ncol(Z)`)

  f. --> New approach to ML and REML


2. General Notation:  No "grouping" assumed --> general Z matrix

3. Inference: "No P values" vs `lmerTest` et al.

  a. `nlme` (book) chapter 2, notably 2.4
     R(markdown) script: [R/ch02.Rmd](R/ch02.Rmd),
     `rmarkdown::render()`ed [html](https://stat.ethz.ch/~maechler/MEMo-pages/ch02.html).

  b0. Browse the  `?pvalues` help page (in the `lme4` package).

  b. The `lmerTest` package has an accompanying publication in JSS (Dec, 2017):
  https://www.jstatsoft.org/article/view/v082i13

  from which we used the (slightly extended/modified) R code,
  [lmerTest_v82i13.R](R/lmerTest_v82i13.R) in 2018, and an extended
  help page example on `ham` tasting data,  [lmerTest-ham-ex.R](R/lmerTest-ham-ex.R) in 2019.

An extended version of JSS paper's Appendix A, is now available at Rune Christensen's [Satterthwaite_for_LMMs](http://htmlpreview.github.io/?https://github.com/runehaubo/lmerTestR/blob/master/pkg_notes/Satterthwaite_for_LMMs.html) -- [rendering correctly at MM's MEMo-pages](https://stat.ethz.ch/~maechler/MEMo-pages/Satterthwaite_for_LMMs.html) --
providing nice derivations on how the degrees of freedom are approximated.

  - When can we trust the confidence intervals / P values ??
  - Profiled Likelihood - based intervals; profile pairs
  - Bootstrap -- non-iid?

  c. _Random slopes_ : non-scalar random effects etc:  Ch. 3 of the lMMwR lecture notes,
		[lMMwR.pdf](https://stat.ethz.ch/~maechler/MEMo-pages/lMMwR.pdf);
	  R code: [ChLongitudinal.R](https://stat.ethz.ch/~maechler/MEMo-pages/ChLongitudinal.R).

### Part II:  Generalized LMM, e.g. for Count Data (Ecology)

  - Example (`contraceptive`) of logistic GLMM: Ch. 6 of the lMMwR lecture notes,
      [lMMwR.pdf](https://stat.ethz.ch/~maechler/MEMo-pages/lMMwR.pdf);
	  R code: [ChGLMMBinomial.R](https://stat.ethz.ch/~maechler/MEMo-pages/ChGLMMBinomial.R).

  - Likelihood for logistic GLMM
  - From binary Bernoulli to Binomial (number of 1's) via aggregation (assuming groups of identical `x_i`)

  - Intro to GLMs -- Springer Text
	[Peter K. Dunn and Gordon K. Smyth (2018) _Generalized Linear Models With Examples in R_](https://link.springer.com/book/10.1007/978-1-4419-0118-7), from Ch. 4.

  [downloadable from inside ETHZ](https://link.springer.com/content/pdf/10.1007%2F978-1-4419-0118-7.pdf)

  - Model formulation; likelihood approximations:
	- Laplace Approximation; generalized to Adaptive Gauss-Hermite (`nAGQ = .`)

  - The new `glmmTMB` package: Zero-inflation, hurdle models, etc


### Part III: *Non*linear MM (NLME)

  a. Motivation and Examples: `nlme` (book) chapter 6
     R(markdown) script: [R/ch06.Rmd](R/ch06.Rmd),
     `rmarkdown::render()`ed [html](https://stat.ethz.ch/~maechler/MEMo-pages/ch06.html).

b. Glimpses into theory: `nlme` (book) chapter 7

  c. Outlook into PK/PD modeling (pharmacology):  New R package
	[`nlmixr`](https://cran.R-project.org/package=nlmixr), incl.
	non-linear functions defined via differential equations (ODE).


### Not treated in lecture:

 - GAMM (Generalized Additive Mixed Models), e.g. `mgcv::gamm()` in R
 - Robust Linear MM, e.g., R package
 [`robustlmm`](https://cran.R-project.org/package=robustlmm)
