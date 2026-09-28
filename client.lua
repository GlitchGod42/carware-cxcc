local file=fs.open("carconfig.txt", "r")
local crypto=require("crypto")
local secretkey=file.readLine()
local channel=file.readLine()
local version = "1.2.1"
file.close()

print("checking for update")
local update = http.get("https://raw.githubusercontent.com/GlitchGod42/carware-cxcc/refs/heads/main/version.txt")

if not update then
    print("user is offline, check internet")
elseif update.getResponseCode() >= 400 then
    if update.readAll() > version then
        print("do you want to update?")
        print("y/N")
        local yn = read()
        if yn == "yes" or yn == "y" then
            print("updating!")
            fs.delete(arg[0] or shell.getRunningProgram())
            shell.run("wget https://raw.githubusercontent.com/GlitchGod42/carware-cxcc/refs/heads/main/car.lua /car.lua")
        end
    end
end

rednet.CHANNEL_BROADCAST = channel
crypto.SECRET_KEY = secretkey

rednet.open("back")
local hostId = rednet.lookup("carware-cxcc")
if not hostId then
    print("car was not found!")
    return
end

print("car found!")
rednet.send(hostId,crypto.cipher("connected"),"carware-cxcc")

forward,backward,left,right = false
sforward,sbackward,sleft,sright = "top","bottom","left","right"

local function broadcastToCar(side,bool)
    local timestamp = os.epoch("utc")
    rednet.broadcast(side.." "..tostring(bool)..":"..timestamp, "carware-cxcc")
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
        broadcastToCar(sforward, false)
    else
        broadcastToCar(sforward, true) -- invert it because of no inverted clutch
    end

    if backward then
        broadcastToCar(sbackward, true)
    else
        broadcastToCar(sbackward, false)
    end

    if left then
        broadcastToCar(sleft, true)
    else
        broadcastToCar(sleft, false)
    end

    if right then
        broadcastToCar(sright, true)
    else
        broadcastToCar(sright, false)
    end
end

rednet.close("back")