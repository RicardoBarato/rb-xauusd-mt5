# RB XAU/USD MT5

RB XAU/USD MT5 is an open-source, research-grade Expert Advisor for MetaTrader 5, focused on gold/XAUUSD systematic backtesting, market regime research and risk-controlled execution.

This project is not financial advice, not a signal service and not a promise of future profitability. Historical backtests are provided for research transparency only.

This repository intentionally does not provide compiled `.ex5` binaries. Users must review and compile the source code themselves using MetaEditor.

RB XAU/USD MT5 é um Expert Advisor open-source de pesquisa para MetaTrader 5, focado em ouro/XAUUSD, backtests sistemáticos, pesquisa de regime de mercado e execução com controle de risco.

Este projeto não é recomendação financeira, não é serviço de sinais e não promete rentabilidade futura. Backtests históricos são apresentados apenas como transparência de pesquisa.

Este repositório intencionalmente não fornece binários `.ex5` compilados. Os usuários devem revisar e compilar o código-fonte por conta própria usando o MetaEditor.

## Status

Public source-only export prepared for human review before publication.

## Source

Main Expert Advisor:

```text
src/RB_XAUUSD_MT5.mq5
```

The repository does not include:

- compiled `.ex5` binaries;
- real `.set` presets;
- raw MetaTrader reports;
- broker exports;
- account data;
- optimization grids;
- private research logs.

## License

License: GPL-3.0-only

See [LICENSE](LICENSE).

## Intended Use

This project is intended for:

- MQL5 source-code review;
- educational study of Expert Advisor structure;
- systematic trading research;
- Strategy Tester experimentation;
- risk-management workflow design;
- reproducibility discussions around backtesting.

It is not intended to be copied directly into live trading without independent review, testing and risk control.

## Compile

1. Open MetaEditor from MetaTrader 5.
2. Place `src/RB_XAUUSD_MT5.mq5` inside your MT5 `MQL5/Experts/` workspace.
3. Review all inputs and source code.
4. Compile locally in MetaEditor.
5. Test first in Strategy Tester and demo only.

## Documentation

- [Disclaimer](DISCLAIMER.md)
- [Risk Disclosure](docs/RISK_DISCLOSURE.md)
- [Methodology](docs/METHODOLOGY.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Backtest Research Summary](docs/BACKTEST_RESEARCH_SUMMARY.md)
- [Validation Limits](docs/VALIDATION_LIMITS.md)
- [Publication Checklist](docs/PUBLICATION_CHECKLIST.md)
- [Sanitized example inputs](examples/example_inputs_sanitized.md)

## Security And Privacy

Do not commit or share:

- account numbers;
- broker exports;
- real presets;
- compiled binaries;
- raw reports;
- logs;
- optimization files;
- local terminal paths;
- credentials.

See [SECURITY.md](SECURITY.md).

## Important Warning

Trading gold/XAUUSD is risky and volatile. Strategy Tester results can diverge materially from live execution because of spread, slippage, commissions, liquidity, broker feed differences and market regime changes. Past performance and backtests do not guarantee future results.
