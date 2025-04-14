# Load environment variables
-include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

# List of all available commands
.PHONY: all test clean deploy fund help install snapshot format anvil zktest

# === MAIN TARGETS ===

# Run all key setup steps in sequence
all: clean remove install update build

# Clean the out/ and cache/ dirs
clean:
	forge clean

# Remove existing git submodules and lib folder (for fresh reset)
remove:
	rm -rf .gitmodules
	rm -rf .git/modules/*
	rm -rf lib
	touch .gitmodules
	git add .
	git commit -m "modules"

# Install dependencies: Cyfrin DevOps, Forge Std, OpenZeppelin
install:
	forge install cyfrin/foundry-devops@0.2.2 --no-commit
	forge install foundry-rs/forge-std@v1.8.2 --no-commit
	forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit

# Update all dependencies
update:
	forge update

# Compile all contracts
build:
	forge build

# Run all tests in test/ directory using Forge
test:
	forge test

# Format all .sol files
format:
	forge fmt

# Take a snapshot (for gas reporting)
snapshot:
	forge snapshot

# Run local anvil node (12-word test mnemonic)
anvil:
	anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1


# === ZK SYNC SPECIFIC ===

# Test in zkSync mode
zktest:
	foundryup-zksync
	forge test --zksync
	foundryup


# === NETWORK-AWARE DEPLOYMENTS ===

# Default arguments for local network
NETWORK_ARGS := --rpc-url sepolia --private-key $(PRIVATE_KEY) --broadcast --verify

# If deploying to Sepolia (or another network passed via `ARGS`), override args
ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) \
	                --private-key $(PRIVATE_KEY) \
	                --broadcast \
	                --verify \
	                --etherscan-api-key $(ETHERSCAN_API_KEY) \
	                -vvvv
endif

# Deploy the BasicNft contract (script-based)
deploy:
	@forge script script/DeployBasicNft.s.sol:DeployBasicNft $(NETWORK_ARGS)

# Mint an NFT using the Interactions script
mint:
	@forge script script/Interactions.s.sol:MintBasicNft $(NETWORK_ARGS)

