require 'lib.moonloader'

script_name("locator")
script_author("qrlk")
script_version("25.06.2022")
script_description("������� ����� ��� ���������")
script_url("https://github.com/qrlk/locator")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = false -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("���� ������ ������������� ������ ������� '"..target_name.." (ID: "..target_id..")".."' � ���������� �� � ������� ����������� ������ Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("������ "..target_name.." (ID: "..target_id..")".."�������� ���� ������, ����������� ����� 60 ������")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://ecf8fa566e65485bb3770450f3bbe3b8@o1272228.ingest.sentry.io/6529880" })
  end
end



local inicfg = require "inicfg"
local dlstatus = require("moonloader").download_status

local script_vers = 1
local script_vers_text = "1.0.0"

local update_url = ""
local update_path = getWorkingDirectory()

local script_url = ""
local script_path = thisScript().path


select_car_dialog = {}
vhinfo = {}
request_model = -1
request_model_last = -1
marker_placed = false
response_timestamp = 0
ser_active = "?"
ser_active_p = "?"
ser_count = "?"
delay_start = os.time()
color = 0x7ef3fa

settings =
inicfg.load(
  {
    locator = {
      startmessage = true,
      autoupdate = true
    },
    map = {
      sqr = false
    },
    transponder = {
      allow_occupied = true,
      allow_unlocked = false,
      catch_srp_start = true,
      catch_srp_stop = true,
      catch_srp_gz = true,
      delay = 5999
    },
    handler = {
      mark_coolest = true,
      mark_coolest_sound = true,
      clear_mark = true
    }
  },
  "locator"
)
no_sampev = false
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  
	sampRegisterChatCommand("update", cmd_update)
  
	_, id = sampGetPlayerIdByHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)
	
	downloadUrlToFIle(update_url, update_path, function(id, status)
	if status == distatus.STATUS_ENDDOWNLOADDATA then
	updateIni = inicfg.load(nil, update_path)
	if tonumber(updateIni.info.vers) > script_vers then
	sampAddChatMessage("�������� ����������! ������: " ..updateIni.info.vers_text, -1)
	update_state = true
		end
	os.remove(update_path)
	end
end)
end

while true do
	wait(0)
	
	if update_state then
		downloadUrlToFile(script_url, script_path, function(id, status)
			if status == distatus.STATUS_ENDDOWNLOADDATA then
				sampAddChatMessage("������ ������� ��������!", -1)
				thisScript():reload()
			end
		end)
		break
	end
  
  transponder_thread = lua_thread.create(transponder)

  init()
  register_chat_commands()

  if settings.locator.startmessage then
    sampAddChatMessage(
      "{8a2be2}/Car Thief by OZ v" ..
      thisScript().version ..
      " {ff0000}��������! {ff0000}������� ���� {00ffff}/carthief",
      0x7ef3fa
    )
    if no_sampev then
      sampAddChatMessage(
        "������ SAMP.Lua �� ��� ��������. ������ ���� ��������. {348cb2}���������: https://www.blast.hk/threads/14624/",
        0xff0000
      )
    end
  end

  while true do
    wait(0)
    fastmap()
  end
end

function register_chat_commands()
  sampRegisterChatCommand(
    "carthief",
    function()
      lua_thread.create(
        function()
          updateMenu()
          wait(100)
          submenus_show(
            mod_submenus_sa,
            "{8a2be2}/Car Thief by OZ v." .. thisScript().version,
            "�������",
            "�������",
            "�����"
          )
        end
      )
    end
  )

  sampRegisterChatCommand(
    "ugon",
    function()
      lua_thread.create(legacy_edith_front)
    end
  )

  sampRegisterChatCommand(
    "donateto",
    function()
      os.execute('explorer "http://qrlk.me/donatelocator"')
    end
  )

  sampRegisterChatCommand(
    "locate",
    function(vh)
      if vh == "" then
        request_model = -1
        addOneOffSound(0.0, 0.0, 0.0, 1053)
      else
        if cars[string.lower(vh)] ~= nil then
          request_model = cars[string.lower(vh)]
          addOneOffSound(0.0, 0.0, 0.0, 1139)
        else
          addOneOffSound(0.0, 0.0, 0.0, 1057)
        end
      end
    end
  )

  sampRegisterChatCommand(
    "ugoncars",
    function()
      lua_thread.create(
        function()
          submenus_show(
            select_car_dialog,
            "{348cb2}locator v." .. thisScript().version,
            "�������",
            "�������",
            "�����"
          )
        end
      )
    end
  )
