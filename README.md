# MFM5130-StatMeth-for-RM

Lecture notes and homework for **MFM5130 Statistical Methods for Risk Modelling** of CUHK-SZ.
Only the sources are tracked: built PDFs and TeX auxiliary files are git-ignored.

> **Maintainer note.** Inline and display math in this file is fine, but use only standard LaTeX
> commands. The macros defined in the preambles of the `.tex` files (the short risk-measure
> abbreviations, and the like) are undefined here and make the Markdown tooling raise a
> ParseError — spell such symbols out with `\mathrm{}` or in plain text instead.

## Repository layout

| Path | Role |
| --- | --- |
| `Lecture-01.tex` | Lecture notes for Lecture 1, *Basics of Quantitative Risk Management* (Yang Liu, Fall 2026): a typeset summary of the slides in which every computation that the slides left to the board ("white board") and every sketched proof is written out, flagged in the PDF under **Derivation (…)**. Compiles to `Lecture-01.pdf`. |
| `hw1.tex` | Homework 1 solutions (10 pages): seven problems on the coherence axioms of VaR/ES, the ES representations, the normal, Student-$t$ and Pareto tail limits, heavy-tailedness with a VaR superadditivity counterexample, and the 100-bond skewness example. Uses `MFM-hw.cls`. |
| `hw2.tex` | Homework 2 solutions (17 pages): ten problems on the multivariate normal (characteristic function, conditional law, unbiasedness of the sample mean and covariance, Bernoulli and normal MLEs, multivariate moment estimation), the variance-mixture and spherical/elliptical families, and elliptical portfolio risk ($\mathrm{VaR}$ subadditivity, equal-density contours, advantages and limitations). Includes one TikZ figure. Uses `MFM-hw.cls`. |
| `MFM-hw.cls` | Homework document class: title block, problem and subproblem counters/macros, page headers. |
| `Makefile` | Build driver: `make Lecture-01.pdf`, `make hw1.pdf`, `make hw2.pdf`, `make all`, `make clean-all`. |

Naming scheme for what comes next: `Lecture-MM.tex` for the following lectures, and homework under
`HW/hwM.tex`, which is what the Makefile rules expect.

## Building

TeX only — `pdflatex` plus the standard packages `amsmath`, `amssymb`, `amsthm`, `bbm`,
`booktabs`, `array`, `enumitem`, `hyperref`.

### Recommended

```sh
latexmk -pdf Lecture-01.tex     # runs pdflatex as often as needed (ToC, cross-references)
latexmk -pdf hw1.tex
latexmk -pdf hw2.tex
```

Equivalent by hand; two passes are required because of `\tableofcontents` and because the
equations, propositions and examples are cross-referenced by label:

```sh
pdflatex Lecture-01.tex && pdflatex Lecture-01.tex
```

Result: a 17-page `Lecture-01.pdf` with no unresolved references.

### Via the Makefile

```sh
make                     # the default target, the same as `make all`
make Lecture-01.pdf      # the same as: make Lecture-01
make hw1.pdf
make hw2.pdf
make all                 # every source listed in LectureNums / HWNums
make clean-cache         # removes *.aux *.log *.out *.toc
make clean-pdf           # removes *.pdf
make clean-all           # both of the above
```

How the rules behave (verified with `make clean-all && make all`):

* Lecture targets get **two** `pdflatex` passes, so the table of contents and all the
  equation/proposition/example labels resolve: `Lecture-01.pdf` comes out 17 pages with no
  unresolved references. `clean-cache` then removes the auxiliary files.
* Homework targets also get **two** `pdflatex` passes (`hw2.tex` cross-references its own numbered
  equations), and accept `hwM.tex` in the repository root *or* in `HW/` — the rule relies on
  `VPATH` and exports `TEXINPUTS`, so the document class is found in both layouts and `hwM.pdf`
  is written to the repository root either way.
* `make clean-pdf` removes only the built documents (`Lecture-*.pdf`, `hw*.pdf`), so the assignment
  PDFs kept in the repository root survive it.
* `LectureNums := 01 02` and `HWNums := 1 2` remain the list of record, but a number without a
  source is skipped with a `no source found` warning instead of breaking the build, so `make all`
  still works with only the sources that are present.

## Lecture 1 — what is covered

1. **QRM and market risk** — risk as a random variable on $(\Omega,\mathcal{F},\mathbb{P})$, the
   portfolio value mapping $V_t=f(t,\mathbf{Z}_t)$, risk factors and risk-factor changes, the P&L
   variable $L_{t+1}=-(V_{t+1}-v_t)$, the loss operator, conditional vs. unconditional loss
   distributions.
