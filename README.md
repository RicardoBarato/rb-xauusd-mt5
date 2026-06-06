# RB XAU/USD MT5

Research-grade open-source Expert Advisor for MetaTrader 5 focused on gold/XAUUSD backtesting, market-regime research and risk-controlled execution.

![MQL5](https://img.shields.io/badge/MQL5-source-blue)
![MetaTrader 5](https://img.shields.io/badge/MetaTrader-5-1f6feb)
![XAUUSD / Gold](https://img.shields.io/badge/XAUUSD-Gold-b8860b)
![GPL-3.0](https://img.shields.io/badge/license-GPL--3.0--only-green)
![Source-only](https://img.shields.io/badge/release-source--only-lightgrey)
![No .ex5 binaries](https://img.shields.io/badge/no-.ex5_binaries-red)
![Research-grade](https://img.shields.io/badge/status-research--grade-orange)

This project is not financial advice, not a signal service and not a promise of future profitability. Historical testing is discussed for research-methodology transparency only.

## Project Snapshot

| Field | Value |
|---|---|
| Market | Gold / XAUUSD |
| Platform | MetaTrader 5 |
| Language | MQL5 |
| Type | Expert Advisor |
| Release model | Source-only |
| License | GPL-3.0-only |
| Compiled binaries | Not distributed |
| Real presets | Not distributed |
| Raw reports | Not distributed |
| Public performance metrics | Not published |

## Why This Project Exists

RB XAU/USD MT5 comes from a real research workflow around automated gold/XAUUSD trading. The public repository opens the source code for review, study and community evolution while keeping private presets, raw tester artifacts, backtest results and production parameters out of the public surface.

The goal is to show a serious engineering workflow for:

- systematic XAUUSD research;
- market-regime thinking;
- risk-controlled execution;
- repeatable Strategy Tester validation methodology;
- disciplined separation between source code, private research and public documentation.

This is deliberately not presented as a ready-made trading product. It is a research-grade codebase and documentation package intended for technical review.

## Backtest Research Boundary

This project comes from a real XAUUSD research workflow, but the public repository does not publish performance tables, production presets, optimization grids, raw reports, broker exports or account-specific artifacts.

The public material focuses on:

- source-code review;
- EA architecture;
- risk-control structure;
- methodology;
- validation limits;
- publication hygiene.

Backtest results, private baselines and parameter studies are intentionally kept outside the public repository. Any serious evaluation should be performed independently in a clean MetaTrader 5 environment, with fresh data, realistic costs, broker-specific assumptions and strict risk controls.

Backtests are research tools, not guarantees. Historical behavior can fail in live execution because of spread, slippage, liquidity, broker feed differences, overfitting, regime changes and execution constraints.

## What Is Included

- GPL-3.0 source code;
- MQL5 Expert Advisor;
- risk-control logic;
- methodology notes;
- architecture overview;
- risk disclosure;
- validation limits;
- sanitized example inputs.

## What Is Intentionally Not Included

- compiled `.ex5` binaries;
- real `.set` presets;
- raw MetaTrader reports;
- public performance tables;
- optimization files;
- broker exports;
- account data;
- private research logs;
- production parameters.

## Source-Only Release

This repository intentionally does not provide compiled `.ex5` binaries. Users must review and compile the source code themselves using MetaEditor.

The included source and documentation are not a production preset. Any serious use requires independent code review, fresh testing, risk controls and responsibility for execution assumptions.

## How To Compile

1. Clone the repository:

   ```bash
   git clone https://github.com/RicardoBarato/rb-xauusd-mt5.git
   ```

2. Open MetaEditor from MetaTrader 5.
3. Copy or open `src/RB_XAUUSD_MT5.mq5`.
4. Compile locally.
5. Test in Strategy Tester and demo.
6. Perform independent validation before making any operational decision.

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

GPL-3.0-only. Distributed modifications must preserve the GPL-3.0 license terms.

See [LICENSE](LICENSE).

## Risk And Responsibility

Gold/XAUUSD trading is volatile and risky. Backtests can diverge materially from live execution due to spread, slippage, commissions, liquidity, broker feed differences and regime changes.

Use of this source code is entirely the user's responsibility.
