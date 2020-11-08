# Energi Gen 3 Core Node in a Docker container using Docker Compose

This repository is meant to ease running Energi Gen 3 Core Node in a Docker container using [Docker Compose](https://docs.docker.com/compose/) and the official [Energi Gen 3 image](https://hub.docker.com/r/energicryptocurrency/energi3).

This repository was created with a single account staking in mind. More adjustments may be needed to stake using multiple accounts or to use Energi Gen 3 Core Node as a Masternode.
Current solution for staking multiple accounts would be to run multiple containers, but it may be not an ideal solution performance-wise.

## Run Energi Gen 3 Core Node using `docker-compose`

To run Energi Gen 3 Core Node in a Docker container:

- clone this git repository: `git clone https://github.com/eandersons/energi3-docker-compose.git`;
- create the following files:
  - `configs/energi3_account_address` that contains the Energi Gen 3 account address;
  - `configs/energi3_account_password` that contains the Energi Gen 3 account password;

  these files are used to get account's address and password to automatically unlock account for staking when launching Energi Gen 3 Core Node;
- copy keystore file to `/path/to/energi3-docker-compose/volumes/root/.energicore3/keystore`;
- create and start Docker container using `docker-compose` (`sudo` may be necessary to use `docker-compose`):

  ``` sh
  cd /path/to/energi3-provisioning/Docker
  docker-compose up --detach
  ```

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
