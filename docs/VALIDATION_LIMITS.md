# Validation Limits

Validation is a process, not a single backtest.

## Known Limits

- Historical tests may overstate live performance.
- MT5 Strategy Tester depends on local data quality.
- Broker feeds can differ.
- Spreads and slippage can be worse in live conditions.
- Gold/XAUUSD can gap or reprice abruptly.
- Parameter choices can be overfit.
- Low trade count can make results statistically fragile.

## Recommended Additional Tests

- Out-of-sample periods.
- Walk-forward validation.
- Monte Carlo reshuffling and bootstrapping.
- Spread and slippage stress.
- Different brokers or data feeds.
- Demo forward testing.
- Failure-mode review for losing years and drawdown clusters.

## Publication Limit

This public source-only export is not a production certification. It is a research artifact for review and further testing.
