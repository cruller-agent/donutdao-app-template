# Franchise (Mineport)

## Overview

Franchise is DonutDAO's gamified token launchpad where projects launch new tokens via a mining-style bonding curve. It's called "Mineport" in the UI. Creators provide DONUT to bootstrap, users mine the new token with ETH, and liquidity is automatically seeded on Uniswap V2.

## How It Works

### 1. Token Launch Flow

```
Creator → Provides DONUT + Launch Params
    ↓
Core Contract → Deploys Unit, Rig, Auction, LP Token
    ↓
Users → Mine Unit tokens by providing ETH to Rig
    ↓
Auto Liquidity → DONUT + Unit paired on Uniswap V2
```

### 2. Core Components

**Unit**: The new ERC20 token being launched
- Implements ERC20Votes for governance
- Mintable only by Rig contract
- Supply determined by launch params

**Rig**: Mining contract for Unit tokens
- Bonding curve pricing (like Donut Miner)
- Halving schedule for emissions
- Epoch-based price adjustments

**Auction**: Secondary market for mining rights
- Users bid for privileged mining access
- Winner gets first access to new epoch
- Creates price discovery

**LP Token**: Uniswap V2 liquidity pair
- DONUT + Unit paired automatically
- Provides instant liquidity
- Tradable on DEXs

## Launching a Token

### Launch Parameters

```solidity
struct LaunchParams {
    address launcher;          // Who's launching (you)
    string tokenName;          // New token name
    string tokenSymbol;        // New token symbol  
    string uri;                // Metadata URI (IPFS recommended)
    uint256 donutAmount;       // DONUT to provide (min requirement)
    uint256 unitAmount;        // Total Unit tokens to mine
    uint256 initialUps;        // Initial units per second
    uint256 tailUps;           // Minimum emission floor
    uint256 halvingPeriod;     // How often to halve emissions
    uint256 rigEpochPeriod;    // Rig epoch duration
    uint256 rigPriceMultiplier; // Rig price growth (2e18 = 2x)
    uint256 rigMinInitPrice;   // Rig starting price floor
    uint256 auctionInitPrice;  // Auction starting bid
    uint256 auctionEpochPeriod; // Auction epoch duration
    uint256 auctionPriceMultiplier; // Auction price curve
    uint256 auctionMinInitPrice; // Auction price floor
}
```

### Example Launch

```solidity
ICore core = ICore(0xA35588D152F45C95f5b152e099647f081BD9F5AB);

// Approve DONUT for launch
IERC20 donut = IERC20(0xAE4a37d554C6D6F3E398546d8566B25052e0169C);
donut.approve(address(core), donutAmount);

// Configure launch
ICore.LaunchParams memory params = ICore.LaunchParams({
    launcher: msg.sender,
    tokenName: "MyToken",
    tokenSymbol: "MTK",
    uri: "ipfs://Qm...",
    donutAmount: 1000 ether,        // Provide 1000 DONUT
    unitAmount: 1_000_000 ether,    // 1M tokens to mine
    initialUps: 10 ether,           // 10 tokens/second initially
    tailUps: 0.1 ether,             // 0.1 tokens/second floor
    halvingPeriod: 7 days,          // Halve every week
    rigEpochPeriod: 1 hours,        // 1h epochs
    rigPriceMultiplier: 2e18,       // 2x price per epoch
    rigMinInitPrice: 0.0001 ether,  // Min 0.0001 ETH
    auctionInitPrice: 0.01 ether,   // Start auction at 0.01 ETH
    auctionEpochPeriod: 1 hours,    // 1h auction epochs
    auctionPriceMultiplier: 2e18,   // 2x auction price
    auctionMinInitPrice: 0.0001 ether
});

// Launch!
(
    address unit,     // New token contract
    address rig,      // Mining contract
    address auction,  // Auction contract
    address lpToken   // LP token address
) = core.launch(params);
```

### Minimum Requirements

```solidity
// Check minimum DONUT required
uint256 minDonut = core.minDonutForLaunch();

// Must provide at least this much DONUT
require(params.donutAmount >= minDonut, "Insufficient DONUT");
```

