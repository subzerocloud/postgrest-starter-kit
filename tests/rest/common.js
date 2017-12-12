import {config} from 'dotenv';
import {spawnSync} from 'child_process';
// var execSync = require('child_process').execSync;
const jwt = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJyb2xlIjoid2VidXNlciJ9.uSsS2cukBlM6QXe4Y0H90fsdkJSGcle9b7p_kMV1Ymk'
const request = require('supertest');

config();//.env file vars added to process.env
const COMPOSE_PROJECT_NAME = process.env.COMPOSE_PROJECT_NAME;
const POSTGRES_USER = process.env.POSTGRES_USER;
const POSTGRES_PASSWORD = process.env.POSTGRES_PASSWORD;
const SUPER_USER = process.env.SUPER_USER;
const SUPER_USER_PASSWORD = process.env.SUPER_USER_PASSWORD;

const DB_HOST = process.env.DB_HOST;
const DB_NAME = process.env.DB_NAME;
const PG = `${COMPOSE_PROJECT_NAME}_db_1`

const psql_version = spawnSync('psql', ['--version']);
const have_psql = (psql_version.stdout && psql_version.stdout.toString('utf8').trim().length > 0)


var rest_service = function() { 
  return request('http://localhost:8080/rest');
}

const resetdb = () => {
  if (have_psql){
    var env = Object.create( process.env );
    env.PGPASSWORD = SUPER_USER_PASSWORD
    const pg = spawnSync('psql', ['-h', 'localhost', '-U', SUPER_USER, DB_NAME, '-f', process.env.PWD + '/db/src/sample_data/reset.sql'], { env: env })
  }
  else{
    const pg = spawnSync('docker', ['exec', PG, 'psql', '-U', SUPER_USER, DB_NAME, '-f', 'docker-entrypoint-initdb.d/sample_data/reset.sql'])
  }
}

module.exports = {
  jwt: jwt,
  resetdb: resetdb,
  rest_service: rest_service
}
