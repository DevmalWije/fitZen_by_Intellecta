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
app.router.add_post("/offer", webrtc_connection.handleConnection)
app.router.add_get("/", testConnection)
app.router.add_get("/validate", database_connection.validateUser)
app.router.add_get("/sessions", database_connection.getSessions)
app.router.add_post("/sessions/add", database_connection.addSession)

web.run_app(app, host='0.0.0.0', port='3000')