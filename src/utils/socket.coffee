# client = new WebSocket 'ws://localhost:8000/ws'
WsClient = require("websocket").w3cwebsocket

Socket = ()->
	socket = {}
	client = new WsClient("ws://localhost:8000/ws")
	handlers = {}

	send_message = (obj)->
		retry = (i)->
			()->
				switch client.readyState
					when client.OPEN
						client.send JSON.stringify(obj)
					when client.CLOSED
						console.log "socket not open:",client.readyState
					when client.CONNECTING
						setTimeout retry(i*2),1000*i
					else
						console.log "socket not open:",client.readyState
		retry(1)()

	open_handler = ()->
		console.log "socket open"
	
	client.onopen = open_handler

	client.onerror = (err)->
		console.log "socket err:"+err

	client.onmessage = (evt)->
		obj = JSON.parse evt.data
		message = obj.message.substr 7
		console.log "RECV "+message
		data = obj.data
		fns = handlers[message]
		return if !fns
		for fn in fns
			fn data,message

	socket.emit = (msg,data)->
		obj = {}
		obj.message = "client:"+msg
		obj.data = data
		send_message(obj)

	socket.on = (msg,fn)->
		handlers[msg] = [] if not handlers[msg]
		handlers[msg].push fn
		return

	return socket

socket = Socket()

module.exports = socket
