To run the tests in this directory do the following
- change to the root of the project folder
- bring the system up using docker-compose
- run the command below

```shell
( \
	source .env && \
	docker run -i -t --rm --name pgtap \
	--network ${COMPOSE_PROJECT_NAME}_default \
	--link ${COMPOSE_PROJECT_NAME}_db_1:db \
	-v $(pwd)/tests/db/:/test \
  -e HOST=$DB_HOST \
	-e DATABASE=$DB_NAME \
	-e USER=$SUPER_USER \
	-e PASSWORD=$SUPER_USER_PASSWORD \
	lren/pgtap:0.96.0-2 \
)
```
