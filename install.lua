print("press enter to start installation...")
print("version v1.0.0")
read()
if fs.exists("/startup" or "/startup.lua") then
    fs.move("/startup" or "/startup.lua", "/startup2.lua")
end

print("press enter when you have connnected only 1 disk drive and put your wireless/ender pocket computer into it")
read()
shell.run("cd /disk")
shell.run("wget https://raw.githubusercontent.com/GlitchGod42/carware-cxcc/refs/heads/main/client.lua car.lua")
shell.run("cd /")
shell.run("wget https://raw.githubusercontent.com/GlitchGod42/carware-cxcc/refs/heads/main/car.lua startup.lua")

local rndstrtable = {}
math.randomseed(os.epoch("utc"))
math.random()
for i=1, 32 do
    table.insert(rndstrtable, string.char(math.random(33, 126)))
end

rndstr = table.concat(rndstrtable)
rndchannel = math.random(1, 65535)

file = fs.open("/carconfig.txt", "w")
file.write(rndstr .. "\n" .. rndchannel)
file.close()

file = fs.open("/disk/carconfig.txt", "w")
file.write(rndstr .. "\n" .. rndchannel)
file.close()

print("done")