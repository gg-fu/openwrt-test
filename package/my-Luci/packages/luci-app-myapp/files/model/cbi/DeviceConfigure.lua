-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.0
local db_e = require "luasql.sqlite3"  
local fs  = require "nixio.fs"
                                                                                                       
f = SimpleForm("DeviceList", translate("DeviceList"), translate("This list gives an overview over currently status device_name meteId deviceId"))
f.reset = false
f.submit = false

device_list = {}
device_name = {}
test = {}
local num = 0
status_value = -1

---
--- sleep n second
---
function sleep(n)
	local t0 = os.clock()
	while os.clock()-t0 <= n do
	end
end
                                                    
---
--- read device message from devicehub.db file
---                                                                                    
function open_db()                                                                                                                                                        
    env = assert(db_e.sqlite3())                    
    db =assert(env:connect("/etc/IoT/devicehub.db"))
end                            
                                       
function sqlite3query(sql) 
    local tb = {}                         
    -- body                                         
    open_db()                          
    local res = assert(db:execute(sql))             
                                      
    local t = {}                      
    local i = 1                        
    while(nil ~= res:fetch(t, 'a')) do 
        tb[i] = {}    
        tb[i] = t                      
        t = {}  --must                
        i=i+1                         
    end           
    res:close()                       
    close_db()   

    for i=1,table.getn(tb) do
	device_name[tb[i].deviceId] = tb[i].device_name
    end       
    return device_name           
end                     
                        
function close_db( ... )
    -- body          
    db:close()         
    env:close()                 
end
      
---
--- change the key name  
---
function Changes_key(szFullString,Table)
        if type(szFullString)~="string" then
                return szFullString
        end
        if type(Table)~="table" then
                return szFullString
        end
        local len = string.len(szFullString)
        local i = 0
        local index_ = 0
        local num = table.getn(Table)
        local str = {}
        local length = {}
        string_ = " "
        flag = 0
        for j=1,num do
                str[j] = string.sub(tostring(Table[j]),1,1)
                length[j] = string.len(tostring(Table[j]))
        end
        while i <= len do
                i = i + 1
                for j=1,num do
                        if string.sub(szFullString,i,i) == str[j] then
                                local match_str = string.sub(szFullString,i,i+length[j]-1)
                                if match_str == Table[j] then
                                        if j==1 then
                                                flag = flag + 1
                                        end
                                        string_ = string.format("%s%s%s%d",string_,string.sub(szFullString,index_,i-1),match_str,flag)
                                        i = i+length[j]
                                        index_ = i
                                else
                                        i = i + 1
                                end
                        end

                end

        end
        string_ = string.format("%s%s",string_,string.sub(szFullString,index_,len))
        return string_,flag
end

---
--- take the string to table
---
function StrToTable(str)
    if str == nil or type(str) ~= "string" then
        return
    end

    return loadstring("return " .. str)()
end

---
--- change the json message to table
---
function JsonToTable(json_data)
        local length = string.len(json_data)
        local i = 0
        local index = 1
        local str = " "
        while i <= length do
                i = i + 1
                if string.sub(json_data,i,i) == ":" then
                        for j=index,i-1 do
                                if string.sub(json_data,j,j)=="\"" then
                                        str = string.format("%s%s%s%s%s",str,string.sub(json_data,index,j-1),"[",string.sub(json_data,j,i-1),"]=")
                                        break
                                end
                        end
                        for j=i+1,length do
                                if string.sub(json_data,j,j)=="," then
                                        str = string.format("%s%s",str,string.sub(json_data,i+1,j))
                                        index = j+1
                                        i = j
                                        break
                                elseif string.sub(json_data,j,j)=="{" then
                                        str = string.format("%s%s",str,"{")
                                        index = j+1
                                        i = j
                                        break
                                elseif string.sub(json_data,j,j)=="]" then
                                        str = string.format("%s%s%s",str,string.sub(json_data,i+1,j-1),"}")
                                        index = j+1
                                        i = j
                                        break
                                elseif string.sub(json_data,j,j)=="[" then
                                        str = string.format("%s%s",str,"{")
                                        index = j+1
                                        i = j
                                        break
                                end
                        end
                end
        end
        str = string.format("%s%s",str,string.sub(json_data,index,length))
	
	return StrToTable(str)

end

