import {config} from 'dotenv';
import {spawnSync} from 'child_process';
// var execSync = require('child_process').execSync;
const jwt = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJyb2xlIjoid2VidXNlciJ9.vAN3uJSleb2Yj8RVPRsb1UBkokqmKlfl6lJ2bg3JfFg'
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

var rest_service = function() { 
  return request('http://localhost:8080/rest');
}

const resetdb = () => {
  const pg = spawnSync('docker', ['exec', PG, 'psql', '-U', SUPER_USER, DB_NAME, '-f', 'docker-entrypoint-initdb.d/sample_data/reset.sql'])
  // console.log (pg.stdout.toString('utf8') )
  // console.log (pg.stderr.toString('utf8') )
}

module.exports = {
  jwt: jwt,
  resetdb: resetdb,
  rest_service: rest_service
}
