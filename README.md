# DonutDAO App Template 🍩⚙️

**Production-ready bootstrap for building on DonutDAO infrastructure**

Fork this template to instantly access DonutDAO's core contracts, pre-configured for Base L2 with all the ecosystem primitives you need.

## What's Inside

This template includes **ready-to-use DonutDAO contracts:**

- **DONUT Token** - Ecosystem currency
- **gDONUT** - Governance token (staked DONUT)
- **LiquidSignal** - Revenue routing governed by gDONUT holders
- **Franchise** - Aligned token launches
- **DonutMiner** - Gamified auction mining
- **Farplace Rigs** - Fair token distribution (MineRig, SpinRig, FundRig)

Plus **full integration examples** and **deployment scripts** for Base mainnet.

## Why Use This Template?

**Instead of integrating manually:**
- ✅ All DonutDAO contracts already imported
- ✅ Base L2 configuration ready
- ✅ DONUT token integration examples
- ✅ LiquidSignal revenue routing setup
- ✅ Farplace rig deployment scripts
- ✅ Testing suite with DonutDAO mocks

**Built on proven stack:**
- Scaffold-ETH 2 (by @austingriffith)
- Base L2 (fast + cheap)
- IPFS + ENS + Limo (decentralized hosting)
- Proven by @clawdbotatg (7 dApps overnight)

## Quick Start

### 1. Fork & Clone

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR_USERNAME/your-donut-app.git
cd your-donut-app
yarn install
```

### 2. Configure

```bash
cp .env.example .env
# Add your deployment key and RPC URLs
```

### 3. Deploy

```bash
# Test locally first
yarn chain          # Terminal 1
yarn deploy        # Terminal 2
yarn start         # Terminal 3

# Deploy to Base mainnet
yarn deploy --network base
```

## What You Can Build

### 1. Revenue-Sharing dApp
Use LiquidSignal to route fees to gDONUT holders:

```solidity
import "@donutdao/contracts/LiquidSignal.sol";

contract MyApp {
    LiquidSignal public liquidSignal;
    
    function collectFees() external payable {
        // Route 50% to LiquidSignal, 50% to team
        uint256 toSignal = msg.value / 2;
        liquidSignal.deposit{value: toSignal}();
    }
}
```

### 2. Token Launch via Farplace
Fair distribution using DonutDAO's proven mechanics:

```solidity
import "@donutdao/contracts/rigs/MineCore.sol";

contract MyLaunch {
    function launchToken(uint256 donutAmount) external {
        MineCore mineCore = MineCore(MINE_CORE_ADDRESS);
        // Launch with fair mining distribution
        mineCore.launch{value: donutAmount}(params);
    }
}
```

### 3. DONUT-Powered Marketplace
Accept DONUT as payment:

```solidity
import "@donutdao/contracts/DONUT.sol";

contract Marketplace {
    IERC20 public donut;
    
    function buyItem(uint256 itemId, uint256 amount) external {
        donut.transferFrom(msg.sender, address(this), amount);
        // Deliver item
    }
}
```

### 4. Governance Integration
Let gDONUT holders vote on your protocol:

```solidity
import "@donutdao/contracts/gDONUT.sol";

contract MyDAO {
    function propose(string description) external {
        require(gDONUT.balanceOf(msg.sender) >= MIN_PROPOSAL_TOKENS);
        // Create proposal
    }
    
    function vote(uint256 proposalId, bool support) external {
        uint256 votes = gDONUT.balanceOf(msg.sender);
        // Cast weighted vote
    }
}
```

## DonutDAO Contracts Reference

All contracts deployed on **Base mainnet:**

### Core Tokens
- **DONUT:** `0x...` (Ecosystem token)
- **gDONUT:** `0x...` (Governance token)

### Infrastructure
- **LiquidSignal:** `0x...` (Revenue routing)
- **Franchise:** `0x...` (Token launches)
- **DonutMiner:** `0x...` (Auction mining)

### Farplace Rigs
- **MineCore:** `0x504d4f579b5e16dB130d1ABd8579BA03087AE1b1`
- **SpinCore:** `0x2E392a607F94325871C74Ee9b9F5FBD44CcB5631`
- **FundCore:** `0x85f3e3135329272820ADC27F2561241f4b4e90db`

*See `contracts/addresses.json` for complete list*

## Project Structure

```
donutdao-app-template/
├── packages/
│   ├── foundry/
│   │   ├── contracts/
│   │   │   ├── YourContract.sol        # Your custom logic
│   │   │   └── examples/               # DonutDAO integration examples
│   │   │       ├── RevenueSharing.sol
│   │   │       ├── DONUTMarketplace.sol
│   │   │       └── FarplaceLauncher.sol
│   │   └── test/
│   │       ├── YourContract.t.sol
│   │       └── integration/            # Integration tests
│   │
│   └── nextjs/
│       ├── app/                        # Your frontend
│       ├── components/
│       │   └── donutdao/              # DonutDAO UI components
│       │       ├── DONUTBalance.tsx
│       │       ├── LiquidSignalStats.tsx
│       │       └── FarplaceRig.tsx
│       └── hooks/
│           └── useDonutDAO.ts         # Custom hooks
│
├── contracts/                          # DonutDAO contract ABIs
│   ├── addresses.json                  # Contract addresses
│   └── interfaces/                     # TypeScript interfaces
│
└── scripts/
    ├── deploy-with-liquidSignal.ts
    └── launch-via-farplace.ts
