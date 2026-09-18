local file=fs.open("carconfig.txt", "r")
local secretkey=file.readLine()
local channel=file.readLine()
file.close()

rednet.CHANNEL_BROADCAST = channel

rednet.open("back")
local hostId = rednet.lookup(secretkey)
if not hostId then
    print("car was not found!")
    return
end

print("car found!")
rednet.send(hostId,"connected",secretkey)

forward,backward,left,right = false
mforward,mbackward,mleft,mright = "top","bottom","left","right"

local function broadcastToCar(side,bool)
    rednet.broadcast(side.." "..bool, secretkey)
end

while true do
    event,arg1 = os.pullEvent()
    if event == "key" then
        if arg1 == keys.w and not backward then
            forward = true
        elseif arg1 == keys.s and not forward then
            backward = true
        elseif arg1 == keys.a and not right then
            left = true
        elseif arg1 == keys.d and not left then
            right = true
        elseif arg1 == keys.backspace then
            break
        end
    elseif event == "key_up" then
        if arg1 == keys.w then
            forward = false
        elseif arg1 == keys.s then
            backward = false
        elseif arg1 == keys.a then
            left = false
        elseif arg1 == keys.d then
            right = true
        end
    end

    if forward then
        broadcastToCar(mforward, false)
    else
        broadcastToCar(mforward, true) -- invert it because of no inverted clutch
    end

    if backward then
        broadcastToCar(mbackward, true)
    else
        broadcastToCar(mbackward, false)
    end

    if left then
        broadcastToCar(mleft, true)
    else
        broadcastToCar(mleft, false)
    end

    if right then
        broadcastToCar(mright, true)
    else
        broadcastToCar(mright, false)
    end
end

rednet.close("back")