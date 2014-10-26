require 'fluentnode'
Server  = require('./../src/Server')
expect  = require('chai').expect
request = require('request')

describe 'test-Server |',->

    server  = new Server()

    it 'check ctor', ->
        expect(Server        ).to.be.an('function')
        expect(server        ).to.be.an('object'  )
        expect(server.app    ).to.be.an('function')
        expect(server.port   ).to.be.an('number'  )
        expect(server._server).to.equal(null)


    it 'start and stop', (done)->
        expect(server.start  ).to.be.an('function')
        expect(server.stop   ).to.be.an('function')
        expect(server.start()).to.equal(server)

        expect(server._server.close         ).to.be.an('function')
        expect(server._server.getConnections).to.be.an('function')

        request server.url(), (error, response,data)->
            expect(error).to.equal(null)
            expect(response.statusCode).to.equal(200)
            expect(data               ).to.equal('hello')

            server.stop()

            request server.url(), (error, response,data)->
                expect(error        ).to.not.equal(null)
                expect(error.message).to.equal('connect ECONNREFUSED')
                expect(response     ).to.equal(undefined)
                done()

    it 'url',->
        expect(server.url()).to.equal("http://localhost:1332")


    it 'routes', ->        
        expect(server.routes         ).to.be.an('function')
        expect(server.routes()       ).to.be.an('array')
        expect(server.routes().size()).to.be.above(0)
        
    it 'Check expected paths', ->
      expectedPaths = [ '/', '/test' ]
      expect(server.routes()).to.deep.equal(expectedPaths)