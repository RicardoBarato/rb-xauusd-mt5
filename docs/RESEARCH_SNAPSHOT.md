# Research Snapshot

## Executive Summary

RB XAU/USD MT5 is a source-only public Expert Advisor project for MetaTrader 5. It is built around systematic gold/XAUUSD research, risk-controlled execution and transparent methodology documentation.

The public repository exists to make the code and research structure reviewable without publishing private presets, raw reports or production configuration.

## Research Scope

| Area | Public Summary |
|---|---|
| Market | Gold / XAUUSD |
| Platform | MetaTrader 5 |
| Language | MQL5 |
| Method | Expert Advisor backtesting |
| Focus | Market-regime research and risk control |
| Publication mode | Source-only |

## What Was Published

- GPL-3.0-only source code.
- One MQL5 Expert Advisor source file.
- Methodology notes.
- Architecture overview.
- Risk disclosure.
- Validation limits.
- Sanitized example inputs.
- Aggregated backtest summaries.

## What Was Omitted For Safety

- Compiled `.ex5` binaries.
- Real `.set` presets.
- Raw MT5 reports.
- HTML/XML/CSV/XLSX/log exports.
- Broker exports.
- Account data.
- Local paths.
- Production parameters.
- Private research logs.

## Why Source-Only

Source-only publication forces review before use. Users can inspect the EA logic, compile it locally and test it under their own assumptions instead of downloading a black-box binary.

This also reduces the risk of unsafe copy/paste operation from private presets or opaque compiled files.

## Why There Is No `.ex5`

Compiled `.ex5` binaries are intentionally not distributed because they are harder to audit, can encourage unsafe use and do not support transparent code review. Anyone interested in the project should review and compile the source code locally in MetaEditor.

## Current Research Read

The aggregated research snapshot suggests that some historical XAUUSD profiles were promising, but also exposed meaningful drawdown and low-trade-count limitations. No experimental filter has been promoted as a replacement for the protected baselines.

The technical direction remains validation-first:

- preserve the strongest historical baselines;
- avoid publishing private operational artifacts;
- test robustness before claiming anything stronger;
- focus on out-of-sample, walk-forward and Monte Carlo validation.

## Next Technical Steps

1. Reproduce source-only tests in a clean environment.
2. Add out-of-sample validation.
3. Run walk-forward validation.
4. Run Monte Carlo and spread/slippage stress.
5. Continue separating public summaries from private research artifacts.

## Backtest Warning

Backtests are research tools, not guarantees. Historical performance can fail in live execution because of data quality, overfitting, spread, slippage, commissions, liquidity, broker feed differences and market-regime changes.
