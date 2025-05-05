# detect_api.py
from flask import Flask, request, jsonify
from ultralytics import YOLO  # or use YOLOv5 if not using Ultralytics >=8
import cv2
import numpy as np
import base64
import io
from PIL import Image

app = Flask(__name__)
model = YOLO('yolov5s.pt')

@app.route('/detect', methods=['POST'])
def detect():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    file = request.files['image']
    image = Image.open(file.stream).convert('RGB')
    image = np.array(image)

    results = model(image)
    boxes = results[0].boxes.xyxy.cpu().numpy().tolist()  # [x1, y1, x2, y2]
    labels = results[0].boxes.cls.cpu().numpy().tolist()
    confidences = results[0].boxes.conf.cpu().numpy().tolist()

    return jsonify({
        'boxes': boxes,
        'labels': labels,
        'confidences': confidences
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
