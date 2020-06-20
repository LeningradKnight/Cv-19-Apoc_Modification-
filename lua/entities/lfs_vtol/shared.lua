-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE

-- IM GETTING SICK OF PEOPLE STEALING CODE SNIPPETS OF HEAVILY CUSTOMIZED VEHICLES AND THEN WONDER WHY THEIR SHIT ACTS WIERD

-- YOU SHOULD USE THE TEMPLATE AS STARTING POINT AND ONLY COPY CODE THAT YOU REALLY NEED IF AT ALL

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "VTOL"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "USA ARMY"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/vtol_cv-19_peregrine.mdl"
ENT.GibModels = {
	"models/debris1.mdl",
	"models/debris2.mdl",
	"models/debris3.mdl",
	"models/debris4.mdl",
	"models/debris5.mdl",
}

ENT.AITEAM = 2

ENT.Mass = 6000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.SeatPos = Vector(173,21,-65)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 0
ENT.MaxRPM = 200
ENT.LimitRPM = 200
ENT.RPMThrottleIncrement = 100

ENT.RotorPos = Vector(76,0,58)
ENT.WingPos = Vector(36,0,68)
ENT.ElevatorPos = Vector(-324,0,98)
ENT.RudderPos = Vector(-324,0,98)

ENT.MaxVelocity = 2000
ENT.MaxPerfVelocity = 1000

ENT.MaxThrust = 500000

ENT.MaxTurnPitch = 600
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 200

ENT.MaxHealth = 3000

ENT.Stability = 0.6

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 40
ENT.MaxThrustVtol = 20000

ENT.MaxPrimaryAmmo = 0
ENT.MaxSecondaryAmmo = 0
ENT.MaxTertiaryAmmo = 0

function ENT:AddDataTables()
	self:NetworkVar( "Bool",11, "IsGroundTouching" )
	self:NetworkVar( "Bool",12, "ForceOpenDoor" )
	self:NetworkVar( "Int",11, "AmmoTertiary", { KeyName = "tertiaryammo", Edit = { type = "Int", order = 5,min = 0, max = self.MaxTertiaryAmmo, category = "Weapons"} } )
	
	self:SetAmmoTertiary( self.MaxTertiaryAmmo )
end

sound.Add( {
	name = "CRYSIS_VTOL_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/crysis_vtol/engine_loop.wav"
} )

sound.Add( {
	name = "CRYSIS_VTOL_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^lfs/crysis_vtol/engine_dist.wav"
} )

sound.Add( {
	name = "CRYSIS_VTOL_MINIGUN_FIRE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/crysis_vtol/minigun_loop.wav"
} )

sound.Add( {
	name = "CRYSIS_VTOL_MINIGUN_LASTSHOT",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/crysis_vtol/minigun_lastshot.wav"
} )

sound.Add( {
	name = "CRYSIS_VTOL_AC_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/crysis_vtol/cannon_loop.wav"
} )

sound.Add( {
	name = "CRYSIS_VTOL_AC_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/crysis_vtol/cannon_lastshot.wav"
} )

sound.Add( {
	name = "CRYSIS_VTOL_MISSILE_FIRE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/crysis_vtol/missile_fire.wav"
} )
