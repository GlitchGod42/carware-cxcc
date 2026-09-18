peripheral.find("modem",rednet.open)
forward = "top"
back = "bottom"
left = "left"
right = "right"
f = fs.open("carconfig.txt", "r")
secretkey=f.readLine()
f.close()
--print(secretkey)
rednet.host(secretkey, "car "..os.computerID())
print("waiting for pc to connect")
rednet.receive(secretkey)
print("connected!")
while true do
    local _,message=rednet.receive(secretkey)
    print(message)
    local ps = require"cc.strings".split(message," ")
    if ps[2] == true then
        redstone.setOutput(ps[1], true)
    else
        redstone.setOutput(ps[1], false)
    end
end