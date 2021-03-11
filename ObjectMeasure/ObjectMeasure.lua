-------------------------------------------------------------------------------
-- ObjectMeasure by MindScape - Designed for Enteleaie
-------------------------------------------------------------------------------

local currentVersion = GetAddOnMetadata("ObjectMeasure", "Version")

-------------------------------------------------------------------------------
-- Local Simple Functions & Definitions
-------------------------------------------------------------------------------

							-- allow us to use cmd() as a shorthand for SendChatMessage with the . already there.
local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

							-- Redefines print() to use a color precursor so it's not needed every print function.
local oldprint = print
local function print(text)
	oldprint("|cffFFE5EE"..text)
end

							-- Make sure these are local and not taking from another addon if they didn't localize.
local x1, x2, y1, y2, z1, z2 = nil,nil,nil,nil,nil,nil

-------------------------------------------------------------------------------
-- Main Functions
-------------------------------------------------------------------------------

local function getObjectCoords(object)
	
	if gX and gY and gZ then	-- Make sure that these exist first, otherwise we'll know that we haven't selected an object on this session. gX/Y/Z are the saved variables when ".go sel" or ".go spawn" reply with coordinates.
		if object == 1 then
			x1 = gX
			y1 = gY
			z1 = gZ
			print("ObjectMeasure: Saved (X: "..gX.. " | Y: "..gY.." | Z: "..gZ.." ) for object 1.")
		elseif object == 2 then
			x2 = gX
			y2 = gY
			z2 = gZ
			print("ObjectMeasure: Saved (X: "..gX.. " | Y: "..gY.." | Z: "..gZ.." ) for object 2.")
		else
			print("ObjectMeasure: Something went wrong in Coord Selection!") -- This should never proc. If it does, they broke it, not me. I swear.
		end
	else
		print("ObjectMeasure: Please select an object first.") -- gX/Y/Z didn't exist, so we need to tell them to select an object, instead of just saving nil.
	end
	
end

local function measureObjects()
	if x1 and x2 and y1 and y2 and z1 and z2 then -- make sure we have the variables needed for measuring
		nX = x1 - x2
		nY = y1 - y2
		nZ = z1 - z2
		print("Objects are (X: "..nX.. " | Y: "..nY.." | Z: "..nZ.." | Direct: "..math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)..") apart.")
	else 					-- if we don't have the variables, we can tell 'em off.
		print("ObjectMeasure: Please use /m1 & /m2 to select which objects to calculate the distance between.")
	end
end

-------------------------------------------------------------------------------
-- Chat Hooks
-------------------------------------------------------------------------------

local function MeasureFilter(Self,Event,Message) -- Catch Selected / Spawned objects so we can store their positioning and use it if needed.
	local clearmsg = Message:gsub("%|cff%x%x%x%x%x%x", ""):gsub("|r", "")
	
	if string.match(Message, "Selected gameobject") or string.match(Message, "Spawned gameobject") and not string.match(Message, "Spawned creature") then
		gX = string.match(clearmsg, "at X: (%-?%d*%.?%d*)")
		gY = string.match(clearmsg, "Y: (-?%d*\.?%d*)")
		gZ = string.match(clearmsg, "Z: (-?%d*\.?%d*)")
	end
	if string.match(Message, "Map:") then
		gX = string.match(clearmsg, "X: (%-?%d*%.?%d*)")
		gY = string.match(clearmsg, "Y: (-?%d*\.?%d*)")
		gZ = string.match(clearmsg, "Z: (-?%d*\.?%d*)")
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MeasureFilter)

-------------------------------------------------------------------------------
-- Slash Commands
-------------------------------------------------------------------------------

SLASH_OMEASUREVERSION1, SLASH_OMEASUREVERSION2 = '/objectmeasure', '/omeasure'; -- 3.
function SlashCmdList.OMEASUREVERSION(msg, editbox) -- 4.
 print("ConvenientCommands: ObjectMeasure v"..currentVersion);
 print(" - Use /m1 & /m2 to save the selected object as object 1 or 2.")
 print(" - Use /mm to measure the distance between object 1 and 2.")
end

SLASH_OBJMEASUREONE1 = '/m1';
function SlashCmdList.OBJMEASUREONE(msg, editbox)
	getObjectCoords(1)
end

SLASH_OBJMEASURETWO1 = '/m2';
function SlashCmdList.OBJMEASURETWO(msg, editbox)
	getObjectCoords(2)
end

SLASH_OBJMEASUREMEASURE1 = '/mm';
function SlashCmdList.OBJMEASUREMEASURE(msg, editbox)
	measureObjects()
end
--- End for now