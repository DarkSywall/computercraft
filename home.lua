-- #####################################################
-- Positioning Modules
-- #####################################################
local homePosition = {
    x = 0,
    y = 0,
    z = 0,
    orientation = "front"
}

function changeOrientation(rotationDirection)
    if rotationDirection == "left" then
        if homePosition.orientation == "front" then
            homePosition.orientation = "left"
        elseif homePosition.orientation == "back" then
            homePosition.orientation = "right"
        elseif homePosition.orientation == "left" then
            homePosition.orientation = "back"
        elseif homePosition.orientation == "right" then
            homePosition.orientation = "front"
        end
    elseif rotationDirection == "right" then
        if homePosition.orientation == "front" then
            homePosition.orientation = "right"
        elseif homePosition.orientation == "back" then
            homePosition.orientation = "left"
        elseif homePosition.orientation == "left" then
            homePosition.orientation = "front"
        elseif homePosition.orientation == "right" then
            homePosition.orientation = "back"
        end
    end

end

function calculateOrientation(movementDirection)
    if movementDirection == "front" then
        if homePosition.orientation == "front" then
            homePosition.x = homePosition.x + 1
        elseif homePosition.orientation == "back" then
            homePosition.x = homePosition.x - 1
        elseif homePosition.orientation == "left" then
            homePosition.y = homePosition.y - 1
        elseif homePosition.orientation == "right" then
            homePosition.y = homePosition.y + 1
        end
    elseif movementDirection == "back" then
        if homePosition.orientation == "front" then
            homePosition.x = homePosition.x - 1
        elseif homePosition.orientation == "back" then
            homePosition.x = homePosition.x + 1
        elseif homePosition.orientation == "left" then
            homePosition.y = homePosition.y + 1
        elseif homePosition.orientation == "right" then
            homePosition.y = homePosition.y - 1
        end
    elseif movementDirection == "up" then
        homePosition.z = homePosition.z + 1
    elseif movementDirection == "down" then
        homePosition.z = homePosition.z - 1
    end
end

function isWayBlocked(direction)
    if direction == "down" then
        isBlocked, msg = turtle.inspectDown()
        return isBlocked
    elseif direction == "up" then
        isBlocked, msg = turtle.inspectUp()
        return isBlocked
    else
        isBlocked, msg = turtle.inspect()
        return isBlocked
    end
end

function moveFront()
    if isWayBlocked("front") then
        return false
    end

    calculateOrientation("front")
    turtle.forward()
end

function moveBack()
    if isWayBlocked("back") then
        return false
    end

    calculateOrientation("back")
    turtle.back()
end

function moveUp()
    if isWayBlocked("up") then
        return false
    end

    calculateOrientation("up")
    turtle.up()
end

function moveDown()
    if isWayBlocked("down") then
        return false
    end

    calculateOrientation("down")
    turtle.down()

end

function rotateLeft()
    changeOrientation("left")
    turtle.turnLeft()
end

function rotateRight()
    changeOrientation("right")
    turtle.turnRight()
end

function getPosition()
    return homePosition.x, homePosition.y, homePosition.z
end

function getOrientation()
    return homePosition.orientation
end

function calculateHomeGas()
    return math.abs(homePosition.x) + math.abs(homePosition.y) + math.abs(homePosition.z)
end

function timeToGoHome()
    -- check if fuel will be to low or chest full
    secureSteps = 20
    stepsLeft = turtle.getFuelLevel() - calculateHomeGas() - secureSteps

    if stepsLeft < 0 then
        return true
    elseif turtle.getItemSpace(16) < 64 then
        return true
    else
        return false
    end
end

function goTo(position)
    -- handle x position
    if homePosition.x > position.x then
        while homePosition.orientation ~= "back" do
            rotateRight()
        end

        while homePosition.x > position.x do
            homePosition.x = homePosition.x - 1
            turtle.forward()
        end
    elseif homePosition.x < position.x then
        while homePosition.orientation ~= "front" do
            rotateRight()
        end
        while homePosition.x < position.x do
            homePosition.x = homePosition.x + 1
            turtle.forward()
        end
    end

    -- handle y position
    if homePosition.y > position.y then
        while homePosition.orientation ~= "left" do
            rotateLeft()
        end

        while homePosition.y > position.y do
            homePosition.y = homePosition.y - 1
            turtle.forward()
        end
    elseif homePosition.y < position.y then
        while homePosition.orientation ~= "right" do
            rotateLeft()
        end
        while homePosition.y < position.y do
            homePosition.y = homePosition.y + 1
            turtle.forward()
        end
    end

    -- handle z position
    if homePosition.z > position.z then
        while homePosition.z > position.z do
            homePosition.z = homePosition.z - 1
            turtle.down()
        end
    elseif homePosition.z < position.z then
        while homePosition.z < position.z do
            homePosition.z = homePosition.z + 1
            turtle.up()
        end
    end

    -- handle orientation
    while homePosition.orientation ~= position.orientation do
        rotateRight()
    end
