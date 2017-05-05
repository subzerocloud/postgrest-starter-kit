import {rest_service, jwt, resetdb} from '../common.js';
const request = require('supertest');
const should = require("should");

describe('read', function() {
  after(function(done){ resetdb(); done(); });
  
  it('basic', function(done) {
    rest_service()
      .get('/items?id=eq.1')
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect( r => {
        r.body.length.should.equal(1);
        r.body[0].id.should.equal(1);
      })
  });

  it('by primary key', function(done) {
    rest_service()
      .get('/items/1?select=id,name')
      .expect(200, done)
      .expect( r => {
        r.body.id.should.equal(1);
        r.body.name.should.equal('item_1');
      })
  });

});