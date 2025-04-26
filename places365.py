import os
import torch
import torchvision.transforms as transforms
from torchvision import models
from PIL import Image
import requests

# -------- 1. Download category names --------
if not os.path.exists('categories_places365.txt'):
    print("Downloading category labels...")
    categories_url = 'https://raw.githubusercontent.com/csailvision/places365/master/categories_places365.txt'
    with open('categories_places365.txt', 'wb') as f:
        f.write(requests.get(categories_url).content)

# Load label names
with open('categories_places365.txt') as f:
    classes = [line.strip().split(' ')[0][3:] for line in f]

# -------- 2. Download pretrained model --------
model_file = 'resnet18_places365.pth.tar'
if not os.path.exists(model_file):
    print("Downloading pretrained Places365 model (ResNet18)...")
    model_url = 'http://places2.csail.mit.edu/models_places365/resnet18_places365.pth.tar'
    with open(model_file, 'wb') as f:
        f.write(requests.get(model_url).content)

# Load model
model = models.resnet18(num_classes=365)
checkpoint = torch.load(model_file, map_location=torch.device('cpu'))
state_dict = {k.replace('module.', ''): v for k, v in checkpoint['state_dict'].items()}
model.load_state_dict(state_dict)
model.eval()

# -------- 3. Image transformation --------
transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

# -------- 4. Load and process your image --------
image_path = 'beach.jpg'  # Replace this with your image file
img = Image.open(image_path).convert('RGB')
input_img = transform(img).unsqueeze(0)

# -------- 5. Run model --------
with torch.no_grad():
    output = model(input_img)
    probs = torch.nn.functional.softmax(output, dim=1)
    top5_probs, top5_idxs = probs.topk(5)

# -------- 6. Show top 5 predictions --------
print("\nTop scene predictions:")
for i in range(5):
    label = classes[top5_idxs[0][i]]
    confidence = top5_probs[0][i].item()
    print(f"{label}: {confidence:.4f}")

# Get best label
scene_label = classes[top5_idxs[0][0]]
print(f"\nMost likely scene: {scene_label}")