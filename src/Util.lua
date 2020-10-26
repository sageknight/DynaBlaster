
-- helper function to get quads
function GenerateTileQuads(atlas, tilewidth, tileheight, tileoffsetX, tileoffsetY)
    
    tileoffsetX = tileoffsetX or 0
    tileoffsetY = tileoffsetY or 0
    
    tilewidth_bound = tilewidth + tileoffsetX
    tileheight_bound = tileheight + tileoffsetY
    
    local sheetWidth = atlas:getWidth() / tilewidth_bound
    local sheetHeight = atlas:getHeight() / tileheight_bound
    
    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth_bound, y * tileheight_bound, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end


-- function to compute xtile, ytile from x and y
function ComputeXtile(x)
    -- return math.ceil(x/TILE_SIZE)
    return math.floor(x/TILE_SIZE) + 1
end

function ComputeYtile(y)
    -- return math.ceil((y - OFFSET_Y)/TILE_SIZE)
    return math.floor((y - OFFSET_Y)/TILE_SIZE) + 1
end


-- return true if this tile is either brick, pillar or wall, useful for fire stopper, monster AI walk
function hitBrickPillarWall(xtile, ytile, room)
    -- check if this tile would hit any of brick, pillar or wall, thus stop the fire range
    return room.brick_coors[ytile][xtile] or -- if hit brick
           (ytile % 2 == 1 and xtile % 2 == 0) or -- if hit pillar
           xtile < 3 or MAP_WIDTH - xtile < 2 or ytile < 2 or MAP_HEIGHT - ytile < 1 -- if hit pillar
end

function hitBrickPillarWallBomb(xtile, ytile, room)
    if hitBrickPillarWall(xtile, ytile, room) then
        return true
    end

    for b, bomb in pairs(room.bombs) do
        if xtile == bomb.xtile and ytile == bomb.ytile then
            return true
        end
    end
    return false
end


-- return true if table contains the value
function has_value(tab, val)
    for v, value in pairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
