const spawn = require('child_process').spawn;
require('dotenv').config();
const PG_MAJOR_VERSION = process.env.PG_VERSION.replace(/\..*/,'');
spawn('docker', [
    'run',
    '-i',
    '-t',
    '--rm',
    '--name', 'pgtap',
    '--net', `${process.env.COMPOSE_PROJECT_NAME}_default`,
    '--link', `${process.env.COMPOSE_PROJECT_NAME}_db_1:db`,
    '-v', `${process.cwd()}/tests/db/:/test`,
    '-e', `HOST=${process.env.DB_HOST}`,
    '-e', `DATABASE=${process.env.DB_NAME}`,
    '-e', `USER=${process.env.SUPER_USER}`,
    '-e', `PASSWORD=${process.env.SUPER_USER_PASSWORD}`, `subzerocloud/pgtap:pg${PG_MAJOR_VERSION}`,
],
{ stdio: 'inherit' });