end

   
--------------------------------------------------------------------------------
-----------------------------------LOCATOR--------------------------------------
--------------------------------------------------------------------------------
cars = {
  ["-"] = -1,
  ["Mercedes-Benz SL65 AMG"] = 18159,
  ["Mercedes-Benz GLS 2020 Brabus"] = 16898,
  ["Mercedes-AMG G63: Mansory"] = 16897,
  ["Mercedes-Benz S500 223b"] = 16893,
  ["Mercedes-Benz GLE63 2016"] = 6616,
  ["Mercedes S63 Coupe AMG"] = 909,
  ["Mercedes-Benz X Class"] = 4793,
  ["Mercedes CLA 45 AMG"] = 6608,
  ["Mercedes CLS 63 AMG"] = 6609,
  ["Mercedes Maybach S 650"] = 3245,
  ["Mercedes-Benz GLE 63"] = 12713,
  ["Mercedes-Benz Actros"] = 12725,
  ["Mercedes-AMG A-45"] = 15113,
  ["Mercedes-Benz S600"] = 3209,
  ["Mercedes-Benz GLE"] = 14912,
  ["Mercedes GT63s AMG"] = 612,
  ["Mercedes-AMG G63 6x6"] = 6615,
  ["Mercedes-Benz CLS 53"] = 12715,
  ["Mercedes-Benz Arocs 4163"] = 15332,
  ["Mercedes-Benz EQC 400"] = 15496,
  ["Mercedes-Benz EQC 400"] = 15858,
  ["Mercedes E63s AMG"] = 794,
  ["Mercedes-Benz C63S"] = 15631,
  ["Mercedes-AMG G65"] = 3205,
  ["Mercedes G63 AMG"] = 613,
  ["Mercedes-Benz VISION AVTR"] = 14913,
  ["Mercedes-AMG Project One R50"] = 14767,
  ["Brabus Adventure"] = 16892,
  ["Brabus 700"] = 16896,
  ["Mercedes GT63 Brabus"] = 15960,
  ["Mercedes-Benz GLE Brabus"] = 15961,
  ["BMW i7"] = 18152,
  ["BMW X7"] = 15746,
  ["BMW M3 GTR"] = 4542,
  ["BMW Z4 40i"] = 3155,
  ["BMW M8"] = 793,
  ["BMW 760li"] = 4774,
  ["BMW M5 F90"] = 3240,
  ["BMW X5 E53"] = 3157,
  ["BMW M6 2020"] = 6606,
  ["BMW IX"] = 15495,
  ["BMW M4 G82"] = 4778,
  ["BMW M5 CS"] = 14909,
  ["BMW 4 Series"] = 12727,
  ["BMW M5 E60"] = 3239,
  ["BMW E34"] = 15904,
  ["BMW X5m"] = 662,
  ["BMW i8"] = 4779,
  ["BMW M3 G20"] = 4782,
  ["BMW E30"] = 15860,
  ["Mercedes-Benz BMW X5 F85"] = 15906,
  ["BMW X6"] = 15747,
  ["BMW 7"] = 15627,
  ["Lamborghini Urus Mansory"] = 16900,
  ["Lamborghini Urus"] = 1194,
  ["Lamborghini Aventador SVJ"] = 3206,
  ["Lamborghini Countach"] = 15099,
  ["Lamborghini Murcielago"] = 15723,
  ["Lamborghini Gallardo"] = 15907,
  ["Nissan Titan"] = 18160,
  ["Nissan LEAF"] = 3211,
  ["Nissan 350Z"] = 4548,
  ["Nissan GTR 2017"] = 14124,
  ["Nissan Skyline R34"] = 3158,
  ["Nissan Silvia S15"] = 3212,
  ["Nissan Qashqai"] = 15105,
  ["Ferrari F40"] = 16955,
  ["Ferrari J50"] = 4785,
  ["Ferrari Monza SP2"] = 14904,
  ["Ferrari Enzo"] = 4790,
  ["Ferrari LaFerrari"] = 14908,
  ["Ferrari 812 Superfast"] = 4803,
  ["Audi Q7"] = 6605,
  ["Audi A6"] = 6604,
  ["Audi e-tron"] = 15497,
  ["Audi R8s"] = 15118,
  ["Audi RS5"] = 12716,
  ["Audi RS7"] = 15631,
  ["Audi TT RS"] = 12724,
  ["Audi R8"] = 3236,
  ["Audi RS6"] = 614,
  ["Audi Q8"] = 1195,
  ["Audi RS6 Quattro"] = 15910,
  ["Rolls-Royce Cullinan Mansory"] = 16899,
  ["Rolls-Royce Cullinan"] = 3199,
  ["Rolls-Royce Phantom"] = 12738,
  ["Bentley Bentayga Mansory"] = 16895,
  ["Bentley Balacar"] = 4776,
  ["Bentley Bentayga"] = 4777,
  ["Bentley"] = 699,
  ["Mazda RX7 Veilside FD"] = 4544,
  ["Mazda 6"] = 15117,
  ["Mazda RX8"] = 4545,
  ["Toyota Tundra"] = 16959,
  ["Toyota Camry XV70"] = 3238,
  ["Toyota Supra A90"] = 6623,
  ["Toyota Land Cruiser VXR V8 4"] = 6611,
  ["Toyota GR"] = 15109,
  ["Toyota Camry XV40"] = 3237,
  ["Toyota Land Cruiser Prado"] = 6621,
  ["Toyota RAV4"] = 6622,
  ["Dodge Charger SLT"] = 16954,
  ["Dodge Challenger SRT"] = 1196,
  ["Dodge Charger (��������)"] = 15085,
  ["Dodge Viper"] = 12721,
  ["Dodge Ram"] = 3266,
  ["Dodge RAM 3500"] = 15963,
  ["Porche Carrera"] = 16952,
  ["Monster A"] = 556,
  ["Monster B"] = 557,
  ["Monster Mutt"] = 6617,
  ["Monster Indonesia"] = 6618,
  ["Monster El Toro"] = 6619,
  ["Monster Grave Digger"] = 6620,
  ["Zombiemobile"] = 16794,
  ["Batmobile"] = 16793,
  ["Lexus LX600"] = 15104,
  ["Lexus RX 450h"] = 3233,
  ["Lexus LX570"] = 667,
  ["Lexus Sport-S"] = 1201,
  ["Kia Optima"] = 1205,
  ["KIA K7"] = 15102,
  ["Kia Sportage"] = 3235,
  ["Volvo V60"] = 1198,
  ["Volvo XC90"] = 1203,
  ["Volvo Truck"] = 12740,
  ["Volvo 460"] = 15335,
  ["Volvo XC90 2012"] = 6625,
  ["Chevrolet Corvette"] = 16951,
  ["Chevrolet Tahoe"] = 16957,
  ["Chevrolet Camaro"] = 606,
  ["Chevrolet Cruze"] = 593,
  ["Chevrolet Aveo"] = 14769,
  ["Volkswagen Scirocco"] = 15107,
  ["Volkswagen Touareg"] = 1194,
  ["Volkswagen Golf R"] = 3235,
  ["Volkswagen Polo"] = 12722,
  ["Volkswagen Tourage"] = 15752,
  ["Volkswagen Passat"] = 3251,
  ["BUGATTI Bolide"] = 14857,
  ["Bugatti Chiron"] = 3202,
  ["Bugatti Divo Sport"] = 3201,
  ["Koenigsegg Gemera"] = 15101,
  ["LADA Priora"] = 14910,
  ["Lada Vesta SW Cross"] = 4788,
  ["Ford GT"] = 12720,
  ["Ford Mustang Mach 1"] = 12737,
  ["Ford Mustang Mach"] = 15116,
  ["Ford Mustang GT"] = 1202,
  ["Land Rover Defender"] = 15115,
  ["Mitsubishi Eclipse"] = 4546,
  ["Mitsubishi Lancer"] = 12731,
  ["Mitsubishi Lancer Old"] = 12723,
  ["leviathan"] = 417,
  ["barracks"] = 433,
  ["tram"] = 449,
  ["rc raider"] = 465,
  ["bmx"] = 481,
  ["police maverick"] = 497,
  ["tanker"] = 514,
  ["intruder"] = 546,
  ["dft-30"] = 578,
  ["farm trailer"] = 610,
  ["broadway"] = 575,
  ["dune"] = 573,
  ["kart"] = 571,
  ["freight flat trailer (train)"] = 569,
  ["roadtrain"] = 515,
  ["buffalo"] = 402,
  ["moonbeam"] = 418,
  ["hotknife"] = 434,
  ["article trailer 2"] = 450,
  ["glendale"] = 466,
  ["burrito"] = 482,
  ["boxville"] = 498,
  ["nebula"] = 516,
  ["cargobob"] = 548,
  ["stafford"] = 580,
  ["flash"] = 565,
  ["raindance"] = 563,
  ["stratum"] = 561,
  ["jester"] = 559,
  ["monster b"] = 557,
  ["majestic"] = 517,
  ["linerunner"] = 403,
  ["esperanto"] = 419,
  ["article trailer"] = 435,
  ["turismo"] = 451,
  ["oceanic"] = 467,
  ["camper"] = 483,
  ["benson"] = 499,
  ["buccaneer"] = 518,
  ["sunrise"] = 550,
  ["newsvan"] = 582,
  ["nevada"] = 553,
  ["merit"] = 551,
  ["tampa"] = 549,
  ["primo"] = 547,
  ["hustler"] = 545,
  ["shamal"] = 519,
  ["perenniel"] = 404,
  ["taxi"] = 420,
  ["previon"] = 436,
  ["speeder"] = 452,
  ["sanchez"] = 468,
  ["marquis"] = 484,
  ["sadler"] = 543
}
keys = {}
for k, v in pairs(cars) do
  table.insert(keys, k)
