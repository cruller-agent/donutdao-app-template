# DonutDAO Contract Addresses (Base Mainnet)

**Network:** Base (Chain ID: 8453)  
**RPC:** https://mainnet.base.org  
**Explorer:** https://basescan.org  

---

## Core Tokens

### DONUT
**Address:** `0xAE4a37d554C6D6F3E398546d8566B25052e0169C`  
**Type:** ERC20 + ERC20Votes  
**Description:** Primary governance token, mintable only by Miner contract  
**Explorer:** https://basescan.org/address/0xAE4a37d554C6D6F3E398546d8566B25052e0169C

### gDONUT (Governance DONUT)
**Address:** `0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3`  
**Type:** ERC20Votes (non-transferable)  
**Description:** Staked DONUT wrapper that represents voting power in governance  
**Explorer:** https://basescan.org/address/0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3  
**Usage:** Stake DONUT 1:1 to receive gDONUT, use for voting

### DONUT-ETH LP
**Address:** `0xD1DbB2E56533C55C3A637D13C53aeEf65c5D5703`  
**Type:** Uniswap V2 LP Token  
**Description:** DONUT/WETH liquidity pool token  
**Explorer:** https://basescan.org/address/0xD1DbB2E56533C55C3A637D13C53aeEf65c5D5703

---

## Standard Tokens (Base)

### WETH
**Address:** `0x4200000000000000000000000000000000000006`  
**Description:** Wrapped ETH on Base (canonical)

### USDC
**Address:** `0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913`  
**Description:** USD Coin on Base (bridged)

### cbBTC
**Address:** `0xcbB7C0000aB88B473b1f5aFd9ef808440eed33Bf`  
**Description:** Coinbase Wrapped BTC on Base

---

## Mining System

### Miner
**Address:** `0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6`  
**Description:** Core mining contract - bonding curve for DONUT minting  
**Explorer:** https://basescan.org/address/0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6  
**Key Functions:**
- `mint(address to, uint256 amount)` - Mine DONUT by providing ETH
- `quote(uint256 donutAmount)` - Calculate ETH cost for DONUT amount
- `quotePrice()` - Get current price per DONUT
- `getDPS()` - Get current donuts per second emission rate

**Parameters:**
- Initial DPS: 4 DONUT/second
- Halving Period: 30 days
- Tail Emission: 0.01 DONUT/second
- Fee: 20%
- Epoch Period: 1 hour
- Price Multiplier: 2x per epoch

### MinerMulticall
**Address:** `0x3ec144554b484C6798A683E34c8e8E222293f323`  
**Description:** Batch query contract for Miner state  
**Explorer:** https://basescan.org/address/0x3ec144554b484C6798A683E34c8e8E222293f323

---

## Governance (LSG - Liquid Signal Governance)

### Voter
**Address:** `0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6`  
**Description:** Core voting contract - manages strategy voting and revenue distribution  
**Explorer:** https://basescan.org/address/0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6  
**Key Functions:**
- `vote(address[] strategies, uint256[] weights)` - Vote for strategies
- `claimBribes(address[] bribes)` - Claim bribe rewards
- `distribute(address strategy)` - Distribute revenue to strategy
- `addStrategy(...)` - Create new strategy (governance)

### GovernanceToken (gDONUT)
**Address:** `0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3`  
**Description:** Same as gDONUT token above - voting power wrapper  
**Key Functions:**
- `stake(uint256 amount)` - Stake DONUT for voting power
- `unstake(uint256 amount)` - Unstake gDONUT to get DONUT back

### RevenueRouter
**Address:** `0x4799CBe9782265C0633d24c7311dD029090dED33`  
**Description:** Routes protocol revenue to Voter for distribution  
**Explorer:** https://basescan.org/address/0x4799CBe9782265C0633d24c7311dD029090dED33

### BribeFactory
**Address:** `0x29121AF2744D354A9ce9EdCC4E13Bbd89C995Bb7`  
**Description:** Factory for deploying Bribe contracts  
**Explorer:** https://basescan.org/address/0x29121AF2744D354A9ce9EdCC4E13Bbd89C995Bb7

### StrategyFactory
**Address:** `0x6C561686394C5915b877b60aC442aD7aa81F5726`  
**Description:** Factory for deploying Strategy contracts  
**Explorer:** https://basescan.org/address/0x6C561686394C5915b877b60aC442aD7aa81F5726

### LSGMulticall
**Address:** `0x41eA22dF0174cF3Cc09B1469a95D604E1833a462`  
**Description:** Batch query contract for governance state  
**Explorer:** https://basescan.org/address/0x41eA22dF0174cF3Cc09B1469a95D604E1833a462

### DAO Treasury
**Address:** `0x690C2e187c8254a887B35C0B4477ce6787F92855`  
**Description:** DonutDAO treasury address (receives strategy payments)  
**Explorer:** https://basescan.org/address/0x690C2e187c8254a887B35C0B4477ce6787F92855

---

## Active Strategies

### Strategy 0: Buy DONUT
**Strategy:** `0xfb02712c5daa614f7d331D7bcbB8Be254A3ecc3F`  
**Bribe:** `0x91556898904c118c0Ae49F1F19c69c49201FB4f1`  
**BribeRouter:** `0xd81333E47544119829cb9A611C0E6170B316f503`  
**Payment Token:** DONUT (`0xAE4a37d554C6D6F3E398546d8566B25052e0169C`)  
**Receiver:** DAO Treasury  
**Description:** Buy DONUT and send to DAO  

