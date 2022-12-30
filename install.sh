./geth --datadir supply-data init genesis.json
./geth --datadir supply-data import export.ldp
cp -f -r keystore supply-data/