end
table.sort(keys)
for k, v in pairs(keys) do
  table.insert(
    select_car_dialog,
    {
      title = v,
      onclick = function()
        request_model = cars[v]
        if request_model == -1 then
          addOneOffSound(0.0, 0.0, 0.0, 1053)
        else
          addOneOffSound(0.0, 0.0, 0.0, 1139)
        end
      end
    }
  )
end

function transponder()
  while true do
    wait(0)
    delay_start = os.time()
    wait(settings.transponder.delay)
    if getActiveInterior() == 0 then
      request_table = {}
      local ip, port = sampGetCurrentServerAddress()
      local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
      request_table["info"] = {
        server = ip .. ":" .. tostring(port),
        sender = sampGetPlayerNickname(myid),
        request = request_model,
        allow_occupied = settings.transponder.allow_occupied,
        allow_unlocked = settings.transponder.allow_unlocked
      }
      request_table["vehicles"] = {}
      if doesCharExist(playerPed) then
        -- ���������� �� ������, ������� ����������, ����� �� �������� ���� ������
        local ped_car = getCarCharIsUsing(playerPed)
        for k, v in pairs(getAllVehicles()) do
          if v ~= ped_car then
            if doesVehicleExist(v) then
              _res, _id = sampGetVehicleIdByCarHandle(v)
              if _res then
                _x, _y, _z = getCarCoordinates(v)
                table.insert(
                  request_table["vehicles"],
                  {
                    id = _id,
                    pos = {
                      x = math.floor(_x),
                      y = math.floor(_y),
                      z = math.floor(_z)
                    },
                    heading = math.floor(getCarHeading(v)),
                    health = getCarHealth(v),
                    model = getCarModel(v),
                    occupied = doesCharExist(getDriverOfCar(v)),
                    locked = getCarDoorLockStatus(v)
                  }
                )
              end
            end
          end
        end
      end
      collecting_data = false
      wait_for_response = true
      local response_path = os.tmpname()
      down = false
      downloadUrlToFile(
        "http://locator.qrlk.me:46547/" .. encodeJson(request_table),
        response_path,
        function(id, status, p1, p2)
          if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            down = true
          end
          if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            wait_for_response = false
          end
        end
      )
      while wait_for_response do
        wait(10)
      end
      processing_response = true

      if down and doesFileExist(response_path) then
        local f = io.open(response_path, "r")
        if f then
          local info = decodeJson(f:read("*a"))
          if info == nil then
            sampAddChatMessage(
              "{ff0000}[" ..
              string.upper(thisScript().name) ..
              "]: ��� ������� ������������ ����� �� �������. ������ ������� ���������.",
              0x348cb2
            )
            thisScript():unload()
          else
            if info.result == "ok" then
              response_timestamp = info.timestamp
              ser_active = info.active
              ser_active_p = info.active_p
              ser_count = info.count
              if info.response ~= nil then
                if info.response == "no cars" then
                  vhinfo = {}
                  if settings.handler.clear_mark and marker_placed then
                    removeWaypoint()
                  end
                else
                  vhinfo = info.response
                  if settings.handler.mark_coolest then
                    mark_coolest_car()
                  end
                end
              else
                if settings.handler.clear_mark and marker_placed then
                  removeWaypoint()
                end
              end
            end
            wait_for_response = false
          end
          f:close()
          --setClipboardText(response_path)
          os.remove(response_path)
        end
      else
        print(
          "{ff0000}[" ..
          string.upper(thisScript().name) ..
          "]: �� �� ������ �������� ����� �� �������. �������: ������� ����� ����� � ����������/������ �������.",
          0x348cb2
        )
      end
      if doesFileExist(response_path) then
        os.remove(response_path)
      end
      processing_response = false
    end
  end
end

function count_next()
  if getActiveInterior() == 0 then
    local count = math.floor(settings.transponder.delay / 1000) - tonumber(os.time() - delay_start)
    if count >= 0 then
      return tostring(count) .. "c"
    elseif wait_for_response then
      return "WAITING FOR RESPONSE"
    elseif processing_response then
      return "PROCESSING RESPONSE"
    else
      return "PERFOMING REQUEST"
    end
  else
    return "����� �� ���"
  end
end

gz_squareStart = {}
gz_squareEnd = {}
gz_id = -1

if
pcall(
  function()
    sampev = require "lib.samp.events"
    color_sampev = ""
  end
)
then
  function sampev.onCreateGangZone(zoneId, squareStart, squareEnd, color)
    if color == -1442840576 then
      gz_id = zoneId
      gz_squareStart = squareStart
      gz_squareEnd = squareEnd
    end
  end

  function sampev.onGangZoneDestroy(zoneId)
    if gz_id == zoneId then
      gz_squareStart = {}
      gz_squareEnd = {}
      gz_id = -1
    end
  end

  function sampev.onServerMessage(color, text)
    local car_to_steal = string.match(text, " ������� ��� ����� ����� (.+), � �� ���� ������ ��������.")

    if settings.transponder.catch_srp_start and car_to_steal then
      if cars[string.lower(car_to_steal)] ~= nil then
        request_model = cars[string.lower(car_to_steal)]
        addOneOffSound(0.0, 0.0, 0.0, 1139)
      else
        request_model = -1
        addOneOffSound(0.0, 0.0, 0.0, 1057)
      end
    end

    if settings.transponder.catch_srp_stop then
      if
      text == " SMS: �� ���� �������!" or
      text == " SMS: ������� �����. ��� ����� ������� ������������, � �� ��������" or
      text == " �������� �����. ����� ����� ������, �������."
      then
        request_model = -1
        addOneOffSound(0.0, 0.0, 0.0, 1057)
      end
    end

    if text == " SMS: ��� �� ��� ��� �����, ���� � �� �����." then
      request_model_last = request_model
      request_model = -1
      if settings.handler.clear_mark and marker_placed then
        removeWaypoint()
      end
    end

    if text == " SMS: ��� �� ��������� �������� ��� ������?! ��� �����!" then
      if request_model == -1 then
        request_model = request_model_last
      end
    end
  end
else
  color_sampev = "{FF0000}"
  no_sampev = true
end

