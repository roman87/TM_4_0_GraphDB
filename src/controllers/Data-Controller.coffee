levelgraph     = require('levelgraph'   )
Data_Service   = require('./../services/Data-Service'  )
GitHub_Service = require('./../services/GitHub-Service')
Jade_Service   = require('./../services/Jade-Service')

class DataControler
  constructor: (server)->
    @server = server

  add_Routes: =>
    @server.app.get('/data'               , @show_Available_Data)
    @server.app.get('/data/:name'         , @json_Raw_Data)
    @

  json_Raw_Data: (req,res)=>
    name = req.params.name
    dataService = new Data_Service(name)
    dataService.load_Data ->                  # note that at the moment this is loading all data all the time
    #dataService.graphService.openDb  ->
      dataService.graphService.allData (data)->
        dataService.graphService.closeDb ->
          res.type 'application/json'
          res.send data.json_pretty()

  show_Available_Data: (req,res)=>

    graphFolder = process.cwd().path_Combine('/views/graphs')
    baseFolder = new Data_Service().path_Root
    db = []
    for folder in baseFolder.folders()
      item  =
                dataId : folder.file_Name()
                queries: folder.path_Combine('queries').files().file_Names_Without_Extension()
                graphs : graphFolder.files('.jade').file_Names_Without_Extension()

      for globalQuery in process.cwd().path_Combine('db-queries').files().file_Names_Without_Extension()
        item.queries.push(globalQuery)
      db.push item

    availableData =
                    baseFolder : baseFolder
                    db         : db

    html = new Jade_Service().enableCache()
                             .renderJadeFile('/views/data.jade', availableData)
    res.send(html)

module.exports = DataControler