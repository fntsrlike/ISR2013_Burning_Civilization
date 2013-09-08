require 'vendor/class'

local ConquerPoint = class(Entity)

function ConquerPoint:__init(name, scene)
    ConquerPoint._base.__init(self, name)
    self.imgIcon = R.images.conquerPoint[1]
    self.imgEmptyPoint = R.images.conquerPoint[2]
    self.imgGetPoint = R.images.conquerPoint[3]
    self.conquerReached = 7
    self.conquerTarget = 10

    self.x = love.graphics.getWidth() - 30
    self.y = love.graphics.getHeight() - 30
    self.ox = self.imgIcon:getWidth() / 2
    self.oy = self.imgIcon:getHeight() / 2
    self.pointX = self.imgGetPoint:getWidth() / 2
    self.pointY = -self.imgGetPoint:getHeight() / 2 
    print(self.pointX)
    print(self.pointY)
    self.scene = scene
    
end

function ConquerPoint:update(dt)
    ConquerPoint._base.update(self, dt)
    self.conquerReached = self.scene.colonizedBarbariansNum
    self.conquerTarget = self.scene.target
end

function ConquerPoint:draw()
    love.graphics.draw( self.imgIcon, self.x, self.y)

    for i=1, self.conquerTarget do
        if i <= self.conquerReached then
            love.graphics.draw(self.imgGetPoint, self.x - 10*i, self.y, 0, 1, 1, self.pointX, self.pointY)
        else
            love.graphics.draw(self.imgEmptyPoint, self.x  - 10*i, self.y, 0, 1, 1, self.pointX, self.pointY)
        end
    end
end

return ConquerPoint