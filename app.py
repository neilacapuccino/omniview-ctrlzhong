from flask import Flask, request, jsonify, send_file
from PIL import Image
import os
import torch
import pyttsx3
from captioning_model import generate_caption
import uuid

# Initialize Flask
app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Load YOLOv5 model
yolo_model = torch.hub.load('yolov5', 'yolov5s', source='local', force_reload=True)

# TTS function
def text_to_speech(text, output_file='tts_output.wav'):
    engine = pyttsx3.init()
    engine.save_to_file(text, output_file)
    engine.runAndWait()
    return output_file

# Flask route
@app.route('/caption', methods=['POST'])
def caption():
    if 'image' not in request.files:
        return jsonify({"error": "No image provided"}), 400

    # Save uploaded image
    image_file = request.files['image']
    image_id = str(uuid.uuid4())
    image_path = os.path.join(UPLOAD_FOLDER, f"{image_id}.jpg")
    image_file.save(image_path)

    # Generate caption
    caption = generate_caption(image_path)

    # Detect objects with YOLOv5
    results = yolo_model(image_path)
    detected_objects = results.names
    labels = list(set([results.names[int(cls)] for cls in results.pred[0][:, -1].tolist()]))

    # Generate TTS
    audio_file = text_to_speech(caption)

    return jsonify({
        "caption": caption,
        "objects": labels,
        "audio_url": "/tts-audio"
    })

@app.route("/tts-audio")
def serve_audio():
    return send_file("tts_output.wav", mimetype="audio/wav")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
