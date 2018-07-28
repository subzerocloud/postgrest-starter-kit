import { rest_service, resetdb } from './common'
import { should } from 'should'

describe('auth', function () {
  before(function (done) { resetdb(); done() })
  after(function (done) { resetdb(); done() })

  it('login', function (done) {
    rest_service()
      .post('/rpc/login?select=me,token')
      .set('Accept', 'application/vnd.pgrst.object+json')
      .send({
        email: 'alice@email.com',
        password: 'pass'
      })
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect(r => {
        // console.log(r.body)
        r.body.me.email.should.equal('alice@email.com')
      })
  })

  it('me', function (done) {
    rest_service()
      .post('/rpc/me')
      .set('Accept', 'application/vnd.pgrst.object+json')
      .withRole('webuser')
      .send({})
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect(r => {
        // console.log(r.body)
        r.body.email.should.equal('alice@email.com')
      })
  })

  it('refresh_token', function (done) {
    rest_service()
      .post('/rpc/refresh_token')
      .set('Accept', 'application/vnd.pgrst.object+json')
      .withRole('webuser')
      .send({})
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect(r => {
        // console.log(r.body)
        r.body.length.should.above(0)
      })
  })

  it('signup', function (done) {
    rest_service()
      .post('/rpc/signup')
      .set('Accept', 'application/vnd.pgrst.object+json')
      .send({
        name: 'John Doe',
        email: 'john@email.com',
        password: 'pass'
      })
      .expect('Content-Type', /json/)
      .expect(200, done)
      .expect(r => {
        // console.log(r.body)
        r.body.me.email.should.equal('john@email.com')
      })
  })
})