## Mining Launched Tokens

### Basic Mining

```solidity
IRig rig = IRig(rigAddress);

// Check current mining price
uint256 price = rig.quotePrice();

// Mine tokens
rig.mint{value: price}(recipient, amount);
```

### Price Discovery

Rig uses same bonding curve as Donut Miner:

```solidity
// Price per token = initPrice * (multiplier ^ epochId)
uint256 currentPrice = rig.quotePrice();
uint256 epochId = rig.currentEpochId();

// Price doubles each epoch (if multiplier = 2e18)
// Reset at start of each epoch
```

### Auction System

Bid for mining privileges:

```solidity
IAuction auction = IAuction(auctionAddress);

// Place bid
auction.bid{value: bidAmount}();

// Winner gets first mining access in next epoch
address currentWinner = auction.currentWinner();
uint256 winningBid = auction.currentBid();
```

## For Developers

### Querying Launches

```solidity
ICore core = ICore(coreAddress);

// Get all launched rigs
uint256 totalLaunches = core.deployedRigsLength();

for (uint i = 0; i < totalLaunches; i++) {
    address rig = core.deployedRigs(i);
    address launcher = core.rigToLauncher(rig);
    address unit = core.rigToUnit(rig);
    address auction = core.rigToAuction(rig);
    address lp = core.rigToLP(rig);
    
    // Query rig state
    IRig(rig).quotePrice();
    IUnit(unit).totalSupply();
}
```

### Integration Example

```solidity
// Create launch frontend
contract LaunchUI {
    ICore public core;
    
    function createLaunch(
        string memory name,
        string memory symbol,
        string memory uri,
        uint256 donutAmount
    ) external {
        // Standard launch params
        ICore.LaunchParams memory params = ICore.LaunchParams({
            launcher: msg.sender,
            tokenName: name,
            tokenSymbol: symbol,
            uri: uri,
            donutAmount: donutAmount,
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
        
        core.launch(params);
    }
}
```

## For Autonomous Agents

### Launch Discovery

```solidity
// Monitor new launches
function checkNewLaunches() public view returns (address[] memory newRigs) {
    uint256 length = core.deployedRigsLength();
    // Track last seen index, return new ones
}

// Evaluate launch potential
function analyzeLaunch(address rig) public view returns (
    uint256 marketCap,
    uint256 miningEfficiency,
    uint256 liquidityDepth
) {
    IRig rigContract = IRig(rig);
    address unit = core.rigToUnit(rig);
    address lp = core.rigToLP(rig);
    
    // Calculate metrics
    uint256 supply = IUnit(unit).totalSupply();
    uint256 price = rigContract.quotePrice();
    marketCap = supply * price / 1e18;
    
    // Check DEX liquidity
    (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(lp).getReserves();
    liquidityDepth = uint256(reserve0) * uint256(reserve1);
    
    // Mining ROI
    uint256 minerPrice = rigContract.quotePrice();
    uint256 dexPrice = getDEXPrice(unit);
    miningEfficiency = (dexPrice * 1e18) / minerPrice;
}
```

### Automated Mining

```solidity
// Mine when profitable
function autoMine(address rig, uint256 amount) external {
    uint256 minerCost = IRig(rig).quote(amount);
    uint256 marketValue = calculateMarketValue(rig, amount);
    
    require(marketValue > minerCost * 110 / 100, "Not profitable"); // 10% margin
    
    IRig(rig).mint{value: minerCost}(msg.sender, amount);
}
```

### Launch Your Own Token

```solidity
// Agent launches its own token
function launchAgentToken() external returns (address unit) {
    ICore.LaunchParams memory params = ICore.LaunchParams({
        launcher: address(this),
        tokenName: "AgentToken",
        tokenSymbol: "AGT",
        uri: "ipfs://...", // Agent metadata
        donutAmount: calculateOptimalDonut(),
        unitAmount: 10_000_000 ether,
        initialUps: calculateOptimalEmission(),
        tailUps: 0.1 ether,
        halvingPeriod: 14 days,
        rigEpochPeriod: 1 hours,
        rigPriceMultiplier: 2e18,
        rigMinInitPrice: 0.0001 ether,
        auctionInitPrice: 0.01 ether,
        auctionEpochPeriod: 1 hours,
        auctionPriceMultiplier: 2e18,
        auctionMinInitPrice: 0.0001 ether
    });
    
    (unit,,,) = core.launch(params);
}
```

