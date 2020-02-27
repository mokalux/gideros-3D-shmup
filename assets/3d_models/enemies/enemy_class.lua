ENEMY = Core.class()

function ENEMY:init(xworld, xobjpath, xobjname, xparams, xBIT, xCOLBIT)
	-- the params
	local params = xparams or {}
	params.posx = xparams.posx or 0
	params.posy = xparams.posy or 0
	params.posz = xparams.posz or 0
	-- the obj
	self.obj = loadObj(xobjpath, xobjname)
	local minx, miny, minz = self.obj.min[1], self.obj.min[2], self.obj.min[3]
	local maxx, maxy, maxz = self.obj.max[1], self.obj.max[2], self.obj.max[3]
	local width, height, length = maxx - minx, maxy - miny, maxz - minz
	local matrix = self.obj:getMatrix()
	matrix:setPosition(params.posx,params.posy,params.posz)
	matrix:setRotationX(0)
	matrix:setRotationY(180)
	matrix:setRotationZ(0)
	matrix:setScale(2,2,2)
	self.obj:setMatrix(matrix)
	-- the obj body
	self.body = xworld:createBody(self.obj:getMatrix())
	-- the obj shape
	self.shape = r3d.SphereShape.new(height / 2 * self.obj:getScaleY())
	-- the obj fixture
	local fixture = self.body:createFixture(self.shape, nil, 16) -- shape, transform, mass
	fixture:setCollisionCategoryBits(xBIT)
	fixture:setCollideWithMaskBits(xCOLBIT)
	-- damping
	self.body:setLinearDamping(0.95)
	-- the list
	xworld.enemies[self.obj] = {body=self.body, isdirty=false}
end
