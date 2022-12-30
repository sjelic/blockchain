
# Instructions

## Installation

To install the applicaction, run `install.sh` script. 

This script will initialize private blockchain network based on genesis.json creating a folder named supply-data. The script will then import pre-existsing blockchain data provided with expord.ldp. Finally, the script will copy the keystore folder with private keys of users to supply-data directory.

## Startup

To start the application, execute `run.sh7 script.

This script will start **Go Ethereum** (geth) application with the active console. In order to write data to the blockchain, geth must be mining. Reading data from the blockchain does not require mining. Console commands for geth regarding mining are:

- `miner.start()` - starts mining
- `miner.stop()` - stops mining

## Dashboard

Once the geth application is running, dashboard can be started by opening the html file: dashboard/dashboard.html with a browser.