2. **Linearization** — first-order Taylor expansion of the loss operator, the linearized loss
   $L^{\Delta}_{t+1}$, the linear stock-portfolio example, and the Black–Scholes example with the
   Greeks (delta, theta, rho, vega).
3. **Risk measures** — factor sensitivity / scenario / loss-distribution based measures; the four
   axioms of coherence (Artzner et al. 1999); the scenario representation
   $\rho_{\mathcal{P}}(L)=\sup_{P\in\mathcal{P}}\mathbb{E}^{P}[L]$, and Proposition 1.7
   (existence/uniqueness); generalized inverses / quantile functions $F^{\leftarrow}$.
4. **VaR and ES** — definitions,
   $\mathrm{ES}_\alpha(L)=\mathbb{E}[L\mid L\ge\mathrm{VaR}_\alpha(L)]$ for continuous loss
   distributions, the practical levels $(\alpha,T)$, and Exercise 1.12 for the normal, Pareto and
   Student-$t$ cases (including the limit of $\mathrm{ES}_\alpha/\mathrm{VaR}_\alpha$ as
   $\alpha\uparrow1$).
5. **Heavy tails** — the MGF-based definition, Pareto / Cauchy / Student-$t$, moment conditions,
   the comparison table of tail decay, applications.
6. **Coherence and subadditivity** — ES is coherent (Prop. 6.9 in MFE 2015); VaR is not
   subadditive, with three counterexamples worked out in full: iid Pareto with infinite mean, iid
   $\mathrm{Exp}(1)$ (superadditive for $\alpha\lesssim0.715$), and the 100-bond skewness example
   (superadditivity iff $(1-p)^n<\alpha\le1-p$). VaR *is* subadditive in the (multivariate)
   normal / elliptical world.

## Homework 1 — what it contains

`hw1.tex` solves seven problems, all on VaR/ES and heavy tails. Throughout, $q=F_L^{\leftarrow}(\alpha)$
denotes the $\alpha$-quantile of the loss and $\overline{F}_L$ the survival function.

