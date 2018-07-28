import { rest_service, resetdb } from './common'
import should from 'should'

describe('read', function () {
  before(function (done) { resetdb(); done() })
  after(function (done) { resetdb(); done() })

  it('basic', function (done) {
    rest_service()
      .get('/todos?select=id,todo')
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect(r => {
        r.body.length.should.equal(3)
        r.body[0].id.should.equal(1)
      })
  })

  it('by primary key', function (done) {
    rest_service()
      .get('/todos/1?select=id,todo')
      .expect(200, done)
      .expect(r => {
        r.body.id.should.equal(1)
        r.body.todo.should.equal('item_1')
      })
  })
})
