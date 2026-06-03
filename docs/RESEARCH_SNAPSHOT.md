# Research Snapshot

This snapshot provides a concise public view of the RB XAU/USD MT5 research state. It is designed for GitHub readers who want the high-level evidence without exposing private reports, real presets or production parameters.

## What Was Tested

| Area | Public Summary |
|---|---|
| Asset | XAUUSD / Gold |
| Platform | MetaTrader 5 |
| Source language | MQL5 |
| Main method | Expert Advisor backtesting |
| Primary comparison | Aggressive, controlled, conservative and alternative baseline profiles |
| Risk focus | Drawdown, profit factor, return preservation and trade count |
| Publication mode | Source-only public export |

## Sanitized Baseline Snapshot

| Profile | Role | Period | Return | PF | DD | Trades | Public Decision |
|---|---|---:|---:|---:|---:|---:|---|
| Aggressive baseline | Main high-return research baseline | 2016-05-20 to 2026-05-20 | +662.06% | 2.50 | 39.90% | 54 | Protected for comparison |
| Controlled baseline | Lower-risk comparison baseline | 2016-05-20 to 2026-05-20 | +273.43% | 2.18 | 31.56% | 49 | Protected for comparison |
| Conservative baseline | Defensive comparison profile | 2016-05-20 to 2026-05-20 | +7.89% | 4.63 | 0.73% | 10 | Protected as conservative reference |
| Alternative baseline | Candidate under observation | 2016-05-20 to 2026-05-20 | +348.76% | 2.18 | 40.39% | 52 | Not promoted |

## What Looked Promising

- The aggressive baseline delivered the strongest historical return in the protected research snapshot.
- The controlled baseline reduced drawdown but also reduced return.
- DD-efficiency diagnostics showed that risk filters can improve theoretical return adjusted to a target drawdown, but the tested variants were not promoted.
- The main research problem is not simply reducing drawdown; it is reducing drawdown without destroying the years that carried most of the edge.

## What Was Not Promoted

- A lower-DD audit profile was not promoted because it reduced exposure and return too much.
- Several experimental DD filters were not promoted because they damaged the strongest later-period capture.
- No experimental filter replaced the protected baselines.

## Artifacts Protected Outside This Repository

The following remain outside the public repository:

- real `.set` presets;
- raw MT5 HTML/XML reports;
- logs and local caches;
- optimization outputs;
- broker exports;
- account data;
- private source-history mapping;
- production parameters.

## Public Artifacts

The public repository contains:

- GPL-3.0-only source code;
- methodology documentation;
- architecture documentation;
- risk disclosure;
- validation limits;
- sanitized example inputs;
- this public research snapshot.

## What Still Needs Validation

Before any operational conclusion, the research still needs:

- out-of-sample testing;
- walk-forward validation;
- Monte Carlo stress;
- spread/slippage/cost stress;
- multi-feed comparison where possible;
- demo forward testing;
- review of failure modes in weak regimes;
- independent code and methodology review.

## Bottom Line

RB XAU/USD MT5 is a public research artifact, not a profit claim. The historical snapshot is interesting enough to justify further validation, but it is not sufficient to claim robustness, live-readiness or future profitability.
