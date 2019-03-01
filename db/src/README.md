# What does this starter kit do to the database?
Subzero uses `db/src/init.sql` as a way to start the creation of DDL in the database. It then calls other sql scripts with the `/ir` psql meta-command.

The order of DDL processing is:

```bash
db/src/.                      
├── init.sql                       # First sql file called by docker-compose.yml (which maps ./db/src/ to
│                                  # /docker-entrypoint-initdb.d/), which the docker Postgres image execs on first run.
├── libs                           # Invokes the below files in the below order:
│   ├── settings                   
│   │   └── schema.sql             # Don't yet understand?  
│   ├── auth                       
│   │   └── schema.sql             # Calls /pgjwt/schema.sql, then adds extra code to allow authentication logic in the DB
|   ├── pgjwt                      
│   │   ├── schema.sql             # Extension to produce jwt tokens in the database. Invokes the below file
│   │   ├── pgjwt--0.0.1.sql       # 'Actual' logic behind [pgjwt](https://github.com/michelp/pgjwt/) lives here
│   │   └── test.sql               # Doesn't seem to get called anywhere? Should be moved to tests/db?
│   ├── request                    
│   │   └── schema.sql             # Defines functions that allow for valid HTTP returns
│   └── rabbitmq                   
│       └── schema.sql             # Creates nice messages for RabbitMQ
├── data                           
│   ├── schema.sql                 # Also calls ../libs/auth/data/user_role_type.sql and ../libs/auth/data/user.sql
│   │                              # ../libs/auth/data/user_role_type.sql - creates an enumerated user role datatype?
│   │                              # ../libs/auth/data/user.sql - defines the columns that must be known about a user in Postgrest
│   │
│   └── todo.sql                   # Creates the 'todo' table that is used in the demo application.
│                                  # Your own application logic could start getting written in here?
├── api                            
│   ├── schema.sql                 # Calls ../libs/auth/api/user_type.sql and ../libs/auth/api/all.sql
│   │                              # ../libs/auth/api/user_type.sql - creates an enumerated user role datatype?
│   │                              # ../libs/auth/api/all.sql invokes the below sql in the same directory:
│   │                              # └── session_type.sql - Defines a datatype for the session(?)
│   │                              # └── login.sql - Holds the function accepting/refusing logins to the DB
│   │                              # └── refresh_token.sql - Function to manage the update of a jwt token
│   │                              # └── signup.sql - Function to handle the creation of a new user
│   │                              # └── me.sql - I think this is a 'whoami' function? Returns current username
│   └── todos.sql                  # Creates and permissions the 'todos' view for the demo application.
│
├── authorization                  
│   ├── roles.sql                  # I don't understand the logic here yet - creates a function to define roles with?
│   └── privileges.sql             # Sets the permissions for the todos view?
├── sample_data                    
│   └── data.sql                   # Fills data.todo and data.user with sample data for the starter-kit app
└── init.sh                        # Final shell script executed after the sql by the Postgres docker image.

```
Note: Each file called `schema.sql` additionally has a schema creation step in it, which matches the file's name. E.g. `rabbitmq/schema.sql` will create the rabbitmq schema.
