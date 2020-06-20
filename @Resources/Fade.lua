-- How to use:
-- Script measure takes 2 options:
--- Source: The measure to monitor for color changes. Must return RGB hex code color.
--- Timestep: The final update value for the measure in milliseconds
-- Return: The RGB hex code color for that update

function Initialize()
	FadeTime = tonumber(SKIN:GetVariable('FadeTime', '1000'))
	Timestep = tonumber(SELF:GetOption('Timestep', '25'))
	Accum = FadeTime
	
	Source = SKIN:GetMeasure(SELF:GetOption('Source', ''))
	OldValue = nil
	print("Fade "..SELF:GetOption('Source', '').." in ".. FadeTime.. "ms in steps of ".. Timestep.. "ms.")
end

function Update()
	NewValue = Source:GetStringValue()
	local CurrentValue = NewValue
	
	if OldValue == nil
	then
		OldValue = NewValue
		
	end
	
	if NewValue ~= OldValue
	then
		if Accum < FadeTime
		then
			-- Continue an existing fade
			Accum = (Accum + Timestep)
			CurrentValue = DoFade(OldValue, NewValue, Accum / FadeTime)
		else
			-- We're starting a new fade! We've been sitting at Accum == 0 so skip that.
			Accum = 0
			CurrentValue = DoFade(OldValue, NewValue, Accum / FadeTime)
			print("Fading "..OldValue.." to "..NewValue);
		end
		
		-- Check if we're done fading
		if CurrentValue == NewValue
		then
			print("Done fading "..OldValue.." to "..NewValue);
			OldValue = NewValue
		end
	end
	
	return CurrentValue
end

-- Figure out what the color is dT% between SrcColor and DestColor,
-- with SrcColor == dT=0 and DestColor == dT=1
function DoFade(SrcColor, DestColor, dT)
	-- Cap off dT
	if dT < 0
	then
		dT = 0
	else
		if dT > 1
		then
			dT = 1
		end
	end
	
	srcRed = tonumber(string.sub(SrcColor, 1, 2), 16)
	destRed = tonumber(string.sub(DestColor, 1, 2), 16)
	curRed = ((1 - dT) * srcRed) + (dT * destRed)
	
	srcGreen = tonumber(string.sub(SrcColor, 3, 4), 16)
	destGreen = tonumber(string.sub(DestColor, 3, 4), 16)
	curGreen = ((1 - dT) * srcGreen) + (dT * destGreen)
	
	srcBlue = tonumber(string.sub(SrcColor, 5, 6), 16)
	destBlue = tonumber(string.sub(DestColor, 5, 6), 16)
	curBlue = ((1 - dT) * srcBlue) + (dT * destBlue)
	
	return string.format('%02X%02X%02X', curRed, curGreen, curBlue)
end