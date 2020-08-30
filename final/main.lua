
-- Sets the size for the pixels
-- Capital because they are constants
TILE_SIZE = 32
-- Sets the size of the window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

-- Renders the tiles on the X and Y axis
MAX_TILES_X = WINDOW_WIDTH / TILE_SIZE
MAX_TILES_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE) - 1

-- Declares some variables
TILE_EMPTY = 0
TILE_SNAKE_HEAD = 1
TILE_SNAKE_BODY = 2
TILE_APPLE = 3
TILE_STONE = 4

local level = 1

-- Speed for the snake per second per tile
SNAKE_SPEED = math.max(0.01, 0.11 - (level * 0.01))

-- initializes the font size and score
local largeFont = love.graphics.newFont('fonts/Snake.ttf', 32)
local hugeFont = love.graphics.newFont('fonts/Snake.ttf', 128)

-- initializes the sounds
local appleSound = love.audio.newSource('sounds/coin.wav', 'static')
local newLevelSound = love.audio.newSource('sounds/newLevel.wav', 'static')
local musicSound = love.audio.newSource('sounds/game_intro.wav', 'static')
local deathSound = love.audio.newSource('sounds/death.wav', 'static')
local gameOverSound = love.audio.newSource('sounds/game_over.wav', 'static')

-- State variables
local score = 0
local gameOver = false
local gameStart = true
local newLevel = true
local lives = 3

-- Creates a table for tiles representing the game window
-- 0 for nothing, 1 for snake head, 2 for snake body, 3 for the apple
local tileGrid = {}

-- Initializes the X and Y axis
-- for the snake head, and a timer
local snakeX, snakeY = 1, 1
local snakeMoving = 'right'
local snakeTimer = 0

-- Snake data structure
local snakeTiles = {
    -- Head of the snake
    {snakeX, snakeY}
}

-- Called at the start of the program
function love.load()
    -- Sets the title
    love.window.setTitle('Snake')

    -- Sets the font
    love.graphics.setFont(largeFont)

    -- Sets the window size and other options
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false
    })

    -- Seeds our program with a random number generator
    math.randomseed(os.time())

    -- Plays the music
    musicSound:setLooping(true)
    musicSound:play()
    love.audio.setVolume(0.30)

    -- Calls the grid function to load and snake function to load
    initializeGrid()
    initializeSnake()

    -- Takes the y and x from the ties table and maps it to the grid, using the 1st table, then the 2nd sub element
    -- and then does it again but with the 1st sub element then assigns it to the snake head
    tileGrid[snakeTiles[1][2]][snakeTiles[1][1]] = TILE_SNAKE_HEAD
end

-- Called anywhere after load, accepts key inputs
function love.keypressed(key)
    -- Quits the program
    if key == 'escape' then
        love.event.quit()
    end
    
    if not gameOver then
        --checks the value of snake moving to see if it is true or false compared to our snakemoving variable
        -- also stops our snake from moving into itself, ~= is the same as != not equal to
        if key == 'left' and snakeMoving ~= 'right' then
            snakeMoving = 'left'
        elseif key == 'right' and snakeMoving ~= 'left' then
            snakeMoving = 'right'
        elseif key == 'up' and snakeMoving ~= 'down' then
            snakeMoving = 'up'
        elseif key == 'down' and snakeMoving ~= 'up' then
            snakeMoving = 'down'
        end
    end

    if newLevel then
        if key == 'space' then
        newLevel = false
        end
    end

    if gameOver or gameStart then
        if key == 'enter' or key == 'return' then
            initializeGrid()
            initializeSnake()
            score = 0
            lives = 3
            gameOver = false
            gameStart = false
        end
    end
end

