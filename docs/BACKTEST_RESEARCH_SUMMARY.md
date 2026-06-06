# Backtest Research Summary

This document describes the public, sanitized backtest research boundary behind RB XAU/USD MT5. It explains methodology and validation expectations only. It does not publish performance tables, raw MT5 reports, real `.set` presets, broker exports, account data, local paths or production parameters.

## Research Scope

The research scope is gold/XAUUSD systematic testing in MetaTrader 5 using MQL5 Expert Advisor logic. The work focused on comparing historical profiles, preserving private baselines and identifying risk-control directions without overstating what backtests can prove.

The public repository is source-only. It is designed for code review and methodology review, not for copying a private production setup.

## Public Research Boundary

| Research item | Public treatment | Safety boundary |
|---|---|---|
| Symbol and platform | Published at a high level | No broker or account metadata |
| Strategy Tester workflow | Published as methodology | No raw reports distributed |
| Validation focus | Discussed conceptually | No performance tables |
| Risk-control direction | Discussed as architecture | No production parameters |
| Private baselines | Not published | Kept outside the public repository |
| Real presets | Not published | Prevents unsafe copy/paste live use |

## Why Backtest Results Are Not Published

Backtest metrics can be misread as proof of future profitability, live-readiness or suitability for a specific account. For that reason, this public repository does not publish historical return, profit factor, drawdown, trade-count tables, optimization grids or buy-and-hold comparisons.

Backtests remain useful as private research tools, but public review should focus on:

- source-code readability;
- risk-control structure;
- methodology;
- validation limits;
- reproducibility discipline;
- separation between public code and private research artifacts.

## What Public Readers Should Not Infer

This repository does not imply:

- future profitability;
- readiness for live trading;
- robustness across brokers, feeds or execution conditions;
- suitability for any specific account size;
- that public defaults reproduce private research;
- that historical edge will persist;
- that any parameter set has been promoted for production use.

## Why Raw Reports Are Not Included

Raw MT5 reports are intentionally excluded because they can contain or imply:

- broker/feed metadata;
- account or environment details;
- local file paths;
- exact preset behavior;
- execution assumptions that could be misused;
- private research context not needed for public code review.

The public repository publishes source code, methodology notes and validation boundaries only.

## Validation Limits

Known limitations:

- low trade count can make statistics fragile;
- historical tests can overfit;
- Strategy Tester depends on data quality and modeling assumptions;
- spread, slippage, commission, swap and liquidity can materially change outcomes;
- gold can gap or reprice abruptly;
- private presets and raw reports are not distributed, so this repository is not a turnkey reproduction package.

## Next Validation Steps

Recommended technical next steps for anyone independently reviewing the source:

1. Re-run tests from a clean MT5 environment.
2. Use independent data and broker assumptions.
3. Add out-of-sample validation.
4. Run walk-forward validation.
5. Run Monte Carlo stress tests.
6. Stress spread, slippage, commission and swap assumptions.
7. Compare multiple data feeds where practical.
8. Treat all results as research, not as financial advice or a trading recommendation.
