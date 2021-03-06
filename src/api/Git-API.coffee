require 'fluentnode'

child_process = require('child_process')

class Git_API
    constructor: (options)->
      @.options        = options || {}
      @.swaggerService = @options.swaggerService

      @commands =
            status: { name: 'status' , params: []}
            remote: { name: 'remote' , params: ['-v']}
            log   : { name: 'log'    , params: ['--graph', '--pretty=oneline', '-15']}
            pull  : { name: 'pull'   , params: ['origin']}

    git_Exec: (command)=>
      git_Exec_Method

    git_Exec_Method : (command)=>
        (req,res)=>
            params = [command.name].concat(command.params)

            result = ''
            options = { cwd : __dirname}
            using child_process.spawn('git', params),->
                @.stdout.on 'data', (data)-> result += data.str()
                @.stderr.on 'data', (data)-> result += data.str()
                @.on 'exit'       , (    )-> res.send JSON.stringify(result)

    add_Git_Command: (command)=>
      get_Command =
            spec   : { path : "/git/#{command.name}/", nickname : command.name}
            action : @git_Exec_Method(command)


      @.swaggerService.addGet(get_Command)

    add_Methods: ()=>
      @add_Git_Command(@.commands.status)
      @add_Git_Command(@.commands.remote)
      @add_Git_Command(@.commands.log)
      @add_Git_Command(@.commands.pull)


module.exports = Git_API