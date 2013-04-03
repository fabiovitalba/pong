function love.load()
	--Setting up Game Window
	windowWidth = 1024
	windowHeight = 480
	pSpeed = 1	--1 = very slow, 2 = slow, 3 = normal, 4 = fast, 5 = hell
	bSpeed = 200	--Ball Speed
	maxColl = 5	--Maximum Collisions
	vol = 1.0	--Background Music Volume
	debugging = true	--Debugging Information
	vector = true	--Vector Drawing
	success = love.graphics.setMode(windowWidth, windowHeight, false, false, 4)	--( width, height, fullscreen, vsync, fsaa )
   
	--Setting Game Variables
	gamestate = "paused"
	gamemsg = ""
	playerTurn = 1
	p1score = 0	--Player 1 Score
	p2score = 0	--Player 2 Score
	p1tmpColl = 0	--Player 1 Collision count
	p2tmpColl = 0	--Player 2 Collision count
	
	--Initializing Physics
	love.physics.setMeter(64)	--The height of a Meter in this world will be 64px
	world = love.physics.newWorld(0, 0, true)	--Create a World for the Bodies to exist in, with horizontal Gravity of 0 and vertical gravity of 0. Real Gravity is 9.81 (= 9.81*64)
		world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	objects = {} --Array holding all the Objects with Physic elements
	
	--Starting the Sound System
	bgSound = love.audio.newSource("tetris_remix.mp3", "stream")	--Source: https://www.youtube.com/watch?v=eHUkHGoBHVY
	love.audio.play(bgSound)
	love.audio.setVolume(vol)
	
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
		objects.wall1.fixture:setUserData("TopWall") 
	
	objects.wall2 = {}	--Bottom wall
		objects.wall2.body = love.physics.newBody(world, windowWidth/2, windowHeight-25, "static")
		objects.wall2.shape = love.physics.newRectangleShape(windowWidth, 50)
		objects.wall2.fixture = love.physics.newFixture(objects.wall2.body, objects.wall2.shape)
		objects.wall2.fixture:setUserData("BottomWall") 
	
	objects.wall3 = {}	--Left wall
		objects.wall3.body = love.physics.newBody(world, 25, windowHeight/2, "static")
		objects.wall3.shape = love.physics.newRectangleShape(50, windowHeight)
		objects.wall3.fixture = love.physics.newFixture(objects.wall3.body, objects.wall3.shape)
		objects.wall3.fixture:setUserData("LeftWall") 
	
	objects.wall4 = {}	--Right wall
		objects.wall4.body = love.physics.newBody(world, windowWidth-25, windowHeight/2, "static")
		objects.wall4.shape = love.physics.newRectangleShape(50, windowHeight)
		objects.wall4.fixture = love.physics.newFixture(objects.wall4.body, objects.wall4.shape)
		objects.wall4.fixture:setUserData("RightWall") 
	
	--Creating the Ball
	objects.ball = {}
		objects.ball.body = love.physics.newBody(world, windowWidth/2, windowHeight/2, "dynamic")	--Creates a Physical Body in the World. The Type is Dynamic, meaning it can be moved by other Objects.
		objects.ball.body:setMass(0.0)
		objects.ball.shape = love.physics.newCircleShape(15)	--The Shape of this Object is a Ball with the Radius of 10px.
		objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) --Attach fixture to body and give it a density of 1. A higher density gives it more mass.
		objects.ball.fixture:setRestitution(1)	--Determines the Bouciness of the Ball.
		objects.ball.fixture:setUserData("Ball") 
	
	--Setting Standard Player Images
	player1IMG = love.graphics.newImage("1.png")	--Note: These are not mine. I do now own this image.
	player2IMG = love.graphics.newImage("2.png")	--Note: These are not mine. I do now own this image.
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
		objects.p1.fixture = love.physics.newFixture(objects.p1.body, objects.p1.shape)
		objects.p1.fixture:setUserData("Player1") 
	
	objects.p2 = {}
		objects.p2.body = love.physics.newBody(world, p2x, p2y, "static")
		objects.p2.shape = love.physics.newRectangleShape(0, 0, 24, 24)
		objects.p2.image = player2IMG
		objects.p2.fixture = love.physics.newFixture(objects.p2.body, objects.p2.shape)
		objects.p2.fixture:setUserData("Player2") 
	
	--Initializing Graphics stuff
	--Standartfont
	stdF = love.graphics.newFont("tcb.ttf", 16)
	love.graphics.setFont(stdF)
	--Title font
	ttlF = love.graphics.newFont("tcb.ttf", 28)
	ttlFOut = love.graphics.newFont("tcb.ttf", 29)
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setColor(0,0,0)
	love.graphics.setColorMode("replace")
