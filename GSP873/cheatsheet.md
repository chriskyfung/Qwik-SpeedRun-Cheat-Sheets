# GSP873 Block.one: Getting Started with the EOSIO Blockchain

_last updated on 2021-09-16_

## Create a virtual machine using the Google Cloud Console

```bash
gcloud compute instances create my-vm-1 \
    --image-family=ubuntu-1804-lts \
    --image-project=ubuntu-os-cloud	\
    --machine-type=n1-standard-2

gcloud compute ssh my-vm-1
```

> Create a virtual machine using the Google Cloud Console

## Install the EOSIO platform

In the SSH shell,

```bash
wget https://github.com/EOSIO/eos/releases/download/v2.0.9/eosio_2.0.9-1-ubuntu-18.04_amd64.deb
sudo apt install ./eosio_2.0.9-1-ubuntu-18.04_amd64.deb
```

```bash
nodeos --version
cleos version client
keosd -v

nodeos -e -p eosio --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --contracts-console >> nodeos.log 2>&1 &

```

> Install the EOSIO platform
^
> Run a local single node blockchain

## Create wallet + Add the EOSIO system account private key to the new wallet

```bash
cleos wallet create --name my_wallet --file my_wallet_password

cat my_wallet_password

export wallet_password=$(cat my_wallet_password)
echo $wallet_password

cleos wallet list

cleos wallet open --name my_wallet

cleos wallet unlock --name my_wallet --password $wallet_password

cleos wallet import --name my_wallet --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

wget https://github.com/eosio/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
sudo apt install ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
eosio-cpp --version

cleos wallet open --name my_wallet

export wallet_password=$(cat my_wallet_password)
echo $wallet_password

cleos wallet unlock --name my_wallet --password $wallet_password
cleos create key --file my_keypair1

export my_private_key=$(cat my_keypair1 | grep -ioP 'Private key: \K.*')
echo $my_private_key
cleos wallet import --name my_wallet --private-key $my_private_key

export my_public_key=$(cat my_keypair1 | grep -ioP 'Public key: \K.*')
echo $my_public_key

cleos create account eosio bob $my_public_key
```

> Create wallet
^
> Add the eosio system account private key to the new wallet
^
> Install the EOSIO Contract Development Toolkit (CDT)
^
> Create a blockchain account