end

function goHome()
    goTo(
        {
            x = 0,
            y = 0,
            z = 0,
            orientation = "front"
        }
    )
end

-- #####################################################
-- Fuel Mods
-- #####################################################
function suckUpFuelMats()
    while turtle.suck() == true do
        -- just do nothing, keep sucking
    end
end

function fillUpWithFuelMats()
    fuelStatus = turtle.getFuelLevel()

    for i = 1, 16, 1 do
        turtle.select(i)
        turtle.refuel()
    end

    if turtle.getFuelLevel() == fuelStatus then
        return false
    else
        return true
    end
end

function fillTurtle()
    -- make sure we are on position 0 0 0
    goHome()

    -- move to chest
    rotateRight()
    rotateRight()
    moveFront()
    moveFront()

    -- fill up turtle
    suckUpFuelMats()
    fillUpWithFuelMats()

    -- go to start position
    goHome()
end

-- #####################################################
-- Storage Fuel Modules
-- #####################################################
function dropItemsToChest()
    for i = 1, 16, 1 do
        turtle.select(i)
        turtle.drop()
    end
end

function emptyInventory()
    -- make sure we are on 0 0 0
    goHome()

    -- move to chest
    rotateLeft()
    moveFront()
    rotateLeft()
    moveFront()
    moveFront()

    -- drop all items
    dropItemsToChest()

    -- go back to 0 0 0
    goHome()
end

-- #####################################################
-- Mining Modules
-- #####################################################
local startLayer = 76 -- here we need to insert the layer where the miner was placed
local bedRockLayer = -60 -- this is the layer where we want not to dig in!

local mineAreaX = 9 -- size of the mine field in x direction
local mineAreaY = 9 -- size of the mine field in y direction

local isRunning = false -- will be set to false as soon as the miner reaches bedrock and returns home

local lastMinePosition = {
    x = 0,
    y = 0,
    z = 0,
    orientation = "front"
}

function checkBedrockUnderneath()
    if startLayer - homePosition.z - 1 <= bedRockLayer then
        return true
    else
        return false
    end
end

function saveCurrentMiningPosition()
    lastMinePosition.x = homePosition.x
    lastMinePosition.y = homePosition.y
    lastMinePosition.z = homePosition.z
    lastMinePosition.orientation = homePosition.orientation
    print(homePosition)
    print(lastMinePosition)
end

function goToLastMinigPosition()
    print(lastMinePosition)
    goTo(lastMinePosition)
end

function dig()
    if turtle.detect() then
        turtle.dig()
    end
end

function digDown()
    if turtle.detectDown() then
        turtle.digDown()
    end
end

function healthCheck()
    if timeToGoHome() then
        saveCurrentMiningPosition()
        goHome()
        emptyInventory()
        fillTurtle()
        goToLastMinigPosition()
    end
end

function mineLayer()
    layerPosition = {
        x = homePosition.x,
        y = homePosition.y,
        z = homePosition.z,
        orientation = homePosition.orientation
    }

    invert = false

    for y = 1, mineAreaY, 1 do
        for x = 1, mineAreaX, 1 do
            dig()
            moveFront()
        end

        if invert then
            rotateLeft()
            dig()
            moveFront()
            rotateLeft()
            invert = false
        else
            rotateRight()
            dig()
            moveFront()
            rotateRight()
            invert = true
        end

        healthCheck()
    end

    goTo(layerPosition)

end

function startMining()
    isRunning = true

    while isRunning do
        mineLayer()

        -- after finishing a whole layer check layer beneath
        if checkBedrockUnderneath() then
            goHome()
            isRunning = false
        else
            rotateLeft()
            rotateLeft()
            digDown()
            moveDown()
        end
    end
end
