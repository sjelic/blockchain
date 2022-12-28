./geth --datadir supply-data init genesis.json
./geth --datadir supply-data import export.ldp
cp -f -r keystore supply-data/
./geth --datadir supply-data/ --networkid 12345 --http --http.addr 127.0.0.1 --http.corsdomain "*" --http.api "eth,net,web3,personal" --vmdebug --rpc.txfeecap 0 --allow-insecure-unlock console