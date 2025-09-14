# Sử dụng image Ubuntu 22.04 làm nền
FROM ubuntu:22.04

# Tránh các hộp thoại hỏi đáp khi cài đặt gói
ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt các gói cần thiết
# sudo: để cấp quyền cho user
# xfce4, xfce4-goodies: Môi trường desktop XFCE
# tightvncserver: VNC server
# openssh-server: SSH server
# nano: Trình soạn thảo văn bản để dễ debug
RUN apt-get update && apt-get install -y \
    sudo \
    xfce4 \
    xfce4-goodies \
    xterm \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-tools \
    openssh-server \
    nano \
    dbus-x11 \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Tạo một user mới tên là "dev" với mật khẩu là "dev"
# Thêm user này vào nhóm sudo để có quyền admin
RUN useradd -m -s /bin/bash dev && \
    echo "dev:dev" | chpasswd && \
    adduser dev sudo

# Cấu hình SSH server
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Sao chép script khởi động VÀO ĐÚNG THƯ MỤC LÀM VIỆC
COPY entrypoint.sh /home/dev/entrypoint.sh

# Cấp quyền thực thi và đổi chủ sở hữu cho user "dev"
# Bước này phải được thực hiện KHI CÒN LÀ ROOT
RUN chmod +x /home/dev/entrypoint.sh && \
    chown dev:dev /home/dev/entrypoint.sh

# CHUYỂN SANG USER "dev"
# USER dev
WORKDIR /home/dev

# Thiết lập môi trường cho VNC (có thể giữ lại hoặc không)
ENV USER=dev \
    HOME=/home/dev

# Mở cổng cho VNC (5901) và SSH (22)
EXPOSE 5901 22

# Lệnh sẽ chạy khi container khởi động
CMD ["/home/dev/entrypoint.sh"]
