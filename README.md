# zwap

Simple zap-and-swap contracts for more secure and gas-efficient exchange and payment use cases.

## eth -> usdc zap
> send ether and receive back usdc / allow for optional payment flow

### ethereum

ZwapUSDC: [`0x00000000000066cb57F7066c1ee03752C015d8AC`](https://etherscan.io/address/0x00000000000066cb57f7066c1ee03752c015d8ac#code)

### arbitrum

ZwapUSDCArb: [`0x15481c4387d40f6f4ed27c8a298685832c96c606`](https://arbiscan.io/address/0x15481c4387d40f6f4ed27c8a298685832c96c606#code)

## Getting Started

Run: `curl -L https://foundry.paradigm.xyz | bash && source ~/.bashrc && foundryup`

Build the foundry project with `forge build`. Run tests with `forge test`. Measure gas with `forge snapshot`. Format with `forge fmt`.

## GitHub Actions

Contracts will be tested and gas measured on every push and pull request.

You can edit the CI script in [.github/workflows/ci.yml](./.github/workflows/ci.yml).

## Disclaimer

*These smart contracts and testing suite are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of anything provided herein or through related user interfaces. This repository and related code have not been audited and as such there can be no assurance anything will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk.*

## License

See [LICENSE](./LICENSE) for more details.
