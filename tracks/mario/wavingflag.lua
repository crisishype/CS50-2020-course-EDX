WavingFlag = Class{}

-- animation speed of the flag
local WAVING_INTERVAL = 0.15

function WavingFlag:init(spritesheet)
    self.texture = spritesheet
    self.animation = Animation({
        texture = self.texture,
        frames = {
            love.graphics.newQuad(0*16, 16*3, 16, 16, self.texture:getDimensions()),
            love.graphics.newQuad(1*16, 16*3, 16, 16, self.texture:getDimensions()),
            love.graphics.newQuad(2*16, 16*3, 16, 16, self.texture:getDimensions())
        },
        interval = WAVING_INTERVAL
    })
end

function WavingFlag:update(dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
end

function WavingFlag:render(x, y)
    love.graphics.draw(self.texture, self.currentFrame, x, y, 0, 1, 1, 0, 0)
end