end

function love.draw()
	--Draw the Fieldwalls
	love.graphics.setColorMode("modulate")
	love.graphics.setColor(72, 160, 14)	--Set the Color to Green for all the Walls
	love.graphics.polygon("fill", objects.wall1.body:getWorldPoints(objects.wall1.shape:getPoints())) --Draw the top wall
	love.graphics.polygon("fill", objects.wall2.body:getWorldPoints(objects.wall2.shape:getPoints())) --Draw the bottom wall
	love.graphics.polygon("fill", objects.wall3.body:getWorldPoints(objects.wall3.shape:getPoints())) --Draw the left wall
	love.graphics.polygon("fill", objects.wall4.body:getWorldPoints(objects.wall4.shape:getPoints())) --Draw the right wall
	
	--Draw the Fieldlines
	love.graphics.setColor(72, 160, 14)
	love.graphics.rectangle("fill", startX, startY, fieldWidth, fieldHeight)	--Inner Game Field
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", startX, startY, fieldWidth, fieldHeight)	--Outline
	love.graphics.line(startX+(fieldWidth/2), startY, startX+(fieldWidth/2), startY+fieldHeight)	--Middle Line
	
	--Draw the Instructions
	love.graphics.setColorMode("modulate")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(stdF)
	love.graphics.print("Player 1 uses W and S Keys and Player 2 uses Up and Down Arrow Keys. Start with Space.\nYou can Pause the Game with the P Key. For further Information press F1.", 10, 10)
	if debugging then	--Debugging Infos
		love.graphics.print(p1score.." : "..p2score, startX+fieldWidth - 75, startY+fieldHeight+5)
		love.graphics.print("The Ball is in Player "..getFieldPosition(objects.ball).."'s Field", 10, 50)
		love.graphics.print("It's Player "..getPlayerTurn().."'s Turn.", 10, startY+fieldHeight+10)
		if playerTurn == 1 then
			love.graphics.print("Player 1 has "..p1tmpColl.." temporary Collissions. Only "..(maxColl - p1tmpColl).." left.", 10, startY+fieldHeight+25)
		elseif playerTurn == 2 then
			love.graphics.print("Player 2 has "..p2tmpColl.." temporary Collissions. Only "..(maxColl - p2tmpColl).." left.", 10, startY+fieldHeight+25)
		end
		x, y = objects.ball.body:getLinearVelocity()
		love.graphics.print("Current Velocity in X-Axis: "..x, startX+fieldWidth - 175, startY+fieldHeight+15)
		love.graphics.print("Current Velocity in Y-Axis: "..y, startX+fieldWidth - 175, startY+fieldHeight+30)
		love.graphics.print("Current Vector Velocity: "..math.abs(x + y), startX+fieldWidth - 450, startY+fieldHeight+15)
	else
		love.graphics.print(p1score.." : "..p2score, startX+fieldWidth - 75, startY+fieldHeight+10)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(ttlF)
	love.graphics.printf("P1", windowWidth/4-100, windowHeight/2 - 12, 200, "center")
	love.graphics.printf("P2", 3 * (windowWidth/4) - 100, windowHeight/2 - 12, 200, "center")
	love.graphics.setFont(stdF)
	
	--Draw the Ball
	love.graphics.setColor(0, 0, 0)	--Set the 2 px Outline Color to Black for the Ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius() + 2)
	love.graphics.setColor(255, 255, 255)	--Set the Drawing Color to White for the Ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	--Draw the Ball Vector
	if vector then
		x, y = objects.ball.body:getLinearVelocity()
		love.graphics.setColor(255, 0, 0)
		love.graphics.line(objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.body:getX() + x, objects.ball.body:getY() + y)
		love.graphics.circle("fill", objects.ball.body:getX() + x, objects.ball.body:getY() + y, 2)
	end
	
	--Set the Players up
	love.graphics.setColorMode("replace")
	love.graphics.draw(objects.p1.image, objects.p1.body:getX(), objects.p1.body:getY(), objects.p1.body:getAngle(),  1, 1, objects.p1.image:getWidth()/2, objects.p1.image:getHeight()/2)
	love.graphics.draw(objects.p2.image, objects.p2.body:getX(), objects.p2.body:getY(), objects.p2.body:getAngle(),  1, 1, objects.p2.image:getWidth()/2, objects.p2.image:getHeight()/2)
	love.graphics.setColorMode("modulate")
	
	if gamestate == "paused" then	--If the Game was Paused display the Message
		--Actual Text
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.setFont(ttlF)
		love.graphics.printf("PAUSED", windowWidth/2 - 100, windowHeight/2 - 12, 200, "center")
		love.graphics.setFont(stdF)
	end
	
	--Check if Game Over
	--See http://www.love2d.org/wiki/Tutorial:PhysicsCollisionCallbacks for Collision resolving
	if not(gamemsg == "") then
		love.graphics.setColor(168, 168, 168, 150)
		love.graphics.rectangle("fill", windowWidth/2-200, windowHeight/2-100, 400, 200)
		love.graphics.setColor(200, 200, 200, 220)
		love.graphics.rectangle("line", windowWidth/2-200, windowHeight/2-100, 400, 200)
		love.graphics.setFont(ttlFOut)
		love.graphics.setColor(168, 168, 168)
		love.graphics.printf(gamemsg, windowWidth/2-200, windowHeight/2-35, 400, "center")
		love.graphics.setFont(ttlF)
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(gamemsg, windowWidth/2-200, windowHeight/2-35, 400, "center")
		love.graphics.setFont(stdF)
	end
