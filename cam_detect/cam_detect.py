from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
from PIL import Image
import io

app = Flask(__name__)
model = YOLO('yolov5s.pt')  # Ensure this model file is downloaded

@app.route('/caption', methods=['POST'])  # Match the route your Flutter app uses
def caption():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    file = request.files['image']
    try:
        image = Image.open(file.stream).convert('RGB')
        image_np = np.array(image)

        # Run detection
        results = model(image_np)

        # Extracting caption from detection results (as a simple label list for now)
        labels = results[0].names if hasattr(results[0], 'names') else results[0].boxes.cls.cpu().numpy().tolist()
        caption = ', '.join([str(label) for label in labels]) if labels else "No objects detected"

        return jsonify({'caption': caption})
    except Exception as e:
        return jsonify({'error': f'Failed to process image: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
