--[[
   v.3.1
   (c)Oleg Simonenko
	simartinfo.blogspot.com
	github.com/razorback456/gideros_tools
]]

ButtonOleg = gideros.class(Sprite)

function ButtonOleg:init(xtext, xcolor, xscalex, xscaley, xalpha, stopPropagation)
	if stopPropagation then self.stopPropagation = true end

	self.textalpha = xalpha
	self.text = TextField.new(nil, xtext)
	self.text:setTextColor(xcolor or 0x0)
	self.text:setAlpha(xalpha or 0)
	self.text:setScale(xscalex, xscaley)
	self:addChild(self.text)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self.on = false
end

function ButtonOleg:onTouchesBegin(e)
	if self:hitTestPoint(e.touch.x, e.touch.y) then
		if e.touch.id ~= self.focus then
			self.focus = e.touch.id
			if self.on == false then
				self:dispatchEvent(Event.new("clickDown"))
				self.click = true
				self.on = true
			end
			if self.textalpha then self.text:setAlpha(self.text:getAlpha() + 0.25) end
		end
		if self.stopPropagation then e:stopPropagation() end ----19.07.19
	end
end

 function ButtonOleg:onTouchesMove(e)
	if self:hitTestPoint(e.touch.x, e.touch.y) then
		if self.focus ~= e.touch.id then
			self.focus = e.touch.id
			if self.on == false then
				self:dispatchEvent(Event.new("clickDown"))
				self.click = nil
				self.on = true
				if self.textalpha then self.text:setAlpha(self.text:getAlpha() + 0.25) end
			end
		else
			if self.stopPropagation then e:stopPropagation() end
			local clickMove = Event.new("clickMove")
			self.click = nil
			clickMove.x = e.touch.x
			clickMove.y = e.touch.y
			self:dispatchEvent(clickMove)
		end
	elseif self.focus == e.touch.id then
		self.focus = nil
		if self.on == true then
			self.on = false
			if self.textalpha then self.text:setAlpha(self.text:getAlpha() - 0.25) end
		end
	end
end

function ButtonOleg:onTouchesEnd(e)
	if self:hitTestPoint(e.touch.x, e.touch.y) then
		self.focus = nil
		if self.on == true then
			self.on = false
			self:dispatchEvent(Event.new("clickUp"))
			if self.click then self:dispatchEvent(Event.new("click")) end
			if self.textalpha then self.text:setAlpha(self.text:getAlpha() - 0.25) end
		end
		if self.stopPropagation then e:stopPropagation() end ----19.07.19
	else
		if self.focus == e.touch.id then
			self.focus = nil
		end
	end
end