end

function love.update(dt)
	world:update(dt) --Update World Physics
	if bgSound:isStopped() then
		bgSound:rewind()
	end
	if gamestate == "running" then
		x, y = objects.ball.body:getLinearVelocity( )
		if math.abs(x + y) < bSpeed then
			if x < 0 then
				objects.ball.body:applyForce(-25, 0)
			elseif x > 0 then
				objects.ball.body:applyForce(25, 0)
			else
				if playerTurn == 1 then
					objects.ball.body:applyForce(25, 0)
				else
					objects.ball.body:applyForce(-25, 0)
				end
			end
		elseif math.abs(x + y) > bSpeed then
			if x < 0 then
				objects.ball.body:applyForce(25, 0)
			elseif x > 0 then
				objects.ball.body:applyForce(-25, 0)
			else
				if playerTurn == 1 then
					objects.ball.body:applyForce(-25, 0)
				else
					objects.ball.body:applyForce(25, 0)
				end
			end
		end
	end
	
	--Player 1 Commands
	if gamestate == "running" then
		if love.keyboard.isDown("w") and ((objects.p1.body:getY() - pSpeed) >= startY) then	--Player 1 goes up
			objects.p1.body:setY(objects.p1.body:getY() - pSpeed)
		elseif love.keyboard.isDown("s") and ((objects.p1.body:getY() + pSpeed) <= (startY + fieldHeight)) then	--Player 1 goes down
			objects.p1.body:setY(objects.p1.body:getY() + pSpeed)
		end
		
		--Player 2 Commands
		if love.keyboard.isDown("up") and ((objects.p2.body:getY() - pSpeed) >= startY) then	--Player 2 goes up
			objects.p2.body:setY(objects.p2.body:getY() - pSpeed)
		elseif love.keyboard.isDown("down") and ((objects.p2.body:getY() + pSpeed) <= (startY + fieldHeight)) then	--Player 2 goes down
			objects.p2.body:setY(objects.p2.body:getY() + pSpeed)
		end
	end
