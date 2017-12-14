const request = require('supertest');
const should = require("should");

describe('root endpoint', function() {
  it('returns json', function(done) {
    request('http://localhost:8080/rest')
      .get('/')
      .expect('Content-Type', /json/)
      .expect(200, done)
  });
});
