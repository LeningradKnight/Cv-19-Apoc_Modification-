-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE

-- IM GETTING SICK OF PEOPLE STEALING CODE SNIPPETS OF HEAVILY CUSTOMIZED VEHICLES AND THEN WONDER WHY THEIR SHIT ACTS WIERD

-- YOU SHOULD USE THE TEMPLATE AS STARTING POINT AND ONLY COPY CODE THAT YOU REALLY NEED IF AT ALL

include("shared.lua")

local VisibleTime = 0
local smVisible = 0
local zoom_mat = Material( "vgui/zoom" )
local mat = Material( "sprites/light_glow02_add" )

local function DrawCircle( X, Y, radius ) -- handy draw circle function. I should make this a global function at some point
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

function ENT:LFSHudPaintPassenger( X, Y, ply )
	if ply ~= self:GetGunner() then return end

	local UsingGunCam = self.ToggledView
	
	local HitPlane = Vector(X*0.5,Y*0.5,0)

	local ID = self:LookupAttachment( "muzzle" )
	local Attachment = self:GetAttachment( ID )

	if Attachment then
		-- for the crosshair to be accurate CLIENT aiming code has to be exactly the same as SERVER aiming code
		
		local Dir = ply:EyeAngles():Forward()
		local TargetDir = Attachment.Ang:Forward()
		local Forward = self:LocalToWorldAngles( Angle(0,0,0) ):Forward()
		local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( Dir ) ,-1,1) ) )
		if AimDirToForwardDir < 120 then
			TargetDir = Dir
		end
		
		local Trace = util.TraceLine( {
			start = Attachment.Pos,
			endpos = (Attachment.Pos + TargetDir  * 50000),
			filter = self
		} )
		
		local pToScreen = Trace.HitPos:ToScreen()
		
		HitPlane = Vector(pToScreen.x,pToScreen.y,0)
	end
	
	local Time = CurTime()
	
	if self:GetAmmoTertiary() ~= self.OldAmmoTertiary then
		self.OldAmmoTertiary = self:GetAmmoTertiary()
		VisibleTime = Time + 2
	end
	
	local Visible = VisibleTime > Time
	smVisible = smVisible + ((Visible and 1 or 0) - smVisible) * FrameTime() * 10
	
	local wobl = ((VisibleTime - 1.9 > Time) and  self:GetAmmoTertiary() > 0) and math.cos( Time * 300 ) * 6 or 0
	
	local vD = 5 + (5 + wobl)
	local vD2 = 10 + (10 + wobl)
	surface.SetDrawColor( Color(255,255,255,255) )
	surface.DrawLine( HitPlane.x + vD, HitPlane.y, HitPlane.x + vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - vD, HitPlane.y, HitPlane.x - vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + vD, HitPlane.x, HitPlane.y + vD2 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - vD, HitPlane.x, HitPlane.y - vD2 ) 
	
	local HitPlane = HitPlane + Vector(1,1,0)
	surface.SetDrawColor( Color(0,0,0,50) )
	surface.DrawLine( HitPlane.x + vD, HitPlane.y, HitPlane.x + vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x - vD, HitPlane.y, HitPlane.x - vD2, HitPlane.y ) 
	surface.DrawLine( HitPlane.x, HitPlane.y + vD, HitPlane.x, HitPlane.y + vD2 ) 
	surface.DrawLine( HitPlane.x, HitPlane.y - vD, HitPlane.x, HitPlane.y - vD2 ) 
	
	draw.SimpleText( self:GetAmmoTertiary(), "LFS_FONT", HitPlane.x + 10, HitPlane.y + 10, Color(255,255,255,55 + 200 * smVisible), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	if not UsingGunCam then return end
	
	local X = ScrW() * 0.5
	local Y = ScrH() * 0.5
	
	self.curZoom = self.curZoom or 90
	
	local Scale = (2.5 - self.curZoom / 70)
	
	local R = X * 0.2 * Scale
	
	surface.SetDrawColor( Color(255,255,255,50) )
	DrawCircle( X, Y, R * 0.8 )
	DrawCircle( X, Y, R )
	
	surface.SetDrawColor( Color(0,0,0,50) )
	DrawCircle( X + 1, Y + 1, R * 0.8 )
	DrawCircle( X + 1, Y + 1, R )
	
	for i = 3, 43 do
		surface.SetDrawColor( Color(255,255,255,100) )
		surface.DrawLine( X + R * 0.19 * i, Y + R * 0.05, X + R * 0.19 * i, Y - R * 0.05 )
		surface.DrawLine( X - R * 0.19 * i, Y + R * 0.05, X - R * 0.19 * i, Y - R * 0.05 )
		
		surface.SetDrawColor( Color(0,0,0,50) )
		surface.DrawLine( X + R * 0.19 * i + 1, Y + R * 0.05 + 1, X + R * 0.19 * i + 1, Y - R * 0.05 + 1 )
		surface.DrawLine( X - R * 0.19 * i + 1, Y + R * 0.05 + 1, X - R * 0.19 * i + 1, Y - R * 0.05 + 1 )
	end

	surface.SetDrawColor( Color(255,255,255,255) )
	surface.SetMaterial(zoom_mat ) 
	surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
	surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
	surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
	surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
end

function ENT:GunCamera( view, ply )
	if ply == self:GetGunner() then
		local Zoom = ply:KeyDown( IN_ATTACK2 )
		
		local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
		local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
		
		if self.oldZoom ~= Zoom then
			self.oldZoom = Zoom
			if Zoom then
				self.ToggledView = not self.ToggledView
			else
				self.curZoom = 90
			end
		end
		
		self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 100,20,90) or 0
		
		if self.ToggledView then
			local ID = self:LookupAttachment( "muzzle" )
			local Attachment = self:GetAttachment( ID )

			if Attachment then
				view.origin = Attachment.Pos + Attachment.Ang:Up() * 15 + Attachment.Ang:Forward() * 5
			else
				view.origin = self:LocalToWorld( Vector(344.11,0,-62) )
			end
			
			view.fov = self.curZoom
		end
	end
	
	if self.oldToggledView ~= self.ToggledView then
		self.oldToggledView = self.ToggledView
		
		if self.ToggledView then
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		else
			surface.PlaySound("weapons/sniper/sniper_zoomout.wav")
		end
	end
	
	return view
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	if ply ~= self:GetDriver() and ply ~= self:GetGunner() then
		view.angles = ply:GetVehicle():LocalToWorldAngles( ply:EyeAngles() )
	end
	
	return self:GunCamera( view, ply )
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return self:GunCamera( view, ply )
end

