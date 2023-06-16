AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")

util.AddNetworkString("IG_UpdateDefconTerminal")

function ENT:Initialize()
	self:SetModel( "models/lordtrilobite/starwars/isd/imp_console_medium03.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

	self:SetSkin( 12 )

	self:PhysWake();
end

net.Receive( "IG_UpdateDefconTerminal", function(_, ply)
	UpdateDefcon( ply, net.ReadUInt(3) )
end)
