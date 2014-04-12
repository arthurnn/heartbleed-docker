fs = require "fs"
spawn = require('child_process').spawn
connect = require "connect"

config = require './config'

app = connect.createServer(connect.static('public')).listen(9099)
io = require("socket.io").listen app
io.set 'log level', 2 # disable heartbeat debug output


commands = []

# Send data to connected client.
sendData = (socket, data, fileName, fileSlug, channel) ->
    data = "#{data}"
    socket.emit 'new-data',
        'fileSlug': fileSlug
        'fileName': fileName
        'channel': channel
        'value': data.replace /(\[[0-9]+m)*/g, ""


# Stop given commands by sending them a SIGTERM signal.
killCommands = (commands) ->
    for fileName, command of commands
        console.log "Killing process for #{fileName}..."
        command.kill 'SIGTERM'


# Start process run a tail -f command on given file and redirect output to
# given socket.
startProcess = (socket, fileName) ->

    args = ['-f', "#{config.logPath}/#{fileName}"]
    command = spawn "tail", args

    # replace . by - to avoid conflicts in the frontend
    fileSlug = fileName.replace /\./g, '-'

    command.stdout.on 'data', (data) ->
        sendData(socket, data, fileName, fileSlug, 'stdout')
    command.stderr.on 'data', (data) ->
        sendData(socket, data, fileName, fileSlug, 'stderr')

    commands[fileName] = command


# On connection, list all files in the log path directory and start redirecting
# a tail -f for each of them to given socket.
# When socket is disconnected, all tail -f process are stopped.
io.sockets.on "connection", (socket) ->

    fs.readdir config.logPath, (err, files) ->

        if !err
            for fileName in files
                startProcess(socket, fileName)

        else
            console.log err

    socket.on "disconnect", () ->
        console.log "Client has disconnected, closing the processes..."
        killCommands commands


process.on 'SIGINT', () ->
    console.log "Server is stopping, closing the processes..."
    killCommands commands
    app.close()
    process.exit()

process.on 'SIGTERM', () ->
    console.log "Server is stopping, closing the processes..."
    killCommands(commands)
    app.close()
