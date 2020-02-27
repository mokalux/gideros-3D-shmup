-- stage
stage:setClearColorBuffer(false)
local isfullscreen = false
-- some vars
myappwidth, myappheight = application:getContentWidth(), application:getContentHeight()
-- collisions bit
local PLAYER1_BIT = math.pow(2,0) -- result = 2^0 = 1
local ENEMY_BIT = math.pow(2,1) -- result = 2^1 = 2
local MISSILE_BIT = math.pow(2,2) -- result = 2^2 = 4
-- game over
local isgameover = false
local gameovertf = TextField.new(nil, "      GAME OVER      \npress spacebar to play!")
gameovertf:setPosition(myappwidth / 2, myappheight / 2)
gameovertf:setScale(6)
gameovertf:setAnchorPoint(0.5,0.5)
gameovertf:setTextColor(0xff0000)
gameovertf:setVisible(false)
-- explosion
local explosiontex = Texture.new("3d_models/texs/explosions-3.png")
local explosionsnd = Sound.new("audio/Explosion.wav")
-- sounds
local laser1 = Sound.new("audio/Laser_Shoot.wav")
-- the UI
local lives, score = 3, 0
local livestf = TextField.new(nil, "LIVES: "..lives)
livestf:setScale(4)
livestf:setTextColor(0x00aaff)
livestf:setPosition(16, livestf:getHeight() + 4)
local scoretf = TextField.new(nil, "SCORE: "..score)
scoretf:setScale(4)
scoretf:setTextColor(0x00aaff)
scoretf:setPosition(myappwidth - scoretf:getWidth() - 64, scoretf:getHeight() + 4)
-- reactphysics3d
require "reactphysics3d"
local world = r3d.World.new(0, 0, 0)
-- some lists
world.enemies = {}
world.missiles = {}
-- the camera
local camera = D3.View.new(myappwidth, myappheight, 45, 1, 512)
-- a bg
local bgtex = Texture.new("3d_models/texs/bg.png", true, {wrap = Texture.REPEAT})
local bg = Pixel.new(bgtex, myappwidth, myappheight, 1.5, 1.5)
-- the player
local player1 = PLAYER1.new(world, "3d_models/player1", "ship01.obj",
		{posz=-16}, PLAYER1_BIT, ENEMY_BIT)
-- mobile controls
local mobile = MobileX.new(player1)
-- the scene
stage:addChild(bg)
stage:addChild(camera)
camera:lookAt(-64,0,0,	0,0,0)
camera:getScene():addChild(player1.obj)
stage:addChild(livestf)
stage:addChild(scoretf)
stage:addChild(gameovertf)
stage:addChild(mobile)
-- physics collisions listener
world:setEventListener(function()
	-- missiles vs enemies collisions
	for k,v in pairs(world.missiles) do
		for k1,v1 in pairs(world.enemies) do
			if world:testAABBOverlap(v.body, v1.body) then
				score += 10
				scoretf:setText("SCORE :"..score)
				v.isdirty = true
				v1.isdirty = true
				explosion(v1.body)
			end
		end
	end
	-- player1 vs enemies collisions
	for k,v in pairs(world.enemies) do
		if world:testAABBOverlap(v.body, player1.body) then
			lives -= 1
			livestf:setText("LIVES: "..lives)
			v.isdirty = true
			if lives <= 0 then gameover() end
			explosion(v.body)
		end
	end
end)
-- explosion
function explosion(xbody)
	local sound = explosionsnd:play()
	local particles = Particles.new()
	particles:setTexture(explosiontex)
	particles:setRotationY(90)
	camera:getScene():addChild(particles)
	particles:addParticles({
		{
			x=-xbody:getTransform():getZ(),y=xbody:getTransform():getY(),
			size=math.random(2,4),
			color=0xD9B589,
			ttl=2*8,
			speedX=0.1,speedY=0.1
		},
		{
			x=-xbody:getTransform():getZ(),y=xbody:getTransform():getY(),
			size=math.random(3,4),
			color=0xffff00,
			ttl=2*8,
			speedX=-0.1,speedY=-0.1
		},
		{
			x=-xbody:getTransform():getZ(),y=xbody:getTransform():getY(),
			size=math.random(3,4),
			color=0xff00ff,
			ttl=2*8,
			speedX=-0.1,speedY=0.1
		},
	})
end
-- mobile event
function mobileEvent(e)
	if gameovertf:hitTestPoint(e.x, e.y) then reset() end
end
-- game over
function gameover()
	isgameover = true
	gameovertf:setVisible(true)
	gameovertf:addEventListener(Event.MOUSE_UP, mobileEvent)
