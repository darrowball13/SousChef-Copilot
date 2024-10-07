
import google.generativeai as genai
import os
import PIL.Image
from dotenv import load_dotenv

# Load the variables from the .env file
load_dotenv()

genai.configure(api_key=os.getenv("API_KEY")) 

model = genai.GenerativeModel("gemini-1.5-flash")
myfile = PIL.Image.open('Gemini_API_Tests\pictures\ingredients1.jfif')
response = model.generate_content( ["Can you generate a recipe from these ingredients", myfile])
print(response.text)