| # | Problem | Key results |
| --- | --- | --- |
| 1 | Show that $\mathrm{VaR}_t$ and $\mathrm{ES}_t$ satisfy the three "easy" coherence axioms | Monotonicity (via $\{X_2\le x\}\cap N^c\subseteq\{X_1\le x\}$ and the infimum over a larger set), cash-additivity ($\mathrm{VaR}_t(X+l)=\mathrm{VaR}_t(X)+l$, then the same for the average of quantiles) and positive homogeneity ($\lambda>0$). |
| 2 | Two integral representations of ES and their continuous case | $\mathrm{ES}_\alpha(L)=\mathbb{E}\big[(L-q)_+\big]/(1-\alpha)+q$ and $\mathrm{ES}_\alpha(L)=\big[\mathbb{E}(L\mathbf{1}_{\{L>q\}})+q\big(1-\alpha-\overline{F}_L(q)\big)\big]/(1-\alpha)$; if $F_L$ is continuous at $q$ this collapses to $\mathbb{E}(L\mathbf{1}_{\{L>q\}})/(1-\alpha)$. Proved with a quantile lemma: $F_Y(y)\ge u\iff y\ge F_Y^{\leftarrow}(u)$, $F_Y\big(F_Y^{\leftarrow}(u)\big)\ge u$ and $\mathbb{E}(Y)=\int_0^1F_Y^{\leftarrow}(u)\,\mathrm{d}u$ (via the inverse-transform construction $F_Y^{\leftarrow}(U)\overset{d}{=}Y$). |
| 3 | Normal case, $L\sim\mathrm{N}(\mu,\sigma^2)$ | $\mathrm{VaR}_\alpha(L)=\mu+\sigma\Phi^{-1}(\alpha)$; $\mathrm{ES}_\alpha(L)=\mu+\sigma\varphi(\Phi^{-1}(\alpha))/(1-\alpha)$ (using $z\varphi(z)=-\varphi'(z)$); $\mathrm{ES}_\alpha/\mathrm{VaR}_\alpha\to1$ as $\alpha\uparrow1$ by Mills' ratio. |
| 4 | Student-$t$ tail, $L\sim t_\nu$ | $1-F_L(x)\sim cx^{-\nu}$ with $c=\Gamma\big(\tfrac{\nu+1}{2}\big)\nu^{(\nu-1)/2}\big/\big(\sqrt{\nu\pi}\,\Gamma(\tfrac{\nu}{2})\big)$ by l'Hôpital, and then $\mathrm{ES}_\alpha/\mathrm{VaR}_\alpha\to\nu/(\nu-1)>1$. |
| 5 | Pareto, $L\sim\mathrm{Par}(1/\xi)$, $0<\xi<1$ | $F_L(\ell)=1-\ell^{-1/\xi}$ for $\ell\ge1$, hence $\mathrm{VaR}_\alpha(L)=(1-\alpha)^{-\xi}$ and $\mathrm{ES}_\alpha(L)=\mathrm{VaR}_\alpha(L)/(1-\xi)$, so the ratio is the constant $1/(1-\xi)>1$. |
| 6 | Heavy-tailedness, $L_1,L_2$ iid with $\mathbb{P}(L_1>x)=x^{-1/2}$, $x\ge1$ | $\mathbb{E}(L_1)=\infty$ (the density is $\tfrac12x^{-3/2}$); the MGF is infinite for every $t>0$; the exact two-variable tail $\mathbb{P}(L_1+L_2>x)=2\sqrt{x-1}/x$ for $x\ge2$ (computed with the substitution $u=x\sin^2\theta$); hence VaR is superadditive: with $q=(1-\alpha)^{-2}$ one gets $\mathrm{VaR}_\alpha(L_1+L_2)=2\big(1+\sqrt{2\alpha-\alpha^2}\big)/(1-\alpha)^2>2q$. |
| 7 | Skewness: 100 independent bonds, loss $-2$ with probability $0.99$ and $100$ with probability $0.01$ | Both strategies have expected loss $-98$; with $D\sim\mathrm{B}(100,0.01)$ defaults, $\mathcal{P}_1=102D-200$ gives $\mathrm{VaR}_{0.95}(\mathcal{P}_1)=106$ (CDF table for $D=0,\dots,4$: $0.366032$, $0.735762$, $0.920627$, $0.981626$, $0.996568$), while the concentrated portfolio $\mathcal{P}_2=100L_1$ gives $\mathrm{VaR}_{0.95}(\mathcal{P}_2)=-200$. VaR therefore ranks the concentrated portfolio as the safer one even though it carries a $1\%$ chance of a $10{,}000$ loss — the skewness face of the failure of subadditivity. |

## Homework 2 — what it contains

`hw2.tex` solves ten problems on the multivariate normal, estimation, and the spherical/elliptical
families (17 pages, one TikZ figure). The assignment (`MFM5130-Assignment2.pdf`) is not tracked.

| # | Problem | Key results |
| --- | --- | --- |
| 1 | Characteristic function of $\mathrm{N}_d(\mu,\Sigma)$ | $\phi_X(t)=\exp(i t^\top\mu-\tfrac12 t^\top\Sigma t)$ from $\mathbb{E}[e^{isZ_1}]=e^{-s^2/2}$. The one-dimensional factor is obtained by completing the square, $isx-x^2/2=-(x-is)^2/2-s^2/2$, and shifting the contour to $\operatorname{Im}z=-s$ (legitimate by Cauchy's theorem, since $\lvert e^{-z^2/2}\rvert=e^{-(x^2-y^2)/2}$ is uniformly integrable in $x$ on the strip). Consequences recorded: the law depends on $A$ only through $AA^\top$, so $\mathrm{N}_d(\mu,\Sigma)$ is unambiguous, and every positive semidefinite $\Sigma$ is admissible (spectral factor $A=U\Lambda^{1/2}$). |
| 2 | Conditional law $\mathrm{N}_{d-k}(\mu_{2.1},\Sigma_{22.1})$ | Block-triangular $T=\begin{pmatrix}I&0\\-\Sigma_{21}\Sigma_{11}^{-1}&I\end{pmatrix}$ gives $T\Sigma T^\top=\operatorname{diag}(\Sigma_{11},\Sigma_{22.1})$, so $U=X_1$ and $V=X_2-\Sigma_{21}\Sigma_{11}^{-1}X_1$ are **independent**; the conditional law follows from $X_2=V+\Sigma_{21}\Sigma_{11}^{-1}x_1$. Also proved: $\Sigma_{11}\succ0$ and $\Sigma_{22.1}\succ0$ (Schur complement), a density cross-check via $\lvert\Sigma\rvert=\lvert\Sigma_{11}\rvert\lvert\Sigma_{22.1}\rvert$ and the block inverse, and the regression reading ($\Sigma_{21}\Sigma_{11}^{-1}$ is the population beta; the residual is independent of the regressor — a Gaussian property). |
| 3 | Unbiasedness of $\hat\mu=\bar X$ and $\hat\Sigma$ | $\mathbb{E}[\bar X]=\mu$; the identity $\sum_i(X_i-\bar X)(X_i-\bar X)^\top=\sum_i(X_i-\mu)(X_i-\mu)^\top-n(\bar X-\mu)(\bar X-\mu)^\top$ has expectation $n\Sigma-\Sigma=(n-1)\Sigma$, so the divisor $n-1$ is exactly what unbiasedness requires. The MLE $\frac{n-1}{n}\hat\Sigma$ is biased downwards. |
| 4 | MLE for $\mathrm{Bernoulli}(p)$ | $\hat p=s/n=\bar X$ from $s/p=(n-s)/(1-p)$, with $\ell''(p)<0$ (strict concavity). Boundary cases discussed: for $s=0$ or $s=n$ the supremum on the open parameter set $(0,1)$ is not attained and the formula is the MLE on $[0,1]$. $\hat p$ is unbiased and attains the Cramér–Rao bound, $\operatorname{Var}(\hat p)=1/(nI(p))$ with $I(p)=1/(p(1-p))$. |
| 5 | MLE for $\mathrm{N}(\mu,\sigma^2)$ | $\hat\mu=\bar x$, $\hat\sigma^2=\frac1n\sum_i(x_i-\bar x)^2$; global maximality from $\log t+1/t\ge1$ applied to $t=\sigma^2/\hat\sigma^2$, which bounds $\ell$ by $-\frac n2(\log2\pi+\log\hat\sigma^2+1)$ with equality iff $(\mu,\sigma^2)=(\bar x,\hat\sigma^2)$. Degenerate sample $x_1=\dots=x_n$: likelihood unbounded, no interior MLE. |
| 6 | Estimation of multivariate moments (5 observations) | $\bar x=(0.006,0.006)^\top$; $\hat\Sigma_{\text{MLE}}=\begin{pmatrix}3.44&3.24\\3.24&5.84\end{pmatrix}10^{-4}$; $S=\begin{pmatrix}4.30&4.05\\4.05&7.30\end{pmatrix}10^{-4}=\frac54\hat\Sigma_{\text{MLE}}$; $\hat\rho=4.05/\sqrt{4.30\cdot7.30}\approx0.7229>0$; for $L=0.6Y_1+0.4Y_2$, $\widehat{\mathbb{E}[L]}=0.006$ and $\widehat{\operatorname{Var}(L)}=4.66\times10^{-4}$ (s.d. $\approx0.0216$), *above* the weighted average $2.716\times10^{-4}$ of the two variances — the effect of the positive covariance. $S$ verified positive definite three ways (Gram form $\tfrac14\sum_i(d_i^\top u)^2$, Sylvester: $S_{11}>0$, $\det S=14.9875\times10^{-8}>0$, eigenvalues $(10.12,1.48)\times10^{-4}$). General proof: $a^\top\Sigma a=\operatorname{Var}(a^\top X)\ge0$. |
| 7 | Variance mixtures: $Y=BX+b$ | $Y\sim M_k(B\mu+b,B\Sigma B^\top,\hat H)$ by acting on the factor, $\tilde A=BA$ with $\tilde A\tilde A^\top=B\Sigma B^\top$; no invertibility needed. The mixing law $\hat H$ is invariant, so the tail index is common to all linear portfolios; closure holds under linear maps but **not** under addition of independent heterogeneous factors. Generator $\psi(u)=\int e^{-uw/2}\,\mathrm{d}\hat H(w)$. |
| 8 | Spherical: (a) $\Leftrightarrow$ (b) $\Leftrightarrow$ (c) | Lemma: spherical $\Leftrightarrow$ $Y\overset{d}{=}OY$ for all orthogonal $O$ (the “$\Leftarrow$” direction uses uniqueness of the rotation-invariant probability measure on $\mathbb{S}^{d-1}$). Then $t^\top S\overset{d}{=}\lVert t\rVert S_1$ gives $\phi_Y(t)=\psi(\lVert t\rVert)$ with $\psi(x)=\mathbb{E}[\varphi_0(Rx)]$; (b)$\Rightarrow$(c) is $\phi_{a^\top Y}(s)=\psi(\lvert s\rvert\lVert a\rVert)$; (c)$\Rightarrow$(a) is the Cramér–Wold device. $\psi$ is real (since $S\overset{d}{=}-S$), $\psi(0)=1$; examples: $\cos x$ ($d=1$, every symmetric univariate law), $e^{-x^2/2}$ (normal, $R\sim\chi_d$), $J_0$ (Bessel, $d=2$); $\mathbb{E}[YY^\top]=\frac{\mathbb{E}[R^2]}{d}I_d$. |
| 9 | Elliptical marginals | $\phi_{X_1}(s)=\phi_X((s,0))=e^{is^\top\mu_1}\psi(s^\top\Sigma_{11}s)$, i.e. $\mathrm{E}_k(\mu_1,\Sigma_{11},\psi)$ with the **same** generator; representation proof via the first $k$ rows of $A$. Remark: the converse fails — elliptical marginals need not be jointly elliptical (density $\varphi(x_1)\varphi(x_2)(1+c(x_1^2-1)(x_2^2-1))$ has normal marginals, is uncorrelated but dependent, and is not elliptical). |
| 10 | Elliptical portfolio risk | (a) $a^\top X\sim\mathrm{E}_1(a^\top\mu,a^\top\Sigma a,\psi)$ via $(A^\top a)^\top S\overset{d}{=}\lVert A^\top a\rVert S_1$. (b) $f_X(x)=\lvert\Sigma\rvert^{-1/2}g((x-\mu)^\top\Sigma^{-1}(x-\mu))$ with $g(u)=(2\pi)^{-d/2}\int r^{-d}e^{-u/(2r^2)}\,\mathrm{d}\hat H(r)$, so the equal-density contours are homothetic ellipsoids centred at $\mu$, with axes the eigenvectors of $\Sigma$ and semi-axes $\sqrt{u_c\lambda_j}$ (TikZ figure). (c) $\mathrm{VaR}_\alpha(L_i)=\lambda_i^\top\mu+\sqrt{\lambda_i^\top\Sigma\lambda_i}\,q_\alpha$. (d) For $\alpha\ge\tfrac12$, $q_\alpha\ge0$ and $\lVert\Sigma^{1/2}\lambda\rVert\le\sum_i\lVert\Sigma^{1/2}\lambda_i\rVert$ give $\mathrm{VaR}_\alpha(\sum_iL_i)\le\sum_i\mathrm{VaR}_\alpha(L_i)$; equality iff the $\Sigma^{1/2}\lambda_i$ are parallel and equally oriented, and for $\alpha<\tfrac12$ the inequality reverses. (e) Two advantages (closure with closed-form VaR and Euler risk budgeting, and the same mean–variance frontier for every finite-variance elliptical law; parsimony with tail flexibility through $\psi$) and two limitations (symmetry, hence no skewness; a single common mixing variable, hence no idiosyncratic tail and no tail diversification). |

## Note on the derivations

`Lecture-01.tex` deliberately does more than the slides: the white-board steps are filled in and,
where a slide only quotes a result, the computation is given. Examples:

* ES as a tail expectation (change of variables $u=F_L(x)$, plus the conditional-expectation step,
  including the atom case, where $\mathrm{ES}_\alpha$ exceeds
  $\mathbb{E}[L\mid L\ge\mathrm{VaR}_\alpha]$);
* the three Exercise 1.12 limits, including the general regular-variation computation
  $\lim_{\alpha\uparrow1}\mathrm{ES}_\alpha/\mathrm{VaR}_\alpha=1/(1-\xi)$, which yields
  $1/(1-\xi)$ for the Pareto $\mathrm{Par}(1/\xi)$ and $\nu/(\nu-1)$ for the Student-$t$ with
  $\nu$ degrees of freedom (here $\xi=1/\nu$), and Mills' ratio for the normal case (limit $1$);
* the exact tail of a sum of two iid $\mathrm{Par}(1/2)$ variables,
  $\mathbb{P}(L_1+L_2>x)=2\sqrt{x-1}/x$ for $x\ge2$ (the slide's $2x^{-1/2}-1/x$ is only its
  leading-order form; the exact formula reduces to $1$ at $x=2$, as it must, and was checked by
  Monte Carlo);
* the threshold $\alpha^{\ast}=1-e^{-t^{\ast}}\approx0.7153$, where $t^{\ast}$ solves
  $e^{t}=1+2t$, for VaR superadditivity of iid $\mathrm{Exp}(1)$;
* the cancellation of coupon and nominal value in the bond example and the exact equivalence
  "superadditivity iff $(1-p)^n<\alpha\le1-p$", with
  $\mathrm{VaR}_{0.95}\big(\sum_i L_i\big)=106$,
  $\mathrm{VaR}_{0.99}\big(\sum_i L_i\big)=208$ and $\mathrm{VaR}_\alpha(100L_1)=-200$ for
  $\alpha\le0.99$ (then $10000$).
