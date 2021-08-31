# Energi Gen 3 Core Node in a Docker container using Docker Compose

This repository is meant to ease running Energi Gen 3 Core Node in a Docker
container using [Docker Compose](https://docs.docker.com/compose/) and the
official
[Energi Gen 3 image](https://hub.docker.com/r/energicryptocurrency/energi3).

This repository was created with staking in mind. More adjustments may be
necessary to run containerised Energi Gen 3 Core Node as a Masternode.

---

- [Prerequisites](#prerequisites)
- [Run Energi Core Node](#run-energi-core-node)
- [Troubleshooting](#troubleshooting)
  - [Apply preimages](#apply-preimages)
  - [Bootstrap chaindata](#bootstrap-chaindata)
- [Energi Core Node Monitor](#energi-core-node-monitor)
- [Update](#update)
- [Helper script](#helper-script)
- [Credits](#credits)

---

## Prerequisites

Requirements to run a Energi 3 Core Node in a Docker container:

- [Docker](https://docs.docker.com/engine/install/);
- [Docker Compose](https://docs.docker.com/compose/install/);
- enough free space to store blockchain data (at the end of August 2021 size of
  the data directory `.energicore3` is roughly 40 GB).

## Run Energi Core Node

To run Energi Gen 3 Core Node in a Docker container:

- clone this git repository:
  `git clone https://github.com/eandersons/energi3-docker-compose.git`;
- create the following files:

  - `configs/energi3_account_address` that contains the Energi Gen 3 account
    address;

    to add multiple accounts for staking, they must be specified as a comma
    separated list of addresses;

  - `configs/energi3_account_password` that contains the Energi Gen 3 account
    password;

    to use multiple accounts for staking each password must be entered in a
    separate line in the same order addresses are specified in
    `configs/energi3_account_address`; these files are used to get account's
    address and password to automatically unlock account for staking when
    launching Energi Gen 3 Core Node;

- copy keystore file to `setup/.energicore3/keystore`;

  > Note: a copy of keystore file should be stored in a safe place as the
  > keystore file that will be placed in `setup/.energicore/keystore` will be
  > moved to a Docker volume.

- open the necessary ports for external inbound access in router and/or
  firewall:

  - `39797` TCP;
  - `39797` UDP;

  `39797` TCP and UDP ports are required for staking and Masternode as it is
  mentioned
  [here (section "1.7. Firewall Rules")](https://wiki.energi.world/en/advanced/core-node-vps#h-17-firewall-rules);

- optionally, to change the Docker Compose project name, `.env.template.env`
  should be copied and renamed to `.env` and if needed the value for
  [the CLI variable `COMPOSE_PROJECT_NAME`](https://docs.docker.com/compose/reference/envvars/#compose_project_name)
  should be changed to the desired value; by default `.env` with the content of
  `.env.template.env` will be created automatically;
- optionally, the Energi Core Node Monitor container can be enabled;
  instructions on how to do it can be found in
  [`nodemon/ReadMe.md`](nodemon/ReadMe.md);
- to move keystore file to the Energi data directory volume, bootstrap chaindata
  and start the Energi Gen 3 Core Node container the following command should be
  executed: `./e3dc setup core` (or `./e3dc setup` if Energi Core Node Monitor
  container should be set up and started as well and all the neccessary
  preparation for it has been done);

  > `docker-compose` is used in `./e3dc setup` so `sudo` might be necessary.

The aforementioned actions must be executed only once - when running Energi Core
Node container for the first time. Later on container can be started with the
command `docker-compose up --detach` or with the helper command `./e3dc start`.

To check if Energi Core Node is running and account is unlocked for staking, the
command `./e3dc status` should be executed. When Energi Core Node is fully
synchronised, value under `nrg.syncing:` is `false` and value for `miner` and
`staking` in the output under `miner.stakingStatus():` is `true`. If not, a
block synchronisation might be in progress and `./e3dc status` should be
executed after a while again to check if Energi Core Node is syncrhonised.

## Troubleshooting

General troubleshooting is described in the official
[Energi troubleshooting guide](https://wiki.energi.world/en/core-node-troubleshoot).

The following actions executed one by one might help if something goes sideways
with chain synchronisation in Energi Gen 3 Core Node container:

1. [apply preimages](#apply-preimages);

   if the problem is not solved, the next step should be executed;

2. [bootstrap chaindata](#bootstrap-chaindata).

If applying preimages and bootstraping chaindata did not help, it might help if
those actions are executed again.
[Energi support](https://wiki.energi.world/en/support/help-me) should be
contacted if the problem is still persistent after multiple tries.

### Apply preimages

Official Energi documentation:
[Apply Preimages](https://wiki.energi.world/en/core-node-troubleshoot#preimages).

To apply preimages for Energi Gen 3 Core Node container the following command
can be used: `./e3dc apply-preimages`.

> `docker-compose` is used in `./e3dc apply-preimages` so `sudo` might be
> necessary.

### Bootstrap chaindata

Official Energi documentation:
[Bootstrap Chaindata](https://wiki.energi.world/en/core-node-troubleshoot#bootstrap).

To bootstrap chaindata for Energi Core Node container the following command can
be used: `./e3dc bootstrap-chaindata`.

> `docker-compose` is used in `./e3dc bootstrap-chaindata` so `sudo` might be
> necessary.

## Energi Core Node Monitor

It is possible to enable Energi Core Node Monitor. Instructions on how to set it
up are located in [`nodemon/ReadMe.md`](nodemon/ReadMe.md).

## Update

To get changes from the repository and update Energi Core Node images and
containers the command `./e3dc update` should be executed. Or
`./e3dc update core` or `./e3dc update monitor` to update image and container
only for the specified service.

It is possible to build images and create containers for Energi Core Node
versions other than the one specified in `.env.template.env`:
`./e3dc update vX.Y.Z` or `./e3dc update core|monitor vX.Y.Z`. This may be
especially useful for cases when a new version has been released but it has not
been reflected in `.env.template.env` yet to update Energi Core Node (and
Monitor) to the lateset version. Note that there is a chance that this command
will fail (most probably because of an error while building Monitor image when
the newest `energi3` veresion cannot be compiled using the Go version specified
in `nodemon/Dockerfile`), and in such case the following commands should be
executed:

1. `./e3dc start core` to start core container as the image for the newest Core
   version should be already built;
2. `./e3dc update monitor` if Energi Core Node Monitor is used; this will use
   the version that is specified in `.env.template.env`

or `./e3dc update` to use Core and Monitor version specified in
`.env.template.env` till isues are resolved in the repopsitory.

## Helper script

A little helper script `e3dc` is available. To see what it provides,
`./e3dc help` should be executed.

## Credits

A list of tools and sources used in this repository:

- [Docker Engine](https://docs.docker.com/engine/);
- [Docker Compose](https://docs.docker.com/compose/);
- [Energi Docker image](https://hub.docker.com/r/energicryptocurrency/energi3)
  (source:
  [Energi Core GitHub repository](https://github.com/energicryptocurrency/energi3)
  ([`containers/docker/master-alpine/Dockerfile`](https://github.com/energicryptocurrency/energi3/blob/master/containers/docker/master-alpine/Dockerfile)));
- [Energi Core Node Monitor script `nodemon.sh`](https://github.com/energicryptocurrency/energi3-provisioning/blob/master/scripts/linux/nodemon.sh).
