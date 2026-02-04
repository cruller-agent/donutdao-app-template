# Donut Miner

## Overview

The Donut Miner is an autonomous token minting mechanism that uses a bonding curve to determine DONUT price dynamically. It implements Bitcoin-style halvings and tail emissions to create a predictable, deflationary supply schedule.

## How It Works

### Bonding Curve Minting

Users provide ETH to "mine" DONUT tokens. Price increases with each epoch based on demand:

```solidity
IMiner miner = IMiner(minerAddress);

// Check current price
uint256 currentPrice = miner.quotePrice();

// Calculate cost for specific amount
uint256 cost = miner.quote(100 ether); // Cost for 100 DONUT

// Mine DONUT
miner.mint{value: cost}(recipient, 100 ether);
```

**Price Formula:**
```
Price per DONUT = initPrice * (PRICE_MULTIPLIER ^ epochId)
```

Where:
- `initPrice`: Starting price (adjustable by miner)
- `PRICE_MULTIPLIER`: 2x (doubles each epoch)
- `epochId`: Current epoch number

### Epoch System

Mining operates in discrete epochs:

```solidity
// Constants
uint256 EPOCH_PERIOD = 1 hour;
uint256 PRICE_MULTIPLIER = 2e18; // 2x per epoch
uint256 MIN_INIT_PRICE = 0.0001 ether;

// Get current epoch
uint256 currentEpoch = miner.getCurrentEpochId();
```

**Epoch Mechanics:**
- New epoch starts every hour
- Price resets to `initPrice` at start of epoch
- Price doubles each epoch within the hour
- Miner can adjust `initPrice` between epochs

### Emission Schedule

DONUT follows a halving schedule similar to Bitcoin:

```solidity
// Constants
uint256 INITIAL_DPS = 4 ether;      // 4 DONUT/second initially
uint256 HALVING_PERIOD = 30 days;   // Halve every 30 days
uint256 TAIL_DPS = 0.01 ether;      // Floor emission

// Current emission rate
uint256 currentDPS = miner.getDPS();
```

**Emission Formula:**
```
DPS = max(INITIAL_DPS / (2 ^ halvings), TAIL_DPS)
```

Where `halvings = (block.timestamp - startTime) / HALVING_PERIOD`

### Fees

20% fee on all mining operations:

```solidity
uint256 FEE = 2_000;      // 2000 basis points
uint256 DIVISOR = 10_000; // 100%

// Net DONUT = (donutAmount * (DIVISOR - FEE)) / DIVISOR
```

Fees are sent to the treasury address.

## Usage Examples

### Basic Mining

```solidity
IMiner miner = IMiner(0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6);

// Mine 10 DONUT
uint256 cost = miner.quote(10 ether);
require(msg.value >= cost, "Insufficient ETH");

miner.mint{value: cost}(msg.sender, 10 ether);
```

### Price Monitoring

```solidity
// Get current mining price
uint256 minerPrice = miner.quotePrice();

// Compare to market price (from DEX)
uint256 marketPrice = getMarketPrice();

// Mine if profitable
if (minerPrice < marketPrice * 95 / 100) { // 5% buffer
    miner.mint{value: minerPrice}(recipient, amount);
}
```

### Emission Tracking

```solidity
// Calculate current halvings
uint256 elapsed = block.timestamp - miner.startTime();
uint256 halvings = elapsed / miner.HALVING_PERIOD();

// Predict next halving
uint256 nextHalvingIn = miner.HALVING_PERIOD() - (elapsed % miner.HALVING_PERIOD());
uint256 nextHalvingAt = block.timestamp + nextHalvingIn;

// Current emission rate
uint256 dps = miner.getDPS();
uint256 dailyEmission = dps * 86400; // Donuts per day
```

## For Autonomous Agents

### Arbitrage Opportunities

