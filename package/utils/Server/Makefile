#
# Copyright (C) 2009-2012 OpenWrt.org
# Copyright (C) 2009-2014 Thomas Heil <heil@terminal-consulting.de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=Server
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/Server
  SECTION:=utils
  CATEGORY:=XGD
  DEPENDS:=+libpthread +libdaemon +libblobmsg-json +libubox +libubus +libsqlite3 +libjson-c +libevent2
  TITLE:=Server
endef



define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) -rf ./src/ $(PKG_BUILD_DIR)/
	$(CP) -rf ./include/ $(PKG_BUILD_DIR)/
	$(CP) -rf ./lib/ $(PKG_BUILD_DIR)/
	$(CP) ./CMakeLists.txt $(PKG_BUILD_DIR)/
endef

define Package/Server/install
	$(INSTALL_DIR) $(1)/usr/bin/ 
	$(INSTALL_DIR) $(1)/etc/IoT
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/usr/bin/backup
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/Server $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/Server $(1)/usr/bin/backup/
endef

$(eval $(call BuildPackage,Server))

