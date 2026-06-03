# Backtest Research Summary

This document summarizes the public, sanitized backtest context behind RB XAU/USD MT5. It publishes aggregated metrics and methodology only. It does not publish raw MT5 reports, real `.set` presets, broker exports, account data, local paths or production parameters.

## Research Scope

The research scope is gold/XAUUSD systematic testing in MetaTrader 5 using MQL5 Expert Advisor logic. The work focused on comparing historical profiles, preserving baselines and identifying risk-control directions without overstating what backtests can prove.

The public repository is source-only. It is designed for code review and methodology review, not for copying a private production setup.

## Public Backtest Highlights

| Research item | Public summary | Safety boundary |
|---|---|---|
| Symbol | XAUUSD / Gold | No broker or account metadata |
| Platform | MetaTrader 5 Strategy Tester | No raw reports distributed |
| Horizon | Multi-year historical testing | Aggregated periods only |
| Validation focus | Return, profit factor, drawdown, trade count | No real presets |
| Risk direction | Drawdown control without destroying trend capture | No production parameters |

Aggregated baseline metrics:

| Test Set | Period | Symbol | Trades | Historical Backtest Return | Profit Factor | Drawdown | Public Status |
|---|---:|---|---:|---:|---:|---:|---|
| Aggressive baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 54 | +662.06% | 2.50 | 39.90% | Protected research baseline |
| Controlled baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 49 | +273.43% | 2.18 | 31.56% | Protected comparison |
| Conservative baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 10 | +7.89% | 4.63 | 0.73% | Defensive comparison |
| Alternative baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 52 | +348.76% | 2.18 | 40.39% | Not promoted |

Buy-and-hold context from aggregated research notes:

| Period | Gold Buy-And-Hold | Aggressive Baseline | Controlled Baseline | Alternative Baseline |
|---|---:|---:|---:|---:|
| 3y | +126.83% | +505.51% | +309.26% | +410.68% |
| 5y | +139.86% | +247.76% | +137.08% | +262.19% |
| 10y | +257.40% | +662.06% | +273.43% | +348.76% |

This comparison is historical only and does not account for all live execution, financing, tax, margin, liquidity or behavioral constraints.

## What The Research Suggests

- XAUUSD trend regimes can dominate long-horizon backtest outcomes.
- Risk-control choices materially change return and drawdown.
- Lower drawdown is not automatically better if it destroys the main trend capture.
- Some historical profiles were promising enough to preserve as baselines for further validation.
- Future work should focus on robustness, out-of-sample testing and failure-mode analysis.

## What The Research Does Not Prove

The research does not prove:

- future profitability;
- readiness for live trading;
- robustness across brokers, feeds or execution conditions;
- suitability for any specific account size;
- that public defaults reproduce private research metrics;
- that historical edge will persist.

## Why Raw Reports Are Not Included

Raw MT5 reports are intentionally excluded because they can contain or imply:

- broker/feed metadata;
- account or environment details;
- local file paths;
- exact preset behavior;
- execution assumptions that could be misused;
- private research context not needed for public code review.

The public repository publishes source code and sanitized summaries only.

## Validation Limits

Known limitations:

- low trade count can make statistics fragile;
- historical tests can overfit;
- Strategy Tester depends on data quality and modeling assumptions;
- spread, slippage, commission, swap and liquidity can materially change outcomes;
- gold can gap or reprice abruptly;
- private presets and raw reports are not distributed, so this repository is not a turnkey reproduction package.

## Next Validation Steps

Recommended technical next steps:

1. Re-run tests from a clean MT5 environment.
2. Add out-of-sample validation.
3. Run walk-forward validation.
4. Run Monte Carlo stress tests.
5. Stress spread, slippage, commission and swap assumptions.
6. Compare multiple data feeds where practical.
7. Continue publishing only sanitized summaries.
