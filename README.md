## **Webhook Deployment & Repository Auto-Update System**
This repository manages a centralized webhook that listens for updates from multiple GitHub repositories and triggers automatic deployments.

---

### **📂 Repository Structure**
```
webhooks/
│── deploy.sh               # Script to deploy the webhook
│── webhook.py              # The Flask webhook server
│── deploy-scripts/
│   ├── repo1-deploy.sh     # Deploy script for repo1
│   ├── repo2-deploy.sh     # Deploy script for repo2
│── webhook.service         # Systemd service file
│── README.md               # Documentation
```

---

## **🚀 Setup & Installation**
### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/yourusername/webhooks.git
cd webhooks
```

### **2️⃣ Deploy the Webhook**
Run the deploy script to install dependencies, configure the webhook, and set up systemd:
```bash
./deploy.sh
```

---

## **🛠️ How It Works**
1. **GitHub Webhooks Send Push Events**  
   - Configure GitHub webhooks in each repository to send `POST` requests to:
     ```
     http://yourserver.com/update-webhook
     ```
   - GitHub sends the repository name in the payload.

2. **`webhook.py` Routes Requests**  
   - The webhook script checks which repository triggered the event.
   - It runs the corresponding `deploy-scripts/{repo}-deploy.sh` file.

3. **Deployment Scripts Pull Updates**  
   - Each repo has a custom deployment script in `deploy-scripts/`.
   - The script pulls the latest changes and performs necessary updates.

---

## **⚙️ Managing Repositories**
### **🔹 Adding a New Repository**
1. Add a new deployment script in `deploy-scripts/`:
   ```bash
   cd deploy-scripts
   vi newrepo-deploy.sh
   ```
   Example:
   ```bash
   #!/bin/bash
   cd /var/www/html/newrepo || exit
   git pull origin main
   ```

2. Make it executable:
   ```bash
   chmod +x deploy-scripts/newrepo-deploy.sh
   ```

3. Update `webhook.py` to recognize the new repo:
   ```python
   REPO_DEPLOY_SCRIPTS = {
       "repo1": f"{DEPLOY_SCRIPTS_DIR}/repo1-deploy.sh",
       "repo2": f"{DEPLOY_SCRIPTS_DIR}/repo2-deploy.sh",
       "newrepo": f"{DEPLOY_SCRIPTS_DIR}/newrepo-deploy.sh"
   }
   ```

4. Restart the webhook service:
   ```bash
   sudo systemctl restart webhook.service
   ```

### **🔹 Removing a Repository**
1. Delete the repo’s deployment script:
   ```bash
   rm deploy-scripts/repo-to-remove-deploy.sh
   ```

2. Remove it from `webhook.py` and restart the service.

---

## **🔧 Managing the Webhook Service**
### **Starting, Stopping, and Restarting**
```bash
sudo systemctl start webhook.service
sudo systemctl stop webhook.service
sudo systemctl restart webhook.service
```

### **Checking Logs**
```bash
journalctl -u webhook.service --follow
```

---

## **🐛 Troubleshooting**
### **Webhook Not Responding?**
- Check if Flask is running:
  ```bash
  sudo systemctl status webhook.service
  ```
- If it's not running, restart:
  ```bash
  sudo systemctl restart webhook.service
  ```

### **Deployment Failing?**
- Run the deployment script manually to check for errors:
  ```bash
  ./deploy-scripts/repo1-deploy.sh
  ```
- Check the logs:
  ```bash
  sudo tail -f /var/log/syslog
  ```

---

## **📌 Future Improvements**
- 🔒 Add webhook authentication (e.g., GitHub HMAC verification).
- 📄 Log webhook activity for debugging.
- 🔄 Auto-restart on failure with monitoring.

---

## **👨‍💻 Contributors**
Maintained by **Tom Gigler**.  
PRs and contributions welcome! 🎉

---

This **README.md** gives clear **installation instructions, usage details, management commands, and troubleshooting steps.** Anything you'd like to add or tweak?