function ENT:LFSHudPaint( X, Y, data )
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	RPM = RPM or 0
	Pitch = Pitch or 0
	Doppler = Doppler or 0
	
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  60 + Pitch * 50, 80,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
	end
	
	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  Pitch * 100, 50,255) + Doppler * 1.25,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1.5 + Pitch * 6, 0.5,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "CRYSIS_VTOL_ENGINE" )
		self.ENG:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "CRYSIS_VTOL_DIST" )
		self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
	self.smYaw = self.smYaw and self.smYaw + (self:GetRotYaw() - self.smYaw) * FrameTime() * 3 or 0
	self.smRoll = self.smRoll and self.smRoll + (self:GetRotRoll() - self.smRoll) * FrameTime() * 3 or 0
	
	local OnGround = self:GetIsGroundTouching()
	
	if OnGround then
		self.smYaw = 0
		self.smRoll = 0
	end
	
	self.SMLG = self.SMLG and self.SMLG + (self:GetLGear() - self.SMLG) * FrameTime() * 5 or 0
	
	local ang = self.smYaw * self.SMLG - self.smRoll * (1 - self.SMLG)
	local Mov = (self:GetRPM() / self:GetLimitRPM()) * 0 * self.SMLG
	
	local Wing1 = -90 * self.SMLG - ang + Mov
	local Wing2 = -90 * self.SMLG + ang + Mov
	local Wing3 = 0 * self.SMLG - ang + Mov
	local Wing4 = 0 * self.SMLG + ang + Mov
	
	self:ManipulateBoneAngles( 4, Angle( 0,0,Wing1 ) )
	self:ManipulateBoneAngles( 3, Angle( 0,0,Wing2 ) )
	self:ManipulateBoneAngles( 2, Angle( Wing3,0,0) )
	self:ManipulateBoneAngles( 1, Angle( Wing4,0,0) )
	
	local Rate = FrameTime() * 5

	self.smgT = self.smgT and self.smgT + math.Clamp(((self:GetForceOpenDoor() and 1 or 0) - self.smgT),-Rate * 0.1,Rate * 0.1) or 0
	
	self.smgLG = self.smgLG and self.smgLG + math.Clamp( ((OnGround and math.min(self.SMLG * 100,1) or 0) - self.smgLG),-Rate,Rate) or 0
	
	self.smgT2 = self.smgT2 and self.smgT2 + ((OnGround and math.min(self.SMLG * 100,1) or 0) - self.smgT2) * FrameTime() * 5 or 0

	self:ManipulateBoneAngles( 15, Angle( 0,0,29 * self.smgT) )
	self:ManipulateBoneAngles( 14, Angle( 0,0,42 * self.smgT) )
	
	self:ManipulateBoneAngles( 7, Angle( 0,0,100 * self.smgT) )
	self:ManipulateBoneAngles( 10, Angle( 0,0,90 * self.smgT) )
	self:ManipulateBoneAngles( 11, Angle( 0,0,90 * self.smgT) )
	
	self:ManipulateBoneAngles(8, Angle( 0,-75,0 * self.smgLG) )
	self:ManipulateBoneAngles(9, Angle( 0,75,0 * self.smgLG) )
	self:ManipulateBoneAngles(6, Angle( 0,90,0 * self.smgLG) )
	self:ManipulateBoneAngles(5, Angle( 0,-90,0 * self.smgLG) )
	
	self.WingAng1 = Wing1
	self.WingAng2 = Wing2

