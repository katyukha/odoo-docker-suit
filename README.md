# Odoo Docker Suit

(Based on [xcgd/odoo](https://registry.hub.docker.com/u/xcgd/odoo/) images)
(Uses [Docker Compose](https://docs.docker.com/compose/) for simplified container management)

To run this suit You have following components installed on Your system:
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/install/)

To start suit do next steps:

1. Clone this repository: ```git clone https://github.com/katyukha/odoo-docker-suit.git```
2. Go inside clon ```cd odoo-docker-suit```
3. Run command: ```docker-compose up```
4. Next odoo instances wii be started:
   * *localhost:7069* for *Odoo 7.0*
   * *localhost:8069* for *Odoo 8.0*
   * *localhost:9069* for *Odoo latest*

If You want to add specific *Odoo* instance you may use folowing syntax:

```sh
docker-compose up o8
```

which will run only *Odoo 8.0* instance.
Available odoo instance:

    * o7: Odoo 7.0
    * o8: Odoo 8.0
    * olatest: Odoo latest

Also it is possible to run tests of third-party addons in dockered environment,
which makes available using this project in CI. For this feature look at folowing
bash scripts:

    * odoo-helper.bash
    * docker-test.bash

Example:

```bash
./docker-test.bash 7.0 https://github.com/katyukha/base_tags.git master base_tags product_tags
```

Note, that this feature will change in future
