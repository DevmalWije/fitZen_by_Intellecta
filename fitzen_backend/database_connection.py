import firebase_admin
from firebase_admin import credentials, auth, firestore
from aiohttp import web
import json
import calculations

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

async def validateUser(request):
    try:
        auth_header = request.headers.get('Authorization')
        token = auth_header.split(" ")[1]
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']

        return web.Response(
            content_type="application/json",
            status=200,
            text=json.dumps({
                "uid": str(uid),
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

def getSessions(request):
    try:
        uid = request.query.get('uid')
        doc = db.collection('users').document(uid).get()
        previous_session_doc = db.collection("users").document(uid).collection("sessions").order_by("timestamp", direction=firestore.Query.DESCENDING).limit(1).get()
        user_data = {}
        previous_session = {}
        if doc.exists:
            user_data = doc.to_dict()

        if len(previous_session_doc) != 0:
            previous_session = previous_session_doc[0].to_dict()
        
        return web.Response(
            content_type="application/json",
            status=200,
            text=json.dumps({
                "totalElapsedSeconds": user_data.get("elapsedSeconds", 0),
                "totalBadPosturePercentage": 0 if user_data == {} else calculations.calculate_posture_percentage(user_data["goodPostureCount"], user_data["badPostureCount"])[1],
                "score": 0 if user_data == {} else calculations.calculate_posture_score(user_data["goodPostureCount"], user_data["badPostureCount"], user_data["elapsedSeconds"]),
                "goodPostureCount": previous_session.get("goodPostureCount", 0),
                "badPostureCount": previous_session.get("badPostureCount", 0),
                "eyeStrainLevel": 0 if (len(previous_session_doc) == 0) else calculations.calculate_blink_score(previous_session["blinkCount"], previous_session["elapsedSeconds"]),
                "elapsedSeconds": previous_session.get("elapsedSeconds", 0),
            }),
        )
    
    except Exception as e:
        return web.Response(
                content_type="application/json",
                status=500,
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
                "goodPostureCount": firestore.Increment(data['goodPostureCount']),
            })
        else:
            db.collection("users").document(data['uid']).set({
                "elapsedSeconds": data["elapsedSeconds"],
                "badPostureCount": data["badPostureCount"],
                "goodPostureCount": data["goodPostureCount"],
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