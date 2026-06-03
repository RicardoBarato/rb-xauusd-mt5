# RB XAU/USD MT5

Open-source research-grade Expert Advisor for MetaTrader 5 focused on gold/XAUUSD systematic backtesting, market regime research and risk-controlled execution.

![MQL5](https://img.shields.io/badge/MQL5-source-blue)
![MetaTrader 5](https://img.shields.io/badge/MetaTrader-5-1f6feb)
![XAUUSD](https://img.shields.io/badge/XAUUSD-Gold-b8860b)
![GPL-3.0](https://img.shields.io/badge/license-GPL--3.0--only-green)
![Source only](https://img.shields.io/badge/release-source--only-lightgrey)
![No binaries](https://img.shields.io/badge/no-.ex5_binaries-red)
![Research grade](https://img.shields.io/badge/status-research--grade-orange)

This is not financial advice, not a signal service and not a promise of future profitability. Historical backtests are presented for research transparency only.

## Research Snapshot

| Item | Value |
|---|---|
| Asset | XAUUSD / Gold |
| Platform | MetaTrader 5 |
| Language | MQL5 |
| Type | Expert Advisor |
| Release | Source-only |
| License | GPL-3.0-only |
| Compiled binaries | Not distributed |
| Raw reports | Not distributed |
| Public source file | `src/RB_XAUUSD_MT5.mq5` |
| Public source SHA256 | `ED85830CA2D91D5628D4B26FEFDD25C31056D3054FE980F62A9B970AA65A28DA` |
| Private source hashes | Maintained outside the public repository |

## Why This Project Exists

RB XAU/USD MT5 was created from a real research workflow around systematic trading on gold. The public repository exists to make the engineering, validation discipline and risk-control structure reviewable without publishing private presets, raw reports or production configuration.

The project focuses on:

- market-regime research for XAUUSD;
- objective rule-based execution;
- risk-controlled position management;
- repeatable Strategy Tester workflows;
- discipline against overfitting;
- clean separation between public source code and private research artifacts;
- open-source review and community-driven improvement.

## Backtest Research Highlights

The table below contains only aggregated and sanitized metrics already documented in the private research checkpoint. It does not include raw MT5 reports, real presets, optimization grids, broker exports, account data or production parameters.

| Research Set | Period | Symbol | Trades | Net Result | Profit Factor | Max Drawdown | Notes |
|---|---:|---|---:|---:|---:|---:|---|
| Aggressive baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 54 | +662.06% | 2.50 | 39.90% | Protected research baseline; private preset not distributed |
| Controlled baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 49 | +273.43% | 2.18 | 31.56% | Lower-return controlled profile; private preset not distributed |
| Conservative baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 10 | +7.89% | 4.63 | 0.73% | Defensive comparison profile |
| Alternative baseline | 2016-05-20 to 2026-05-20 | XAUUSD | 52 | +348.76% | 2.18 | 40.39% | Kept under observation, not promoted |

Additional context is available in [docs/RESEARCH_SNAPSHOT.md](docs/RESEARCH_SNAPSHOT.md) and [docs/BACKTEST_RESEARCH_SUMMARY.md](docs/BACKTEST_RESEARCH_SUMMARY.md).

These figures are research artifacts. They are not a guarantee, not a live-trading recommendation and not sufficient proof of future performance.

## What Is Included

- GPL-3.0-only source code;
- one MQL5 Expert Advisor source file;
- methodology notes;
- architecture overview;
- risk disclosure;
- validation limits;
- sanitized example inputs;
- publication checklist for safe future updates.

## What Is Intentionally Not Included

- compiled `.ex5` binaries;
- real `.set` presets;
- raw MT5 reports;
- optimization files;
- broker exports;
- account data;
- private research logs;
- production parameters;
- full private experiment artifacts.

## Source-Only Release

This repository intentionally does not provide compiled `.ex5` binaries. Users must review and compile the source code themselves using MetaEditor.

The public defaults and example inputs should be treated as research documentation, not as a ready-made live-trading setup.

## How To Compile

1. Clone the repository:

   ```bash
   git clone https://github.com/RicardoBarato/rb-xauusd-mt5.git
   ```

2. Open MetaEditor from MetaTrader 5.
3. Copy or open `src/RB_XAUUSD_MT5.mq5` inside your MT5 `MQL5/Experts/` workspace.
4. Review all inputs and source code.
5. Compile locally in MetaEditor.
6. Test first in Strategy Tester and demo only.
7. Do not use live without independent validation, risk controls and responsibility for execution conditions.

## Repository Structure

```text
.
|-- README.md
|-- LICENSE
|-- DISCLAIMER.md
|-- SECURITY.md
|-- CONTRIBUTING.md
|-- CHANGELOG.md
|-- src/
|   `-- RB_XAUUSD_MT5.mq5
|-- docs/
|   |-- ARCHITECTURE.md
|   |-- BACKTEST_RESEARCH_SUMMARY.md
|   |-- METHODOLOGY.md
|   |-- PUBLICATION_CHECKLIST.md
|   |-- RESEARCH_SNAPSHOT.md
|   |-- RISK_DISCLOSURE.md
|   `-- VALIDATION_LIMITS.md
`-- examples/
    `-- example_inputs_sanitized.md
```

## Documentation

- [Disclaimer](DISCLAIMER.md)
- [Backtest Research Summary](docs/BACKTEST_RESEARCH_SUMMARY.md)
- [Research Snapshot](docs/RESEARCH_SNAPSHOT.md)
- [Methodology](docs/METHODOLOGY.md)
- [Risk Disclosure](docs/RISK_DISCLOSURE.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Validation Limits](docs/VALIDATION_LIMITS.md)
- [Publication Checklist](docs/PUBLICATION_CHECKLIST.md)
- [Sanitized example inputs](examples/example_inputs_sanitized.md)

## License

This project is licensed under GPL-3.0-only. Distributed modifications must preserve the GPL-3.0 license terms.

See [LICENSE](LICENSE).

## Risk And Responsibility

Gold/XAUUSD is volatile. Strategy Tester results can differ materially from live execution because of spread, slippage, commissions, liquidity, data quality, broker feed differences and regime changes. Past performance and backtests do not guarantee future results.

Use of this source code is entirely the user's responsibility.