--------------------------------------------------------------------------------
-------------------------------------MENU---------------------------------------
--------------------------------------------------------------------------------
function updateMenu()
  mod_submenus_sa = {
    {
      title = "{ff0000}Script Information",
      onclick = function()
        sampShowDialog(
          0,
          "{8a2be2}/Car Thief by OZ v." .. thisScript().version .. " - ����������",
          "{8a2be2}Car Thief by OZ\n{ffffff}������ ������ ��� ��������� �� ��������� Blasthack\n\n���� �������: ��������� ���������� ��������� � ��������� ����� �����.\n\n������ ������ ����� ��������� ����� ������� �� ������ ������� ��� ������, ������ �������� ������� ������ ����� ����� ������ �� ���� ����.\n������ �����, �� ������ ����������� ���������� ������ ��� ������ � ����� ������.\n������ �� ������� ���������, �������� ���� �� ������� ������� ������.\n\n��������� ����� ������� � ���������� ���� � ��������� ����� �� ����� ���������� �������.\n\n��� �� �������� ������� �� fastmap: L-ALT + �(M), � ��� �� �� zoommap L-ALT + �(,).\n�� ������ ����� ���� ���������, � �� ������ ��������� ����� ������������ �� �����.\n�� ������ ����� �������� ����� �� ��������, ����� K (����� ������� zoommap).\n������� ���� - �������� ������, ����� - ��������, ������� - �������.\n\n����������� ��������� � ���������, ��� ����� ���� ���������.\n\n{00bfff}��������� �������:\n{ff0000}/carthief{ffffff} - ���� �������.\n{ff0000}/locate [��������] {ffffff}- ����� ����. ��� [��������] = �����.\n{ff0000}/ugoncars {ffffff}- ������ ������ ������.\n{ff0000}/ugon {ffffff}- ����� � ������, ������ ����� �� ����� ���������� �������.",
          "����"
        )
      end
    },
    {
      title = " "
    },
    {
      title = "{AAAAAA}�������"
    },
    {
      title = "{ff00ff}������� ������ ��� ������",
      onclick = function()
        submenus_show(
          select_car_dialog,
          "{8a2be2}/Car Thief by OZ v." .. thisScript().version,
          "�������",
          "�������",
          "�����"
        )
      end
    },
    {
      title = "{ff1493}����� � ������",
      onclick = function()
        lua_thread.create(legacy_edith_front)
      end
    },
    {
        title = '{9400d3}��� ���� �� ����',
		onclick = function()
			sampShowDialog(2, "{9400d3}��� ���� �� ����", "{7fff00}Brabus 850 ���� 40�� \nMitsubishi Eclipse ���� 590� \nBugatti Bolide ���� 560� \nMercedes Benz C63 ���� 590� \nBMW X5M ���� 20�� \nLexus LX600 ���� 40�� \nBugatti Divo Sport ���� 20�� \nMitsubishi Lancer ���� 16�� \nMercedes Benz GLE 63 ���� 24�� \nSubaru BRZ ���� 560� \nBrabus 700 ���� 5.6�� \nBlade ���� 960� \nLand Rover Defender ���� 4.8�� \nAudi RS7 ���� 560� \nBMW X6 ���� 5.6�� \nLexus RX 450H ���� 12.7�� \nMercedes AMG G65 AMG ���� 20�� \nMercedes Benz Actros ���� 40�� \nMountain ���� 590� \nMazda RX8 ���� 560� \nToyota Supra A90 ���� 12�� \nAudi S4 ���� 24�� \nKoenigsegg Gemera ���� 47.5�� \nBMW F10 ���� 560� \nBentley Bentayga 5.6�� \nInfernus Pegassi 13.6�� \nCyber Truck 40�� \nDucati Diavel 20�� \nBMW M5 E60 12�� \nLada Priora 560� \nMazda RX8 560� \nBMW i7 5.5�� \nToyota Land Cruiser VXR V8 4 24�� \nLexus Sport-S 16�� \nToyota GR 37.5�� \nPorsche Panamera Turbo 9�� \nAudi R8 20�� \nNissan 350Z 560� \nTesla Model 3 8�� \nMercedes Benz C63 560� \nMercedes AMG G63 Mansory 5.6�� \nChevrolet Tahoe 5.6�� \nBMW F10 560�� \nMercedes Benz E63 w221 1.4� \nBugatti Chiron 20�� \nSecuricar 16�� \nVolvo Truck 40�� \nCheetah 4.8�� \nBugatti Divo Sport 20�� \nPorsche 911 40�� \nOpel Vivaro 560� \nBMW M8 GRAN COUPE 560�", "�������", "�������")
		end
	},
	{
		title = '{0000ff}�������������� ����� �/c',
		onclick = function()
			sampShowDialog(0, "�������������� ����� �/�", "��� ������� ������� ������� �� ������ '���������'", "���������", "���������")
			local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED) -- ������� ���� ��
			if isButtonPressed(PLAYER_PED, ���������) then
				while true do
		wait(100)
		for i = 1, 4096 do
			if sampTextdrawIsExists(i) then
				local model, rotX, rotY, rotZ, zoom, clr1, clr2 = sampTextdrawGetModelRotationZoomVehColor(i)			
				if model == 1318 and rotY == 270 then
					setVirtualKeyDown(65, true) wait(100) setVirtualKeyDown(65, false)
				end					
				if model == 1318 and rotY == 180 then
					setVirtualKeyDown(87, true) wait(100) setVirtualKeyDown(87, false)
				end
				if model == 1318 and rotY == 90 then
					setVirtualKeyDown(68, true) wait(100) setVirtualKeyDown(68, false)
				end					
				if model == 1318 and rotY == 0 then
					setVirtualKeyDown(83, true) wait(100) setVirtualKeyDown(83, false)
				end								
			end
		end
	end
end
		end
    },
    {
      title = "{00bfff}��������� �������",
      submenu = {
        {
          title = "{AAAAAA}��������� �������"
        },
        {
          title = "���/���� ��������������: " .. tostring(settings.locator.autoupdate),
          onclick = function()
            settings.locator.autoupdate = not settings.locator.autoupdate
            inicfg.save(settings, "locator")
          end
        },
        {
          title = "���/���� ��������� ��� ������: " .. tostring(settings.locator.startmessage),
          onclick = function()
            settings.locator.startmessage = not settings.locator.startmessage
            inicfg.save(settings, "locator")
          end
        },
        {
          title = " "
        },
        {
          title = "{AAAAAA}��������� ���������� � ���������"
        },
        {
          title = color_sampev ..
          "[SRP | SAMP.Lua]: ������ ������ ����� � ��������� ����������� ������: " ..
          tostring(settings.transponder.catch_srp_start),
          onclick = function()
            settings.transponder.catch_srp_start = not settings.transponder.catch_srp_start
            inicfg.save(settings, "locator")
          end
        },
        {
          title = color_sampev ..
          "[SRP | SAMP.Lua]: ������ ����� ����� � ��������� �������� ������: " ..
          tostring(settings.transponder.catch_srp_stop),
          onclick = function()
            settings.transponder.catch_srp_stop = not settings.transponder.catch_srp_stop
            inicfg.save(settings, "locator")
          end
        },
        {
          title = color_sampev ..
          "[SRP | SAMP.Lua]: ������ ������ ������� ��� '���� ����� ������': " ..
          tostring(settings.transponder.catch_srp_gz),
          onclick = function()
            settings.transponder.catch_srp_gz = not settings.transponder.catch_srp_gz
            inicfg.save(settings, "locator")
          end
        },
        {
          title = " "
        },
        {
          title = "{AAAAAA}��������� �������"
        },
        {
          title = "����������� ������� ����������: " .. tostring(settings.transponder.allow_occupied),
          onclick = function()
            settings.transponder.allow_occupied = not settings.transponder.allow_occupied
            inicfg.save(settings, "locator")
          end
        },
        {
          title = "����������� �������� ���������� (������ �� �/� �������): " ..
          tostring(settings.transponder.allow_unlocked),
          onclick = function()
            settings.transponder.allow_unlocked = not settings.transponder.allow_unlocked
            inicfg.save(settings, "locator")
          end
        },
        {
          title = "�������� ����� ���������: " .. tostring(settings.transponder.delay) .. " ��",
          submenu = {
            {
              title = "999 ��",
              onclick = function()
                settings.transponder.delay = 999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "1999 ��",
              onclick = function()
                settings.transponder.delay = 1999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "2999 ��",
              onclick = function()
                settings.transponder.delay = 2999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "3999 ��",
              onclick = function()
                settings.transponder.delay = 3999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "4999 ��",
              onclick = function()
                settings.transponder.delay = 4999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "5999 ��",
              onclick = function()
                settings.transponder.delay = 5999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "6999 ��",
              onclick = function()
                settings.transponder.delay = 6999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "7999 ��",
              onclick = function()
                settings.transponder.delay = 7999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "8999 ��",
              onclick = function()
                settings.transponder.delay = 8999
                inicfg.save(settings, "locator")
              end
            },
            {
              title = "9999 ��",
              onclick = function()
                settings.transponder.delay = 9999
                inicfg.save(settings, "locator")
              end
            }
          }
        },
        {
          title = " "
        },
        {
          title = "{AAAAAA}��������� ��������� ������"
        },
        {
          title = "�������� �������� ����� ������ ������� ��� �����: " ..
          tostring(settings.handler.mark_coolest),
          onclick = function()
            settings.handler.mark_coolest = not settings.handler.mark_coolest
            inicfg.save(settings, "locator")
          end
        },
        {
          title = "�������� ������, ����� ������ �������� �� ����� �����������: " ..
          tostring(settings.handler.mark_coolest_sound),
          onclick = function()
            settings.handler.mark_coolest_sound = not settings.handler.mark_coolest_sound
            inicfg.save(settings, "locator")
          end
        },
        {
          title = "������� ������������ �������� ������ ����� ��� ����������: " ..
          tostring(settings.handler.clear_mark),
          onclick = function()
            settings.handler.clear_mark = not settings.handler.clear_mark
            inicfg.save(settings, "locator")
          end
        }
      }
    },
    {
      title = " "
    },
    {
      title = "{AAAAAA}������"
    },
    {
      title = "{ffff00}Qrlk - Github",
      onclick = function()
        os.execute('explorer "http://github.com/qrlk/locator"')
      end
    },
	{
      title = "{ffa500}Qrlk - Blasthack",
      onclick = function()
        os.execute('explorer "https://www.blast.hk/members/156833/"')
      end
	},
	{
      title = "{ff8c00}Vinchester - VK",
      onclick = function()
        os.execute('explorer "https://vk.com/ozfire_original"')
      end
	},
	{
      title = "{ff4500}Vinchester - Blasthack",
      onclick = function()
        os.execute('explorer "https://www.blast.hk/members/506881/"')
      end
	},
	}
