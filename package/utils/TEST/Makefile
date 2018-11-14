#
# Copyright (C) 2009-2012 OpenWrt.org
# Copyright (C) 2009-2014 Thomas Heil <heil@terminal-consulting.de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=TEST
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/TEST
  SECTION:=utils
  CATEGORY:=XGD
  DEPENDS:=+libpthread +libubox +libubus 
  TITLE:=TEST
endef



define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) -rf ./src/ $(PKG_BUILD_DIR)/
	$(CP) -rf ./include/ $(PKG_BUILD_DIR)/
	$(CP) ./CMakeLists.txt $(PKG_BUILD_DIR)/
endef

define Package/TEST/install
	$(INSTALL_DIR) $(1)/usr/bin/ 
	$(INSTALL_DIR) $(1)/etc/IoT
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/usr/bin/backup
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/TEST $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/TEST $(1)/usr/bin/backup/
endef

$(eval $(call BuildPackage,TEST))

