local rq = http.get("https://raw.githubusercontent.com/DarkSywall/computercraft/master/home.lua")
local file = fs.open("darksywall/home.lua", "w")
file.write(rq.readAll())
rq.close()