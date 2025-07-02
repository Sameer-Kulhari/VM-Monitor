# VM - Monitor
# 💻 VM-Monitor

**VM-Monitor** is a lightweight Bash-based monitoring tool that **detects idle Linux virtual machines** — specifically designed for systems running **XRDP (remote desktop)**. If the VM has been idle for a specified time (default: 30 minutes), it sends a **push notification** via [ntfy.sh](https://ntfy.sh/).

---

## 🚀 Features

- **Monitor inactivity** on cloud VMs (Azure, AWS, GCP, etc.)
- **Save costs** by identifying unused compute resources
- **Get alerts** when your desktop-accessed VMs are idle

---

## 🔔 How It Works

The script `vm-idle-notifier.sh`:

1. **Checks CPU usage** — low usage means low system activity
2. **Checks XRDP user sessions** — no active remote desktop users = likely idle
3. **Tracks idle time** — if both conditions are true for 30+ minutes
4. **Sends a push notification** to your phone or browser via [ntfy.sh](https://ntfy.sh/)

Runs automatically every 5 minutes using a **systemd service** (no cron jobs needed).

---

## 📦 What's Included

| File                        | Description                                           |
|-----------------------------|------------------------------------------------------|
| `vm-idle-notifier.sh`       | Bash script that monitors CPU and XRDP sessions      |
| `vm-idle-notifier.service`  | *systemd* unit file to run the script in background  |
| `README.md`                 | Setup instructions and usage details                 |

---

## 🛠️ Installation Guide

Follow these steps on **any Linux VM** (Debian/Ubuntu recommended):

### 1️⃣ Clone the Repo

```bash
git clone https://github.com/Sameer-Kulhari/VM-Monitor.git
cd VM-Monitor
```

### 2️⃣ Move the Script to `/opt`

```bash
sudo mkdir -p /opt/vm-monitor
sudo cp vm-idle-notifier.sh /opt/vm-monitor/
sudo chmod +x /opt/vm-monitor/vm-idle-notifier.sh
```

### 3️⃣ Install the systemd Service

```bash
sudo cp vm-idle-notifier.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable vm-idle-notifier
sudo systemctl start vm-idle-notifier
```

### 4️⃣ Done! 🎉

The script will now check your VM every 5 minutes. If it's been idle for 30+ minutes (no XRDP users + low CPU), you'll get a push notification via [ntfy.sh](https://ntfy.sh/).

---

## ⚙️ Configuration (Optional)

You can customize thresholds by editing the script:

```bash
sudo nano /opt/vm-monitor/vm-idle-notifier.sh
```

**Variables You Can Change:**

| Variable                | Default Value      | Description                                         |
|-------------------------|-------------------|-----------------------------------------------------|
| `TOPIC`                 | `vm-idle-xrdp`    | Your [ntfy.sh](https://ntfy.sh/) topic name         |
| `IDLE_THRESHOLD_MINUTES`| `30`              | Minutes before a notification is sent               |
| `CPU_IDLE_LIMIT`        | `5`               | Max CPU usage (%) to consider VM idle               |

---

## 📲 Receiving Notifications

You can receive messages via:

- **Browser:** Open `https://ntfy.sh/YOUR_TOPIC_NAME`
- **ntfy mobile app**
- **ntfy CLI** or self-hosted instance

---

## 🧪 Testing & Logs

**Test the script manually:**
```bash
/opt/vm-monitor/vm-idle-notifier.sh
```

**Check service logs:**
```bash
journalctl -u vm-idle-notifier -f
```

---

## 🧼 Uninstall

```bash
sudo systemctl stop vm-idle-notifier
sudo systemctl disable vm-idle-notifier
sudo rm /etc/systemd/system/vm-idle-notifier.service
sudo rm -rf /opt/vm-monitor
```

---

## 🙌 Contributing

Pull requests and suggestions are welcome!

---

> **🧠 Tip:**  
> Use a **random topic** for *ntfy.sh* (like `vm-idle-2ja7xfz`) to prevent public access.