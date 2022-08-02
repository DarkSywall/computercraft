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
    secureSteps = 10
    stepsLeft = turtle.getFuelLevel() - calculateHomeGas() - secureSteps

    if stepsLeft > 0 then
        return false
    else
        return true
    end
end

function goHome()
    -- neutralize z axis
    if homePosition.z > 0 then
        while homePosition.z > 0 do
            homePosition.z = homePosition.z - 1
            turtle.down()
        end
    elseif homePosition.z < 0 then
        while homePosition.z < 0 do
            homePosition.z = homePosition.z + 1
            turtle.up()
        end
    end

    -- neutralize y axis
    if homePosition.y > 0 then
        while homePosition.orientation ~= "left" do
            rotateLeft()
        end

        while homePosition.y > 0 do
            homePosition.y = homePosition.y - 1
            turtle.forward()
        end
    elseif homePosition.y < 0 then
        while homePosition.orientation ~= "right" do
            rotateLeft()
        end
        while homePosition.y < 0 do
            homePosition.y = homePosition.y + 1
            turtle.forward()
        end
    end

    -- neutralize x axis
    if homePosition.x > 0 then
        while homePosition.orientation ~= "right" do
            rotateRight()
        end

        while homePosition.x > 0 do
            homePosition.x = homePosition.x - 1
            turtle.forward()
        end
    elseif homePosition.x < 0 then
        while homePosition.orientation ~= "left" do
            rotateRight()
        end
        while homePosition.x < 0 do
            homePosition.x = homePosition.x + 1
            turtle.forward()
        end
    end
end
