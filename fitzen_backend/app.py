from aiohttp import web
import json
import webrtc_connection
import database_connection

def testConnection(request):
    return web.Response(
        content_type="application/json",
        text=json.dumps(
            {"connection": "success"}
        ),
    )

app = web.Application()

#setting up routes
app.router.add_post("/api/offer", webrtc_connection.handleConnection)
app.router.add_get("/api/", testConnection)
app.router.add_get("/api/validate", database_connection.validateUser)
app.router.add_get("/api/sessions", database_connection.getSessions)
app.router.add_post("/api/sessions/add", database_connection.addSession)

#set host and port
web.run_app(app, host='0.0.0.0', port='3000')