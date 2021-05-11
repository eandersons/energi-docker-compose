# Energi Core Node Monitor for `energi3-docker-compose`

Dockerised Energi Core Node Monitor for the dockerised Energi Core Node.

---

- [Enable the Energi Core Node Monitor service](#enable-the-energi-core-node-monitor-service)
  - [Environment variables](#environment-variables)

---

## Enable the Energi Core Node Monitor service

To enable Energi Core Node Monitor, `docker-compose.override.template.yml` has to be copied in the root directory and renamed to `docker-compose.override.yml`. Then `nodemon/.env.template.env` must be copied and renamed to `.env` and values should be provided for environment variables when a non-interactive setup is used (`INTERACTIVE_SETUP=n`). All the environment variables are described in [the subsection below](#environment-variables).

To setup Energi Core Node Monitor container, command `sh configure-nodemon.sh` must be executed from the root directory (where `docker-compose.yml` is located).

> `docker-compose` is used in `configure-nodemon.sh` so `sudo` might be necessary.

After the setup Energi Core Node Monitor container can be started with the command `docker-compose up --detach`.

> After the Energi Core Node Monitor container is launched for the first time or it is recreated, a message about user and group changes will be sent.

### Environment variables

`.env` contains environment variables that are used to set up Energi Core Node Monitor in a non-interactive mode (`INTERACTIVE_SETUP=n`). All of them are optional and almost all of them are used only in the configuration run.

- `DISCORD_WEBHOOK_CHANGE`: when `INTERACTIVE_SETUP=n`, value `y`  indicates that the existing Discord webhooks should be replaced with the value of the following environment variables if the Energi Core Node Monitor has already been set up:
  - `DISCORD_WEBHOOK_ERROR`;
  - `DISCORD_WEBHOOK_INFORMATION`;
  - `DISCORD_WEBHOOK_SUCCESS`;
  - `DISCORD_WEBHOOK_WARNING`;
- the following environment values are for Discord webhook addresses:
  - `DISCORD_WEBHOOK_ERROR`;
  - `DISCORD_WEBHOOK_INFORMATION`;
  - `DISCORD_WEBHOOK_SUCCESS`;
  - `DISCORD_WEBHOOK_WARNING`;

  one webhook can be used for all message types;

  more detailed instructions on how to set up Discord to receive messages from the Energi Core Node Monitor are in [the official Energi Core Node Monitoring Tool guide (section "Setup Discord")](https://docs.energi.software/en/advanced/nodemon#discord);
  these ene
- `ECNM_CURRENCY`: the currency to be used in messages about wallet balance;

  if not set, `USD` will be used;
- `ECNM_INTERVAL`: an interval between two subsequent Energi Core Node Monitor runs;
  the following suffixes can be used to specify the desired time units:
  - `s` or no suffix for seconds;
  - `m` for minutes;
  - `h` for hours;
  - `d` for days;

  when this environment is not defined or it's value is not specified, the default interval will be used: 10 minutes;
- `ECNM_SERVER_ALIAS`: a server name to be used in messages;

  default value: container's hostname (something like `35199a65247e`)
- `ECNM_SHOW_IP`: `y` indicates that the Energi Core Node Monitor's IP address should be displayed in messages;

  this value alone is quite pointless as it will display the Energi Core Node Monitor Docker container's internal IP address (something like `192.168.0.2`); to display server's external IP address, the environment variable `ECNM_SHOW_IP_EXTERNAL` must be set to `y`;
- `ECNM_SHOW_IP_EXTERNAL`: when `ECNM_SHOW_IP=y`, value `y` indicates that the server's external IP address should be displayed in messages instead of container's internal IP;
- `INTERACTIVE_SETUP`: setting this environment variable to `y` or not setting value at all indicates that the Energi Core Node Monitor setup process will be interactive; this means that all the neccessary values in setup process will have to be entered manually and all the environment variables can be without values;
- `TELEGRAM_BOT_TOKEN`: token for Telegram bot to send Energi Core Node Monitor messages to;

  > When a Telegram bot is used, at least one message has to be sent to it recently so the `result` array in the response of `https://api.telegram.org/bot{Telegram bot token}/getUpdates` (where `{Telegram bot token}` is the actual token) is not empty, otherwise the script will not be able to setup Telegram integration.

  detailed instructions on how to set up Telegram are in [the official Energi Core Node Monitoring Tool guid (section "Setup Telegram")](https://docs.energi.software/en/advanced/nodemon#telegram);
- `TELEGRAM_BOT_TOKEN_CHANGE`: when `INTERACTIVE_SETUP=n`, value `y` indicates that the existing Telegram token must be replaced with the one that is assigned to `TELEGRAM_BOT_TOKEN` if the Energi Core Node Monitor has been already set up.
