
ArkInventory.Tools = { }





--[[
-- /dump GetItemClassInfo( ArkInventory.Const.ENUM.ITEMCLASS.ARMOR.PARENT )
-- /dump GetItemSubClassInfo( ArkInventory.Const.ENUM.ITEMCLASS.ARMOR.PARENT, ArkInventory.Const.ENUM.ITEMCLASS.ARMOR.LEATHER )

for x = 4, 4 do
	--local x = ArkInventory.Const.ENUM.ITEMCLASS.TRADEGOODS.HERBS
	local n = GetItemClassInfo( x )
	--if n and n ~= "" then
		ArkInventory.Output( "----------" )
		ArkInventory.Output( x, " ", n )
	--end
	for y = 0, 50 do
		n = GetItemSubClassInfo( x, y )
		if n and n ~= "" then
			ArkInventory.Output( y, " ", n )
		end
	end
end
]]--

--[[
local name
for x = 352170, 352180 do
--	if IsSpellKnown( x ) then
		name = GetSpellInfo( x )
--		if name and string.match( string.lower( name ), "flying" ) then
			ArkInventory.Output( x, " = ", name, " / ", IsSpellKnown( x ) )
--			GetSpellInfo( 352177 )
--			IsSpellKnown( 352177 )
--		end
--	end
end
]]--


--[[
local z = "always"
ArkInventory.Output( "search=", z )
for k, v in pairs (_G) do
	if type( k ) == "string" and type( v ) == "string" then
		--if string.match( string.lower( k ), string.lower( z ) ) then -- found in key
		--if string.match( string.lower( v ), string.lower( z ) ) then -- found in value
		if string.lower( v ) == string.lower( z ) then -- exact match with value
			ArkInventory.Output( k, "=", v )
		end
	end
end
--]]

function ArkInventory.Tools.dump_enum( value, path, search )
	if type( value ) == "table" then
		for k, v in pairs( value ) do
			ArkInventory.Tools.dump_enum( v, path .. "." .. k, search )
		end
	else
		if string.match( string.lower( path ), string.lower( search ) ) then
			ArkInventory.Output( path, " = ", value )
		end
	end
end
--ArkInventory.Tools.dump_enum( Enum, "Enum", "container" )

function ArkInventory.Tools.dump( value )
	if type( value ) == "table" then
		for k, v in pairs( value ) do
			ArkInventory.Output( k )
		end
	else
		ArkInventory.Output( value )
	end
end
