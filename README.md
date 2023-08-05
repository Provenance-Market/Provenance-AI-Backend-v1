1. Configure keys in your `.env`

```.env
SEPOLIA_RPC_URL="RPC URL"
GOERLI_RPC_URL="RPC URL"
PRIVATE_KEY="sepolia testnet api key"
ETHERSCAN_API_KEY="etherscane api key to verify contracts"
```

2. Run `make install` to install packages

3. Run `make DeployProvNFTFactory ARGS="--network sepolia"` to deploy Factory to sepolia
* Or add the `ARGS="--network goerli"` to deploy to goerli

4. Run `forge test` to run all tests
* Or run `forge test --mt <TEST NAME>` to run a specific test
    * e.g., `forge test --mt testNameAndSymbolIsCorrect`
* Add the `-vv` flag to see the console.log statements in the test
    * `forge test --mt testReleaseFundsEvenly -vv`


* `/src` - Contracts 
* `/script` - Deploy Scripts 
* `/test` - Tests
* `Makefile` - commands