end

--------------------------------------------------------------------------------
------------------------------------LEGACY--------------------------------------
--------------------------------------------------------------------------------
function legacy_edith_front()
  local x, y = getCharCoordinates(playerPed)
  local str = "{00ff66}��� ��������:{ffffff}\n"
  local first = false
  table.sort(vhinfo, sort)
  for k, v in pairs(vhinfo) do
    if v["occupied"] == false then
      if not first then
        str = str .. "{7ef3fa}"
        placeWaypoint(v["pos"]["x"], v["pos"]["y"], v["pos"]["z"])
        marker_placed = true
      end
      str =
      str ..
      "* " ..
      kvadrat1(v["pos"]["x"], v["pos"]["y"]) ..
      " || ����������: " ..
      math.floor(getDistanceBetweenCoords2d(x, y, v["pos"]["x"], v["pos"]["y"])) ..
      "m  || " ..
      carsids[v["model"]] ..
      " || " ..
      v["health"] ..
      " hp. ������: " ..
      toanime(v["occupied"]) ..
      ". X: " ..
      math.floor(v["pos"]["x"]) ..
      ". Y:" ..
      math.floor(v["pos"]["y"]) ..
      ". Z:" ..
      math.floor(v["pos"]["z"]) ..
      ". ������: " ..
      tostring(
        math.floor(
          response_timestamp -
          v["timestamp"]
        )
      ) ..
      " ��� �����\n"
      if not first then
        str = str .. "{ffffff}"
        first = true
      end
    end
  end

  str = str .. "\n{00ff66}� ���������:{ffffff}\n"
  for k, v in pairs(vhinfo) do
    if v["occupied"] == true then
      if not first then
        str = str .. "{7ef3fa}"
        placeWaypoint(v["pos"]["x"], v["pos"]["y"], v["pos"]["z"])
        marker_placed = true
      end
      str =
      str ..
      "* " ..
      kvadrat1(v["pos"]["x"], v["pos"]["y"]) ..
      " || ����������: " ..
      math.floor(getDistanceBetweenCoords2d(x, y, v["pos"]["x"], v["pos"]["y"])) ..
      "m  || " ..
      carsids[v["model"]] ..
      " || " ..
      v["health"] ..
      " hp. ������: " ..
      toanime(v["occupied"]) ..
      ". X: " ..
      math.floor(v["pos"]["x"]) ..
      ". Y:" ..
      math.floor(v["pos"]["y"]) ..
      ". Z:" ..
      math.floor(v["pos"]["z"]) ..
      ". ������: " ..
      tostring(
        math.floor(
          response_timestamp -
          v["timestamp"]
        )
      ) ..
      " ��� �����\n"
      if not first then
        str = str .. "{ffffff}"
        first = true
      end
    end
  end
  if first then
    str = str .. "\n\n{e5ff00}���������� ������ �������� �� ����� ������ (waypoint).{ffffff}"
  end
  sampShowDialog(9123, "LOCATOR: ����� � ������ " .. tostring(carsids[request_model]), str, "����")
end

marker_last_x = 0
marker_last_y = 0

function mark_coolest_car()
  local x, y = getCharCoordinates(playerPed)
  local first = false
  table.sort(vhinfo, sort)
  for k, v in pairs(vhinfo) do
    if v["occupied"] == false then
      if not first then
        placeWaypoint(v["pos"]["x"], v["pos"]["y"], v["pos"]["z"])
        marker_placed = true
        if v["pos"]["x"] ~= marker_last_x or v["pos"]["y"] ~= marker_last_y then
          if settings.handler.mark_coolest_sound then
            addOneOffSound(0.0, 0.0, 0.0, 1139)
          end
        end
        marker_last_x = v["pos"]["x"]
        marker_last_y = v["pos"]["y"]
      end

      if not first then
        first = true
      end
    end
  end

  for k, v in pairs(vhinfo) do
    if v["occupied"] == true then
      if not first then
        placeWaypoint(v["pos"]["x"], v["pos"]["y"], v["pos"]["z"])
        marker_placed = true
        if v["pos"]["x"] ~= marker_last_x or v["pos"]["y"] ~= marker_last_y then
          if settings.handler.mark_coolest_sound then
            addOneOffSound(0.0, 0.0, 0.0, 1139)
          end
        end
        marker_last_x = v["pos"]["x"]
        marker_last_y = v["pos"]["y"]
      end

      if not first then
        first = true
      end
    end
  end
end

function toanime(bool)
  if bool then
    return "�����"
  else
    return "�� �����"
  end
end

