function IGDEBUG(text)
	file.Append("igdebug.txt", "[" .. os.date('%d-%m-%Y - %I:%M:%S %p', os.time()) .. "] " .. text .. "\n")
	print(text)
end