#!/bin/bash

# 1. Make sure backup script is executable
chmod +x wisp-backup.sh

CURRENT_DIR=$(pwd)
# The Production Schedule: Minute 0, Every 6 hours
CRON_JOB="0 */6 * * * $CURRENT_DIR/wisp-backup.sh >> $CURRENT_DIR/backup.log 2>&1"

# 2. CLEAR the 12:15 AM test schedule
crontab -l 2>/dev/null | grep -v "$CURRENT_DIR/wisp-backup.sh" | crontab -

# 3. INJECT the production schedule
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

echo "🛡️ Production schedule locked in! Backups will run every 6 hours."