function kvadrat1(X, Y)
  local KV = {
    [1] = "�",
    [2] = "�",
    [3] = "�",
    [4] = "�",
    [5] = "�",
    [6] = "�",
    [7] = "�",
    [8] = "�",
    [9] = "�",
    [10] = "�",
    [11] = "�",
    [12] = "�",
    [13] = "�",
    [14] = "�",
    [15] = "�",
    [16] = "�",
    [17] = "�",
    [18] = "�",
    [19] = "�",
    [20] = "�",
    [21] = "�",
    [22] = "�",
    [23] = "�",
    [24] = "�"
  }
  X = math.ceil((X + 3000) / 250)
  if X < 10 then
    X = "0" .. tostring(X)
  end
  Y = math.ceil((Y * - 1 + 3000) / 250)
  Y = KV[Y]
  local KVX = (Y .. "-" .. X)
  return KVX
end

carsids = {
  [ - 1] = "�� ������",
  [400] = "Landstalker",
  [401] = "Bravura",
  [402] = "Buffalo",
  [403] = "Linerunner",
  [404] = "Perenniel",
  [405] = "Sentinel",
  [406] = "Dumper",
  [407] = "Firetruck",
  [408] = "Trashmaster",
  [409] = "Stretch",
  [410] = "Manana",
  [411] = "Infernus",
  [412] = "Voodoo",
  [413] = "Pony",
  [414] = "Mule",
  [415] = "Cheetah",
  [416] = "Ambulance",
  [417] = "Leviathan",
  [418] = "Moonbeam",
  [419] = "Esperanto",
  [420] = "Taxi",
  [421] = "Washington",
  [422] = "Bobcat",
  [423] = "Mr Whoopee",
  [424] = "BF Injection",
  [425] = "Hunter",
  [426] = "Premier",
  [427] = "Enforcer",
  [428] = "Securicar",
  [429] = "Banshee",
  [430] = "Predator",
  [431] = "Bus",
  [432] = "Rhino",
  [433] = "Barracks",
  [434] = "Hotknife",
  [435] = "Article Trailer",
  [436] = "Previon",
  [437] = "Coach",
  [438] = "Cabbie",
  [439] = "Stallion",
  [440] = "Rumpo",
  [441] = "RC Bandit",
  [442] = "Romero",
  [443] = "Packer",
  [444] = "Monster",
  [445] = "Admiral",
  [446] = "Squallo",
  [447] = "Seasparrow",
  [448] = "Pizzaboy",
  [449] = "Tram",
  [450] = "Article Trailer 2",
  [451] = "Turismo",
  [452] = "Speeder",
  [453] = "Reefer",
  [454] = "Tropic",
  [455] = "Flatbed",
  [456] = "Yankee",
  [457] = "Caddy",
  [458] = "Solair",
  [459] = "Topfun Van",
  [460] = "Skimmer",
  [461] = "PCJ-600",
  [462] = "Faggio",
  [463] = "Freeway",
  [464] = "RC Baron",
  [465] = "RC Raider",
  [466] = "Glendale",
  [467] = "Oceanic",
  [468] = "Sanchez",
  [469] = "Sparrow",
  [470] = "Patriot",
  [471] = "Quad",
  [472] = "Coastguard",
  [473] = "Dinghy",
  [474] = "Hermes",
  [475] = "Sabre",
  [476] = "Rustler",
  [477] = "ZR-350",
  [478] = "Walton",
  [479] = "Regina",
  [480] = "Comet",
  [481] = "BMX",
  [482] = "Burrito",
  [483] = "Camper",
  [484] = "Marquis",
  [485] = "Baggage",
  [486] = "Dozer",
  [487] = "Maverick",
  [488] = "SAN News Maverick",
  [489] = "Rancher",
  [490] = "FBI Rancher",
  [491] = "Virgo",
  [492] = "Greenwood",
  [493] = "Jetmax",
  [494] = "Hotring Racer C",
  [495] = "Sandking",
  [496] = "Blista Compact",
  [497] = "Police Maverick",
  [498] = "Boxville",
  [499] = "Benson",
  [500] = "Mesa",
  [501] = "RC Goblin",
  [502] = "Hotring Racer A",
  [503] = "Hotring Racer B",
  [504] = "Bloodring Banger",
  [505] = "Rancher",
  [506] = "Super GT",
  [507] = "Elegant",
  [508] = "Journey",
  [509] = "Bike",
  [510] = "Mountain Bike",
  [511] = "Beagle",
  [512] = "Cropduster",
  [513] = "Stuntplane",
  [514] = "Tanker",
  [515] = "Roadtrain",
  [516] = "Nebula",
  [517] = "Majestic",
  [518] = "Buccaneer",
  [519] = "Shamal",
  [520] = "Hydra",
  [521] = "FCR-900",
  [522] = "NRG-500",
  [523] = "HPV1000",
  [524] = "Cement Truck",
  [525] = "Towtruck",
  [526] = "Fortune",
  [527] = "Cadrona",
  [528] = "FBI Truck",
  [529] = "Willard",
  [530] = "Forklift",
  [531] = "Tractor",
  [532] = "Combine Harvester",
  [533] = "Feltzer",
  [534] = "Remington",
  [535] = "Slamvan",
  [536] = "Blade",
  [537] = "Freight (Train)",
  [538] = "Brownstreak (Train)",
  [539] = "Vortex",
  [540] = "Vincent",
  [541] = "Bullet",
  [542] = "Clover",
  [543] = "Sadler",
  [544] = "Firetruck LA",
  [545] = "Hustler",
  [546] = "Intruder",
  [547] = "Primo",
  [548] = "Cargobob",
  [549] = "Tampa",
  [550] = "Sunrise",
  [551] = "Merit",
  [552] = "Utility Van",
  [553] = "Nevada",
  [554] = "Yosemite",
  [555] = "Windsor",
  [556] = "Monster A",
  [557] = "Monster B",
  [558] = "Uranus",
  [559] = "Jester",
  [560] = "Sultan",
  [561] = "Stratum",
  [562] = "Elegy",
  [563] = "Raindance",
  [564] = "RC Tiger",
  [565] = "Flash",
  [566] = "Tahoma",
  [567] = "Savanna",
  [568] = "Bandito",
  [569] = "Freight Flat Trailer (Train)",
  [570] = "Streak Trailer (Train)",
  [571] = "Kart",
  [572] = "Mower",
  [573] = "Dune",
  [574] = "Sweeper",
  [575] = "Broadway",
  [576] = "Tornado",
  [577] = "AT400",
  [578] = "DFT-30",
  [579] = "Huntley",
  [580] = "Stafford",
  [581] = "BF-400",
  [582] = "Newsvan",
  [583] = "Tug",
  [584] = "Petrol Trailer",
  [585] = "Emperor",
  [586] = "Wayfarer",
  [587] = "Euros",
  [588] = "Hotdog",
  [589] = "Club",
  [590] = "Freight Box Trailer (Train)",
  [591] = "Article Trailer 3",
  [592] = "Andromada",
  [593] = "Dodo",
  [594] = "RC Cam",
  [595] = "Launch",
  [596] = "Police Car (LSPD)",
  [597] = "Police Car (SFPD)",
  [598] = "Police Car (LVPD)",
  [599] = "Police Ranger",
  [600] = "Picador",
  [601] = "S.W.A.T.",
  [602] = "Alpha",
  [603] = "Phoenix",
  [604] = "Glendale Shit",
  [605] = "Sadler Shit",
  [606] = "Baggage Trailer A",
  [607] = "Baggage Trailer B",
  [608] = "Tug Stairs Trailer",
  [609] = "Boxville",
  [610] = "Farm Trailer"
}

