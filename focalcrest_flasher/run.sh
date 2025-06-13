#!/usr/bin/with-contenv bashio

#GPIO0_C1 0_c5 断电
#3_D4复位

# 定义颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}MIXTILE Flasher${NC}"

# 检查设备路径
if bashio::config.has_value 'device'; then
    echo -e "${GREEN}Flashing device:$(bashio::config 'device')${NC}"
else
    echo -e "${RED}Error:Device path error,Program terminated${NC}"
    exit 1
fi

#检查波特率 此插件无用
if bashio::config.has_value 'bootloader_baudrate'; then
    echo -e "${GREEN}Bootloader baudrate:$(bashio::config 'bootloader_baudrate')${NC}"
else
    echo -e "${RED}Error:Bootloader baudrate error,Program terminated${NC}"
    exit 1
fi

# 检查固件链接
if bashio::config.has_value 'firmware_url'; then
    echo -e "${GREEN}Download images from:$(bashio::config 'firmware_url')${NC}"
else
    echo -e "${RED}Error:firmware_url error,Program terminated${NC}"
    exit 1
fi

# 下载固件 检查固件
wget "$(bashio::config 'firmware_url')" -O ./image.gbl && {
    echo -e "${GREEN}Save image succ${NC}"
  # 后续脚本内容...
} || {
    RETVAL=$?
    echo -e "${RED}Images download failed,Please check the url and try again ${NC}"
  exit 1
}

echo -e "${GREEN}Flashing${NC}"

verbose=""
if bashio::config.true 'verbose'; then
    verbose="-v"
    echo -e "${GREEN}verbose mode on${NC}"
else
    echo -e "${GREEN}verbose mode off${NC}"
fi

# 开始烧录
universal-silabs-flasher \
    ${verbose} \
    --device $(bashio::config 'device') \
    flash \
    --firmware image.gbl && {
        echo -e "${GREEN}Update Success${NC}"
} || {
    return_value=$?
    echo -e "${RED}Update Faile,please check the log and try again${NC}"
  exit 1
}
    