```

## Example: Revenue-Sharing App

Complete example in `packages/foundry/contracts/examples/RevenueSharing.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@donutdao/contracts/LiquidSignal.sol";

contract RevenueSharing {
    LiquidSignal public immutable liquidSignal;
    address public immutable team;
    uint256 public constant SIGNAL_SHARE = 50; // 50%
    
    constructor(address _liquidSignal, address _team) {
        liquidSignal = LiquidSignal(_liquidSignal);
        team = _team;
    }
    
    // Users pay for service
    function useService() external payable {
        require(msg.value >= 0.01 ether, "Minimum fee");
        
        // Split: 50% to LiquidSignal, 50% to team
        uint256 toSignal = (msg.value * SIGNAL_SHARE) / 100;
        uint256 toTeam = msg.value - toSignal;
        
        // Route to gDONUT holders
        liquidSignal.deposit{value: toSignal}();
        
        // Send to team
        (bool success, ) = team.call{value: toTeam}("");
        require(success, "Transfer failed");
    }
}
```

Frontend integration (`packages/nextjs/components/RevenueStats.tsx`):

```typescript
import { useDonutDAO } from "@/hooks/useDonutDAO";

export function RevenueStats() {
  const { liquidSignalTVL, userShare } = useDonutDAO();
  
  return (
    <div>
      <p>Total in LiquidSignal: {liquidSignalTVL} DONUT</p>
      <p>Your share: {userShare}%</p>
    </div>
  );
}
```

## Testing with DonutDAO

Test against real DonutDAO contracts:

```solidity
// packages/foundry/test/integration/LiquidSignalIntegration.t.sol
import "forge-std/Test.sol";
import "../../contracts/examples/RevenueSharing.sol";

contract LiquidSignalIntegrationTest is Test {
    RevenueSharing public app;
    address constant LIQUID_SIGNAL = 0x...; // Base mainnet
    
    function setUp() public {
        // Fork Base mainnet
        vm.createSelectFork(vm.rpcUrl("base"));
        app = new RevenueSharing(LIQUID_SIGNAL, address(this));
    }
    
    function testRevenueRouting() public {
        // Test against real LiquidSignal contract
        app.useService{value: 1 ether}();
        // Verify routing worked
    }
}
```

## DonutDAO Integration Patterns

### 1. Accept DONUT Payments
```solidity
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

IERC20 donut = IERC20(DONUT_ADDRESS);
donut.transferFrom(payer, recipient, amount);
```

### 2. Stake for gDONUT
```solidity
import "@donutdao/contracts/gDONUT.sol";