function sort(a, b)
  local x, y = getCharCoordinates(playerPed)
  getDistanceBetweenCoords2d(x, y, a["pos"]["x"], a["pos"]["y"])
  return getDistanceBetweenCoords2d(x, y, a["pos"]["x"], a["pos"]["y"]) <
  getDistanceBetweenCoords2d(x, y, b["pos"]["x"], b["pos"]["y"])
end
--------------------------------------------------------------------------------
--------------------------------------GMAP--------------------------------------
--------------------------------------------------------------------------------
active = false
mapmode = 1
modX = 2
modY = 2

function dn(nam)
  file = getGameDirectory() .. "\\moonloader\\resource\\locator\\" .. nam
  if not doesFileExist(file) then
    downloadUrlToFile("https://raw.githubusercontent.com/qrlk/locator/master/resource/locator/" .. nam, file)
  end
end

function init()
  if not doesDirectoryExist(getGameDirectory() .. "\\moonloader\\resource") then
    createDirectory(getGameDirectory() .. "\\moonloader\\resource")
  end
  if not doesDirectoryExist(getGameDirectory() .. "\\moonloader\\resource\\locator") then
    createDirectory(getGameDirectory() .. "\\moonloader\\resource\\locator")
  end
  dn("waypoint.png")
  dn("matavoz.png")
  dn("pla.png")

  for i = 1, 16 do
    dn(i .. ".png")
    dn(i .. "k.png")
  end

  player = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/pla.png")
  matavoz = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/matavoz.png")
  font = renderCreateFont("Impact", 8, 4)
  font10 = renderCreateFont("Impact", 10, 4)
  font12 = renderCreateFont("Impact", 12, 4)

  resX, resY = getScreenResolution()
  m1 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/1.png")
  m2 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/2.png")
  m3 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/3.png")
  m4 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/4.png")
  m5 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/5.png")
  m6 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/6.png")
  m7 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/7.png")
  m8 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/8.png")
  m9 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/9.png")
  m10 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/10.png")
  m11 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/11.png")
  m12 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/12.png")
  m13 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/13.png")
  m14 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/14.png")
  m15 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/15.png")
  m16 = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/16.png")
  m1k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/1k.png")
  m2k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/2k.png")
  m3k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/3k.png")
  m4k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/4k.png")
  m5k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/5k.png")
  m6k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/6k.png")
  m7k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/7k.png")
  m8k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/8k.png")
  m9k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/9k.png")
  m10k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/10k.png")
  m11k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/11k.png")
  m12k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/12k.png")
  m13k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/13k.png")
  m14k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/14k.png")
  m15k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/15k.png")
  m16k = renderLoadTextureFromFile(getGameDirectory() .. "/moonloader/resource/locator/16k.png")
  if resX > 1024 and resY >= 1024 then
    bX = (resX - 1024) / 2
    bY = (resY - 1024) / 2
    size = 1024
  elseif resX > 720 and resY >= 720 then
    bX = (resX - 720) / 2
    bY = (resY - 720) / 2
    size = 720
  else
    bX = (resX - 512) / 2
    bY = (resY - 512) / 2
    size = 512
  end
end

