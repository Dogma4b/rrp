ENT.Base = "base_ai" -- Основа "base_ai"
ENT.Type = "ai" -- Тип
ENT.AutomaticFrameAdvance = true -- Показывает анимацию нпс
ENT.Spawnable = true
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end