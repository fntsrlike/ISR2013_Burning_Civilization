require 'vendor/class'

local Campfire = class(Entity)

function Campfire:__init(name, ox, oy)
    self._base.__init(self, name)
    self.images = R.images.campfires
    self.ox = ox
    self.oy = oy
    self.width = self.images.normal:getWidth()
    self.height = self.images.normal:getHeight()
    self.zIndex = 0

    self.timer = Timer(10)

    self.barbsLimitNum = 5
    self.barbsBeingNum = 0

end

function Campfire:registerObservers()
    -- TODO: �O ��֦���ڸ������¼�
end

function Campfire:update(dt)
    if self.timer:isTimeUp() == true then
        self._base.removeSelf()
    end

    -- TODO: �ж������̶������Ƿ��И�֦���е�Ԓ�ͳԵ������ӠI����������ޡ�

    -- Q: ��΂ɜy����һ��������barbs? 
    -- A: ��Ұ�U���|�l�I��ĺ���ȥ��׃�������������P��ʽ�aՈ����Ұ�U�˵ĳ�ʽ�a��
end

function Campfire:draw()

    -- TODO: �I�������L��Ѫ�l
    --       Ѫ�l�������g��֣��r�gԽ�LԽ���ɂ���չ����֮�tԽ�����g�s��

    -- TODO: �I���D��
    --       love.graphics.draw(self.images.normal, self.ox - self.width / 2, self.oy - self.height / 2)
end


function Campfire:changeLifeTime(seconds)
    self.timer:changeLifeTime(seconds)
end

function Campfire:isBeingFull()
    if self.barbsBeingNum < self.barbsLimitNum then
        return false
    else
        return true
    end
end

function Campfire:changeBarbsBeingNum(number)
    self.barbsBeingNum = self.barbsBeingNum + number

    if self.barbsBeingNum < 0 then
        error("Number of barbarian near campfire is Error!!!")
    end
end

return Campfire