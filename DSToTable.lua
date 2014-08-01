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
Documentation:

	[function] CreateDSTable([string] index, [string] type)
	index is the DataStore is used
	type is the type of DataStore (nil or '' for a regular DataStore, 'Ordered' for OrderedDataStore, 'Global' for GlobalDataStore
	Returns [table] DSTable
	
	

	[table] DSTable
		All calls to this table to get an index goes to the DataStore, for example CreateDSTable('test','Ordered').hi is the same as game:GetService('DataStoreService'):GetOrderedDataStore('test'):GetAsync('hi') and therefore returns the same
		All calls to this table to set an index goes to the DataStore, for example CreateDSTable('test','Ordered').hi='hello!' is the same as game:GetService('DataStoreService'):GetOrderedDataStore('test'):SetAsync('hi',true)
		The system is cached per table, so that you can call to the same address infinetly and only use up one request in the DataStore request limit
		
]]
