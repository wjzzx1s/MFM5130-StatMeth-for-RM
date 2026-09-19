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
| `MFM-hw.cls` | Homework document class: title block, problem and subproblem counters/macros, page headers. |
| `Makefile` | Build driver: `make Lecture-01.pdf`, `make hw1.pdf`, `make all`, `make clean-all`. |

Naming scheme for what comes next: `Lecture-MM.tex` for the following lectures, and homework under
`HW/hwM.tex`, which is what the Makefile rules expect.

## Building

TeX only — `pdflatex` plus the standard packages `amsmath`, `amssymb`, `amsthm`, `bbm`,
`booktabs`, `array`, `enumitem`, `hyperref`.

### Recommended

```sh
latexmk -pdf Lecture-01.tex     # runs pdflatex as often as needed (ToC, cross-references)
latexmk -pdf hw1.tex
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
make all                 # every source listed in LectureNums / HWNums
make clean-cache         # removes *.aux *.log *.out *.toc
make clean-pdf           # removes *.pdf
make clean-all           # both of the above
```

How the rules behave (verified with `make clean-all && make all`):

* Lecture targets get **two** `pdflatex` passes, so the table of contents and all the
  equation/proposition/example labels resolve: `Lecture-01.pdf` comes out 17 pages with no
  unresolved references. `clean-cache` then removes the auxiliary files.
* Homework targets accept `hwM.tex` in the repository root *or* in `HW/` — the rule relies on
  `VPATH` and exports `TEXINPUTS`, so the document class is found in both layouts and `hwM.pdf`
  is written to the repository root either way.
* `LectureNums := 01 02` and `HWNums := 1` remain the list of record, but a number without a
  source is skipped with a `no source found` warning instead of breaking the build, so `make all`
  already works with only `Lecture-01.tex` present.

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
