Data_Import_Util = require('/src/utils/Data-Import-Util'.append_To_Process_Cwd_Path())

get_Graph = (options, callback)->
  graphService = options.importService.graph

  db = graphService.db
  db.search [
              { subject: db.v('object'), object:'Query'}
              { subject: db.v('object'), predicate: db.v('predicate'), object: db.v('subject')}
            ], (err, data)->
                new Data_Import_Util(data).graph_From_Data (graph)->
                  callback(graph)

module.export = get_Graph