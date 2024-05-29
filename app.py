from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd
import time

url = 'https://www.youtube.com/@JohnWatsonRooney/videos'
driver = webdriver.Chrome()
driver.get(url)

# Scroll down to load more videos
last_height = driver.execute_script("return document.documentElement.scrollHeight")
while True:
    driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")
    time.sleep(2)  # wait for the page to load
    new_height = driver.execute_script("return document.documentElement.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height

# Wait until the video elements are present
wait = WebDriverWait(driver, 10)
videos = wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, 'style-scope ytd-rich-grid-media')))

video_list = []
for video in videos:
    try:
        # Extract video details with waits to ensure elements are present
        title = video.find_element(By.XPATH, './/*[@id="video-title"]').text
        views = video.find_element(By.XPATH, './/*[@id="metadata-line"]/span[1]').text
        time = video.find_element(By.XPATH, './/*[@id="metadata-line"]/span[2]').text
        
        vid_item = {
            'title': title,
            'views': views,
            'posted': time
        }
        video_list.append(vid_item)
    except Exception as e:
        print(f"Error: {e}")

# Create DataFrame
df = pd.DataFrame(video_list)
print(df)

# Save DataFrame to a CSV file
csv_file_path = "youtube_videos.csv"
df.to_csv(csv_file_path, index=False)

print(f"Data saved to {csv_file_path}")

# Close the WebDriver
driver.quit()