---
--- Display device real time status
---         
function change_status(deviceID_,meteId,section)
    	local stt = luci.sys.exec("ubus -v call devicehub get_devs \'{\"sqno\":666,\"randomcode\":\"528agb\"}\'")
	json_str,deviceNum = Changes_key(stt,{"deviceId","metes"})
        --table_msg = json.decode(json_str)
        table_msg = JsonToTable(json_str)
	data_ = table_msg["devicelist"]
	if table_msg == nil then
		luci.http.write("ubus command failed")
		return
	end
	for i=1,deviceNum do
		local deviceId = string.format("deviceId%d",i)
		local metes = string.format("metes%d",i)
		if data_[deviceId] == deviceID_ then 
			for k,v in pairs(data_[metes]) do
				if type(v) == "table" then
					for k1,v1 in pairs(v) do
						if k1 == meteId then
							test[section].status = tostring(v1)
						end

					end
				end
			end
		end
	end
	return test
	
end

---
--- get device status
---	
function Get_devs()
	test = {}
    	local data = luci.sys.exec("ubus -v call devicehub get_devs \'{\"sqno\":666,\"randomcode\":\"528agb\"}\'")
	json_str,_ = Changes_key(data,{"deviceId","metes"})
        --table_msg = json.decode(json_str)
        table_msg = JsonToTable(json_str)
	if table_msg == nil then
		luci.http.write("ubus command failed")
		return
	end
	for k1,v1 in pairs(table_msg.devicelist) do
		if type(v1) ~= "table" then
			device_list[k1]=v1
		
		end	
	end
     	for k,v in pairs(table_msg.devicelist) do
	    	if type(v) == "table" then
			local str = string.format("deviceId%d",string.match(k,"%d+"))
			for k2,v2 in pairs(v) do
				if type(v2) == "table" then
					for k3,v3 in pairs(v2) do
						num = num+1
						test[num]={}
						test[num]["meteId"]=k3
						test[num]["status"]=tostring(v3)
						test[num]["deviceId"] = device_list[str]
						test[num]["deviceName"] = device_name[device_list[str]]
					end
				end
			end
 		end
		
	end
	return test
	
end

sqlite3query("select deviceId,device_name,mete_num,createTime from iot_bas_device") 
Get_devs()
t = f:section(Table,test)
t:option(DummyValue, "deviceName", translate("deviceName"))
t:option(DummyValue, "deviceId", translate("deviceId"))
t:option(DummyValue, "meteId", translate("meteId"))
o = t:option(Value, "status", translate("status"))
o.size = 5
o.datatype="uinteger"

---
--- the "Value" write action
---
function o.write(self,section,value)
	status_value = value
end

---
--- Scanning on line equipment
---                                                                           
scan = t:option(Button, "_Scan", translate("Scan"))
scan.inputstyle = "apply"
function scan.write(self, section)
     	--
    	-- Scan Device
	--
     
	local str = luci.sys.exec("ubus -v call devicehub allowjoin \'{\"sqno\":120,\"scanflag\":1}\'")

end

---
--- delete related devices
---
delete = t:option(Button, "_delete", translate("Delete"))
delete.inputstyle = "apply"
function delete.write(self, section)
    	--
	-- delete device
     	--
     	local s = string.format("ubus -v call devicehub dev_delete \'{\"sqno\":666,\"deviceId\":\"%s\"}\'",test[section].deviceId)
	luci.sys.exec(s)
end

---
--- control devices
---
control = t:option(Button, "_control", translate("Control"))
control.inputstyle = "apply"
function control.write(self, section)
	if tonumber(test[section].status) ~= status_value then
	
		if status_value ~= -1 then
			local str = string.format("ubus -v call devicehub dev_control \'{\"sqno\":120,\"deviceId\":\"%s\",\"meteId\":\"%s\",\"value\":%d}\'",test[section].deviceId,test[section].meteId,status_value)
			local res = luci.sys.exec(str)
			sleep(0.3)
			change_status(test[section].deviceId,test[section].meteId,section)
		end
	end
	status_value = -1
end


---
--- Equipment specification interface
---
m = SimpleForm("rc", translate("Description document"),                                                                                                                
        translate("This is a description document for control equipment,and you can add new description to extend the document!"))
                                                                                                                                                                
t = m:field(TextValue, "rcs")                                                                                                                                   
t.rmempty = true                                                                                                                                                
t.rows = 20                                                                                                                                                     
                                                                                                                                                                
function t.cfgvalue()
	if fs.access("/etc/IoT/description.txt") then
		return fs.readfile("/etc/IoT/description.txt")
	end                                                                                                                                           
end                                                                                                                                                             
                                                                                                                                                                
function m.handle(self, state, data)                                                                                                                            
        if state == FORM_VALID then                                                                                                                             
                if data.rcs then                                                                                                                                
                        fs.writefile("/etc/IoT/description.txt", data.rcs:gsub("\r\n", "\n"))                                                                              
                end                                                                                                                                             
        end                                                                                                                                                     
        return true                                                                                                                                             
end    

return f,m