end

function ENT:AnimRotor()
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()	
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local Wing1 = self.WingAng1
		local Wing2 = self.WingAng2

		if not Wing1 or not Wing2 then return end

		local Size = 170

		local MirrorY = false
		for d = 0,1 do

			local InvY = MirrorY and 1 or -1

			local Rot = self:LocalToWorldAngles( Angle(MirrorY and Wing2 or Wing1,0,0) )
			local Pos = self:LocalToWorld( Vector(-23,206 * InvY,48) ) - Rot:Right() * 70 * InvY + Rot:Forward() * -120

			local effectdata = EffectData()
				effectdata:SetOrigin( Pos )
			util.Effect( "lfs_blacksmoke", effectdata )
			MirrorY = true
		end


	end
end

function ENT:Draw()
	self:DrawModel()
	
	if self:GetForceOpenDoor() then
		local Alpha = math.abs( math.cos( CurTime() * 5 ) ) * 30
		
		render.SetMaterial( mat )
		render.DrawSprite( self:LocalToWorld( Vector(-375,-106,79) ), Alpha, Alpha, Color( 255, 0, 0, 255) )
		render.DrawSprite( self:LocalToWorld( Vector(-375,109,79) ), Alpha, Alpha, Color( 255, 0, 0, 255) )
		render.DrawSprite( self:LocalToWorld( Vector(-40,1,14) ), Alpha, Alpha, Color( 255, 0, 0, 255) )
	end
	
	if not self:GetEngineActive() then return end
	
	local Wing1 = self.WingAng1
	local Wing2 = self.WingAng2
	
end