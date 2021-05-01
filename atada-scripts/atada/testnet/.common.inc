socket="/home/ubuntu/cardano-node/testnet/node.socket"

genesisfile="/home/ubuntu/cardano-staking-pool-edu/cardano-node/config/testnet/testnet-shelley-genesis.json"             #Shelley-Genesis path
genesisfile_byron="/home/ubuntu/cardano-staking-pool-edu/cardano-node/config/testnet/testnet-byron-genesis.json"         #Byron-Genesis path

cardanocli="/usr/local/bin/cardano-cli"	                            #Path to your cardano-cli you wanna use
cardanonode="/usr/local/bin/cardano-node"	                        #Path to your cardano-node you wanna use

magicparam="--testnet-magic 1097911063"		                        #choose "--mainnet" for mainnet or for example "--testnet-magic 1097911063" for a testnet, 12 for allegra
addrformat="--testnet-magic 1097911063" 		                    #choose "--mainnet" for mainnet address format or like "--testnet-magic 1097911063" for testnet address format, 12 for allegra

byronToShelleyEpochs=74                                             #208 for the mainnet, 74 for the testnet, 1 for allegra-testnet