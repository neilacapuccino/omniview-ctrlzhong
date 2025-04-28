import pytesseract
import cv2
import pyttsx3

pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

engine = pyttsx3.init('sapi5')
voices = engine.getProperty('voices')
engine.setProperty('voice', voices[1].id)
engine.setProperty('rate', 160)

cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    small_frame = cv2.resize(frame, (640, 480))
    cv2.imshow('Capture', small_frame)

    key = cv2.waitKey(1)

    if key % 256 == 27:
        break
    elif key % 256 == 32:
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        gray = cv2.cvtColor(frame_rgb, cv2.COLOR_RGB2GRAY)
        _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY)
        thresh = cv2.medianBlur(thresh, 3)

        text = pytesseract.image_to_string(thresh, lang='eng')
        print("Detected text:")
        print(text.strip())

        engine.say(text)
        engine.runAndWait()

cap.release()
cv2.destroyAllWindows()
