Sample data in this directory was generated using `datafiller` utility
you can install it like so

```shell
wget -q https://raw.githubusercontent.com/memsql/datafiller/master/datafiller -O /usr/local/bin/datafiller \
	&& chmod +x /usr/local/bin/datafiller
```

after it's installed, you can generate sample data using a comand like the one below

```shell
( \
  cd db/src/data && \
  cat users.sql items.sql subitems.sql | datafiller --size=2 > ../sample_data/data.sql \
)
```