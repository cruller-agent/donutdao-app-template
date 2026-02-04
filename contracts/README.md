# DonutDAO Contracts

Complete Foundry library for building on DonutDAO's protocol stack.

## Quick Start

```bash
cd donutdao-contracts
forge install
forge build
forge test
```

## What's Inside

This repository contains:

### 📚 **Full Contract Interfaces**
- **Governance**: Voting, staking, revenue distribution
- **Mining**: DONUT minting via bonding curve
- **Franchise**: Token launchpad with auto liquidity

### 📖 **Comprehensive Documentation**
- [Governance System](./donutdao-contracts/docs/GOVERNANCE.md) - LSG mechanics
- [Mining System](./donutdao-contracts/docs/MINING.md) - Bonding curves & halvings
- [Franchise System](./donutdao-contracts/docs/FRANCHISE.md) - Token launches

### 🔧 **Example Contracts**
- [DonutDAOIntegration.sol](./donutdao-contracts/src/examples/DonutDAOIntegration.sol) - Full integration example

### 📋 **Contract Addresses**
See [addresses.json](./donutdao-contracts/addresses.json) for all deployed addresses on Base.

## Structure

```
donutdao-contracts/
├── src/
│   ├── interfaces/
│   │   ├── governance/    # LSG interfaces
│   │   ├── mining/        # Miner interfaces
│   │   └── franchise/     # Launch interfaces
│   ├── examples/          # Reference implementations
│   └── ...
├── docs/                  # Detailed documentation
├── test/                  # Test suite
└── addresses.json         # Deployed contract addresses
```

## Installation

### As a Foundry Dependency

```bash
forge install donutdao/donutdao-app-template
```

### For Development

```bash
git clone https://github.com/donutdao/donutdao-app-template
cd donutdao-app-template/contracts/donutdao-contracts
forge install
```

## Usage

### Import Interfaces

```solidity
import {IVoter} from "donutdao-contracts/src/interfaces/governance/IVoter.sol";
import {IMiner} from "donutdao-contracts/src/interfaces/mining/IMiner.sol";
import {ICore} from "donutdao-contracts/src/interfaces/franchise/ICore.sol";
```

### Example: Stake & Vote

```solidity
// Stake DONUT for voting power
IGovernanceToken gDonut = IGovernanceToken(0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3);
gDonut.stake(1000 ether);

// Vote for strategies
IVoter voter = IVoter(0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6);
address[] memory strategies = new address[](1);
strategies[0] = myStrategy;
uint256[] memory weights = new uint256[](1);
weights[0] = 10000; // 100% weight

voter.vote(strategies, weights);
```

### Example: Mine DONUT

```solidity
IMiner miner = IMiner(0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6);

// Check price
uint256 cost = miner.quote(100 ether);

// Mine DONUT
miner.mint{value: cost}(recipient, 100 ether);
```

### Example: Launch Token

```solidity
ICore core = ICore(0xA35588D152F45C95f5b152e099647f081BD9F5AB);

ICore.LaunchParams memory params = ICore.LaunchParams({
    launcher: msg.sender,
    tokenName: "MyToken",
    tokenSymbol: "MTK",
    uri: "ipfs://...",
    donutAmount: 1000 ether,
    unitAmount: 1_000_000 ether,
    // ... rest of params
});

(address unit, address rig, address auction, address lp) = core.launch(params);
```

## Architecture

### Governance (LSG)
- **Liquid Democracy**: Vote weight → Revenue distribution
- **Strategies**: Protocols that receive revenue based on votes
- **Bribes**: Incentivize voting for specific strategies
- **gDONUT**: Staked DONUT = voting power

### Mining
- **Bonding Curve**: ETH → DONUT at dynamic price
- **Halvings**: Emissions halve every 30 days
- **Epochs**: Price resets hourly, doubles within epoch
- **Tail Emissions**: Long-term 0.01 DONUT/sec floor

### Franchise
- **Launch**: Provide DONUT → Deploy new token
- **Mining**: Users mine new token with ETH
- **Liquidity**: Auto-paired on Uniswap V2
- **Gamified**: Auctions for mining privileges

## Contract Addresses (Base)

| Component | Contract | Address |
|-----------|----------|---------|
| **Tokens** | DONUT | `0xAE4a37d554C6D6F3E398546d8566B25052e0169C` |
| | gDONUT | `0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3` |
| **Mining** | Miner | `0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6` |
| **Governance** | Voter | `0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6` |
| | RevenueRouter | `0x4799CBe9782265C0633d24c7311dD029090dED33` |
| **Franchise** | Core | `0xA35588D152F45C95f5b152e099647f081BD9F5AB` |
| | UniswapV2Router | `0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24` |

See [addresses.json](./donutdao-contracts/addresses.json) for complete list.

## Resources

- **Glaze Corp**: [https://www.glazecorp.io/](https://www.glazecorp.io/) - Primary builder of core DONUT infrastructure
- **Documentation**: [docs/](./donutdao-contracts/docs/)
- **Examples**: [src/examples/](./donutdao-contracts/src/examples/)
- **Source Repos**:
  - [Liquid Signal Governance](https://github.com/Heesho/liquid-signal-governance)
  - [Donut Miner](https://github.com/Heesho/donut-miner)
  - [Franchise](https://github.com/Heesho/miner-launchpad-foundry)

## Development

```bash
# Build
forge build

# Test
forge test

# Test with gas report
forge test --gas-report

# Coverage
forge coverage

# Format
forge fmt
```

## Contributing

Contributions welcome! Please submit PRs to the source repositories:
- LSG: https://github.com/Heesho/liquid-signal-governance
- Miner: https://github.com/Heesho/donut-miner
- Franchise: https://github.com/Heesho/miner-launchpad-foundry

## Security

⚠️ **USE AT YOUR OWN RISK**

These contracts are provided for developer reference. Always audit before production use.

## License

MIT License

Built by the DonutDAO community 🍩
