#!/bin/bash

# Цвета для вывода
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${GREEN}Starting k3s agent installation...${RESET}"

# Проверяем наличие node-token, ожидаем его появления
echo -e "${YELLOW}Waiting for node token to be available...${RESET}"
while [ ! -f /vagrant/shared/node-token ]; do
  echo -e "${YELLOW}Still waiting for node token...${RESET}"
  sleep 3
done

# Чтение токена
NODE_TOKEN=$(cat /vagrant/shared/node-token)

# Проверка что токен не пустой
if [ -z "$NODE_TOKEN" ]; then
  echo -e "${RED}Error: Node token is empty!${RESET}"
  exit 1
fi

echo -e "${GREEN}Node token found! Installing k3s agent...${RESET}"

# Установка агента
curl -sfL https://get.k3s.io | \
  K3S_URL="https://192.168.56.110:6443" \
  K3S_TOKEN="$NODE_TOKEN" \
  INSTALL_K3S_EXEC="--node-ip=192.168.56.111 --node-name=ebaillotSW --flannel-iface=eth1" \
  sh -

echo -e "${GREEN}k3s agent installed and connected to server!${RESET}"