```solidity
// Monitor miner vs DEX price
function checkArbitrage() public view returns (bool profitable, uint256 profit) {
    uint256 minerPrice = miner.quotePrice();
    uint256 dexPrice = getDEXPrice(); // Query Uniswap/Aerodrome
    
    if (minerPrice < dexPrice) {
        profitable = true;
        profit = dexPrice - minerPrice;
    }
}

// Execute arbitrage
function executeArbitrage(uint256 donutAmount) external {
    uint256 cost = miner.quote(donutAmount);
    
    // Mine DONUT
    miner.mint{value: cost}(address(this), donutAmount);
    
    // Sell on DEX
    sellOnDEX(donutAmount);
}
```

### Optimal Mining Times

```solidity
// Mine at start of epoch when price is lowest
function shouldMine() public view returns (bool) {
    uint256 currentEpoch = miner.getCurrentEpochId();
    uint256 epochStartTime = miner.epochStartTime();
    
    // Mine in first 10 minutes of epoch
    return block.timestamp < epochStartTime + 10 minutes;
}
```

### Supply Modeling

```solidity
// Calculate total supply at future timestamp
function projectSupply(uint256 timestamp) public view returns (uint256) {
    uint256 elapsed = timestamp - miner.startTime();
    uint256 halvings = elapsed / miner.HALVING_PERIOD();
    
    uint256 supply = 0;
    uint256 periodLength = miner.HALVING_PERIOD();
    
    // Sum each halving period
    for (uint i = 0; i <= halvings; i++) {
        uint256 dps = miner.INITIAL_DPS() / (2 ** i);
        if (dps < miner.TAIL_DPS()) dps = miner.TAIL_DPS();
        
        uint256 duration = (i == halvings) 
            ? elapsed % periodLength 
            : periodLength;
            
        supply += dps * duration;
    }
    
    return supply;
}
```

## Advanced Features

### Miner Role

The "miner" address (different from Miner contract) can adjust parameters:

```solidity
// Only callable by miner address
miner.setInitPrice(newInitPrice); // Adjust epoch starting price
miner.setMiner(newMiner);         // Transfer miner role
miner.setTreasury(newTreasury);   // Change fee recipient
```

### Secondary Market (Auction)

Mining rights can be auctioned:

```solidity
// Check if auction is active
bool auctionActive = auction.isActive();

// Bid on mining rights
auction.bid{value: bidAmount}();

// Winner gets privileged mining access
```

## Contract Addresses (Base)

| Contract | Address |
|----------|---------|
| Miner | `0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6` |
| DONUT Token | `0xAE4a37d554C6D6F3E398546d8566B25052e0169C` |
| MinerMulticall | `0x3ec144554b484C6798A683E34c8e8E222293f323` |

## Key Metrics

### Current State (as of launch)
- **Initial DPS**: 4 DONUT/second
- **Halving Period**: 30 days
- **Epoch Period**: 1 hour
- **Price Multiplier**: 2x per epoch
- **Fee**: 20%

### Supply Schedule
| Days | Halvings | DPS | Daily Emission |
|------|----------|-----|----------------|
| 0-30 | 0 | 4.0 | 345,600 |
| 31-60 | 1 | 2.0 | 172,800 |
| 61-90 | 2 | 1.0 | 86,400 |
| 91-120 | 3 | 0.5 | 43,200 |
| 121+ | 4+ | 0.25→0.01 | 21,600→864 |

### Cumulative Supply
- After 1 year: ~59M DONUT
- After 2 years: ~67M DONUT
- Long-term: ~70M DONUT (tail emissions)

## Security Considerations

- **Price Manipulation**: Epochs limit rapid price changes
- **Fee Bypass**: All minting goes through Miner contract
- **Supply Control**: Only Miner can mint DONUT
- **Reentrancy**: Protected by OpenZeppelin patterns

## Further Reading

- [Source Code](https://github.com/Heesho/donut-miner)
- [DONUT Tokenomics](./TOKENOMICS.md)
- [Bonding Curve Analysis](./BONDING_CURVES.md)
