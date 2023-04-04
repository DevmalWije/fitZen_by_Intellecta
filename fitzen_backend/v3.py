import blink_detection
import asyncio
import multiThreadingVersion
import optimisedModelImp
from av import VideoFrame
from aiortc.contrib.media import MediaRelay
from aiortc import MediaStreamTrack, RTCPeerConnection, RTCSessionDescription
import aiohttp_cors
from aiohttp import web
import json
import time
import cv2
import mediapipe as mp
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_face_mesh = mp.solutions.face_mesh

# For webcam input:
drawing_spec = mp_drawing.DrawingSpec(thickness=1, circle_radius=1)
# cap = cv2.VideoCapture(0)
# with mp_face_mesh.FaceMesh(
#         max_num_faces=1,
#         refine_landmarks=True,
#         min_detection_confidence=0.5,
#         min_tracking_confidence=0.5) as face_mesh:
#     while cap.isOpened():
#         success, image = cap.read()
#         if not success:
#             print("Ignoring empty camera frame.")
#             # If loading a video, use 'break' instead of 'continue'.
#             continue

#         # To improve performance, optionally mark the image as not writeable to
#         # pass by reference.
#         image.flags.writeable = False
#         image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
#         results = face_mesh.process(image)

#         # Draw the face mesh annotations on the image.
#         image.flags.writeable = True
#         image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
#         if results.multi_face_landmarks:
#             for face_landmarks in results.multi_face_landmarks:

#                 mp_drawing.draw_landmarks(
#                     image=image,
#                     landmark_list=face_landmarks,
#                     connections=mp_face_mesh.FACEMESH_TESSELATION,
#                     landmark_drawing_spec=None,
#                     connection_drawing_spec=mp_drawing_styles
#                     .get_default_face_mesh_tesselation_style())
#                 # mp_drawing.draw_landmarks(
#                 #     image=image,
#                 #     landmark_list=face_landmarks,
#                 #     connections=mp_face_mesh.FACEMESH_CONTOURS,
#                 #     landmark_drawing_spec=None,
#                 #     connection_drawing_spec=mp_drawing_styles
#                 #     .get_default_face_mesh_contours_style())
#                 # mp_drawing.draw_landmarks(
#                 #     image=image,
#                 #     landmark_list=face_landmarks,
#                 #     connections=mp_face_mesh.FACEMESH_IRISES,
#                 #     landmark_drawing_spec=None,
#                 #     connection_drawing_spec=mp_drawing_styles
#                 #     .get_default_face_mesh_iris_connections_style())


#         # Flip the image horizontally for a selfie-view display.
#         # cv2.imshow('MediaPipe Face Mesh', cv2.flip(image, 1))
#         if cv2.waitKey(5) & 0xFF == 27:
#             break
# cap.release()


relay = MediaRelay()

face_mesh = mp_face_mesh.FaceMesh(
    max_num_faces=1,
    refine_landmarks=True,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)


class VideoTransformTrack(MediaStreamTrack):
    """
    A video stream track that transforms frames from an another track.
    """

    kind = "video"
    channel = None

    def __init__(self, track):
        super().__init__()  # don't forget this!
        self.track = track

    async def recv(self):
        frame = await self.track.recv()

        # Use to_rgb() function of VideoFrame object to avoid color conversion step
        image = frame.to_rgb().to_ndarray()

        # result_dict = optimisedModelImp.image_frame_model(image)
        start_time = time.time()  # start the timer
        dict = await multiThreadingVersion.image_frame_model(image)
        blink_dict = blink_detection.detect_blinks(image)
        end_time = time.time()
        print("Elapsed time: {:.2f} seconds".format(end_time - start_time))
        print(dict['posture_class'])
        print(blink_dict["eye_strain_level"])

        if VideoTransformTrack.channel != None:
            posture_count = 0
            last_posture = ""
            while True:
                # getting the current posture
                current_posture = dict['posture_class']
                # checking if the posture is same as the last posture
                if current_posture != last_posture:
                    posture_count = 0
                    last_posture = current_posture
                else:
                    posture_count += 1
                # if the posture is same for 10 frames then send the posture to the client
                if posture_count >= 10:
                    posture_count = 0
                    if last_posture == "proper_posture":
                        VideoTransformTrack.channel.send(json.dumps({
                            'posture': "Good Posture",
                            'eye_strain': blink_dict["eye_strain_level"]
                        }))
                    else:
                        VideoTransformTrack.channel.send(json.dumps({
                            'posture': "Bad Posture",
                            'eye_strain': blink_dict["eye_strain_level"]
                        }))
                    break
                else:
                    pass

        # # Use FaceMesh object initialized outside of recv function
        # results = face_mesh.process(image)

        # # Draw the face mesh annotations on the image.
        # if results.multi_face_landmarks:
        #     for face_landmarks in results.multi_face_landmarks:
        #         mp_drawing.draw_landmarks(
        #             image=image,
        #             landmark_list=face_landmarks,
        #             connections=mp_face_mesh.FACEMESH_TESSELATION,
        #             landmark_drawing_spec=None,
        #             connection_drawing_spec=mp_drawing_styles
        #             .get_default_face_mesh_tesselation_style())

        new_frame = VideoFrame.from_ndarray(
            dict['image_frame'], format="rgb24")
        new_frame.pts = frame.pts
        new_frame.time_base = frame.time_base
        return new_frame


global pc


async def offer(request):
    params = await request.json()
    offer = RTCSessionDescription(sdp=params["sdp"], type=params["type"])

    pc = RTCPeerConnection()

    @pc.on("datachannel")
    def on_datachannel(channel):
        print("Data channel is created!")
        VideoTransformTrack.channel = channel

    @pc.on("connectionstatechange")
    async def on_connectionstatechange():
        print("Connection state is %s", pc.connectionState)
        if pc.connectionState == "failed":
            await pc.close()
        elif pc.connectionState == "connected":
            pc.createDataChannel("data")

    @pc.on("track")
    def on_track(track):
        print("Track %s received", track.kind)
        if track.kind == "video":
            pc.addTrack(VideoTransformTrack(relay.subscribe(track)))

        @track.on("ended")
        async def on_ended():
            print("Track %s ended", track.kind)

    # handle offer
    await pc.setRemoteDescription(offer)

    # send answer
    answer = await pc.createAnswer()
    await pc.setLocalDescription(answer)

    return web.Response(
        content_type="application/json",
        text=json.dumps(
            {"sdp": pc.localDescription.sdp, "type": pc.localDescription.type}
        ),
    )


def root(request):
    return web.Response(
        content_type="application/json",
        text=json.dumps(
            {"connection": "success"}
        ),
    )

# async def on_shutdown(app):
    # close peer connections
    # await pc.close()


app = web.Application()
cors = aiohttp_cors.setup(app)
# app.on_shutdown.append(on_shutdown)
app.router.add_post("/offer", offer)
app.router.add_get("/", root)

for route in list(app.router.routes()):
    cors.add(route, {
        "*": aiohttp_cors.ResourceOptions(
            allow_credentials=True,
            expose_headers="*",
            allow_headers="*",
            allow_methods="*"
        )
    })

web.run_app(app, host='0.0.0.0', port='3000')
