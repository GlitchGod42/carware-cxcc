peripheral.find("modem",rednet.open)
forward = "top"
back = "bottom"
left = "left"
right = "right"
f = fs.open("carconfig.txt", "r")
local crypto = require("crypto")
secretkey=f.readLine()
channel=f.readLine()
f.close()
local TIMEOUT = 1000
rednet.CHANNEL_BROADCAST = channel
crypto.SECRET_KEY = secretkey
--print(secretkey)
rednet.host("carware-cxcc", "car "..os.computerID())
print("waiting for pc to connect")
rednet.receive("carware-cxcc")
print("connected!")
::invalid::
while true do
    local _,message=crypto.cipher(rednet.receive("carware-cxcc"))
    age = tonumber(require"cc.strings".split(message,":")[1]) - os.epoch("utc") < TIMEOUT
    if age < TIMEOUT or age < 0 then print("invalid/old message detected!");goto invalid end
    print(message)
    local ps1 = require"cc.strings".split(message," ")
    local ps = ps1:gsub("[:]", "")
    if ps[2] == "true" then
        redstone.setOutput(ps[1], true)
    else
        redstone.setOutput(ps[1], false)
    end
end