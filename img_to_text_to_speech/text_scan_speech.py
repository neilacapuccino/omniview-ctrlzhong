import pytesseract
import cv2 
import matplotlib.pyplot as plt 
import pyttsx3
#for config
pytesseract.pytesseract.tesseract_cmd = r"C:\\Program Files\\Tesseract-OCR\tesseract.exe"
img = cv2.imread("C:\\omniview\\img_to_text_to_speech\\text.png")
plt.imshow(img)
plt.axis('off')  
plt.show()

img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

# Extract text
text = pytesseract.image_to_string(img_rgb)

# Print text
print("Text:")
print(text)

#text to speech
engine = pyttsx3.init('sapi5')
voices = engine.getProperty('voices')
engine.setProperty('voice', voices[1].id)
engine.setProperty('rate', 160)

engine.say(text)
engine.runAndWait()
