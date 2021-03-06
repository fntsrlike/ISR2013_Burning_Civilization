require 'vendor/class'

local Scene_Game = class(Scene_Base)

function Scene_Game:__init(info, level)
	Scene_Game._base.__init(self, info)

	self.level = level

	local player = Player('player')
	player.x = level.playerPos.x
	player.y = level.playerPos.y
	self._screen:addEntity(player)

	self.stickManager = StickManager("stickManager")
	self._screen:addEntity(self.stickManager)
	for i = 1, level.orginalSticks do
		self.stickManager:randomAddStick()
	end

	self.barbarianManager = BarbarianManager("barbarianManager")
	self._screen:addEntity(self.barbarianManager)
	for i = 1, level.target do
		self.barbarianManager:randomAddBarbarian()
	end

	self.colonizedBarbariansNum = 0
	beholder.observe(Event.CHANGE_COLONIZED_BARBARIANS, function(n)
		self.colonizedBarbariansNum = self.colonizedBarbariansNum + n
	end)

	-- Landform

	for i, item in ipairs(level.blockSand) do
		local element = Sand("Landform", item.x * 50 - 25, item.y * 50 - 25)
		self._screen:addEntity(element)
	end

	for i, item in ipairs(level.blockRock) do
		local element = Rock("Landform", item.x * 50 - 25, item.y * 50 - 25)
		self._screen:addEntity(element)
	end

	-- Border

	local leftBorder = Border('leftBorder', Rect(-20, -20, 10, 1000))
	local rightBorder = Border('rightBorder', Rect(820, -20, 10, 1000))
	local upBorder = Border('upBorder', Rect(-20, -20, 1000, 10))
	local downBorder = Border('downBorder', Rect(-20, 620, 1000, 10))
	self._screen:addEntities({leftBorder, rightBorder, upBorder, downBorder})

	-- Panel

	self.countdown = Countdown(level.timeLimit)
	self._screen:addEntity(self.countdown)
	self._screen:addEntity(ConquerPoint("conquerPoint", self))

	love.audio.stop(Game.globalStroage.bgm)
	Game.globalStroage.bgm = R.musics.level
	love.audio.play(Game.globalStroage.bgm)
end

function Scene_Game:update(dt)
	if self.colonizedBarbariansNum >= self.level.target then
		local canvas = love.graphics.newCanvas()
		canvas:renderTo(function()
			self:draw()
		end)

		Game.SceneManager:switchScene(Scene_Result,
			canvas, { status = 'win', next = self.level.index + 1 }
		)
	end

	if self.countdown.timer:isTimeUp() then
		local canvas = love.graphics.newCanvas()
		canvas:renderTo(function()
			self:draw()
		end)

		Game.SceneManager:switchScene(Scene_Result,
			canvas, { status = 'lose', next = self.level.index }
		)
	end

	if self.stickManager:stickCounter() <= self.level.spawnStickCond then
		if math.random() < self.level.spawnStickRate then
			self.stickManager:randomAddStick()
		end
	end

	if self.stickManager:fireCounter() <= self.level.spawnLightCond then
		if math.random() < self.level.spawnLightRate then
			self.stickManager:randomLightStick()
		end
	end

	Scene_Game._base.update(self, dt)
end

function Scene_Game:draw()
	love.graphics.draw(R.images.bg, 0, 0)

	Scene_Game._base.draw(self)
end

function Scene_Game:reachedTarget()
	return self.colonizedBarbariansNum >= self.target
end

return Scene_Game
