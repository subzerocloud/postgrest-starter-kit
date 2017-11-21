# PostgREST Starter Kit

Boilerplate and tooling for authoring REST API backends with [PostgREST](https://postgrest.com).

![PostgREST Starter Kit](https://raw.githubusercontent.com/wiki/subzerocloud/postgrest-starter-kit/images/postgrest-starter-kit.gif "PostgREST Starter Kit")


## Purpose

PostgREST enables a different way of building data driven API backends. It does "one thing well" and that is to provide you with a REST api over your database, however to build a complex production system that does things like talk to 3rd party systems, sends emails, implements real time updates for browsers, write integration tests, implement authentication, you need additional components. For this reason, some developers either submit feature requests that are not the scope of PostgREST or think of it just as a prototyping utility and not a powerful/flexible production component with excellent performance. This repository aims to be a starting point for all PostgREST based projects and bring all components together under a well defined structure. We also provide tooling that will aid you with iterating on your project and tools/scripts to enable a build pipeline to push everything to production. There are quite a few components in the stack but you can safely comment out pg_amqp_bridge/rabbitmq (or even openresty) instances in docker-compose.yml if you don't need the features/functionality they provide.


## Features

✓ Cross-platform development on macOS, Windows or Linux inside [Docker](https://www.docker.com/)<br>
✓ [PostgreSQL](https://www.postgresql.org/) database schema boilerplate with authentication and authorization flow<br>
✓ [OpenResty](https://openresty.org/en/) configuration files for the reverse proxy<br>
✓ [RabbitMQ](https://www.rabbitmq.com/) integration through [pg-amqp-bridge](https://github.com/subzerocloud/pg-amqp-bridge)<br>
✓ [Lua](https://www.lua.org/) functions to hook into each stage of the HTTP request and add custom logic (integrate 3rd party systems)<br>
✓ Debugging and live code reloading (sql/configs/lua) functionality using [subzero-cli](https://github.com/subzerocloud/subzero-cli)<br>
✓ Full migration management (migration files are automatically created) through [subzero-cli](https://github.com/subzerocloud/subzero-cli)/[sqitch](http://sqitch.org/)/[apgdiff](https://github.com/subzerocloud/apgdiff)<br>
✓ SQL unit test using [pgTAP](http://pgtap.org/)<br>
✓ Integration tests with [SuperTest / Mocha](https://github.com/visionmedia/supertest)<br>
✓ Docker files for building production images<br>
✓ Community support on [Slack](https://slack.subzero.cloud/)<br>
✓ Compatible with [subZero Starter Kit](https://github.com/subzerocloud/subzero-starter-kit) if you decide you need a GraphQL API with no additional work<br>


## Directory Layout

```bash
.
├── db                        # Database schema source files and tests
│   ├── src                   # Schema definition
│   │   ├── api               # Api entities avaiable as REST endpoints
│   │   ├── data              # Definition of source tables that hold the data
│   │   ├── libs              # A collection modules of used throughout the code
│   │   ├── authorization     # Application level roles and their privileges
│   │   ├── sample_data       # A few sample rows
│   │   └── init.sql          # Schema definition entry point
│   └── tests                 # pgTap tests
├── openresty                 # Reverse proxy configurations and Lua code
│   ├── lualib
│   │   └── user_code         # Application Lua code
│   ├── nginx                 # Nginx files
│   │   ├── conf              # Configuration files
│   │   └── html              # Static frontend files
│   ├── tests                 # Mocha based integration tests
│   │   ├── rest              # REST interface tests
│   │   └── common.js         # Helper functions
│   ├── Dockerfile            # Dockerfile definition for production
│   └── entrypoint.sh         # Custom entrypoint
├── postgrest                 # PostgREST 
│   └── tests                 # Simple bash based integration tests
├── docker-compose.yml        # Defines Docker services, networks and volumes
└── .env                      # Project configurations

```


## Installation

Make sure that you have [Docker](https://www.docker.com/community-edition) v17 or newer installed.

Setup your git repo with a reference to the upstream
```base
mkdir example-api && cd example-api
git clone https://github.com/subzerocloud/postgrest-starter-kit.git .
git remote rename origin upstream && git branch --unset-upstream
```

Launch the app with [Docker Compose](https://docs.docker.com/compose/):

```bash
docker-compose up -d
```

The API server must become available at [http://localhost:8080/rest](http://localhost:8080/rest).
Try a simple request

```bash
curl http://localhost:8080/rest/todos?select=id,todo
```

## Development workflow and debugging

Install [subzero-cli](https://github.com/subzerocloud/subzero-cli) using with
```
npm install -g subzero-cli
```

Execute `subzero dashboard` in the root of your project.<br />
After this step you can view the logs of all the stack components (SQL queries will also be logged) and
if you edit a sql/conf/lua file in your project, the changes will immediately be applied.


## Testing

The starter kit comes with a testing infrastructure setup. 
You can write pgTAP tests that run directly in your database, useful for testing the logic that resides in your database (user privileges, Row Level Security, stored procedures).
Integration tests are written in JavaScript.

Here is how you run them

```bash
npm install                     # Install test dependencies
npm test                        # Run all tests (db, rest)
npm run test_db                 # Run pgTAP tests
npm run test_rest               # Run integration tests
```

## Keeping Up-to-Date

You can always fetch and merge the recent updates back into your project by running:

```bash
git fetch upstream
git merge upstream/master
```

## Deployment

More information in [Production Infrastructure (AWS ECS+RDS)](https://github.com/subzerocloud/postgrest-starter-kit/wiki/Production-Infrastructure) and [Pushing to Production](https://github.com/subzerocloud/postgrest-starter-kit/wiki/Pushing-to-Production)

## Contributing

Anyone and everyone is welcome to contribute.

## Support and Documentation
* [Wiki](https://github.com/subzerocloud/postgrest-starter-kit/wiki) — comprehensive documentation
* [PostgREST API Referrance](https://postgrest.com/en/stable/api.html)
* [PostgreSQL Manual](https://www.postgresql.org/docs/current/static/index.html)
* [Slack](https://slack.subzero.cloud/) — Watch announcements, share ideas and feedback
* [GitHub Issues](https://github.com/subzerocloud/postgrest-starter-kit/issues) — Check open issues, send feature requests

## License

Copyright © 2017-present subZero Cloud, LLC.<br />
This source code is licensed under [MIT](https://github.com/subzerocloud/postgrest-starter-kit/blob/master/LICENSE.txt) license<br />
The documentation to the project is licensed under the [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/) license.

