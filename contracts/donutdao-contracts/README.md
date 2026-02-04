# DonutDAO Contracts

A comprehensive Foundry library containing all DonutDAO protocol contracts, interfaces, and documentation. This repository provides everything developers need to build applications on top of the DonutDAO ecosystem.

## Overview

DonutDAO is a collection of individuals supporting the DONUT token on Base. Core infrastructure by [Glaze Corp](https://www.glazecorp.io/), with permissionless smart contracts that anyone can build on top of. Features: liquid signal governance, autonomous mining, and a token launchpad. The ecosystem consists of three main components:

1. **Liquid Signal Governance (LSG)** - Liquid democracy & revenue distribution
2. **Donut Miner** - Autonomous token mining with dynamic pricing
3. **Franchise (Mineport)** - Gamified token launchpad

## Quick Start

```bash
# Clone and install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test

# Run tests with gas reporting
forge test --gas-report
```

## Architecture

### 1. Liquid Signal Governance (LSG)

**What it does:** Enables liquid democracy where gDONUT holders vote with their staked weight to direct protocol revenue. Votes signal which strategies (protocols/apps) should receive rewards.

**Key Contracts:**
- `Voter` - Core voting and distribution logic
- `GovernanceToken` (gDONUT) - Staking wrapper for DONUT
- `Strategy` - Represents a vote-able protocol/app
- `Bribe` - Incentive mechanism for vote purchasing
- `RevenueRouter` - Routes protocol revenue to voters

**Deployed Addresses (Base):**
- Voter: `0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6`
- GovernanceToken (gDONUT): `0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3`
- RevenueRouter: `0x4799CBe9782265C0633d24c7311dD029090dED33`

**Usage Example:**
```solidity
import {IVoter} from "src/interfaces/governance/IVoter.sol";
import {IGovernanceToken} from "src/interfaces/governance/IGovernanceToken.sol";

// Stake DONUT to get voting power
IGovernanceToken gDonut = IGovernanceToken(0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3);
gDonut.stake(100 ether); // Stake 100 DONUT

// Vote for strategies
IVoter voter = IVoter(0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6);
address[] memory strategies = new address[](1);
strategies[0] = myStrategy;
uint256[] memory weights = new uint256[](1);
weights[0] = 10000; // 100% of your voting power

voter.vote(strategies, weights);
```

**For Agents:**
- Query strategy weights: `voter.strategy_Weight(strategy)`
- Check claimable rewards: `voter.strategy_Claimable(strategy)`
- Automate vote rebalancing based on yield
- Monitor revenue notifications: `voter.notifyRevenue(amount)`

---

### 2. Donut Miner

**What it does:** Autonomous DONUT token minting via a bonding curve mechanism. Users provide ETH to "mine" DONUT at dynamically adjusted prices. The miner implements halvings and decay mechanics similar to Bitcoin.

**Key Contracts:**
- `Miner` - Core mining logic with bonding curve
- `Donut` - The DONUT ERC20 token (mintable only by Miner)
- `Auction` - Secondary market for mining rights
- `Base` - Base class for auction mechanics

**Deployed Addresses (Base):**
- Miner: `0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6`
- DONUT Token: `0xAE4a37d554C6D6F3E398546d8566B25052e0169C`

**Mining Parameters:**
- Initial DPS (Donuts Per Second): 4 DONUT
- Halving Period: 30 days
- Tail Emission: 0.01 DONUT/sec
- Fee: 20% (2000 bps)
- Price Multiplier: 2x per epoch

**Usage Example:**
```solidity
import {IMiner} from "src/interfaces/mining/IMiner.sol";

IMiner miner = IMiner(0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6);

// Check current mining price
uint256 currentPrice = miner.quotePrice();

// Mine DONUT by providing ETH
miner.mint{value: currentPrice}(recipient, donutAmount);

// Query mining stats
uint256 dps = miner.dps(); // Current donuts per second
uint256 epochId = miner.currentEpochId();
```

**For Agents:**
- Monitor price efficiency: `quotePrice()` vs market price
- Automate mining during favorable conditions
- Track halvings for emission modeling
- Aggregate user mining operations

---

### 3. Franchise (Mineport)

**What it does:** Gamified token launchpad where projects launch tokens via a mining-style bonding curve. Creators provide DONUT, users mine the new token with ETH, and liquidity is automatically seeded on Uniswap V2.

**Key Contracts:**
- `Core` - Launch orchestration
- `Unit` - The new token being launched
- `Rig` - Mining contract for the Unit token
- `Auction` - Secondary market for mining rights
- `RigFactory`, `UnitFactory`, `AuctionFactory` - Deployment factories

**Deployed Addresses (Base):**
- Core: `0xA35588D152F45C95f5b152e099647f081BD9F5AB`
- UniswapV2Router: `0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24`
- UniswapV2Factory: `0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6`

**Launch Parameters:**
```solidity
struct LaunchParams {
    address launcher;          // Who's launching
    string tokenName;          // New token name
    string tokenSymbol;        // New token symbol
    string uri;                // Metadata URI
    uint256 donutAmount;       // DONUT to bootstrap
    uint256 unitAmount;        // New tokens to mine
    uint256 initialUps;        // Initial units per second
    uint256 tailUps;           // Tail emission
    uint256 halvingPeriod;     // Halving schedule
    uint256 rigEpochPeriod;    // Rig epoch duration
    uint256 rigPriceMultiplier; // Price increase per epoch
    uint256 rigMinInitPrice;   // Min starting price
    uint256 auctionInitPrice;  // Auction starting price
    uint256 auctionEpochPeriod; // Auction epoch duration
    uint256 auctionPriceMultiplier; // Auction price curve
    uint256 auctionMinInitPrice; // Auction min price
}
```

**Usage Example:**
```solidity
import {ICore} from "src/interfaces/franchise/ICore.sol";

ICore core = ICore(0xA35588D152F45C95f5b152e099647f081BD9F5AB);

// Launch a new token
ICore.LaunchParams memory params = ICore.LaunchParams({
    launcher: msg.sender,
    tokenName: "MyToken",
    tokenSymbol: "MTK",
    uri: "ipfs://...",
    donutAmount: 1000 ether,
    unitAmount: 1_000_000 ether,
    initialUps: 10 ether,
    tailUps: 0.1 ether,
    halvingPeriod: 7 days,
    rigEpochPeriod: 1 hours,
    rigPriceMultiplier: 2e18,
    rigMinInitPrice: 0.0001 ether,
    auctionInitPrice: 0.01 ether,
    auctionEpochPeriod: 1 hours,
    auctionPriceMultiplier: 2e18,
    auctionMinInitPrice: 0.0001 ether
});

(address unit, address rig, address auction, address lpToken) = core.launch(params);
```

**For Agents:**
- Launch agent-specific tokens
- Monitor new launches: `core.deployedRigs(index)`
- Automate liquidity provision
- Track mining efficiency across rigs

---

## Contract Interfaces

All interfaces are located in `src/interfaces/` organized by component:

### Governance Interfaces
- `IVoter.sol` - Voting and distribution
- `IGovernanceToken.sol` - gDONUT staking
- `IStrategy.sol` - Strategy implementation
- `IBribe.sol` - Bribe rewards
- `IBribeRouter.sol` - Bribe routing
- `IRevenueRouter.sol` - Revenue distribution

### Mining Interfaces
- `IMiner.sol` - Core mining interface (create this)
- `IAuction.sol` - Auction interface (create this)

### Franchise Interfaces
- `ICore.sol` - Launch coordination
- `IRig.sol` - Mining contract
- `IUnit.sol` - Launched token
- `IAuction.sol` - Secondary market
- `IUniswapV2.sol` - DEX integration

---

## Building on DonutDAO

### For Application Developers

```solidity
// Install as dependency
forge install donutdao/donutdao-contracts

// Import interfaces
import {IVoter} from "donutdao-contracts/src/interfaces/governance/IVoter.sol";
import {ICore} from "donutdao-contracts/src/interfaces/franchise/ICore.sol";
```

### For Autonomous Agents

**Key Integration Points:**
1. **Governance Participation:** Stake DONUT → gDONUT, vote for strategies
2. **Mining Operations:** Monitor prices, execute mining, track halvings
3. **Token Launches:** Deploy new tokens, bootstrap liquidity
4. **Revenue Optimization:** Track claimable rewards, rebalance votes

**Example Agent Workflow:**
```solidity
// 1. Check if mining is profitable
uint256 minerPrice = miner.quotePrice();
uint256 marketPrice = getMarketPrice();
if (minerPrice < marketPrice * 0.95) {
    miner.mint{value: minerPrice}(recipient, amount);
}

// 2. Rebalance governance votes based on yield
address[] memory strategies = voter.getStrategies();
for (uint i = 0; i < strategies.length; i++) {
    uint256 claimable = voter.strategy_Claimable(strategies[i]);
    // Adjust vote weights based on claimable rewards
}

// 3. Launch agent-specific token
core.launch(agentLaunchParams);
```

---

## Testing

```bash
# Run all tests
forge test

# Test specific contract
forge test --match-contract VoterTest

# Test with verbose output
forge test -vvv

# Generate coverage report
forge coverage
```

---

## Documentation

Detailed documentation for each component:

- **[Governance System](./docs/GOVERNANCE.md)** - LSG mechanics, voting strategies
- **[Mining System](./docs/MINING.md)** - Bonding curves, halvings, auctions
- **[Franchise System](./docs/FRANCHISE.md)** - Token launches, liquidity bootstrapping

---

## Contract Addresses

All deployed addresses on Base (Chain ID: 8453):

```json
{
  "tokens": {
    "DONUT": "0xAE4a37d554C6D6F3E398546d8566B25052e0169C",
    "gDONUT": "0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3",
    "DONUT_ETH_LP": "0xD1DbB2E56533C55C3A637D13C53aeEf65c5D5703",
    "WETH": "0x4200000000000000000000000000000000000006",
    "USDC": "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913"
  },
  "mining": {
    "Miner": "0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6",
    "MinerMulticall": "0x3ec144554b484C6798A683E34c8e8E222293f323"
  },
  "governance": {
    "Voter": "0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6",
    "GovernanceToken": "0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3",
    "RevenueRouter": "0x4799CBe9782265C0633d24c7311dD029090dED33",
    "LSGMulticall": "0x41eA22dF0174cF3Cc09B1469a95D604E1833a462",
    "DAO": "0x690C2e187c8254a887B35C0B4477ce6787F92855"
  },
  "franchise": {
    "Core": "0xA35588D152F45C95f5b152e099647f081BD9F5AB",
    "Multicall": "0x5D16A5EB8Ac507eF417A44b8d767104dC52EFa87",
    "UniswapV2Router": "0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24",
    "UniswapV2Factory": "0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6"
  }
}
```

---

## Resources

- **Glaze Corp:** [https://www.glazecorp.io/](https://www.glazecorp.io/) - Primary builder of core DONUT infrastructure
- **GitHub:**
  - [Liquid Signal Governance](https://github.com/Heesho/liquid-signal-governance)
  - [Donut Miner](https://github.com/Heesho/donut-miner)
  - [Franchise (Mineport)](https://github.com/Heesho/miner-launchpad-foundry)
- **Smart Contracts:** View on [BaseScan](https://basescan.org)

---

## Security

**⚠️ USE AT YOUR OWN RISK**

These contracts are provided as-is for developer reference. Always conduct thorough security audits before using in production.

**Note:** DonutDAO is not an organization. It's a collection of individuals supporting the DONUT token. The smart contracts are immutable and permissionless—anyone can build infrastructure on top. Core contracts by [Glaze Corp](https://www.glazecorp.io/).

---

## Contributing

Contributions welcome! Please open issues or PRs on the respective source repositories:
- LSG: https://github.com/Heesho/liquid-signal-governance
- Miner: https://github.com/Heesho/donut-miner  
- Franchise: https://github.com/Heesho/miner-launchpad-foundry

---

## License

MIT License - see LICENSE file for details

Built with ❤️ by the DonutDAO community
