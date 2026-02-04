# Liquid Signal Governance (LSG)

## Overview

Liquid Signal Governance is DonutDAO's novel governance mechanism that combines liquid democracy with autonomous revenue distribution. Instead of voting on proposals, gDONUT holders vote to signal which protocols and applications should receive protocol revenue.

## Core Concepts

### 1. Staking & Voting Power

Users stake DONUT tokens to receive gDONUT (Governance DONUT), which represents their voting power.

```solidity
// Stake DONUT to get voting power
IGovernanceToken gDonut = IGovernanceToken(gDonutAddress);
IERC20(donutToken).approve(address(gDonut), amount);
gDonut.stake(amount);

// Your voting power
uint256 votingPower = gDonut.balanceOf(msg.sender);
```

**Key Properties:**
- 1 DONUT → 1 gDONUT
- gDONUT is non-transferable (voting power locked)
- Unstaking returns DONUT 1:1
- gDONUT implements ERC20Votes for delegation

### 2. Strategies

Strategies represent protocols, applications, or initiatives that can receive protocol revenue. Each strategy has:

- **Payment Token**: Token strategy accepts (USDC, WETH, etc.)
- **Payment Receiver**: Address that receives distributions
- **Weight**: Voting power directed to this strategy
- **Bribe**: Contract for vote incentives

```solidity
// View strategy info
IVoter voter = IVoter(voterAddress);
uint256 weight = voter.strategy_Weight(strategyAddress);
uint256 claimable = voter.strategy_Claimable(strategyAddress);
bool isAlive = voter.strategy_IsAlive(strategyAddress);
```

### 3. Voting

Voters allocate their voting power across strategies. Voting weight determines revenue distribution.

```solidity
// Vote for strategies
address[] memory strategies = new address[](2);
strategies[0] = strategy1;
strategies[1] = strategy2;

uint256[] memory weights = new uint256[](2);
weights[0] = 6000; // 60% of voting power
weights[1] = 4000; // 40% of voting power

voter.vote(strategies, weights);
```

**Voting Rules:**
- Weights are in basis points (10000 = 100%)
- Can split votes across multiple strategies
- Votes persist until changed
- Must wait between vote changes (anti-gaming)

### 4. Revenue Distribution

Protocol revenue flows through the system:

1. **Revenue Source** → notifies Voter of new revenue
2. **Voter** → distributes to strategies based on vote weight
3. **Strategies** → receive payment in their designated token
4. **Voters** → earn from bribes on their voted strategies

```solidity
// Distribute revenue to a strategy
voter.distribute(strategyAddress);

// Distribute to all strategies
voter.distributeAll();

// Claim bribe rewards
address[] memory bribes = new address[](1);
bribes[0] = bribeAddress;
voter.claimBribes(bribes);
```

## Advanced Features

### Bribes

Protocols can incentivize votes by depositing rewards in their strategy's bribe contract:

```solidity
IBribe bribe = IBribe(bribeAddress);

// Deposit rewards for voters
IERC20(rewardToken).approve(address(bribe), amount);
bribe.notifyRewardAmount(rewardToken, amount);

// Voters claim proportional to their votes
bribe.getReward(msg.sender, tokens);
```

**Bribe Mechanics:**
- Distributed pro-rata to voters
- Multiple reward tokens supported
- Weekly epochs
- Auto-compounds if configured

### Strategy Lifecycle

**Creating a Strategy:**
```solidity
voter.addStrategy(
    paymentToken,        // Token strategy receives
    paymentReceiver,     // Where payments go
    initPrice,           // Starting price
    epochPeriod,         // Epoch duration
    priceMultiplier,     // Price growth rate
    minInitPrice         // Price floor
);
```

**Killing a Strategy:**
```solidity
// Only governance can kill
voter.killStrategy(strategyAddress);
// Strategy becomes inactive, no longer receives revenue
```

## For Autonomous Agents

### Reading State

```solidity
// Get all strategies
address[] memory allStrategies = voter.getStrategies();

// Check total voting weight
uint256 totalWeight = voter.totalWeight();

// Your current votes
address[] memory myVotes = voter.getStrategyVote(msg.sender);

// Strategy-specific info
uint256 weight = voter.strategy_Weight(strategy);
uint256 pending = voter.getStrategyPendingRevenue(strategy);
address bribe = voter.strategy_Bribe(strategy);
```

### Automation Opportunities

**1. Vote Rebalancing**
```solidity
// Monitor claimable bribes and rebalance votes for max yield
for (uint i = 0; i < strategies.length; i++) {
    uint256 bribes = calculateBribeAPR(strategies[i]);
    uint256 revenue = calculateRevenueAPR(strategies[i]);
    // Optimize vote allocation
}
```

**2. Bribe Harvesting**
```solidity
// Automatically claim bribes across all strategies
address[] memory myBribes = getMyActiveBribes();
voter.claimBribes(myBribes);
```

**3. Revenue Distribution**
```solidity
// Trigger distributions for profitable strategies
if (voter.strategy_Claimable(strategy) > gasThreshold) {
    voter.distribute(strategy);
}
```

## Contract Addresses (Base)

| Contract | Address |
|----------|---------|
| Voter | `0x9C5Cf3246d7142cdAeBBD5f653d95ACB73DdabA6` |
| GovernanceToken (gDONUT) | `0xC78B6e362cB0f48b59E573dfe7C99d92153a16d3` |
| RevenueRouter | `0x4799CBe9782265C0633d24c7311dD029090dED33` |
| LSGMulticall | `0x41eA22dF0174cF3Cc09B1469a95D604E1833a462` |
| DAO | `0x690C2e187c8254a887B35C0B4477ce6787F92855` |

## Security Considerations

- **Vote Locking**: Votes are locked for a period after casting to prevent gaming
- **Revenue Verification**: Only authorized sources can notify revenue
- **Strategy Management**: Only governance can add/kill strategies
- **Bribe Safety**: Bribes are isolated per strategy

## Further Reading

- [Source Code](https://github.com/Heesho/liquid-signal-governance)
- [DonutDAO Docs](https://github.com/donutdao)
- [Voting Strategies](./VOTING_STRATEGIES.md)
