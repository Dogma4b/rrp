ENT.Base = "base_ai" -- ������ "base_ai"
ENT.Type = "ai" -- ���
ENT.AutomaticFrameAdvance = true -- ���������� �������� ���
ENT.Spawnable = true
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end