end

function love.keypressed(key)
	if key == ' ' then
		--Game is running
		gamestate = "running"
		gamemsg = ""
		resetPositions()
		if math.random(100) % 2 == 1 then
			objects.ball.body:applyForce(10000, 0)
			playerTurn = 2
		else
			objects.ball.body:applyForce(-10000, 0)
			playerTurn = 1
		end
		love.audio.resume(bgSound)
	elseif key == 'p' then
		--Game is paused
		if gamestate == "paused" then
			objects.ball.body:setAwake(true)
			gamestate = "running"
			love.audio.resume(bgSound)
		else
			objects.ball.body:setAwake(false)
			gamemsg = ""
			gamestate = "paused"
			love.audio.pause(bgSound)
		end
	end
end

function getFieldPosition(obj)	--Check in which field the Ball is in this Moment
	if obj.body:getX() < (startX + fieldWidth/2) then	--If the Body is in the left side of the Screen/Gamefield
		return 1	--The Object is in Player 1's Field
	else
		return 2	--The Object is in Player 2's Field
	end
end

function resetPositions()
	--Resetting Ball Position
	objects.ball.body:setPosition(fieldWidth/2 + startX, fieldHeight/2 + startY)
	objects.ball.body:setAwake(false)
	objects.ball.body:setAwake(true)
	
	--Resetting Player Positions
	p1y = windowHeight/2
	p2y = windowHeight/2
end

function getPlayerTurn()
	return playerTurn
end

--Collision Callbacks
--a is the first fixture object in the collision.
--b is the second fixture object in the collision.
--coll is the contact object created.  
function beginContact(a, b, coll)
	x,y = coll:getNormal()	--Get Coordinates of the Collision Point
	if a:getUserData() == "Ball" or b:getUserData() == "Ball" then	--Ball collides somewhere
		if a:getUserData() == "LeftWall" or b:getUserData() == "LeftWall" then	--Ball collides with the left wall
			gameOver(2)
		elseif a:getUserData() == "RightWall" or b:getUserData() == "RightWall" then	--Ball collides with the right wall
			gameOver(1)
		end
		
		if a:getUserData() == "TopWall" or b:getUserData() == "TopWall" then	--Ball collides with the top wall
			if playerTurn == 1 then
				p1tmpColl = p1tmpColl + 1
			elseif playerTurn == 2 then
				p2tmpColl = p2tmpColl + 1
			end
			checkCollisions()
		elseif a:getUserData() == "BottomWall" or b:getUserData() == "BottomWall" then	--Ball collides with the bottom wall
			if playerTurn == 1 then
				p1tmpColl = p1tmpColl + 1
			elseif playerTurn == 2 then
				p2tmpColl = p2tmpColl + 1
			end
			checkCollisions()
		end
		
		if a:getUserData() == "Player1" or b:getUserData() == "Player1" then	--Ball collides with Player 1
			playerTurn = 1
			p1tmpColl = 0
			p2tmpColl = 0
		elseif a:getUserData() == "Player2" or b:getUserData() == "Player2" then	--Ball collides with Player 2
			playerTurn = 2
			p1tmpColl = 0
			p2tmpColl = 0
		end
	end
end

function endContact(a, b, coll)
	
end

function preSolve(a, b, coll)
	
end

function postSolve(a, b, coll)
	
end

function checkCollisions()
	if p1tmpColl >= maxColl then
		gameOver(2)
	elseif p2tmpColl >= maxColl then
		gameOver(1)
	end
end

function gameOver(winner)
	gamestate = "paused"
	if winner == 1 then
		gamemsg = "Player 2 lost the match.\nCongratulations Player 1!"
		objects.ball.body:setAwake(false)
		p1score = p1score + 1
	elseif winner == 2 then
		gamemsg = "Player 1 lost the match.\nCongratulations Player 2!"
		objects.ball.body:setAwake(false)
		p2score = p2score + 1
	end
end