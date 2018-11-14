#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-myapp
PKG_RELEASE:=20181022

PKG_LICENSE:=Apache-2.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-myapp
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:= management Web UI
  MAINTAINER:=Petar Koretic <petar.koretic@sartura.hr>
endef


define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-myapp/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin
	$(INSTALL_BIN) \
		./files/controller/DeviceConfigure.lua \
		$(1)/usr/lib/lua/luci/controller/admin

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/admin_DeviceConfigure
	$(INSTALL_BIN) \
		./files/model/cbi/DeviceConfigure.lua \
		$(1)/usr/lib/lua/luci/model/cbi/admin_DeviceConfigure
	$(INSTALL_DIR) $(1)/etc/IoT/
	$(INSTALL_DATA) \
		./files/description.txt \
		$(1)/etc/IoT/description.txt


endef

$(eval $(call BuildPackage,luci-app-myapp))
