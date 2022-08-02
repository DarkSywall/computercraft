local gitLinks = {
    { name = "home.lua", url = "https://raw.githubusercontent.com/DarkSywall/computercraft/master/home.lua" },
    { name = "refill.lua", url = "https://raw.githubusercontent.com/DarkSywall/computercraft/master/refill.lua" }
}

local folderName = "darksywall"

for i = 1, #gitLinks, 1 do
    rq = http.get(gitLinks[i].url)
    file = fs.open(folderName .. "/" .. gitLinks[i].name, "w")
    file.write(rq.readAll())
    rq.close()
end
