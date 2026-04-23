# 第一阶段：下载与准备
FROM alpine:latest AS builder
RUN apk add --no-cache wget tar

WORKDIR /tmp
# 建议手动检查版本号是否正确，或使用环境变量
RUN wget https://github.com/SagerNet/sing-box/releases/download/v1.10.1/sing-box-1.10.1-linux-amd64.tar.gz && \
    tar -zxvf sing-box-1.10.1-linux-amd64.tar.gz && \
    mv sing-box-1.10.1-linux-amd64/sing-box /usr/local/bin/sing-box && \
    chmod +x /usr/local/bin/sing-box

# 第二阶段：运行环境
FROM alpine:latest
RUN apk add --no-cache ca-certificates mailcap

WORKDIR /app
# 从 builder 阶段拷贝二进制文件
COPY --from=builder /usr/local/bin/sing-box /app/sing-box
# 拷贝配置文件
COPY config.json /app/config.json

# 确保端口与 Back4app 设置一致
EXPOSE 8080

CMD ["./sing-box", "run", "-c", "config.json"]
