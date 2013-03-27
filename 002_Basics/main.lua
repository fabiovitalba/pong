function love.load()
	--Setting up Game Window
	windowWidth = 1024
	windowHeight = 480
	speed = 3		--2 = slow, 3 = normal, 4 = fast
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
	objects.wall1 = {}	--Top wall
	objects.wall1.body = love.physics.newBody(world, windowWidth/2, 25, "static") --The Bodyshape anchors to the middle, so be sure to take the middle Point as your reference, and not the left upper corner!
	objects.wall1.shape = love.physics.newRectangleShape(windowWidth, 50) --Make the Shape of the Object a Rectangle with the Dimensions "windowWidth x 50"
	objects.wall1.fixture = love.physics.newFixture(objects.wall1.body, objects.wall1.shape) --Attach the Shape to the Body
	
	objects.wall2 = {}	--Bottom wall
	objects.wall2.body = love.physics.newBody(world, windowWidth/2, windowHeight-25, "static")
	objects.wall2.shape = love.physics.newRectangleShape(windowWidth, 50)
	objects.wall2.fixture = love.physics.newFixture(objects.wall2.body, objects.wall2.shape)
	
	objects.wall3 = {}	--Left wall
	objects.wall3.body = love.physics.newBody(world, 25, windowHeight/2, "static")
	objects.wall3.shape = love.physics.newRectangleShape(50, windowHeight)
	objects.wall3.fixture = love.physics.newFixture(objects.wall3.body, objects.wall3.shape)
	
	objects.wall4 = {}	--Right wall
	objects.wall4.body = love.physics.newBody(world, windowWidth-25, windowHeight/2, "static")
	objects.wall4.shape = love.physics.newRectangleShape(50, windowHeight)
	objects.wall4.fixture = love.physics.newFixture(objects.wall4.body, objects.wall4.shape)
	
	--Creating the Ball
	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, windowWidth/2, windowHeight/2, "dynamic")	--place the body in the center of the world and make it dynamic, so it can move around
	objects.ball.shape = love.physics.newCircleShape(10)	--the ball's shape has a radius of 10
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 0) -- Attach fixture to body and give it a density of 1.
	objects.ball.fixture:setRestitution(0.9)	--let the ball bounce
	objects.ball.body:setLinearDamping(0)
	
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
	objects.p1.body = love.physics.newBody(world, p1x, p1y, "static")
	objects.p1.shape = love.physics.newRectangleShape(0, 0, 24, 24)
	objects.p1.image = player1IMG
	objects.p1.fixture = love.physics.newFixture(objects.p1.body, objects.p1.shape, 50)	-- A higher density gives it more mass.
	
	objects.p2 = {}
	objects.p2.body = love.physics.newBody(world, p2x, p2y, "static")
	objects.p2.shape = love.physics.newRectangleShape(0, 0, 24, 24)
	objects.p2.image = player2IMG
	objects.p2.fixture = love.physics.newFixture(objects.p2.body, objects.p2.shape, 50)
	
	--Initializing Graphics stuff
	--Standartfont
	stdF = love.graphics.newFont("tcb.ttf", 16)
	love.graphics.setFont(stdF)
	--Title font
	ttlF = love.graphics.newFont("tcb.ttf", 28)
	love.graphics.setColor(0,0,0,255)
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setColor(0,0,0)
	love.graphics.setColorMode("replace")
	
end

function love.draw()
	--Draw the Fieldwalls
	love.graphics.setColorMode("modulate")
	love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the wall1
	love.graphics.polygon("fill", objects.wall1.body:getWorldPoints(objects.wall1.shape:getPoints())) --Draw the top wall
	love.graphics.polygon("fill", objects.wall2.body:getWorldPoints(objects.wall2.shape:getPoints())) --Draw the bottom wall
	love.graphics.polygon("fill", objects.wall3.body:getWorldPoints(objects.wall3.shape:getPoints())) --Draw the left wall
	love.graphics.polygon("fill", objects.wall4.body:getWorldPoints(objects.wall4.shape:getPoints())) --Draw the right wall
	
	--Draw the Fieldlines
	love.graphics.setColor(72, 160, 14)
	love.graphics.rectangle("fill", startX, startY, fieldWidth, fieldHeight)	--Field
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", startX, startY, fieldWidth, fieldHeight)	--Outline
	love.graphics.line(startX+(fieldWidth/2), startY, startX+(fieldWidth/2), startY+fieldHeight)	--Middle Line
	
	--Draw the Ball
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	
	--Set the Players up
	love.graphics.setColorMode("replace")
	love.graphics.draw(objects.p1.image, objects.p1.body:getX(), objects.p1.body:getY(), objects.p1.body:getAngle(),  1, 1, objects.p1.image:getWidth()/2, objects.p1.image:getHeight()/2)
	love.graphics.draw(objects.p2.image, objects.p2.body:getX(), objects.p2.body:getY(), objects.p2.body:getAngle(),  1, 1, objects.p2.image:getWidth()/2, objects.p2.image:getHeight()/2)
	
	--Draw the Instructions
	love.graphics.setColorMode("modulate")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(stdF)
	love.graphics.print("Player 1 uses W and S Keys and Player 2 uses Up and Down Arrow Keys. Start with Space.", 10, 10)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(ttlF)
	love.graphics.print("P1", (startX + fieldWidth/4), (startY + windowWidth/2))
	love.graphics.print("P2", (startX + 3*(fieldWidth/4)), (startY + windowWidth/2))
	
	--Check if Game Over
end

function love.update(dt)
	world:update(dt) --Update World Physics
	
	--Player 1 Commands
	if love.keyboard.isDown("w") then
		--Player 1 goes up
		--objects.p1.body:applyForce(0, -600)				--For Players who want real Physics
		objects.p1.body:setY(objects.p1.body:getY() - speed)
	elseif love.keyboard.isDown("s") then
		--Player 1 goes down
		--objects.p1.body:applyForce(0, 600)				--For Players who want real Physics
		objects.p1.body:setY(objects.p1.body:getY() + speed)
	end
	
	--Player 2 Commands
	if love.keyboard.isDown("up") then
		--Player 2 goes up
		--objects.p2.body:applyForce(0, -600)				--For Players who want real Physics
		objects.p2.body:setY(objects.p2.body:getY() - speed)
	elseif love.keyboard.isDown("down") then
		--Player 2 goes down
		--objects.p2.body:applyForce(0, 600)				--For Players who want real Physics
		objects.p2.body:setY(objects.p2.body:getY() + speed)
	end
end

function love.keypressed(key)
	if key == ' ' then
		--Gamestate = Started
		gamestate = "running"
		objects.ball.body:setPosition(fieldWidth/2 + startX, fieldHeight/2 + startY)
		if math.random(100) % 2 == 1 then
			objects.ball.body:applyForce(100000, 0)
		else
			objects.ball.body:applyForce(-100000, 0)
		end
	elseif key == 'p' then
		--Gamestate = Paused
		if gamestate == "paused" then
			objects.ball.body:setAwake(true)
			gamestate = "running"
		else
			objects.ball.body:setAwake(false)
			gamestate = "paused"
		end
	end
end