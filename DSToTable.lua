CreateDSTable=function(index,type)
  local ds
  if type==nil or type=='' then
	ds=game:GetService('DataStoreService'):GetDataStore(index)
	elseif tostring(type):lower()=='ordered' then
	ds=game:GetService('DataStoreService'):GetOrderedDataStore(index)
	elseif tostring(type):lower()=='global' then
	ds=game:GetService('DataStoreService'):GetGlobalDataStore(index)
	end
	local t={}
	local cache={}
	local updater={}
	setmetatable(t,{})
	local m=getmetatable(t )
	m.__index=function(_,i)
		if cache[i]==nil then
			local r=ds:GetAsync(i )
			cache[i]=r
			if updater[i]==nil then
			ds:OnUpdate(i,function(v) cache[i]=v end) updater[i]=true end
			return r
		else
			return cache[i]
		end
	end
	m.__newindex=function(_,i,v)
		ds:SetAsync(i,v)
		cache[i]=v
		if updater[i]==nil then
		ds:OnUpdate(i,function(val) cache[i]=val end) updater[i]=true end)
	end
	return t
end

--[[
Examples
