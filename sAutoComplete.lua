sAC = LibStub("AceAddon-3.0"):NewAddon("sAC", "AceEvent-3.0");

local _G = getfenv(0);

sConsoleFrame_t = CreateFrame("Frame", "name", UIParent)

function string.startswith(sbig, slittle)
  if type(slittle) == "table" then
    for k,v in ipairs(slittle) do
      if string.sub(sbig, 1, string.len(v)) == v then 
        return true
      end
    end
    return false
  end
  return string.sub(sbig, 1, string.len(slittle)) == slittle
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

local function f1(a)
	print("f1")
end

local function f2(a)
	print("f2")
end

local function cmd_help()
	local t = {}
	for k,v in pairs(sConsoleFrame_t.command) do
		t[k] = {}
	end
	return t
end

--/print sAC:Complete("f", sConsoleFrame_t.command)
function sAC:OnInitialize()
	--load modules
	sConsoleFrame_t.module = {}
	for name, module in self:IterateModules() do
		sConsoleFrame_t.module[name] = module;
		module:Enable();
	end
	
	--create the basic 'help' command
	sConsoleFrame_t.command = {}
	sAC:AddCommand("help", cmd_help(), f1, "the help function")
	
	local protected_key = {"func", "help"} 
	
	for k,v in pairs(sConsoleFrame_t.command.help) do
		if not table.contains(protected_key,k) then
			print(k,v)
		end
	end
	
	--[[
		sConsoleFrame_t.command = {
								["help"] ={
									func = ""
									help = ""
									loaded 
									}
		
		}
	--]]
	--[[
	sConsoleFrame_t.command = {}
	t = {	["a"] = "aa",
			["b"] = {
				["b1"] = "bb1",
				["b2"] = "bb2",
				},
			["c"] = "cc",
			}	
	sConsoleFrame_t.command["loaded"] = t
	sConsoleFrame_t.command["loaded"].func = "func"
	print(table.contains(sConsoleFrame_t.command["loaded"], "func"))
	--table.insert(sConsoleFrame_t.command["loaded"], t)
	--]]
	
	--[[
	sConsoleFrame_t.command = {
						["load"] = {
							func = f1,
							help = "help text for f1",
							["cmd2_0"] = {
								["cmd1_1"] = {},
								["cmd1_1"] = {},
								["cmd1_1"] = {},
								},
							["cmd2_0"] = {
								["cmd2_1"] = {},
								["cmd2_1"] = {},
								},
							["cmd2_0"] = sAC:LoadAddon(),
							},
						["print"] = {
							func = f2,
							help = "help text for f2",
							["all"] = {},
							["one"] = {},
							},
						}

	--]]
	sConsoleFrame_t.help = {}
end

function sAC:P()
	for k,v in pairs(sConsoleFrame_t.command["load"]["cmd2_0"]) do
		print(v)
	end
end

function sAC:LoadAddon()
	local t = {}
	for i=1, GetNumAddOns() do
		name, _, _, _, _, reason = GetAddOnInfo(i)
		--print(name, reason)
		if reason == "DISABLED" then
			table.insert(t, name)
		end
		--print(IsAddOnLoaded(i))
	end
	return t
	--sConsoleFrame_t.command["load"]["cmd2_0"] = t
end

function sAC:OnEnable()

end

function sAC:AddCommand(cmd, cmd_table, func, help)
	if not sConsoleFrame_t.command[cmd] then
		if type(cmd_table) == "table" then
			sConsoleFrame_t.command[cmd] = cmd_table
		else
			sConsoleFrame_t.command[cmd] = {}
		end
		sConsoleFrame_t.command[cmd].func = func
		sConsoleFrame_t.command[cmd].help = help
	else
		print("Error: Command already exists.")
	end
end

function sAC:AddCommandTree()
	if not sConsoleFrame_t.command[cmd] then
		sConsoleFrame_t.command[cmd] = func
		sConsoleFrame_t.help[cmd] = help
	else
		print("Error: Command already exists.")
	end
end

function sAC:Complete(cur_string, cmd_table)
--return a table of possible options
	local t = {}
	local protected_key = {"func", "help"} 
	
	for i,v in ipairs(cmd_table) do
		if string.startswith(v, cur_string) then
			if not table.contains(protected_key, v) then
				table.insert(t, v)
			end
		end
	end
	return t
end

--/script table.foreachi(sAC:Complete("",{"func", "help", "adrian", "nayana", "aanya", "lol", "freddy"}), print)