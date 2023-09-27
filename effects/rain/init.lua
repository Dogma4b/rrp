// Antigaming Team 2014 //

function EFFECT:Init(data)
	self.Particles = data:GetMagnitude()*1
	self.DieTime = CurTime()+1
	self.Emiter = ParticleEmitter(LocalPlayer():GetPos())
end

function EFFECT:Think()
	if CurTime() > self.DieTime then return false end
	local emitter = self.Emiter
	for i=0, self.Particles do
		local spawnpos = LocalPlayer():GetPos()+Vector(math.random(-1200,1200)+LocalPlayer():GetVelocity().x*2,math.random(-1200,1200)+LocalPlayer():GetVelocity().y*2,400)
		
		local particle = emitter:Add("particle/Water/WaterDrop_001a", spawnpos)
		if(particle) then
			particle:SetVelocity(Vector(math.sin(CurTime()/4)*30,50,-700))
			particle:SetLifeTime(0)
			particle:SetDieTime(4)
			particle:SetEndAlpha(255)
			particle:SetStartSize(0)
			particle:SetEndSize(math.random(10,20))
			particle:SetAirResistance(0)
			particle:SetStartAlpha(128)
			particle:SetCollide(true)
			particle:SetBounce(0)
			particle:SetCollideCallback(ParticleCollides)
		end
	end
	return true
end

function ParticleCollides(particle,pos,norm)
	particle:SetDieTime(0)
	local effectdata = EffectData()
	effectdata:SetStart(pos)
	effectdata:SetOrigin(pos)
	effectdata:SetScale(math.random(1,2))
	util.Effect("watersplash",effectdata)
end

function EFFECT:Render()

end