module("luci.controller.admin.DeviceConfigure", package.seeall)
 
function index()
    entry({"admin", "DeviceConfigure"}, alias("admin", "DeviceConfigure", "DeviceConfigure"), _("DeviceConfigure"), 30).index = true
    entry({"admin", "DeviceConfigure", "DeviceConfigure"}, cbi("admin_DeviceConfigure/DeviceConfigure"), _("Scan_Device"), 1)
end

