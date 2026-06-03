# Backtest Research Summary

This document summarizes the public, sanitized research context behind RB XAU/USD MT5. It is intentionally limited to aggregated metrics and methodology. It does not include raw Strategy Tester reports, real `.set` presets, optimization grids, broker exports, account data or production parameters.

## Research Scope

The private research workflow focused on gold/XAUUSD systematic testing in MetaTrader 5. The goal was not to produce a guaranteed trading system, but to compare rule-based Expert Advisor variants under repeatable backtest conditions and preserve the most useful baselines for further validation.

The public export keeps the source code and methodology visible while excluding private operational artifacts.

## Test Environment

| Item | Public Summary |
|---|---|
| Platform | MetaTrader 5 |
| Language | MQL5 |
| Symbol | XAUUSD / Gold |
| Primary timeframe | M1 |
| Report type | Aggregated metrics only |
| Raw reports | Not distributed |
| Real presets | Not distributed |
| Broker/account details | Not distributed |
| Compiled binaries | Not distributed |

## Backtest Highlights

The following metrics were copied from internal checkpoint documentation as aggregated research results. They are published to show the research direction, not to advertise performance or provide production-ready settings.

| Research Set | Period | Symbol | Trades | Net Result | Profit Factor | Max Drawdown | Win Rate | Status |
|---|---:|---|---:|---:|---:|---:|---:|---|
| Aggressive baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 54 | +662.06% | 2.50 | 39.90% | 51.85% | Protected baseline |
| Controlled baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 49 | +273.43% | 2.18 | 31.56% | Not published | Protected baseline |
| Conservative baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 10 | +7.89% | 4.63 | 0.73% | Not published | Protected comparison |
| Alternative baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 52 | +348.76% | 2.18 | 40.39% | Not published | Observation only |

## Buy-And-Hold Context

The private checkpoint also compared the research baselines with a simple gold buy-and-hold reference using aggregated MT5-derived price movement.

| Period | Gold Buy-And-Hold | Aggressive Baseline | Controlled Baseline | Alternative Baseline | Winner In This Snapshot |
|---|---:|---:|---:|---:|---|
| 3y | +126.83% | +505.51% | +309.26% | +410.68% | Aggressive baseline |
| 5y | +139.86% | +247.76% | +137.08% | +262.19% | Alternative baseline |
| 10y | +257.40% | +662.06% | +273.43% | +348.76% | Aggressive baseline |

This comparison is only a historical reference. It does not account for all execution, financing, tax, margin, liquidity or behavioral constraints.

## Protected Baselines / Source Hash Context

The private lab preserves source fingerprints and experiment notes for internal integrity control. The public repository does not publish the complete protected-source mapping because it could expose unnecessary private research structure.

Public source integrity:

| File | SHA256 |
|---|---|
| `src/RB_XAUUSD_MT5.mq5` | `ED85830CA2D91D5628D4B26FEFDD25C31056D3054FE980F62A9B970AA65A28DA` |

Private presets, raw reports, logs and caches remain outside this repository.

## Interpretation

The research suggests that the EA family can produce materially different profiles depending on risk controls and configuration:

- the aggressive profile captured strong historical gold trends but accepted high drawdown;
- the controlled profile reduced return and drawdown but did not eliminate risk;
- the conservative profile was much more defensive but had low return;
- the alternative profile remained interesting but was not promoted as a primary baseline.

The strongest historical return also came with concentrated exposure and relatively low trade count. That makes further validation necessary before any operational conclusion.

## What The Results Suggest

- Gold/XAUUSD trend regimes can dominate long-horizon performance.
- Risk controls materially change the return/drawdown profile.
- Lower drawdown is not automatically better if it destroys the main trend capture.
- A useful next research stage should focus on preserving strong trend years while reducing weak-regime losses.

## What The Results Do Not Prove

These results do not prove:

- future profitability;
- live execution quality;
- robustness across brokers or feeds;
- robustness across all market regimes;
- suitability for any specific account size or leverage;
- that the public defaults reproduce the private research metrics;
- that the EA is ready for live trading.

## Known Limitations

- Low trade count can make statistics fragile.
- Historical testing can overfit to specific regimes.
- Gold can gap or reprice abruptly.
- MT5 data quality and execution assumptions matter.
- Spreads, slippage, commissions and swaps can materially change results.
- Private presets and raw reports are not public, so results are not turnkey-reproducible from this repository alone.
- Out-of-sample, walk-forward, Monte Carlo and forward demo validation remain necessary.

## Next Validation Steps

Recommended future validation before any stronger conclusion:

1. Re-run source-only tests from a clean MT5 environment.
2. Add out-of-sample periods.
3. Run walk-forward validation.
4. Run Monte Carlo trade-order and return-path stress.
5. Stress spread, slippage, commission and swap assumptions.
6. Compare multiple data feeds where legally and practically available.
7. Keep private presets and raw reports out of the public repository.
8. Publish only sanitized summaries after review.
