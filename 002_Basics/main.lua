function love.load()
	--Setting Game Window
	windowWidth = 1024
	windowHeight = 480
	success = love.graphics.setMode(windowWidth, windowHeight, false, true, 4)	--( width, height, fullscreen, vsync, fsaa )
	
	--Setting Game Variables
	gamestate = "paused"
	
	--Initializing Physics
	love.physics.setMeter(64)	--the height of a meter our worlds will be 64px
	world = love.physics.newWorld(0, 9.81*64, true)	--create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81 (= 9.81*64)
	objects = {} -- table to hold all our physical objects
	
	--Creating the Game Field
	startX = 50
	startY = 50
	fieldWidth = windowWidth - 100
	fieldHeight = windowHeight - 100
	grassIMG = love.graphics.newImage("g.jpg")
	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, windowWidth/2, windowHeight/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	objects.ground.shape = love.physics.newRectangleShape(fieldWidth, fieldHeight) --make a rectangle with a width of 650 and a height of 50
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) --attach shape to body
	
	--Creating the Ball
	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, windowWidth/2, windowHeight/2, "dynamic")	--place the body in the center of the world and make it dynamic, so it can move around
	objects.ball.shape = love.physics.newCircleShape(10)	--the ball's shape has a radius of 10
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	objects.ball.fixture:setRestitution(0.9)	--let the ball bounce
	
	--Creating the Players Physics	
	objects.p1 = {}
	objects.p1.body = love.physics.newBody(world, 200, 550, "dynamic")
	objects.p1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
	objects.p1.fixture = love.physics.newFixture(objects.p1.body, objects.p1.shape, 5)	-- A higher density gives it more mass.
	
	objects.p2 = {}
	objects.p2.body = love.physics.newBody(world, 200, 400, "dynamic")
	objects.p2.shape = love.physics.newRectangleShape(0, 0, 100, 50)
	objects.p2.fixture = love.physics.newFixture(objects.p2.body, objects.p2.shape, 2)
	
	--Setting Player Images
	player1IMG = love.graphics.newImage("1.png")
	player2IMG = love.graphics.newImage("2.png")
	--Setting up Players Positions
	p1x = 50
	p1y = windowHeight/2
	p2x = windowWidth - (50 + 24)
	p2y = windowHeight/2
	
	--Initializing Graphics stuff
	local f = love.graphics.newFont(12)
	love.graphics.setFont(f)
	love.graphics.setColor(0,0,0,255)
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setColor(0,0,0)
	love.graphics.setColorMode("replace")
	
end

function love.draw()
	--Draw the Field
	love.graphics.setColorMode("modulate")
	love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", startX, startY, fieldWidth, fieldHeight)	--Outline
	love.graphics.line(startX+(fieldWidth/2), startY, startX+(fieldWidth/2), startY+fieldHeight)	--Middle Line
	
	--Draw the Ball
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	
	love.graphics.setColor(50, 50, 50) -- set the drawing color to grey for the blocks
	love.graphics.polygon("fill", objects.p1.body:getWorldPoints(objects.p1.shape:getPoints()))
	love.graphics.polygon("fill", objects.p2.body:getWorldPoints(objects.p2.shape:getPoints()))
	
	--Update the Players positions
	love.graphics.setColorMode("replace")
	love.graphics.draw(player1IMG, p1x, p1y)
	love.graphics.draw(player2IMG, p2x, p2y)
	
	--Draw the Instructions
	love.graphics.setColorMode("modulate")
	love.graphics.setColor(0,0,0, 255)
	love.graphics.print("Player 1 uses W and S Keys and Player 2 uses Up and Down Arrow Keys. Start with Space.", 10, 10)
	love.graphics.print("P1", startX+fieldWidth/4, startY+windowWidth/2)
	love.graphics.print("P2", startX+3*(fieldWidth/4), startY+windowWidth/2)
	
	--Check if Game Over
end

function love.update(dt)
	world:update(dt) --this puts the world into motion
	
	--here we are going to create some keyboard events
	if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
		objects.ball.body:applyForce(400, 0)
	elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
		objects.ball.body:applyForce(-400, 0)
	elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
		objects.ball.body:setPosition(fieldWidth/2, fieldHeight/2)
	end
	
	--Player 1 Commands
	if love.keyboard.isDown("w") and ((p1y - 1) >= startY) then
		--Player 1 goes up
			p1y = p1y - 1
	elseif love.keyboard.isDown("s") and ((p1y+1) <= (startY+(fieldHeight-24))) then
		--Player 1 goes down
		p1y = p1y + 1
	end
	--Player 2 Commands
	--if love.keyboard.isDown("up") and ((p2y - 1) >= startY)  then
		--Player 2 goes up
		--p2y = p2y - 1
	--elseif love.keyboard.isDown("down") and ((p2y+1) <= (startY+(fieldHeight-24))) then
		--Player 2 goes down
		--p2y = p2y + 1
	--end
end

function love.keypressed(key)
	if key == ' ' then
		--Gamestate = Started
		gamestate = "running"
	elseif key == 'p' then
		--Gamestate = Paused
		gamestate = "paused"
	end
end