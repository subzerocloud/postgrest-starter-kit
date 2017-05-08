# PostgREST API Starter Kit

**PostgREST API Starter Kit** is a boilerplate and tooling for authoring **data API**
backends with [PostgREST](https://postgrest.com).

## Features

✓ Cross-platform development on macOS, Windows or Linux inside [Docker](https://www.docker.com/)<br>
✓ [PostgreSQL](https://www.postgresql.org/) database schema boilerplate with authentication and authorization flow<br>
✓ [OpenResty](https://openresty.org/en/) configuration files for the reverse proxy<br>
✓ [Lua](https://www.lua.org/) functions to hook into each stage of the HTTP request and add custom logic (integrate 3rd party systems)<br>
✓ Debugging and live code reloading (sql/configs/lua) functionality using [subZero devtools](https://github.com/subzerocloud/devtools)<br>
✓ Sql unit test using [pgTAP](http://pgtap.org/)<br>
✓ Integration tests with [SuperTest / Mocha](https://github.com/visionmedia/supertest)<br>
✓ (soon) Docker files for building production images<br>
✓ Community support on [Slack](https://slack.subzero.cloud/)<br>


## Directory Layout

```bash
.
├── db                        # Database schema source files and tests
│   ├── src                   # Schema definition
│   │   ├── api               # Api entities avaiable as REST endpoints
│   │   ├── data              # Definition of source tables that hold the data
│   │   ├── pgjwt             # JWT util functions
│   │   ├── request           # HTTP request helper functions
│   │   ├── roles             # Application level roles and their privileges
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
│   │   ├── rest              # Rest interface tests
│   │   └── common.js         # Helper functions
│   ├── Dockerfile            # Dockerfile definition for production
│   └── entrypoint.sh         # Custom entrypoint
├── postgrest                 # PostgREST 
│   └── tests                 # Simple bash based integration tests
├── docker-compose.yml        # Defines Docker services, networks and volumes
└── .env                      # Project configurations

```


## Getting Started

Make sure that you have [Docker](https://www.docker.com/community-edition) v17 or newer installed, clone the repo and launch the app with [Docker
Compose](https://docs.docker.com/compose/):

```bash
git clone --single-branch https://github.com/subzerocloud/postgrest-starter-kit example-api
cd example-api                  # Change current directory to the newly created one
docker-compose up -d            # Launch Docker containers
```

The API server must become available at [http://localhost:8080/rest](http://localhost:8080/rest).
Try a simple request

```bash
curl http://localhost:8080/rest/items?id=eq.1
```

## Testing

```bash
npm install                     # Install test dependencies
npm run test_db                 # Run pgTAP tests
npm run test_rest               # Run integration tests
npm test                        # Run all tests (db, rest)
```

## Keeping Up-to-Date

If you keep the original Git history after  forking and clonning this repo, you can always fetch and merge
the recent updates back into your project by running:

```bash
git remote add upstream https://github.com/subzerocloud/postgrest-starter-kit.git
git fetch upstream
git merge upstream/master
```


## Development workflow and debugging

Download and install [subZero devtools](https://github.com/subzerocloud/devtools) for your OS.<br />
Execute `sz` (of the name you used to symlink the binary) in the root of your project.<br />
After this step you can view the logs of all the stack components (SQL queries will also be logged).
If you endit and sql/conf/lua file in your project, the changes will immediately be applied.


![DevTools](https://github.com/subzerocloud/devtools/blob/master/screenshot.png?raw=true "DevTools")

## Deployment

There are two stages when going into production.

### Deploying your database code
In production you should use [RDS](https://aws.amazon.com/rds/postgresql/) or a similar service.
We'll soon have examples on how to migrate SQL code from dev to production

### Deploying PostgREST and OpenResty
We recommend deploying both components (OpenResty/PostgREST) as Docker containers.
You can use [EC2 Container Service](https://aws.amazon.com/ecs/) to help solve a lot of devops problems when deploying containers.
We'll soon provide task definition templates. For PostgREST you can use the official image in production. For OpenResty you will build your own image that is based on the official one but includes all your custom configurations and files.

## Contributing

Anyone and everyone is welcome to contribute.

## Support

* [Slack](https://slack.subzero.cloud/) — Watch announcements, share ideas and feedback
* [GitHub Issues](https://github.com/subzerocloud/postgrest-starter-kit/issues) — Check open issues, send feature requests

## License

Copyright © 2017-present subZero Cloud, LLC.<br />
This source code is licensed under [MIT](https://github.com/subzerocloud/postgrest-starter-kit/blob/master/LICENSE.txt) license<br />
The documentation to the project is licensed under the [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/) license.
