# Architecture

This document describes the `XAUUSD MT5 Expert Advisor` source release at a high level without publishing private presets, production parameters or non-public research artifacts.

## Main Components

### Signal Module

Evaluates price action, trend and breakout/retest conditions using market data available inside MetaTrader 5.

### Regime And Filter Module

Applies volatility, trend-quality and session filters to avoid some unfavorable conditions.

### Risk Module

Calculates risk-based position sizing, drawdown guards and operational limits.

### Execution Module

Uses the MT5 trading API to submit orders only when the configured safety flags allow trading.

### Operational Protection Module

Includes symbol checks, spread checks, session checks, cooldowns and limits on trading frequency.

### Diagnostics

The source includes runtime checks and control flow suitable for Strategy Tester review. This public export does not include raw logs or private diagnostic reports.

## Source File

```text
src/RB_XAUUSD_MT5.mq5
```

## Notes

The public repository intentionally excludes production presets and private research artifacts. Users should treat the included defaults as research defaults, not as a recommended live configuration.
