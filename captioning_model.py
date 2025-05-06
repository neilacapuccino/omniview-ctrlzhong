# captioning_model.py
from PIL import Image
from transformers import BlipProcessor, BlipForConditionalGeneration
import torch

# Load once
processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
model = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base")
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)

def generate_caption(image):
    inputs = processor(image, return_tensors="pt").to(device)
    output = model.generate(**inputs)
    return processor.decode(output[0], skip_special_tokens=True)

