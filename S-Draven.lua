if myHero.charName ~= "Draven" then
  return
	
end
local __a = 0.2
local a_a = true
local b_a = "S-Draven"
local c_a = "https://raw.githubusercontent.com/Dienofail/BoL/master/common/SourceLib.lua"
local d_a = LIB_PATH .. "SourceLib.lua"
if FileExist(d_a) then
  require("SourceLib")
else
  DOWNLOADING_SOURCELIB = true
  DownloadFile(c_a, d_a, function()
    print("Required libraries downloaded successfully, please reload")
  end)
end
if DOWNLOADING_SOURCELIB then
  print("Downloading required libraries, please wait...")
  return
end
if a_a then
  SourceUpdater(b_a, __a, "raw.github.com", "/sonzenbi/BoL/blob/master/" .. b_a .. ".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/sonzenbi/BoL/blob/master/" .. b_a .. ".version"):CheckUpdate()
end
local _aa = Require("SourceLib")
_aa:Add("vPrediction", "https://raw.githubusercontent.com/Ralphlol/BoLGit/master/VPrediction.lua")
_aa:Add("SxOrbWalk", "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua")
_aa:Check()
if _aa.downloadNeeded == true then
  return
end
function split(dda, __b)
  local a_b = {}
  if not dda or not __b then
    return a_b
  end
  for b_b in dda .. __b:gmatch("(.-)" .. __b) do
    a_b[#a_b + 1] = b_b
  end
  return a_b
end

local aba = 0
local bba = 0
local cba = 0
local dba = false
local _ca = false
local aca = GetDistanceSqr(mousePos, Reticle)
local bca, cca = 550, 1000
local dca
local _da = 0
local ada = false
local bda = false
local cda = {}
function GetCustomTarget()
  ts:update()
  if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then
    return _G.AutoCarry.Crosshair:GetTarget()
  end
  if not _G.Reborn_Loaded then
    return ts.target
  end
  return ts.target
end
function OnLoad()
  print("<font color = \"#FF0000\">S-Draven</font> <font color = \"#fff8e7\">by Sonzenbi v" .. __a .. "</font>")
  DManager = DrawManager()
  IgniteCheck()
  Minions = minionManager(MINION_ENEMY, cca, myHero, MINION_SORT_MAXHEALTH_ASC)
  JMinions = minionManager(MINION_JUNGLE, cca, myHero, MINION_SORT_MAXHEALTH_DEC)
  Config = scriptConfig("S-Draven", "Draven")
  Config:addSubMenu("Key Bindings", "KeyBindings")
  Config.KeyBindings:addParam("ComboActive", "Combo key(Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  Config.KeyBindings:addParam("ClearActive", "Farm key(X)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
  Config:addSubMenu("Combo Settings", "CSet")
  Config.CSet:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
  Config.CSet:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
  Config.CSet:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
  Config.CSet:addParam("manapls", "Min. % mana for W and E ", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
  Config:addSubMenu("Item Settings", "ISet")
  Config.ISet:addSubMenu("BotRK Settings", "Botrk")
  Config.ISet.Botrk:addParam("UseBotrk", "Use Botrk", SCRIPT_PARAM_ONOFF, true)
  Config.ISet.Botrk:addParam("MaxOwnHealth", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
  Config.ISet.Botrk:addParam("MinEnemyHealth", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
  Config.ISet:addSubMenu("Bilgewater Settings", "Bilgewater")
  Config.ISet.Bilgewater:addParam("UseBilgewater", "Use Bilgewater", SCRIPT_PARAM_ONOFF, true)
  Config.ISet.Bilgewater:addParam("MaxOwnHealth", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 80, 1, 100, 0)
  Config.ISet.Bilgewater:addParam("MinEnemyHealth", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
  Config.ISet:addSubMenu("Youmuu Settings", "Youmuu")
  Config.ISet.Youmuu:addParam("UseYoumuu", "Use Youmuu", SCRIPT_PARAM_ONOFF, true)
  Config:addSubMenu("Laneclear Settings", "LSet")
  Config.LSet:addParam("UseQ", "Use Q in 'Laneclear'", SCRIPT_PARAM_ONOFF, true)
  Config.LSet:addParam("UseW", "Use W in 'Laneclear'", SCRIPT_PARAM_ONOFF, true)
  Config:addSubMenu("Jungleclear Settings", "JSet")
  Config.JSet:addParam("UseQ", "Use Q in 'Jungleclear'", SCRIPT_PARAM_ONOFF, true)
  Config.JSet:addParam("UseW", "Use W in 'Jungleclear'", SCRIPT_PARAM_ONOFF, true)
  Config:addSubMenu("Draw Settings", "DSet")
  DManager:CreateCircle(myHero, cca, 1, {
    255,
    255,
    255,
    255
  }):AddToMenu(Config.DSet, SpellToString(_E) .. " Range", true, true, true)
  Config:addSubMenu("Misc", "Misc")
  Config.Misc:addSubMenu("KillSteal Settings - SOON", "KS")
  Config.Misc.KS:addParam("Ult", "Use Ult KS", SCRIPT_PARAM_ONOFF, true)
  Config.Misc.KS:addParam("UltRange", "Ult KS range", SCRIPT_PARAM_SLICE, 1500, 500, 10000, 0)
  Config.Misc.KS:addParam("Ignite", "Use Ignite KS", SCRIPT_PARAM_ONOFF, true)
  Config.Misc:addSubMenu("Auto-Interrupt", "Interrupt")
  Interrupter(Config.Misc.Interrupt, OnInterruptSpell)
  Config.Misc:addSubMenu("Anti-Gapclosers", "AG")
  AntiGapcloser(Config.Misc.AG, OnGapclose)
  Config.Misc:addParam("Qcatch", "Catch Axes(Z)", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("Z"))
  Config:addSubMenu("Target Selector", "TSet")
  VP = VPrediction()
  ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1150)
  ts.name = "Focus"
  Config.TSet:addTS(ts)
  if _G.Reborn_Loaded then
    DelayAction(function()
      PrintChat("<font color = \"#FFFFFF\">[Fantastik Draven] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
      Config:addParam("SACON", "[MOA] SAC:R support is active.", 5, "")
      ada = true
    end, 10)
  elseif not _G.Reborn_Loaded then
    PrintChat("<font color = \"#FFFFFF\">[Draven] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
    Config:addSubMenu("Orbwalker", "SxOrb")
    SxOrb:LoadToMenu(Config.SxOrb)
    bda = true
  end
  Config.KeyBindings:permaShow("ComboActive")
  Config.KeyBindings:permaShow("ClearActive")
  Config.Misc:permaShow("Qcatch")
end
function OnTick()
  target = GetCustomTarget()
  if bda then
    SxOrb:ForceTarget(target)
  end
  if Config.Misc.Qcatch then
    if dba == true and cba == 1 and aba == 1 or aba == 2 then
      if bda then
        SxOrb:EnableMove()
      elseif ada then
        _G.AutoCarry.MyHero:MovementEnabled(true)
      end
    end
    if dba == true and bba < 0.25 then
      if bda then
        SxOrb:EnableMove()
      elseif ada then
        _G.AutoCarry.MyHero:MovementEnabled(true)
      end
    end
    if cba > 0 and aba == 0 or cba > 0 and aba == 1 then
      if bda then
        SxOrb:DisableMove()
      elseif ada then
      end
    end
    if cba > 0 and GetDistance(myHero, Reticle) > 100 then
      if bda then
        SxOrb:DisableAttacks()
      end
    elseif bda then
      SxOrb:EnableAttacks()
    end
    if cba == 0 and aba == 0 then
      if bda then
        SxOrb:EnableMove()
      elseif ada then
        _G.AutoCarry.MyHero:MovementEnabled(true)
      end
    end
  end
  if aba == 1 or aba == 2 then
    bba = os.clock()
  elseif aba == 0 then
    bba = 0
  end
  QREADY = myHero:CanUseSpell(_Q) == READY
  WREADY = myHero:CanUseSpell(_W) == READY
  EREADY = myHero:CanUseSpell(_E) == READY
  RREADY = myHero:CanUseSpell(_R) == READY
  IREADY = dca ~= nil and myHero:CanUseSpell(dca) == READY
  if ValidTarget(target) then
    if Config.Misc.KS.Ult then
      KS(target)
    end
    if Config.Misc.KS.Ignite then
      AutoIgnite(target)
    end
  end
  if Config.KeyBindings.ComboActive then
    Combo()
    if not _G.AutoCarry then
      UseItems(Target)
    end
  end
  if Config.KeyBindings.HarassActive then
    Harass()
  end
  if Config.KeyBindings.ClearActive then
    Laneclear()
    Jungleclear()
  end
  CheckItems()
end
function CheckItems()
  if (ItemCheck or 0) + 100 < GetTickCount() then
    ItemCheck = GetTickCount()
    ItemBotRK = GetInventorySlotItem(3153)
    ItemBilgeWater = GetInventorySlotItem(3144)
    ItemYoumuus = GetInventorySlotItem(3142)
  end
end
function Combo()
  if ValidTarget(target) then
    if Config.CSet.UseQ and GetDistance(target) <= bca and QREADY and aba < 2 or aba ~= 1 and cba < 2 then
      CastSpell(_Q)
    end
    if ManaManager() then
      if Config.CSet.UseE and GetDistance(target) <= cca and EREADY then
        CastSpell(_E, target.x, target.z)
      end
      if Config.CSet.UseW and GetDistance(target) <= 700 and WREADY and aba > 0 then
        CastSpell(_W)
      end
    end
  end
end
function Laneclear()
  Minions:update()
  for dda, __b in pairs(Minions.objects) do
    if Config.LSet.UseQ and GetDistance(__b) <= bca and QREADY and aba < 2 and #Minions.objects > 2 then
      CastSpell(_Q)
    end
    if Config.LSet.UseW and GetDistance(__b) <= bca and WREADY and aba > 0 then
      CastSpell(_W)
    end
  end
end
function Jungleclear()
  JMinions:update()
  for dda, __b in pairs(JMinions.objects) do
    if Config.JSet.UseQ and GetDistance(__b) <= bca and QREADY and aba < 2 and #JMinions.objects > 1 then
      CastSpell(_Q)
    end
    if Config.JSet.UseW and GetDistance(__b) <= bca and WREADY and aba > 0 then
      CastSpell(_W)
    end
  end
end
function UseItems(dda)
  if ItemBotRK and Config.ISet.Botrk.UseBotrk and math.floor(myHero.health / myHero.maxHealth * 100) <= Config.ISet.Botrk.MaxOwnHealth and dda and ValidTarget(dda, 500) and math.floor(dda.health / dda.maxHealth * 100) >= Config.ISet.Botrk.MinEnemyHealth and myHero:CanUseSpell(ItemBotRK) == 0 then
    CastSpell(ItemBotRK, dda)
  end
  if ItemBilgeWater and Config.ISet.Bilgewater.UseBilgewater and math.floor(myHero.health / myHero.maxHealth * 100) <= Config.ISet.Bilgewater.MaxOwnHealth and dda and ValidTarget(dda, 500) and math.floor(dda.health / dda.maxHealth * 100) >= Config.ISet.Bilgewater.MinEnemyHealth and myHero:CanUseSpell(ItemBilgeWater) == 0 then
    CastSpell(ItemBilgeWater, dda)
  end
  if ItemYoumuus and Config.ISet.Youmuu.UseYoumuu and dda and ValidTarget(dda, 500) and myHero:CanUseSpell(ItemYoumuus) == 0 then
    CastSpell(ItemYoumuus)
  end
end
function OnCreateObj(dda)
  if dda.name == "Draven_Base_Q_buf.troy" and GetDistance(dda) < 50 then
    aba = aba + 1
  end
  if dda.name == "Draven_Base_Q_reticle.troy" and GetDistance(dda) < 600 and Config.Misc.Qcatch then
    if bda then
      SxOrb:DisableMove()
    end
    Reticle = dda
    if bda then
      for i = 1, 10 do
        myHero:MoveTo(Reticle.x, Reticle.z)
      end
    elseif ada then
      _G.AutoCarry.Orbwalker:OverrideOrbwalkLocation(Reticle)
    end
    if ada then
    end
    cba = cba + 1
  end
  if dda.name == "Draven_Base_Q_ReticleCatchSuccess.troy" then
    dba = true
    if bda and not Reticle then
      SxOrb:EnableMove()
    elseif ada and not Reticle then
      _G.AutoCarry.Orbwalker:OverrideOrbwalkLocation(nil)
    end
  end
end
function OnProcessSpell(dda, __b)
  if dda == myHero and __b.name:lower():find("attack") and bba > 0.25 and Config.Misc.Qcatch then
    DelayAction(function()
      if bda then
        _ENV.SxOrb:DisableMove()
      end
    end, __b.windUpTime + GetLatency() / 2000)
  end
end
function OnDeleteObj(dda)
  if dda.name == "Draven_Base_Q_buf.troy" then
    if aba == 1 then
      aba = 0
    elseif aba == 2 then
      aba = 1
    elseif aba > 2 then
      aba = aba - 2
    end
  end
  if dda.name == "Draven_Base_Q_reticle.troy" and _ENV.Config.Misc.Qcatch then
    if cba == 1 then
      cba = 0
    elseif cba == 2 then
      cba = 1
    elseif cba > 2 then
      cba = cba - 2
    end
    if cba == 0 then
      if bda then
        _ENV.SxOrb:EnableMove()
      elseif ada then
        _ENV._G.AutoCarry.MyHero:MovementEnabled(true)
        _ENV._G.AutoCarry.Orbwalker:OverrideOrbwalkLocation(nil)
      end
    end
    dba = false
  end
  if dda.name == "Draven_Base_Q_ReticleCatchSuccess.troy" then
    dba = false
    if bda then
      _ENV.SxOrb:EnableMove()
    elseif ada then
      _ENV._G.AutoCarry.MyHero:MovementEnabled(true)
    end
  end
end
function OnDraw()
  DrawText("Q Axes: " .. aba, 18, 100, 100, 4294967040)
  DrawText("Q Reticles: " .. cba, 18, 100, 120, 4294967040)
  if dba == true then
    DrawText("Catch Success: true", 18, 100, 140, 4294967040)
  else
    DrawText("Catch Success: false", 18, 100, 140, 4294967040)
  end
  if Reticle then
    DrawCircle(Reticle.x, Reticle.y, Reticle.z, 100, 4278222848)
  end
end
function OnInterruptSpell(dda, __b)
  if GetDistanceSqr(dda.visionPos, myHero.visionPos) < cca and EREADY then
    CastSpell(_E, dda.visionPos.x, dda.visionPos.z)
  end
end
function OnGapclose(dda, __b)
  if GetDistanceSqr(dda.visionPos, myHero.visionPos) < cca and EREADY then
    CastSpell(_E, dda.visionPos.x, dda.visionPos.z)
  end
end
function ManaManager()
  if myHero.mana >= myHero.maxMana * (Config.CSet.manapls / 100) then
    return true
  else
    return false
  end
end
function IgniteCheck()
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
    dca = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    dca = SUMMONER_2
  end
end
function AutoIgnite(dda)
  _da = _ENV.IREADY and _ENV.getDmg("IGNITE", dda, _ENV.myHero) or 0
  if dda.health <= _da and _ENV.GetDistance(dda) <= 600 and dca ~= nil and _ENV.IREADY then
    _ENV.CastSpell(dca, dda)
  end
end
function KS(dda)
  if RREADY and getDmg("R", dda, myHero) > dda.health and GetDistance(dda) <= Config.Misc.KS.UltRange and GetDistance(dda) > bca then
    CastSpell(_R, dda.x, dda.z)
  end
end
function DrawCircleNextLvl(dda, __b, a_b, b_b, c_b, d_b, _ab)
  b_b = b_b or 300
  quality = math.max(8, round(180 / math.deg((math.asin(_ab / (2 * b_b))))))
  quality = 2 * math.pi / quality
  b_b = b_b * 0.92
  local aab = {}
  for theta = 0, 2 * math.pi + quality, quality do
    local bab = WorldToScreen(D3DXVECTOR3(dda + b_b * math.cos(theta), __b, a_b - b_b * math.sin(theta)))
    aab[#aab + 1] = D3DXVECTOR2(bab.x, bab.y)
  end
  DrawLines2(aab, c_b or 1, d_b or 4294967295)
end
function round(dda)
  if dda >= 0 then
    return math.floor(dda + 0.5)
  else
    return math.ceil(dda - 0.5)
  end
end
function DrawCircle2(dda, __b, a_b, b_b, c_b)
  local d_b = Vector(dda, __b, a_b)
  local _ab = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local aab = d_b - d_b - _ab:normalized() * b_b
  local bab = WorldToScreen(D3DXVECTOR3(aab.x, aab.y, aab.z))
  if OnScreen({
    x = bab.x,
    y = bab.y
  }, {
    x = bab.x,
    y = bab.y
  }) then
    DrawCircleNextLvl(dda, __b, a_b, b_b, 1, c_b, 80)
  end
end
function tablelength(dda)
  local __b = 0
  for a_b in pairs(dda) do
    __b = __b + 1
  end
  return __b
end
