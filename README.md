# Energi Gen 3 Core Node in a Docker container using Docker Compose

This repository is meant to ease running Energi Gen 3 Core Node in a Docker container using [Docker Compose](https://docs.docker.com/compose/) and the official [Energi Gen 3 image](https://hub.docker.com/r/energicryptocurrency/energi3).

This repository was created for staking. More adjustments may be necessary to run containerised Energi Gen 3 Core Node as a Masternode.

---

- [Energi Gen 3 Core Node in a Docker container using Docker Compose](#energi-gen-3-core-node-in-a-docker-container-using-docker-compose)
  - [Run Energi Gen 3 Core Node using `docker-compose`](#run-energi-gen-3-core-node-using-docker-compose)
  - [Troubleshooting](#troubleshooting)
    - [Apply preimages](#apply-preimages)
    - [Bootstrap chaindata](#bootstrap-chaindata)
  - [Update](#update)

---

## Run Energi Gen 3 Core Node using `docker-compose`

To run Energi Gen 3 Core Node in a Docker container:

- clone this git repository: `git clone https://github.com/eandersons/energi3-docker-compose.git`;
- create the following files:
  - `configs/energi3_account_address` that contains the Energi Gen 3 account address;

    to add multiple accounts for staking, they must be specified as a comma separated list of addresses;
  - `configs/energi3_account_password` that contains the Energi Gen 3 account password;

    to use multiple accounts for staking each password must be entered in a separate line in the same order addresses are specified in `configs/energi3_account_address`;

  these files are used to get account's address and password to automatically unlock account for staking when launching Energi Gen 3 Core Node;
- copy keystore file to `volumes/root/.energicore3/keystore`;
- bootstrap chaindata and start the Energi Gen 3 Core Node container: `./bootstrap-chaindata.sh`;
  > `bootstrap-chaindata.sh` should be made executable or it can be run using a shell binary (for example: `bash bootstrap-chaindata.sh`);
  >
  > `docker-compose run` is used in `bootstrap-chaindata.sh` so `sudo` might be necessary.
- open the necessary ports for external inbound access in router and/or firewall:
  - `39797` TCP;
  - `39797` UDP;

  `39797` TCP and UDP ports are required for staking and Masternode as it is mentioned [here (section "1.7. Firewall Rules")](https://docs.energi.software/en/advanced/core-node-vps#h-17-firewall-rules).

To check if Energi Gen 3 Core Node is running and account is unlocked for staking, execute the following commands:

- `docker-compose exec core sh` - this command will open `sh` shell in Energi Gen 3 Core Node container;
- `energi3 attach` will open Energi Core Node console;
- `miner.stakingStatus()` will display staking status;

  values for `miner` and `staking` should be `true`;
  if not, block synchronisation is in progress; it can be checked with the command in Energi Core Node console: `nrg.syncing`; when the output is `false`, check output of `miner.stakingStatus()` again.

## Troubleshooting

General troubleshooting is described in the official [Energi troubleshooting guide](https://docs.energi.software/en/core-node-troubleshoot).

The following actions executed one by one might help if something goes sideways with chain synchronisation in Energi Gen 3 Core Node container:

1. [apply preimages](#apply-preimages);

   if the problem is not solved, the next step should be executed;

2. [bootstrap chaindata](#bootstrap-chaindata).

If applying preimages and bootstraping chaindata did not help, it might help if those actions are executed again. [Energi support](https://docs.energi.software/en/support/help-me) should be contacted if the problem is still persistent after multiple tries.

### Apply preimages

Official Energi documentation: [Apply Preimages](https://docs.energi.software/en/core-node-troubleshoot#preimages).

To apply preimages for Energi Gen 3 Core Node container the following command can be used: `./apply-preimages.sh`.

> This script should be made executable or it can be executed with shell binary (for example: `bash apply-preimages.sh`).
>
> In this script `docker-compose` is used so `sudo` might be necessary.

### Bootstrap chaindata

Official Energi documentation: [Bootstrap Chaindata](https://docs.energi.software/en/core-node-troubleshoot#bootstrap).

To bootstrap chaindata for Energi Core Node container the following command can be used: `./bootstrap-chaindata.sh`.

> This script should be made executable or it can be executed with shell binary (for example: `bash bootstrap-chaindata.sh`).
>
> In this script `docker-compose` is used so `sudo` might be necessary.

## Update

Steps to update Energi Core Node container:

1. stop and remove the Energi Core Node container:
  `docker-compose down`;
2. pull changes from repository:
  `git pull`;
3. build image and start the container:
  `docker-compose up --build --detach`.