function fastmap()
  if not sampIsChatInputActive() and isKeyDown(0xA4) then
    while isKeyDown(77) or isKeyDown(188) do
      wait(0)

      x, y = getCharCoordinates(playerPed)
      if not sampIsChatInputActive() and wasKeyPressed(0x4B) then
        settings.map.sqr = not settings.map.sqr
        inicfg.save(settings, "locator")
      end
      if isKeyDown(77) then
        mapmode = 0
      elseif isKeyDown(188) or mapmode ~= 0 then
        mapmode = getMode(modX, modY)
        if wasKeyPressed(0x25) then
          if modY > 1 then
            modY = modY - 1
          end
        elseif wasKeyPressed(0x27) then
          if modY < 3 then
            modY = modY + 1
          end
        elseif wasKeyPressed(0x26) then
          if modX < 3 then
            modX = modX + 1
          end
        elseif wasKeyPressed(0x28) then
          if modX > 1 then
            modX = modX - 1
          end
        end
      end
      if mapmode == 0 or mapmode == -1 then
        renderDrawTexture(m1, bX, bY, size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m2, bX + size / 4, bY, size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m3, bX + 2 * (size / 4), bY, size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m4, bX + 3 * (size / 4), bY, size / 4, size / 4, 0, 0xFFFFFFFF)

        renderDrawTexture(m5, bX, bY + size / 4, size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m6, bX + size / 4, bY + size / 4, size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m7, bX + 2 * (size / 4), bY + size / 4, size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m8, bX + 3 * (size / 4), bY + size / 4, size / 4, size / 4, 0, 0xFFFFFFFF)

        renderDrawTexture(m9, bX, bY + 2 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m10, bX + size / 4, bY + 2 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m11, bX + 2 * (size / 4), bY + 2 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m12, bX + 3 * (size / 4), bY + 2 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)

        renderDrawTexture(m13, bX, bY + 3 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m14, bX + size / 4, bY + 3 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m15, bX + 2 * (size / 4), bY + 3 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawTexture(m16, bX + 3 * (size / 4), bY + 3 * (size / 4), size / 4, size / 4, 0, 0xFFFFFFFF)
        renderDrawBoxWithBorder(bX, bY + size - size / 42, size, size / 42, - 1, 2, - 2)

        renderFontDrawText(
          font10,
          string.format(
            "������� ����: %s   �������: %s   �������� ��������� ����������: %s   �������� ��������� ����������: %s   ����� � ����: %s || UPD: %s",
            carsids[request_model],
            #vhinfo,
            ser_active,
            ser_active_p,
            ser_count,
            count_next()
          ),
          bX,
          bY + size - size / 45,
          0xFF00FF00
        )

        if size == 1024 then
          iconsize = 16
        end
        if size == 720 then
          iconsize = 12
        end
        if size == 512 then
          iconsize = 10
        end
      else
        if size == 1024 then
          iconsize = 32
        end
        if size == 720 then
          iconsize = 24
        end
        if size == 512 then
          iconsize = 16
        end
      end
      if mapmode == 1 then
        if settings.map.sqr then
          renderDrawTexture(m9k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m10k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m13k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m14k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m9, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m10, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m13, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m14, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 2 then
        if settings.map.sqr then
          renderDrawTexture(m10k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m11k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m14k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m15k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m10, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m11, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m14, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m15, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 3 then
        if settings.map.sqr then
          renderDrawTexture(m11k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m12k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m15k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m16k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m11, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m12, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m15, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m16, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 4 then
        if settings.map.sqr then
          renderDrawTexture(m5k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m6k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m9k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m10k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m5, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m6, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m9, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m10, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 5 then
        if settings.map.sqr then
          renderDrawTexture(m6k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m7k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m10k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m11k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m6, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m7, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m10, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m11, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 6 then
        if settings.map.sqr then
          renderDrawTexture(m7k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m8k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m11k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m12k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m7, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m8, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m11, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m12, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 7 then
        if settings.map.sqr then
          renderDrawTexture(m1k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m2k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m5k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m6k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m1, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m2, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m5, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m6, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 8 then
        if settings.map.sqr then
          renderDrawTexture(m2k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m3k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m6k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m7k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m2, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m3, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m6, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m7, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      if mapmode == 9 then
        if settings.map.sqr then
          renderDrawTexture(m3k, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m4k, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m7k, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m8k, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        else
          renderDrawTexture(m3, bX, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m4, bX + size / 2, bY, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m7, bX, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
          renderDrawTexture(m8, bX + size / 2, bY + size / 2, size / 2, size / 2, 0, 0xFFFFFFFF)
        end
      end
      --renderDrawTexture(matavoz, getX(0), getY(0), 16, 16, 0, - 1)
      if getQ(x, y, mapmode) or mapmode == 0 then
        renderDrawTexture(player, getX(x), getY(y), iconsize, iconsize, - getCharHeading(playerPed), - 1)
      end
      if
      settings.transponder.catch_srp_gz and gz_squareStart["x"] ~= nil and gz_squareEnd["y"] ~= nil and
      (getQ(gz_squareStart["x"], gz_squareEnd["y"], mapmode) or mapmode == 0)
      then
        renderDrawBox(
          getX(gz_squareStart["x"]) + iconsize / 2,
          getY(gz_squareEnd["y"]) + iconsize / 2,
          getX(gz_squareEnd["x"]) - getX(gz_squareStart["x"]),
          getY(gz_squareStart["y"]) - getY(gz_squareEnd["y"]),
          0x80FFFFFF
        )
      end

      for z, v1 in pairs(vhinfo) do
        if getQ(v1["pos"]["x"], v1["pos"]["y"], mapmode) or mapmode == 0 then
          if v1["locked"] == 2 then
            color = 0xFF00FF00
          else
            color = 0xFFdedbd2
          end

          if v1["occupied"] then
            color = 0xFFFF0000
          end

          if response_timestamp - v1["timestamp"] > 2 then
            if mapmode == 0 then
              renderFontDrawText(
                font,
                string.format("%.0f?", response_timestamp - v1["timestamp"]),
                getX(v1["pos"]["x"]) + 17,
                getY(v1["pos"]["y"]) + 2,
                color
              )
            else
              renderFontDrawText(
                font12,
                string.format("%.0f?", response_timestamp - v1["timestamp"]),
                getX(v1["pos"]["x"]) + 31,
                getY(v1["pos"]["y"]) + 4,
                color
              )
            end
          end
          if v1["health"] ~= nil then
            if mapmode == 0 then
              renderFontDrawText(
                font,
                v1["health"] .. " dl",
                getX(v1["pos"]["x"]) - 30,
                getY(v1["pos"]["y"]) + 2,
                color
              )
            else
              renderFontDrawText(
                font12,
                v1["health"] .. " dl",
                getX(v1["pos"]["x"]) - string.len(v1["health"] .. " dl") * 9.4,
                getY(v1["pos"]["y"]) + 4,
                color
              )
            end
          end
          renderDrawTexture(
            matavoz,
            getX(v1["pos"]["x"]),
            getY(v1["pos"]["y"]),
            iconsize,
            iconsize,
            -v1["heading"] + 90,
            -1
          )
        end
      end
    end
  end
end

function getMode(x, y)
  if x == 1 then
    if y == 1 then
      return 1
    end
    if y == 2 then
      return 2
    end
    if y == 3 then
      return 3
    end
  end
  if x == 2 then
    if y == 1 then
      return 4
    end
    if y == 2 then
      return 5
    end
    if y == 3 then
      return 6
    end
  end
  if x == 3 then
    if y == 1 then
      return 7
    end
    if y == 2 then
      return 8
    end
    if y == 3 then
      return 9
    end
  end
end

function getQ(x, y, mp)
  if mp == 1 then
    if x <= 0 and y <= 0 then
      return true
    end
  end
  if mp == 2 then
    if x >= -1500 and x <= 1500 and y <= 0 then
      return true
    end
  end
  if mp == 3 then
    if x >= 0 and y <= 0 then
      return true
    end
  end
  if mp == 4 then
    if x <= 0 and y >= -1500 and y <= 1500 then
      return true
    end
  end
  if mp == 5 then
    if x >= -1500 and x <= 1500 and y >= -1500 and y <= 1500 then
      return true
    end
  end

  if mp == 6 then
    if x >= 0 and y >= -1500 and y <= 1500 then
      return true
    end
  end

  if mp == 7 then
    if x <= 0 and y >= 0 then
      return true
    end
  end
  if mp == 8 then
    if x >= -1500 and x <= 1500 and y >= 0 then
      return true
    end
  end
  if mp == 9 then
    if x >= 0 and y >= 0 then
      return true
    end
  end
  return false
end

function getX(x)
  if mapmode == 0 then
    x = math.floor(x + 3000)
    return bX + x * (size / 6000) - iconsize / 2
  end
  if mapmode == 3 or mapmode == 9 or mapmode == 6 then
    return bX - iconsize / 2 + math.floor(x) * (size / 3000)
  end
  if mapmode == 1 or mapmode == 7 or mapmode == 4 then
    return bX - iconsize / 2 + math.floor(x + 3000) * (size / 3000)
  end
  if mapmode == 2 or mapmode == 8 or mapmode == 5 then
    return bX - iconsize / 2 + math.floor(x + 1500) * (size / 3000)
  end
end

function getY(y)
  if mapmode == 0 then
    y = math.floor(y * - 1 + 3000)
    return bY + y * (size / 6000) - iconsize / 2
  end
  if mapmode == 7 or mapmode == 9 or mapmode == 8 then
    return bY + size - iconsize / 2 - math.floor(y) * (size / 3000)
  end
  if mapmode == 1 or mapmode == 3 or mapmode == 2 then
    return bY + size - iconsize / 2 - math.floor(y + 3000) * (size / 3000)
  end
  if mapmode == 4 or mapmode == 5 or mapmode == 6 then
    return bY + size - iconsize / 2 - math.floor(y + 1500) * (size / 3000)
  end
end
--------------------------------------------------------------------------------
--------------------------------------3RD---------------------------------------
--------------------------------------------------------------------------------
-- made by FYP
function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or "Select", close_button or "Close", back_button or "Back"
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == "table" and v.title .. "  >>" or v.title)
    end
    sampShowDialog(
      id,
      caption,
      table.concat(string_list, "\n"),
      select_button,
      (#prev_menus > 0) and back_button or close_button,
      4
    )
    repeat
      wait(0)
      local result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == "table" then -- submenu
            table.insert(prev_menus, {menu = menu, caption = caption})
            if type(item.onclick) == "function" then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == "function" then
            local result = item.onclick(menu, list + 1)
            if not result then
              return result
            end
            return display(menu, id, caption)
          end
        else -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end
