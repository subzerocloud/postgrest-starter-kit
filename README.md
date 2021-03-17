# PostgREST Starter Kit

Base project and tooling for authoring REST API backends with [PostgREST](https://postgrest.com).

![PostgREST Starter Kit](https://raw.githubusercontent.com/wiki/subzerocloud/postgrest-starter-kit/images/postgrest-starter-kit.gif "PostgREST Starter Kit")


## Purpose

PostgREST enables a different way of building data driven API backends. It does "one thing well" and that is to provide you with a REST api over your database, however to build a complex production system that does things like talk to 3rd party systems, sends emails, implements real time updates for browsers, write integration tests, implement authentication, you need additional components. For this reason, some developers either submit feature requests that are not the scope of PostgREST or think of it just as a prototyping utility and not a powerful/flexible production component with excellent performance. This repository aims to be a starting point for all PostgREST based projects and bring all components together under a well defined structure. We also provide tooling that will aid you with iterating on your project and tools/scripts to enable a build pipeline to push everything to production. There are quite a few components in the stack but you can safely comment out pg_amqp_bridge/rabbitmq (or even openresty) instances in docker-compose.yml if you don't need the features/functionality they provide.

## PostgREST+ as a service
Run your PostgREST instance in [subZero cloud](https://subzero.cloud/postgrest-plus.html) and get additional features to the OS version ( [free plan](https://subzero.cloud/pricing.html) available).

Alternatively, deploy an [enhanced version](https://docs.subzero.cloud/postgrest-plus/) of PostgREST on your infrastructure using binary and docker distributions.

✓ **Fully Managed** &mdash; subZero automates every part of setup, running and scaling of PostgREST. Let your team focus on what they do best - building your product. Leave PostgREST management and monitoring to the experts.<br>
✓ **Faster Queries** &mdash; Run an enhanced PostgREST version that uses prepared statements instead of inline queries. This results in up to 30% faster response times.<br>
✓ **Custom Relations** &mdash; Define custom relations when automatic detection does not work. This allows you to use the powerful embedding feature even with the most complicated views<br>
✓ **GraphQL API** &mdash; In addition to the REST API you get a GraphQL api with no additional coding. Leverage all the powerful tooling, libraries and integrations for GraphQL in your frontend.<br>
✓ **Preconfigured Authentication** &mdash;  Authenticate users with local email/password or using 3rd party OAuth 2.0 providers (google/facebook/github preconfigured) <br>
✓ **Analytical queries** &mdash; Use `GROUP BY`, aggregate and window functions in your queries <br>

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
✓ Compatible with [subZero Starter Kit](https://github.com/subzerocloud/subzero-starter-kit) if you need a GraphQL API and a few [more features](https://github.com/subzerocloud/subzero-starter-kit#features) with no additional work<br>


## Directory Layout

```bash
.
├── db                        # Database schema source files and tests
│   └── src                   # Schema definition
│       ├── api               # Api entities avaiable as REST endpoints
│       ├── data              # Definition of source tables that hold the data
│       ├── libs              # A collection modules of used throughout the code
│       ├── authorization     # Application level roles and their privileges
│       ├── sample_data       # A few sample rows
│       └── init.sql          # Schema definition entry point
├── openresty                 # Reverse proxy configurations and Lua code
│   ├── lua                   # Application Lua code
│   ├── nginx                 # Nginx configuration files
│   ├── html                  # Static frontend files
│   └── Dockerfile            # Dockerfile definition for building production images
├── tests                     # Tests for all the components
│   ├── db                    # pgTap tests for the db
│   └── rest                  # REST interface tests
├── docker-compose.yml        # Defines Docker services, networks and volumes
└── .env                      # Project configurations

```



## Installation 

### Prerequisites
* [Docker](https://www.docker.com)
* [Node.js](https://nodejs.org/en/)
* [subzero-cli](https://github.com/subzerocloud/subzero-cli#install)

### Create a New Project
Click **[Use this template]** (green) button.
Choose the name of your new repository, description and public/private state then click **[Create repository from template]** button.
Check out the [step by step guide](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template) if you encounter any problems.

After this, clone the newly created repository to your computer.
In the root folder of application, run the docker-compose command

```bash
docker-compose up -d
```

The API server will become available at the following endpoints:

- Frontend [http://localhost:8080/](http://localhost:8080/)
- REST [http://localhost:8080/rest/](http://localhost:8080/rest/)

Try a simple request

```bash
curl http://localhost:8080/rest/todos?select=id,todo
```

## Development workflow and debugging

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

## Contributing

Anyone and everyone is welcome to contribute.

## Support and Documentation
* [Documentation](https://docs.subzero.cloud/postgrest-starter-kit/)
* [PostgREST API Referance](https://postgrest.com/en/stable/api.html)
* [PostgreSQL Manual](https://www.postgresql.org/docs/current/static/index.html)
* [Slack](https://slack.subzero.cloud/) — Get help, share ideas and feedback
* [GitHub Issues](https://github.com/subzerocloud/postgrest-starter-kit/issues) — Check open issues, send feature requests

## License

Copyright © 2017-present subZero Cloud, LLC.<br />
This source code is licensed under [MIT](https://github.com/subzerocloud/postgrest-starter-kit/blob/master/LICENSE.txt) license<br />
The documentation to the project is licensed under the [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/) license.

