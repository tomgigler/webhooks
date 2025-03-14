from flask import Flask, request, abort, jsonify
import subprocess
import json
import os

app = Flask(__name__)

# Define repo-to-script mapping dynamically from the deploy-scripts directory
DEPLOY_SCRIPTS_DIR = os.path.abspath(os.path.dirname(__file__)) + "/deploy-scripts"
REPO_DEPLOY_SCRIPTS = {
    "soccer": f"{DEPLOY_SCRIPTS_DIR}/soccer-deploy.sh",
    "pi": f"{DEPLOY_SCRIPTS_DIR}/pi-deploy.sh"
}

@app.route("/update-webhook", methods=["POST"])
def webhook():
    """Trigger the appropriate deployment script based on the repository."""
    try:
        payload = request.get_json()
        repo_name = payload.get("repository", {}).get("name")

        if repo_name not in REPO_DEPLOY_SCRIPTS:
            return jsonify({"error": "No deployment configured for this repo"}), 400

        script_path = REPO_DEPLOY_SCRIPTS[repo_name]
        subprocess.run([script_path], check=True)

        return jsonify({"message": f"Deployment triggered for {repo_name}"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