### Portfolio Management

```solidity
// Track all launched tokens
mapping(address => LaunchMetadata) public launches;

struct LaunchMetadata {
    address unit;
    address rig;
    address auction;
    address lp;
    uint256 launchTime;
    uint256 totalMined;
}

// Update portfolio
function updatePortfolio() external {
    uint256 length = core.deployedRigsLength();
    for (uint i = 0; i < length; i++) {
        address rig = core.deployedRigs(i);
        if (launches[rig].launchTime == 0) {
            // New launch detected
            launches[rig] = LaunchMetadata({
                unit: core.rigToUnit(rig),
                rig: rig,
                auction: core.rigToAuction(rig),
                lp: core.rigToLP(rig),
                launchTime: block.timestamp,
                totalMined: 0
            });
        }
    }
}
```

## Economic Model

### Launch Economics

For a typical launch:
- **DONUT Provided**: 1000 DONUT
- **Unit Tokens**: 1M tokens
- **Initial Price**: Based on DONUT/Unit ratio + mining demand
- **Liquidity Depth**: Instant via Uniswap V2 pair

### Revenue Flows

1. **Creator**: Receives Unit tokens from initial supply
2. **Miners**: Pay ETH to Rig, receive Unit tokens
3. **Rig**: Accumulates ETH, pairs with DONUT for LP
4. **LP Holders**: Earn trading fees on Uniswap
5. **Auction Winners**: Get mining privileges

### Fee Structure

```solidity
// Protocol fee on launches
uint256 protocolFee = launchAmount * FEE / DIVISOR;

// Rig mining fee (typically 20%)
uint256 miningFee = mintAmount * FEE / DIVISOR;
```

## Contract Addresses (Base)

| Contract | Address |
|----------|---------|
| Core | `0xA35588D152F45C95f5b152e099647f081BD9F5AB` |
| Multicall | `0x5D16A5EB8Ac507eF417A44b8d767104dC52EFa87` |
| UniswapV2Router | `0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24` |
| UniswapV2Factory | `0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6` |

## Best Practices

### For Launchers

1. **DONUT Amount**: Provide enough for meaningful liquidity (1000+ DONUT)
2. **Token Supply**: Balance scarcity vs accessibility (1M-10M typical)
3. **Emission Rate**: Start high, tail low (10→0.1 typical)
4. **Halving Period**: Weekly or bi-weekly (7-14 days)
5. **Metadata**: Include rich IPFS data (image, description, links)

### For Miners

1. **Timing**: Mine early in epochs when price is lowest
2. **Profitability**: Check DEX price vs mining cost
3. **Liquidity**: Ensure LP has depth before large purchases
4. **Research**: Review launcher reputation and token utility

### For Integrators

1. **Discovery**: Poll `deployedRigs()` for new launches
2. **Caching**: Cache rig metadata to reduce RPC calls
3. **Price Feeds**: Integrate Uniswap price oracles
4. **Safety**: Validate rig is deployed by Core contract

## Security Considerations

- **Rug Prevention**: DONUT locked in LP, immutable contracts
- **Price Manipulation**: Epochs limit rapid price swings
- **Supply Control**: Only Rig can mint Unit tokens
- **Liquidity**: Auto-paired on Uniswap, permissionless trading

## Further Reading

- [Source Code](https://github.com/Heesho/miner-launchpad-foundry)
- [Franchise UI](https://franchise.donutdao.com) *(placeholder)*
- [Launch Strategy Guide](./LAUNCH_STRATEGY.md) *(placeholder)*
- [Bonding Curve Math](./BONDING_CURVES.md) *(placeholder)*
