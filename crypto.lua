crypto = {}

crypto.SECRET_KEY = ""

function crypto.cipher(text)
	local output = {}
	for i = 1, #text do
		local textByte = string.byte(text, i)
		local keyIndex = ((i - 1) % #crypto.SECRET_KEY) + 1
		local keyByte = string.byte(crypto.SECRET_KEY, keyIndex)
		table.insert(output, string.char(bit32.bxor(textByte, keyByte)))
	end
	return table.concat(output)
end

return crypto
