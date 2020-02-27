MobileX = Core.class(Sprite)

function MobileX:init(xhero)
	-- local variables
	local alpha = 0.25
	-- buttons
	local btnB = ButtonOleg.new("B", 0xffffff, 16, 14, alpha) -- UP (B)
--	btnB:setPosition(btnB:getWidth() + 4, myappheight - 24)
	btnB:setPosition(0, myappheight - btnB:getHeight() - 4)
	self:addChild(btnB)

	local btnA = ButtonOleg.new("A", 0xffffff, 16, 14, alpha) -- DOWN (A)
	btnA:setPosition(0, myappheight)
	self:addChild(btnA)

	local btnleft = ButtonOleg.new("<", 0xffffff, 24, 16, alpha) -- LEFT
	btnleft:setPosition(myappwidth - btnleft:getWidth() - btnleft:getWidth() - 16, myappheight)
	self:addChild(btnleft)

	local btnright = ButtonOleg.new(">", 0xffffff, 24, 16, alpha) -- RIGHT
	btnright:setPosition(myappwidth - btnright:getWidth(), myappheight)
	self:addChild(btnright)

	local btnX = ButtonOleg.new("X", 0xff0000, 16, 14, alpha) -- SPACE (X)
--	btnX:setPosition(btnX:getWidth() + btnX:getWidth() + 16, myappheight - 24)
	btnX:setPosition(btnX:getWidth() + 16, myappheight - btnX:getHeight() / 2)
	self:addChild(btnX)

	-- buttons CANCELLER 1 --
	local btnscanceller1 = ButtonOleg.new("O", 0xffffff, 128, 64, nil) -- -1
	btnscanceller1:setAnchorPoint(0.5, 0.5)
	btnscanceller1:setPosition(0, myappheight + btnscanceller1:getHeight())
	self:addChild(btnscanceller1)
	-- buttons CANCELLER 2 --
	local btnscanceller2 = ButtonOleg.new("O", 0xffffff, 128, 64, nil) -- -1
	btnscanceller2:setAnchorPoint(0.5, 0.5)
	btnscanceller2:setPosition(myappwidth, myappheight + btnscanceller2:getHeight())
	self:addChild(btnscanceller2)

	-- listeners
	btnB:addEventListener("clickDown", function(e) -- UP B
		e:stopPropagation()
		xhero.isup = true
	end)
	btnB:addEventListener("clickMove", function(e)
		xhero.isup = true
	end)
	btnB:addEventListener("clickUp", function(e)
		e:stopPropagation()
		xhero.isup = false
	end)

	btnA:addEventListener("clickDown", function(e) -- DOWN B
		e:stopPropagation()
		xhero.isdown = true
	end)
	btnA:addEventListener("clickMove", function(e)
		xhero.isdown = true
	end)
	btnA:addEventListener("clickUp", function(e)
		e:stopPropagation()
		xhero.isdown = false
	end)

	btnleft:addEventListener("clickDown", function(e) -- LEFT
		e:stopPropagation()
		xhero.isleft = true
	end)
	btnleft:addEventListener("clickMove", function(e)
		xhero.isleft = true
	end)
	btnleft:addEventListener("clickUp", function(e)
		e:stopPropagation()
		xhero.isleft = false
	end)

	btnright:addEventListener("clickDown", function(e) -- RIGHT
		e:stopPropagation()
		xhero.isright = true
	end)
	btnright:addEventListener("clickMove", function(e)
		xhero.isright = true
	end)
	btnright:addEventListener("clickUp", function(e)
		e:stopPropagation()
		xhero.isright = false
	end)

	btnX:addEventListener("clickDown", function(e) -- SPACE X
		e:stopPropagation()
		xhero.isshoot = true
	end)
	btnX:addEventListener("clickMove", function(e)
--		xhero.isshoot = true
	end)
	btnX:addEventListener("clickUp", function(e)
		e:stopPropagation()
		xhero.isshoot = false
	end)

	-- CANCELLERS
	btnscanceller1:addEventListener("clickMove", function(e) -- BUTTON CANCELLER 1
		xhero.isup = false
		xhero.isdown = false
		xhero.isshoot = false
	end)
	btnscanceller2:addEventListener("clickMove", function(e) -- BUTTON CANCELLER 2
		xhero.isright = false
		xhero.isleft = false
	end)
end
