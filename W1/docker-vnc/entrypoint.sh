#!/bin/bash

# Khởi động các dịch vụ hệ thống (với quyền root)
echo "Starting D-Bus service..."
service dbus start #

# Khởi động SSH service (với quyền root)
echo "Starting SSH service..."
service ssh start

# --- Chuyển sang user "dev" để chạy các lệnh của user ---
echo "Starting VNC server as dev user..."
su - dev -c '
  mkdir -p /home/dev/.vnc && \
  # SỬA LỖI CUỐI CÙNG: Thêm "\nn" để vncpasswd chạy tự động
  echo -e "password\npassword\nn" | vncpasswd && \
  # Tạo một file xstartup có ghi log lỗi của XFCE
  cat <<EOF > /home/dev/.vnc/xstartup
#!/bin/sh
# Ghi lại log lỗi của XFCE vào file riêng
XFCE_LOG="/home/dev/.vnc/xfce.log"
# Xóa môi trường cũ và khởi động XFCE
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 > "\${XFCE_LOG}" 2>&1
EOF
  chmod +x /home/dev/.vnc/xstartup && \
  vncserver :1 -geometry 1280x720 -depth 24 -localhost no
'

echo "Container is running."
# Giữ cho container tiếp tục chạy
tail -f /dev/null