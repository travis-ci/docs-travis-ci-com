import time
import requests
import base64


TOKEN = "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"
REPO = "Rockykdv5/vampirexcheats"
FILE_PATH = ".travis.yml"
BRANCH = "main"

HEADERS = {
    "Authorization": f"token {TOKEN}",
    "Accept": "application/vnd.github.v3+json"
}

def get_file_sha():

    url = f"https://api.github.com/repos/{REPO}/contents/{FILE_PATH}"
    response = requests.get(url, headers=HEADERS)
    response.raise_for_status()
    return response.json()["sha"]

def get_file_content():

    url = f"https://api.github.com/repos/{REPO}/contents/{FILE_PATH}"
    response = requests.get(url, headers=HEADERS)
    response.raise_for_status()
    return response.json()["content"]

def update_file(new_content, sha):

    url = f"https://api.github.com/repos/{REPO}/contents/{FILE_PATH}"
    data = {
        "message": "Add space to the end of file",
        "content": new_content,
        "sha": sha,
        "branch": BRANCH
    }
    response = requests.put(url, json=data, headers=HEADERS)
    response.raise_for_status()

def main():
    while True:
        try:

            sha = get_file_sha()
            current_content = get_file_content()


            decoded_content = base64.b64decode(current_content).decode("utf-8")
            updated_content = decoded_content + " "
            encoded_content = base64.b64encode(updated_content.encode("utf-8")).decode("utf-8")

            # Update the file
            update_file(encoded_content, sha)
            print("Successfully added a space to the file.")

        except Exception as e:
            print(f"An error occurred: {e}")


        time.sleep(1800)

if __name__ == "__main__":
    main()