end
-- reset
function reset()
	isgameover = false
	gameovertf:setVisible(false)
	gameovertf:removeEventListener(Event.MOUSE_UP, mobileEvent)
	lives = 3
	livestf:setText("LIVES: "..lives)
	player1:setPosition(0,0,-9)
end
-- game loop
local bgadv = 0
local speed = 10*32
local spawntime = 0
local enemylimit, missilelimit = 0,0
stage:addEventListener(Event.ENTER_FRAME, function(e)
	-- animate bg
	bgadv += 1
	bg:setTexturePosition(bgadv, 0)
	-- game over
	if isgameover then return end
	-- destroy
	for k,v in pairs(world.missiles) do
		missilelimit = v.body:getTransform():getZ()
		if v.isdirty or missilelimit > 36 then
			-- remove from list
			world.missiles[k] = nil
			-- remove from the collision world
			world:destroyBody(v.body)
			-- remove the missile from the game
			camera:getScene():removeChild(k)
		end
	end
	for k,v in pairs(world.enemies) do
		enemylimit = v.body:getTransform():getZ()
		if v.isdirty or enemylimit < -36 then
			-- remove from list
			world.enemies[k] = nil
			-- remove from the collision world
			world:destroyBody(v.body)
			-- remove the missile from the game
			camera:getScene():removeChild(k)
		end
	end
	-- reactphysics3d calculate
	world:step(e.deltaTime)
	-- move the player1
	if player1.isleft then
		if player1.body:getTransform():getZ() < 16 then
			player1.body:applyForce(0,0,speed)
		end
	end
	if player1.isright then
		if player1.body:getTransform():getZ() > -16 then
			player1.body:applyForce(0,0,-speed)
		end
	end
	if player1.isup then
		if player1.body:getTransform():getY() < 12 then
			player1.body:applyForce(0,speed,0)
		end
	end
	if player1.isdown then
		if player1.body:getTransform():getY() > -12 then
			player1.body:applyForce(0,-speed,0)
		end
	end
	if player1.isshoot then shoot() player1.isshoot = false end
	player1.obj:setMatrix(player1.body:getTransform())
	-- the missiles
	for k,v in pairs(world.missiles) do
		v.body:applyForce(0,0,speed*12)
--		k:setMatrix(v.body:getTransform())
		k:setX(v.body:getTransform():getX())
		k:setY(v.body:getTransform():getY())
		k:setZ(v.body:getTransform():getZ())
	end
	-- the enemies
	for k,v in pairs(world.enemies) do
		v.body:applyForce(0,0,-speed*2)
		k:setPosition(v.body:getTransform():getPosition())
	end
	-- enemy spawner
	spawntime += 1
	if spawntime >= 100 then spawn() spawntime = 0 end
end)

-- functions
function spawn()
	local enemy = ENEMY.new(world, "3d_models/enemies", "ship03.obj",
			{posy=Core.random(0,-12,12),posz=Core.random(0,30,36)}, ENEMY_BIT, PLAYER1_BIT + MISSILE_BIT)
	camera:getScene():addChild(enemy.obj)
end

function shoot()
	local sound = laser1:play()
	local missile = MISSILE.new(world, "3d_models/missiles", "missile03.obj",
		{posx=player1.obj:getX(), posy=player1.obj:getY(), posz=player1.obj:getZ()},
		MISSILE_BIT, ENEMY_BIT
	)
	camera:getScene():addChild(missile.obj)
end

-- keyboard controls
stage:addEventListener(Event.KEY_DOWN, function(e)
	if e.keyCode == KeyCode.UP then player1.isup = true end
	if e.keyCode == KeyCode.DOWN then player1.isdown = true end
	if e.keyCode == KeyCode.LEFT then player1.isleft = true end
	if e.keyCode == KeyCode.RIGHT then player1.isright = true end
	if e.keyCode == KeyCode.SPACE then player1.isshoot = true end
	if e.keyCode == KeyCode.R then reset() end
	if e.keyCode == KeyCode.F then
		isfullscreen = not isfullscreen
		application:setFullScreen(isfullscreen)
	end
	if e.keyCode == KeyCode.BACK then application:exit() end
end)

stage:addEventListener(Event.KEY_UP, function(e)
	if e.keyCode == KeyCode.UP then player1.isup = false end
	if e.keyCode == KeyCode.DOWN then player1.isdown = false end
	if e.keyCode == KeyCode.LEFT then player1.isleft = false end
	if e.keyCode == KeyCode.RIGHT then player1.isright = false end
	if e.keyCode == KeyCode.SPACE then player1.isshoot = false end
end)