### Strategy 1: Buy DONUT-ETH LP
**Strategy:** `0x26799141c31B051f13A239324c26ef72d82413E5`  
**Bribe:** `0x9A03A63fFf50f86a6D3C37e0aBD1c75f8cAa4151`  
**BribeRouter:** `0x0A72F0982016f2FDBc88e314049F82EC9c030Fd8`  
**Payment Token:** DONUT-ETH LP (`0xD1DbB2E56533C55C3A637D13C53aeEf65c5D5703`)  
**Receiver:** DAO Treasury  
**Description:** Buy DONUT-ETH LP and send to DAO  

### Strategy 2: Buy USDC
**Strategy:** `0xdc4c547EDef2156875E9C1632D00a0B456cfc834`  
**Bribe:** `0x39A52a04b596Fb51d0962Ec6b4287d1Ec844C3f9`  
**BribeRouter:** `0x1bB79f8896a9C693579acC4f0B69ae4F50DA7d7F`  
**Payment Token:** USDC (`0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913`)  
**Receiver:** DAO Treasury  
**Description:** Buy USDC and send to DAO  

### Strategy 3: Buy cbBTC
**Strategy:** `0x4eBa1Ee0A1DAdbd2CdFfc4056fe1e20330A9806A`  
**Bribe:** `0x210a77C8b52FfD7d72a86f565e7C2d18F2BF9fef`  
**BribeRouter:** `0xa2d691F0176c99843961E0424934499945cc0A9C`  
**Payment Token:** cbBTC (`0xcbB7C0000aB88B473b1f5aFd9ef808440eed33Bf`)  
**Receiver:** DAO Treasury  
**Description:** Buy cbBTC and send to DAO  

---

## Franchise (Mineport) - Token Launchpad

### Core
**Address:** `0xA35588D152F45C95f5b152e099647f081BD9F5AB`  
**Description:** Main launchpad contract for deploying new token mining rigs  
**Explorer:** https://basescan.org/address/0xA35588D152F45C95f5b152e099647f081BD9F5AB  
**Key Functions:**
- `launch(LaunchParams)` - Deploy new token with mining rig
- `deployedRigs(uint256)` - Get rig by index
- `rigToUnit(address)` - Get token address for rig
- `rigToLP(address)` - Get LP token address for rig

### Multicall
**Address:** `0x5D16A5EB8Ac507eF417A44b8d767104dC52EFa87`  
**Description:** Batch query contract for franchise state  
**Explorer:** https://basescan.org/address/0x5D16A5EB8Ac507eF417A44b8d767104dC52EFa87

### UniswapV2Router
**Address:** `0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24`  
**Description:** Custom Uniswap V2 router for Franchise  
**Explorer:** https://basescan.org/address/0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24

### UniswapV2Factory
**Address:** `0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6`  
**Description:** Custom Uniswap V2 factory for Franchise  
**Explorer:** https://basescan.org/address/0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6

---

## Usage Examples

### Stake & Vote
```solidity
// 1. Stake DONUT
IERC20(DONUT).approve(gDONUT, amount);
IGovernanceToken(gDONUT).stake(amount);

// 2. Vote for strategies
address[] memory strategies = new address[](1);
strategies[0] = 0xfb02712c5daa614f7d331D7bcbB8Be254A3ecc3F; // Buy DONUT strategy
uint256[] memory weights = new uint256[](1);
weights[0] = 10000; // 100% of voting power

IVoter(VOTER).vote(strategies, weights);
```

### Mine DONUT
```solidity
IMiner miner = IMiner(0xF69614F4Ee8D4D3879dd53d5A039eB3114C794F6);

// Check price
uint256 cost = miner.quote(100 ether); // Cost for 100 DONUT

// Mine DONUT
miner.mint{value: cost}(recipient, 100 ether);
```

### Launch Token
```solidity
ICore core = ICore(0xA35588D152F45C95f5b152e099647f081BD9F5AB);

// Approve DONUT
IERC20(DONUT).approve(address(core), donutAmount);

// Launch
ICore.LaunchParams memory params = ICore.LaunchParams({
    launcher: msg.sender,
    tokenName: "MyToken",
    tokenSymbol: "MTK",
    // ... rest of params
});

(address unit, address rig, address auction, address lp) = core.launch(params);
```

---

## Integration Checklist

When building on DonutDAO:

- [ ] **Import interfaces** from this library
- [ ] **Verify addresses** on BaseScan before mainnet use
- [ ] **Test on Base Sepolia** first (testnet addresses TBD)
- [ ] **Monitor emission schedule** (halvings every 30 days)
- [ ] **Track strategy weights** for governance participation
- [ ] **Handle epoch timing** for mining operations
- [ ] **Implement error handling** for all external calls
- [ ] **Add access controls** for sensitive operations
- [ ] **Consider gas optimization** for batch operations

---

## Resources

- **Documentation:** [docs/](./docs/)
- **Interfaces:** [src/interfaces/](./src/interfaces/)
- **Examples:** [src/examples/](./src/examples/)
- **Source Repos:**
  - [Liquid Signal Governance](https://github.com/Heesho/liquid-signal-governance)
  - [Donut Miner](https://github.com/Heesho/donut-miner)
  - [Franchise](https://github.com/Heesho/miner-launchpad-foundry)

---

**Last Updated:** 2026-02-04  
**Maintained By:** DonutDAO Community