-- Typically between load and draw, updates
-- using delta time multiplying any value
-- DT adjusts to different CPUs and devices
function love.update(dt)
    if not gameOver and not newLevel then
        snakeTimer = snakeTimer + dt
        
        -- Variables to set the new values into the old
        local priorHeadX, priorHeadY = snakeX, snakeY

        -- Sets the controls using a timer + - for x and y axis
        -- Also checks to see if the snake is off screen
        if snakeTimer >= SNAKE_SPEED then
            if snakeMoving == 'up' then
                if snakeY <= 1 then
                    snakeY = MAX_TILES_Y
                else
                    snakeY = snakeY - 1
                end
            elseif snakeMoving == 'down' then
                if snakeY >= MAX_TILES_Y then
                    snakeY = 1
                else
                    snakeY = snakeY + 1
                end
            elseif snakeMoving == 'left' then
                if snakeX <= 1 then
                    snakeX = MAX_TILES_X
                else
                    snakeX = snakeX - 1
                end
            else
                if snakeX >= MAX_TILES_X then
                    snakeX = 1
                else            
                    snakeX = snakeX + 1
                end
            end
            
            -- Push a new head element onto the snake data structure
            table.insert(snakeTiles, 1, {snakeX, snakeY})

            if tileGrid[snakeY][snakeX] == TILE_SNAKE_BODY or 
                tileGrid[snakeY][snakeX] == TILE_STONE then

                lives = lives - 1

                -- Checks to see if we have zero lives and takes one away if we do
                if lives > 0 then
                    newLevel = true
                    clearSnake()
                    initializeSnake()
                    deathSound:play()
                else
                    gameOver = true
                    love.audio.stop()
                    gameOverSound:play()
                    
                end

            -- If we eat an apple
            elseif tileGrid[snakeY][snakeX] == TILE_APPLE then

                -- Adds one to the score, then generates a new apple
                score = score + 1

                -- Play sound effect
                appleSound:play()

                -- Increase the level after 3 apples
                if score > level * math.ceil(level / 2) * 3 then
                    level = level + 1
                    SNAKE_SPEED = math.max(0.01, 0.11 - (level * 0.01))
                    newLevel = true
                    newLevelSound:play()

                    initializeGrid()
                    initializeSnake()

                    return
                end

                generateObstacle(TILE_APPLE)
            
            -- Pops the tail and adds to the new grid
            else
                -- indexes into snaketiles and gives us the last element
                local tail = snakeTiles[#snakeTiles]
                tileGrid[tail[2]][tail[1]] = TILE_EMPTY
                table.remove(snakeTiles)
            end

            if not gameOver and not newLevel then
                -- If our snake body is greater than one
                if #snakeTiles > 1 then

                    -- Sets the prior head value to a body value
                    tileGrid[priorHeadY][priorHeadX] = TILE_SNAKE_BODY
                end

                -- Updates the view with the next tile location
                tileGrid[snakeY][snakeX] = TILE_SNAKE_HEAD
            end

            -- Resets the timer to control the frame speed
            snakeTimer = 0
        end
    end
end

-- Literally draws to the screen
function love.draw()

    if gameStart then
        love.graphics.setFont(hugeFont)
        love.graphics.printf("SNAKE", 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, 'center')

        love.graphics.setFont(largeFont)
        love.graphics.printf('Press Enter to Start', 0, WINDOW_HEIGHT / 2 + 96, WINDOW_WIDTH, 'center')

    else
        drawGrid()

        -- Draws the score on the game
        -- and sets the font color
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('Score: ' .. tostring(score), 10, 10)
    
        -- Draws the level on the game
        love.graphics.printf('Level: ' .. tostring(level), -10, 10, WINDOW_WIDTH, 'right')

        -- Draws the lives on the game
        love.graphics.printf('Lives: ' .. tostring(lives), 0, 10, WINDOW_WIDTH, 'center')

        if newLevel then
            love.graphics.setFont(hugeFont)
            love.graphics.printf("LEVEL " .. tostring(level), 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, 'center')
    
            love.graphics.setFont(largeFont)
            love.graphics.printf('Press Space To Start', 0, WINDOW_HEIGHT / 2 + 96, WINDOW_WIDTH, 'center')

        elseif gameOver then
            drawGameOver()
        end
    end
end

function drawGameOver()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('GAME OVER', 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, 'center')

    love.graphics.setFont(largeFont)
    love.graphics.printf('Press Enter To Restart', 0, WINDOW_HEIGHT / 2 + 96, WINDOW_WIDTH, 'center')
end

-- Draws a grid on the window
function drawGrid()
    -- Initializes the X and Y axis, then takes the max number of tiles
    -- and if it goes over wraps around and restarts
    -- Subtracts 1 since the table and pixels start at 1
    -- Starts at 0 since coordinates start at zero
    for y = 1, MAX_TILES_Y do
        for x = 1, MAX_TILES_X do
            if tileGrid[y][x] == TILE_EMPTY then

                -- Changes the color of the grid, and checks to see if we have an empty tile on the y or x
                love.graphics.setColor(0, 0, 0, 0)
                love.graphics.rectangle('line', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

            -- Sets the color, and checks to see if we have an apple on the y or x axis
            elseif tileGrid [y][x] == TILE_APPLE then
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

            elseif tileGrid[y][x] == TILE_STONE then
                love.graphics.setColor(0.8, 0.8, 0.8, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

            elseif tileGrid[y][x] == TILE_SNAKE_HEAD then
                -- Sets the color, and  draws the snake
                love.graphics.setColor(0, 1, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

            elseif tileGrid[y][x] == TILE_SNAKE_BODY then
                love.graphics.setColor(0, 0.5, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
end

function generateObstacle(obstacle)
    local obstacleX, obstacleY

    repeat
        obstacleX, obstacleY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)    
    until tileGrid[obstacleY][obstacleX] == TILE_EMPTY

    tileGrid[obstacleY][obstacleX] = obstacle
end

-- Function that clears the snake from the screen when you die and resets it
function clearSnake()
    -- If every key value in pairs on the table snaketiles
    -- set the y and the x on the tilegrid to empty
    for k, elem in pairs(snakeTiles) do 
        if k > 1 then
            tileGrid[elem[2]][elem[1]] = TILE_EMPTY
        end
    end
end


-- Sets the snake access to 1, 1 and sets the snakeTiles table to X, and Y
function initializeSnake()
    snakeX, snakeY = 1, 1
    snakeMoving = right
    snakeTiles = {
        {snakeX, snakeY}
    }      
    -- Takes the y and x from the ties table and maps it to the grid, using the 1st table, then the 2nd sub element
    -- and then does it again but with the 1st sub element then assigns it to the snake head
    tileGrid[snakeTiles[1][2]][snakeTiles[1][1]] = TILE_SNAKE_HEAD
end

-- Initializes the grid
function initializeGrid()
    -- Clears the grid to restart
    tileGrid = {}
    -- Inerates through all the x axis tiles and y axis tiles
    -- sets the tile indecies to zero
    -- Creating a 2d array
    for y = 1, MAX_TILES_Y do

        -- Inserts an empty tilegrid into the main table tileGrid
        table.insert(tileGrid, {})

        for x = 1, MAX_TILES_X do
            table.insert(tileGrid[y], TILE_EMPTY)
        end
    end

    for i = 1, math.min(50, level * 2) do
        generateObstacle(TILE_STONE)
    end

    generateObstacle(TILE_APPLE)
end