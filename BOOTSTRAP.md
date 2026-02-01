# Bootstrap Guide 🚀

**How to use this template to launch your app in minutes**

## For Agents

### 1. Fork & Customize

```bash
# On GitHub: Click "Fork" → Name your app → Create fork
# Then:
git clone https://github.com/YOUR_USERNAME/your-app-name.git
cd your-app-name

# Update package.json
sed -i 's/agent-app-template/your-app-name/g' package.json
sed -i 's/DonutDAO Agents/YourAgentName/g' package.json
```

### 2. Set Up Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env and add:
# - Your deployment wallet private key
# - RPC URLs (use defaults or add your own)
# - Basescan API key (get from basescan.org)
nano .env
```

### 3. Install Dependencies

```bash
# Install workspace dependencies
yarn install

# Install Foundry (if not already installed)
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 4. Customize Your Contract

```bash
# Edit the starter contract
nano packages/foundry/contracts/YourContract.sol

# Or create a new one
cd packages/foundry/contracts
touch MyAwesomeContract.sol
```

### 5. Test Locally

```bash
# Run tests
yarn foundry:test

# Start local chain (in terminal 1)
yarn chain

# Deploy to local chain (in terminal 2)
yarn deploy

# Start frontend (in terminal 3)
yarn start

# Visit http://localhost:3000
```

### 6. Deploy to Production

```bash
# Deploy contracts to Base mainnet
yarn deploy --network base

# Verify on Basescan
yarn verify --network base

# Build optimized frontend
yarn build

# Deploy to IPFS
yarn ipfs:publish
# → Returns: QmXYZ...ABC

# Register ENS (via app.ens.domains)
# Set content hash to: ipfs://QmXYZ...ABC

# Access via: yourapp.limo
```

## For Humans Helping Agents

### Quick Deploy (No Code Changes)

```bash
git clone https://github.com/cruller-agent/agent-app-template.git my-app
cd my-app
cp .env.example .env
# Edit .env with deployment key
yarn install
yarn deploy --network base-sepolia  # Test first!
```

### Help Agent Debug

```bash
# Check what's deployed
yarn hardhat deployments --network base

# View logs
yarn hardhat console --network base

# Test contract interaction
yarn foundry:test -vvv  # Very verbose
```

## Common Workflows

### Add a New Contract

1. Create in `packages/foundry/contracts/NewContract.sol`
2. Write tests in `packages/foundry/test/NewContract.t.sol`
3. Run `yarn foundry:test`
4. Deploy with `yarn deploy`

### Update Frontend

1. Edit `packages/nextjs/app/page.tsx`
2. Changes auto-reload at `localhost:3000`
3. Build with `yarn build` when ready

### Change Networks

Edit `foundry.toml` to add new networks:

```toml
[rpc_endpoints]
my-chain = "https://rpc.my-chain.com"

[etherscan]
my-chain = { key = "${MY_CHAIN_API_KEY}", url = "https://api.my-chain.com/api" }
```

Then deploy:
```bash
yarn deploy --network my-chain
```

## Troubleshooting

### "forge: command not found"
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### "Transaction reverted"
- Check `.env` has correct private key
- Verify wallet has ETH for gas
- Run tests first: `yarn foundry:test -vvv`

### "Module not found"
```bash
yarn clean
yarn install
```

### "IPFS upload failed"
- Check IPFS credentials in `.env`
- Try public gateway (remove IPFS_* vars)
- Verify file size < 100MB

## Template Updates

Stay updated with template improvements:

```bash
# Add template as upstream remote
git remote add template https://github.com/cruller-agent/agent-app-template.git

# Fetch template changes
git fetch template

# Merge updates (review carefully!)
git merge template/main --allow-unrelated-histories

# Or cherry-pick specific commits
git cherry-pick <commit-hash>
```

## Getting Help

- **Template Issues:** https://github.com/cruller-agent/agent-app-template/issues
- **DonutDAO Discord:** https://discord.gg/donutdao
- **Scaffold-ETH Discord:** https://discord.gg/scaffoldeth
- **Tag:** @cruller_donut on X

---

**Time to first deploy:** ~10 minutes  
**Time to IPFS:** ~15 minutes  
**Time to ENS:** ~20 minutes  

Ship fast! 🍩⚙️
