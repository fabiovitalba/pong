function love.load()
	--Setting Game Window
	windowWidth = 1024
	windowHeight = 480
	success = love.graphics.setMode(windowWidth, windowHeight, false, true, 4)	--( width, height, fullscreen, vsync, fsaa )
	
	--Setting Game Variables
	gamestate = "paused"
	
	--Initializing Physics
	love.physics.setMeter(64)	--the height of a meter our worlds will be 64px
	world = love.physics.newWorld(0, 0, true)	--create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81 (= 9.81*64)
	objects = {} -- table to hold all our physical objects
	
	--Creating the Game Field Variables
	startX = 50
	startY = 50
	fieldWidth = windowWidth - 100
	fieldHeight = windowHeight - 100
	grassIMG = love.graphics.newImage("g.jpg")
	--Creating the Walls
	objects.wall1 = {}
	objects.wall1.body = love.physics.newBody(world, windowWidth/2, 25) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	objects.wall1.shape = love.physics.newRectangleShape(windowWidth, 50) --make a rectangle with a width of the whole Window and a height of 50
	objects.wall1.fixture = love.physics.newFixture(objects.wall1.body, objects.wall1.shape, 5000) --attach shape to body
	
	objects.wall2 = {}
	objects.wall2.body = love.physics.newBody(world, windowWidth/2, 25) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	objects.wall2.shape = love.physics.newRectangleShape(windowWidth, 50) --make a rectangle with a width of the whole Window and a height of 50
	objects.wall2.fixture = love.physics.newFixture(objects.wall2.body, objects.wall2.shape, 5000) --attach shape to body
	
	--Creating the Ball
	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, windowWidth/2, windowHeight/2, "dynamic")	--place the body in the center of the world and make it dynamic, so it can move around
	objects.ball.shape = love.physics.newCircleShape(10)	--the ball's shape has a radius of 10
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 10) -- Attach fixture to body and give it a density of 1.
	objects.ball.fixture:setRestitution(0.9)	--let the ball bounce
	
	--Setting Player Images
	player1IMG = love.graphics.newImage("1.png")
	player2IMG = love.graphics.newImage("2.png")
	--Setting up Players Positions
	p1x = 50
	p1y = windowHeight/2
	p2x = windowWidth - 50
	p2y = windowHeight/2
	--Creating the Players Physics
	objects.p1 = {}
	objects.p1.body = love.physics.newBody(world, p1x, p1y, "dynamic")
	objects.p1.shape = love.physics.newRectangleShape(0, 0, 24, 24)
	objects.p1.image = player1IMG
	objects.p1.fixture = love.physics.newFixture(objects.p1.body, objects.p1.shape, 5)	-- A higher density gives it more mass.
	
	objects.p2 = {}
	objects.p2.body = love.physics.newBody(world, p2x, p2y, "dynamic")
	objects.p2.shape = love.physics.newRectangleShape(0, 0, 24, 24)
	objects.p2.image = player2IMG
	objects.p2.fixture = love.physics.newFixture(objects.p2.body, objects.p2.shape, 5)
	
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
	love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the wall1
	love.graphics.polygon("fill", objects.wall1.body:getWorldPoints(objects.wall1.shape:getPoints())) -- draw a "filled in" polygon using the wall1's coordinates
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", startX, startY, fieldWidth, fieldHeight)	--Outline
	love.graphics.line(startX+(fieldWidth/2), startY, startX+(fieldWidth/2), startY+fieldHeight)	--Middle Line
	
	--Draw the Ball
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	
	--Set the Players up
	love.graphics.setColorMode("replace")
	--love.graphics.polygon("fill", objects.p1.body:getWorldPoints(objects.p1.shape:getPoints()))
	love.graphics.draw(objects.p1.image, objects.p1.body:getX(), objects.p1.body:getY(), objects.p1.body:getAngle(),  1, 1, objects.p1.image:getWidth()/2, objects.p1.image:getHeight()/2)
	--love.graphics.polygon("fill", objects.p2.body:getWorldPoints(objects.p2.shape:getPoints()))
	love.graphics.draw(objects.p2.image, objects.p2.body:getX(), objects.p2.body:getY(), objects.p2.body:getAngle(),  1, 1, objects.p2.image:getWidth()/2, objects.p2.image:getHeight()/2)
	
	--Update the Players positions
	--love.graphics.setColorMode("replace")
	--love.graphics.draw(player1IMG, objects.p1.body:getWorldPoints(objects.p1.shape:getPoints()))
	--love.graphics.draw(player2IMG, objects.p2.body:getWorldPoints(objects.p2.shape:getPoints()))
	
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
	
	--Ball Control
	if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
		objects.ball.body:applyForce(400, 0)
	elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
		objects.ball.body:applyForce(-400, 0)
	elseif love.keyboard.isDown("up") then --press the up arrow key to push the ball in the air
		objects.ball.body:applyForce(0, -400)
	elseif love.keyboard.isDown("down") then --press the down arrow key to push the ball down
		objects.ball.body:applyForce(0, 400)
	elseif love.keyboard.isDown(" ") then --press the up arrow key to set the ball in the air
		objects.ball.body:setPosition(fieldWidth/2, fieldHeight/2)
	end
	
	--Player Controls
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