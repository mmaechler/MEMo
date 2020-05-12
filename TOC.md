# Mixed Models := ((--| generalized | non-) Linear | Generalized Additive) Mixed-Effects Models
### i.e., LMM, GLMM, NLMM. GAMM

## Table of Contents -- Lectures

### Part I:  Linear MM

1. Introduction - 1- and 2-way ANOVA and beyond

#### 'The' `nlme` book: Pinheiro, J.C., and Bates, D.M. (2000) *Mixed-Effects Models in S and S-PLUS*, Springer.
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
  - 2020: COVID-19 pandemic: News: [**Air pollution linked with higher COVID-19 death rates**](https://www.hsph.harvard.edu/news/hsph-in-the-news/air-pollution-linked-with-higher-covid-19-death-rates/) study from Harvard School of Public Health; e.g. [New York Times, April 7](https://www.nytimes.com/2020/04/07/climate/air-pollution-coronavirus-covid.html).
 Harvard publication, updated several times; latest of April 24): <https://projects.iq.harvard.edu/covid-pm>.  That page
       - mentions that everything is reproducible available on <https://github.com/wxwx1993/PM_COVID> , and  asks to cite

        Exposure to air pollution and COVID-19 mortality in the United States.
	Xiao Wu, Rachel C. Nethery, Benjamin M. Sabath, Danielle Braun, Francesca Dominici.
	medRxiv 2020.04.05.20054502; https://doi.org/10.1101/2020.04.05.20054502

      - I have forked the **R** code for the Generalized Linear Mixed Model (GLMM) which is their model to
	<https://github.com/mmaechler/PM_COVID> in order to add more.



  - Somewhat gentle introduction to GLMs -- Springer Text
	[Peter K. Dunn and Gordon K. Smyth (2018) _Generalized Linear Models With Examples in R_](https://link.springer.com/book/10.1007/978-1-4419-0118-7), from Ch. 4,
  [downloadable from inside ETHZ](https://link.springer.com/content/pdf/10.1007%2F978-1-4419-0118-7.pdf).

  - Modeling Count Data (by GLMs), including Hurdle and Zero-Inflation Models:
	_Regression Models for Count Data in R_ vignette `countreg` from CRAN package
	[`pscl`](https://cran.r-project.org/package=pscl), slightly commented
	by MM, as
	[Rnw](https://stat.ethz.ch/~maechler/MEMo-pages/countreg.Rnw),  and
	[pdf](https://stat.ethz.ch/~maechler/MEMo-pages/countreg.pdf).

  - Model formulation; likelihood approximations:
	- Laplace Approximation; generalized to Adaptive Gauss-Hermite
      Quadrature (=: AGQ) (in R, `glmer(*,  nAGQ = k)`).

    - CRAN package [`GLMMadaptive`](https://cran.r-project.org/package=GLMMadaptive)
      promising special emphasis on AGQ.
	  We use its _GLMMadaptive Basics_ vignette, extended by MM.
	  Get the Rmarkdown source
	  [Rmd](https://stat.ethz.ch/~maechler/MEMo-pages/GLMMadaptive_basics_MM.Rnw), or R script,
		[R](https://stat.ethz.ch/~maechler/MEMo-pages/GLMMadaptive_basics_MM.R),  and rendered
      [pdf](https://stat.ethz.ch/~maechler/MEMo-pages/GLMMadaptive_basics_MM.pdf).

  - (Outlook only:) CRAN package [`glmmTMB`](https://cran.r-project.org/package=glmmTMB):
    Zero-inflation, hurdle models, etc; fast algorithms via automatic differentiation numerics
    (`TMB` = Template Model Builder).  
  Two examples, comparison with other R pkgs in
  [R journal paper](https://journal.r-project.org/archive/2017/RJ-2017-066/)

### Part III: *Non*linear MM (NLME)

  a. Motivation and Examples: `nlme` (book) chapter 6
     R(markdown) script: [R/ch06.Rmd](R/ch06.Rmd),
     `rmarkdown::render()`ed [html](https://stat.ethz.ch/~maechler/MEMo-pages/ch06.html).

  b. Glimpses into theory: `nlme` (book) chapter 7 (handouts of p.306--309)

  c. Outlook into PK/PD modeling (pharmacology):  New R package
	[`nlmixr`](https://cran.R-project.org/package=nlmixr), incl.
	non-linear functions defined via differential equations (ODE).

  d. *N*on-*l*inear *M*ixed-*E*ffects (NLME): `nlme` (book) chapter 8, adapted R(markdown)
     script: [R/ch08.Rmd](R/ch08.Rmd),
     `rmarkdown::render()`ed [html](https://stat.ethz.ch/~maechler/MEMo-pages/ch08.html).


### Not treated in lecture:

 - GAMM (Generalized Additive Mixed Models), e.g. `mgcv::gamm()` in R
 - Robust Linear MM, e.g., R package
 [`robustlmm`](https://cran.R-project.org/package=robustlmm)
