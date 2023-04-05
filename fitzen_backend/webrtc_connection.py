from aiortc import MediaStreamTrack, RTCPeerConnection, RTCSessionDescription
from aiortc.contrib.media import MediaRelay
from aiohttp import web
import json
import multiThreadingVersion
import blink_detection
from av import VideoFrame

relay = MediaRelay()

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
        image = frame.to_rgb().to_ndarray()
        dict = await multiThreadingVersion.image_frame_model(image)
        blink_dict = blink_detection.detect_blinks(image)
        # print(dict['posture_class'])
        # print(blink_dict["eye_strain_level"])

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
                    VideoTransformTrack.channel.send(json.dumps({
                        'posture': dict['posture_class'],
                        'good_posture_count': dict['good_posture_count'],
                        'bad_posture_count': dict['bad_posture_count'],
                        'total_blink_count': blink_dict['total_blink_count'],
                        'eye_strain': blink_dict["eye_strain_level"]
                    }))
                    break

        new_frame = VideoFrame.from_ndarray(dict['image_frame'], format="rgb24")
        new_frame.pts = frame.pts
        new_frame.time_base = frame.time_base
        return new_frame


async def handleConnection(request):
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
            blink_detection.eye_strain_level = 0
            blink_detection.total_blink_count = 0
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