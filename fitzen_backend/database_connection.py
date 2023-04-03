import firebase_admin
from firebase_admin import credentials, auth, firestore
from aiohttp import web
import json

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

async def validateUser(request):
    try:
        auth_header = request.headers.get('Authorization')
        token = auth_header.split(" ")[1]
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']

        #fetching data from db
        doc = db.collection(u'users').document(uid).get()
        user_data = {}
        if doc.exists:
            user_data = doc.to_dict()
        else:
            user_data = {}
        
        return web.Response(
            content_type="application/json",
            status=200,
            text=json.dumps({
                "uid": str(uid),
                "user_data": user_data,    
            }),
        )
    except Exception as e:
        return web.Response(
            content_type="application/json",
            status=401,
            text=json.dumps(
                {"error": str(e)}
            ),
        )

async def addSession(request):
    try:
        data = await request.json()
        
        doc = db.collection("users").document(data['uid']).get()
        if doc.exists:
            db.collection("users").document(data['uid']).update({
                "elapsedSeconds": firestore.Increment(data['elapsedSeconds']),
                "badPostureCount": firestore.Increment(data['badPostureCount']),
                "score": 120
            })
        else:
            db.collection("users").document(data['uid']).set({
                "elapsedSeconds": data["elapsedSeconds"],
                "badPostureCount": data["badPostureCount"],
                "score": 120
            })
            
        data['timestamp'] = firestore.SERVER_TIMESTAMP
        db.collection("users").document(data['uid']).collection('sessions').add(data)


        return web.Response(
                content_type="application/json",
                status=200,
                text=json.dumps(
                    {"success": True}
                ),
            )
    except Exception as e:
        return web.Response(
                content_type="application/json",
                status=401,
                text=json.dumps(
                    {"success": False}
                ),
        )