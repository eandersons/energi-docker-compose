# Energi Gen 3 Core Node in a Docker container using Docker Compose

This repository is meant to ease running Energi Gen 3 Core Node in a Docker container using [Docker Compose](https://docs.docker.com/compose/) and the official [Energi Gen 3 image](https://hub.docker.com/r/energicryptocurrency/energi3).

This repository was created with staking in mind. More adjustments may be necessary to run containerised Energi Gen 3 Core Node as a Masternode.

---

- [Prerequisites](#prerequisites)
- [Run Energi Gen 3 Core Node using `docker-compose`](#run-energi-gen-3-core-node-using-docker-compose)
- [Troubleshooting](#troubleshooting)
  - [Apply preimages](#apply-preimages)
  - [Bootstrap chaindata](#bootstrap-chaindata)
- [Energi Core Node Monitor](#energi-core-node-monitor)
- [Update](#update)
- [Credits](#credits)

---

## Prerequisites

Requirements to run a Energi 3 Core Node in a Docker container:

- [Docker](https://docs.docker.com/engine/install/);
- [Docker Compose](https://docs.docker.com/compose/install/);
- enough free space to store blockchain data (as of mid April 2021 size of the data directory `.energicore3` is roughly 30 GB).

## Run Energi Gen 3 Core Node using `docker-compose`

To run Energi Gen 3 Core Node in a Docker container:

- clone this git repository: `git clone https://github.com/eandersons/energi3-docker-compose.git`;
- create the following files:
  - `configs/energi3_account_address` that contains the Energi Gen 3 account address;

    to add multiple accounts for staking, they must be specified as a comma separated list of addresses;
  - `configs/energi3_account_password` that contains the Energi Gen 3 account password;

    to use multiple accounts for staking each password must be entered in a separate line in the same order addresses are specified in `configs/energi3_account_address`;

  these files are used to get account's address and password to automatically unlock account for staking when launching Energi Gen 3 Core Node;
- copy keystore file to `setup/.energicore3/keystore`;
  > Note: a copy of keystore file should be stored in a safe place as the keystore file that will be placed in `setup/.energicore/keystore` will be moved to a Docker volume.
- open the necessary ports for external inbound access in router and/or firewall:
  - `39797` TCP;
  - `39797` UDP;

  `39797` TCP and UDP ports are required for staking and Masternode as it is mentioned [here (section "1.7. Firewall Rules")](https://docs.energi.software/en/advanced/core-node-vps#h-17-firewall-rules);
- optionally, to change the Docker Compose project name, `.env.template.env` should be copied and renamed to `env` and the value for [the CLI variable `COMPOSE_PROJECT_NAME`](https://docs.docker.com/compose/reference/envvars/#compose_project_name) should be changed to the desired value;
- to move keystore file to the Energi data directory volume, bootstrap chaindata and start the Energi Gen 3 Core Node container the following command should be executed: `./setup.sh`;
  > `setup.sh` should be made executable or it can be run using a shell binary (for example: `[ba]sh setup.sh`);
  >
  > `docker-compose run` and `docker-compose up` is used in `setup.sh` so `sudo` might be necessary.

The aforementioned actions must be executed only once - when running Energi Core Node coneainer for the first time. Later on container can be started with the command `docker-compose up --detach`.

To check if Energi Gen 3 Core Node is running and account is unlocked for staking, execute the following commands:

- `docker-compose exec core sh` - this command will open `sh` shell in Energi Gen 3 Core Node container;
- `energi3 attach` will open Energi Core Node console;
- `miner.stakingStatus()` will display staking status;

  values for `miner` and `staking` should be `true`;
  if not, block synchronisation might be in progress; it can be checked with the command in Energi Core Node console: `nrg.syncing`; when the output is `false`, check output of `miner.stakingStatus()` again.

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

> This script should be made executable or it can be executed with shell binary (for example: `[ba]sh apply-preimages.sh`).
>
> In this script `docker-compose` is used so `sudo` might be necessary.

### Bootstrap chaindata

Official Energi documentation: [Bootstrap Chaindata](https://docs.energi.software/en/core-node-troubleshoot#bootstrap).

To bootstrap chaindata for Energi Core Node container the following command can be used: `./bootstrap-chaindata.sh`.

> This script should be made executable or it can be executed with shell binary (for example: `[ba]sh bootstrap-chaindata.sh`).
>
> In this script `docker-compose` is used so `sudo` might be necessary.

## Energi Core Node Monitor

It is possible to enable Energi Core Node Monitor. Instructions on how to set it up are located in [nodemon/ReadMe.md](nodemon/ReadMe.md).

## Update

Steps to update Energi Core Node container:

1. to pull changes from repository:
  `git pull`;
2. to build image and recreate and run the container:
  `docker-compose up --build --force-recreate --detach`.

## Credits

A list of tools and sources used in this repository:

- [Docker Engine](https://docs.docker.com/engine/);
- [Docker Compose](https://docs.docker.com/compose/);
- [Energi Docker image](https://hub.docker.com/r/energicryptocurrency/energi3) (source: [Energi Core GitHub repository](https://github.com/energicryptocurrency/energi3) ([`containers/docker/master-alpine/Dockerfile`](https://github.com/energicryptocurrency/energi3/blob/master/containers/docker/master-alpine/Dockerfile))).
