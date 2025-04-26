import os
import torch
import torchvision.transforms as transforms
from torchvision import models
from PIL import Image
import cv2
import requests

# -------- Setup (download necessary files) --------

# Download Places365 labels
if not os.path.exists('categories_places365.txt'):
    print("Downloading category labels...")
    categories_url = 'https://raw.githubusercontent.com/csailvision/places365/master/categories_places365.txt'
    with open('categories_places365.txt', 'wb') as f:
        f.write(requests.get(categories_url).content)

# Load label names
with open('categories_places365.txt') as f:
    classes = [line.strip().split(' ')[0][3:] for line in f]

# Download Places365 model
model_file = 'resnet18_places365.pth.tar'
if not os.path.exists(model_file):
    print("Downloading pretrained Places365 model...")
    model_url = 'http://places2.csail.mit.edu/models_places365/resnet18_places365.pth.tar'
    with open(model_file, 'wb') as f:
        f.write(requests.get(model_url).content)

# Load Places365 model
scene_model = models.resnet18(num_classes=365)
checkpoint = torch.load(model_file, map_location=torch.device('cpu'))
state_dict = {k.replace('module.', ''): v for k, v in checkpoint['state_dict'].items()}
scene_model.load_state_dict(state_dict)
scene_model.eval()

# Image transforms
scene_transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

# -------- Image Captioning Model --------
# Use torchvision's pretrained captioning model (new in torchvision 0.15+)

from torchvision.models import vit_b_16, ViT_B_16_Weights
from torchvision.models import vit_b_32, ViT_B_32_Weights
from torchvision.models.detection import fasterrcnn_resnet50_fpn

from torchvision.models import resnet50
from torchvision.models.vision_transformer import VisionTransformer
from torchvision.models import vit_b_16
import torchvision.models as models

try:
    from torchvision.models import vit_b_16, ViT_B_16_Weights
except:
    print("Upgrade torchvision to version 0.15+ to use built-in captioning models.")

from transformers import BlipProcessor, BlipForConditionalGeneration

# Load BLIP model (one of the best lightweight captioning models)
processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
caption_model = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base")

# -------- Capture Image from Camera --------

def capture_photo(save_path='captured_photo.jpg'):
    cap = cv2.VideoCapture(0)
    print("Press SPACE to capture the photo.")
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        cv2.imshow('Camera', frame)
        
        key = cv2.waitKey(1)
        if key % 256 == 32:  # Space key
            cv2.imwrite(save_path, frame)
            print(f"Photo saved as {save_path}")
            break

    cap.release()
    cv2.destroyAllWindows()

# -------- Recognize Scene --------

def recognize_scene(img_path):
    img = Image.open(img_path).convert('RGB')
    input_img = scene_transform(img).unsqueeze(0)

    with torch.no_grad():
        output = scene_model(input_img)
        probs = torch.nn.functional.softmax(output, dim=1)
        top1_prob, top1_idx = probs.topk(1)

    label = classes[top1_idx[0][0]]
    confidence = top1_prob[0][0].item()

    return label, confidence

# -------- Generate Caption --------

def generate_caption(img_path):
    img = Image.open(img_path).convert('RGB')
    inputs = processor(img, return_tensors="pt")

    with torch.no_grad():
        out = caption_model.generate(**inputs)
    
    caption = processor.decode(out[0], skip_special_tokens=True)
    return caption

# -------- MAIN --------

def main():
    # Step 1: Take Photo
    capture_photo()

    # Step 2: Recognize Scene
    scene_label, confidence = recognize_scene('captured_photo.jpg')
    print(f"\nDetected Scene: {scene_label} ({confidence*100:.2f}% confidence)")

    # Step 3: Generate Caption
    caption = generate_caption('captured_photo.jpg')
    print(f"\nGenerated Caption: {caption}")

    # Step 4: Combine description
    full_description = f"This photo shows a {scene_label}. Description: {caption}."
    print(f"\nFull Description:\n{full_description}")

if __name__ == "__main__":
    main()
