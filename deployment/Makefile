.PHONY: setup compile clean

setup:
	@echo "Installing dependencies..."
	npm install

compile:
	@echo "WARNING: MAKE SURE YOU HAVE SET THE .env FILE CORRECTLY"
	@echo "Compiling smart contracts..."
	npx hardhat compile

deploy: compile
	@echo "Deploying smart contracts..."
	npx hardhat run script/deploy.js --network bsctest

verify:
	@echo "Verifying smart contracts..."
	@read -p "Enter contract address: " CONTRACT_ADDR; \
	npx hardhat verify --network bsctest --constructor-args-path constructor-args.js $$CONTRACT_ADDR

clean:
	@echo "Cleaning up..."
	rm -rf node_modules
	rm -rf artifacts
	rm -rf cache