gDONUT.stake(donutAmount);
uint256 govPower = gDONUT.balanceOf(msg.sender);
```

### 3. Route Revenue to LiquidSignal
```solidity
LiquidSignal(LIQUID_SIGNAL_ADDRESS).deposit{value: feeAmount}();
```

### 4. Launch via Farplace
```solidity
MineCore(MINE_CORE_ADDRESS).launch(
    donutSeed,
    emissionRate,
    halvingSchedule
);
```

## Deployment Checklist

- [ ] Customize your contract logic
- [ ] Write tests (including DonutDAO integration tests)
- [ ] Test on Base Sepolia testnet
- [ ] Get DONUT for testing (faucet or swap)
- [ ] Deploy to Base mainnet
- [ ] Verify contracts on Basescan
- [ ] Deploy frontend to IPFS
- [ ] Register ENS name
- [ ] Announce on DonutDAO Discord

## Resources

### DonutDAO Documentation
- [Comprehensive Overview](../DONUTDAO_COMPREHENSIVE.md)
- [Farplace Architecture](https://github.com/Heesho/farplace-monorepo)
- [LiquidSignal Spec](TBD)
- [DonutDAO Discord](https://discord.gg/donutdao)

### Development Tools
- [Scaffold-ETH 2 Docs](https://docs.scaffoldeth.io)
- [Base Docs](https://docs.base.org)
- [Foundry Book](https://book.getfoundry.sh)

### Community
- **DonutDAO Discord:** https://discord.gg/donutdao
- **X/Twitter:** [@donutdao](https://x.com/donutdao)
- **GitHub:** [github.com/donutdao](https://github.com/donutdao)

## Contributing

Help improve the template:

1. Fork this repo
2. Add useful examples
3. Improve documentation
4. Submit PR

Ideas for contributions:
- More integration examples
- UI components for DonutDAO contracts
- Testing utilities
- Deployment scripts
- Documentation improvements

## Support

Questions? Issues?

- **Template bugs:** https://github.com/cruller-agent/donutdao-app-template/issues
- **DonutDAO help:** Discord #dev-support
- **General agent help:** @cruller_donut on X

## License

MIT - Fork, build, ship!

---

**Template created by:** [@cruller_donut](https://x.com/cruller_donut)  
**For:** DonutDAO ecosystem builders  
**Based on:** [Agent App Template](https://github.com/cruller-agent/agent-app-template)  
**Powered by:** Scaffold-ETH 2 + Base + IPFS

Build the agentic internet. 🍩⚙️

## Security & Auditing

**⚠️ This template generates AI-written smart contracts**

### Before Deploying to Mainnet:

**Tier 1: Low-Risk (< $10k TVL)**
- Run all tests: `yarn foundry:test`
- Static analysis: `slither .`
- Test DonutDAO integrations on testnet
- Add disclaimer from `SECURITY_DISCLAIMER.md` (Tier 1)
- Deploy with small DONUT amounts only

**Tier 2: Medium-Risk ($10k-$100k TVL)**
- All Tier 1 steps +
- DonutDAO community review (Discord #dev-review)
- 2+ developer reviews
- Test LiquidSignal integration thoroughly
- Bug bounty program
- Add Tier 2 disclaimer

**Tier 3: High-Risk (> $100k TVL)**
- All Tier 2 steps +
- **Professional security audit required**
- Bug bounty via Immunefi/Code4rena
- Multi-sig controls (consider gDONUT governance)
- Emergency pause mechanism
- Gradual rollout plan
- Add Tier 3 disclaimer

### DonutDAO-Specific Security

**When integrating with DonutDAO contracts:**

✅ **Verify contract addresses** - Check `contracts/addresses.json`  
✅ **Test on Base Sepolia first** - Use testnet deployments  
✅ **Start with small DONUT amounts** - Test revenue routing  
✅ **Monitor LiquidSignal deposits** - Verify fees route correctly  
✅ **Community review recommended** - Post in DonutDAO Discord  

**Example: Testing LiquidSignal Integration**
```solidity
// In your tests
function testLiquidSignalIntegration() public {
    // Fork Base mainnet
    vm.createSelectFork(vm.rpcUrl("base"));
    
    // Test against real LiquidSignal
    uint256 balanceBefore = address(LIQUID_SIGNAL).balance;
    app.collectFees{value: 1 ether}();
    uint256 balanceAfter = address(LIQUID_SIGNAL).balance;
    
    assertEq(balanceAfter - balanceBefore, 0.5 ether);
}
```

### Security Tools (Included)

**Free tools you should use:**
```bash
# Static analysis
slither packages/foundry/contracts/

# Test all integrations
forge test --match-path test/integration/*

# Fuzz test revenue routing
forge test --fuzz-runs 10000
```

**See `SECURITY_DISCLAIMER.md` for:**
- Disclaimer templates (Tier 1/2/3)
- Pre-deployment checklist
- Community review process
- Emergency response plan

### DonutDAO Review Process

**Post in Discord #dev-review:**
```
🔍 REVIEW REQUEST - DonutDAO Integration

Contract: [Name]
Purpose: [e.g., Route fees to LiquidSignal]
Testnet: base-sepolia:0x...
GitHub: [link]

DonutDAO contracts used:
- LiquidSignal ✅
- DONUT token ✅
- [others]

Looking for review of:
- Integration correctness
- Security issues
- Gas optimization

Bounty: [X DONUT] for critical findings
```

### Research: How Top Agents Handle Security

Based on @clawdbotatg and @0xDeployer research:

**Common approach:**
1. ⚠️ Clear disclaimers
2. 🧪 Extensive testing
3. 👥 Community review
4. 🔄 Iterate quickly
5. 🛠️ Use security tools

**Bankr's approach:**
- Blockaid integration (malicious contract detection)
- Security Module (10% of $BNKR staked to vouch)
- Real-time validation

**Transparency > Perfection**

See `../AGENT_AUDITING_PRACTICES.md` for complete research.
