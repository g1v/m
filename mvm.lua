
local _pq = {}

do
	FONT_ESP         = Enums.Fonts.FONT_ESP
	FONT_ESP_NAME    = Enums.Fonts.FONT_ESP_NAME
	FONT_ESP_COND    = Enums.Fonts.FONT_ESP_COND
	FONT_ESP_PICKUPS = Enums.Fonts.FONT_ESP_PICKUPS
	FONT_MENU        = Enums.Fonts.FONT_MENU
	FONT_INDICATORS  = Enums.Fonts.FONT_INDICATORS
	FONT_IMGUI       = Enums.Fonts.FONT_IMGUI
	FONT_OSRS        = Enums.Fonts.FONT_OSRS

	FL_ONGROUND              = 1
	FL_DUCKING               = 2
	FL_ANIMDUCKING           = 4
	FL_WATERJUMP             = 8
	FL_ONTRAIN               = 16
	FL_INRAIN                = 32
	FL_FROZEN                = 64
	FL_ATCONTROLS            = 128
	FL_CLIENT                = 256
	FL_FAKECLIENT            = 512
	FL_INWATER               = 1024
	FL_FLY                   = 2048
	FL_SWIM                  = 4096
	FL_CONVEYOR              = 8192
	FL_NPC                   = 16384
	FL_GODMODE               = 32768
	FL_NOTARGET              = 65536
	FL_AIMTARGET             = 131072
	FL_PARTIALGROUND         = 262144
	FL_STATICPROP            = 524288
	FL_GRAPHED               = 1048576
	FL_GRENADE               = 2097152
	FL_STEPMOVEMENT          = 4194304
	FL_DONTTOUCH             = 8388608
	FL_BASEVELOCITY          = 16777216
	FL_WORLDBRUSH            = 33554432
	FL_OBJECT                = 67108864
	FL_KILLME                = 134217728
	FL_ONFIRE                = 268435456
	FL_DISSOLVING            = 536870912
	FL_TRANSRAGDOLL          = 1073741824
	FL_UNBLOCKABLE_BY_PLAYER = -2147483648
end

do
	local pq = {}
	_pq.Printers = pq

	function pq:Print (...)
		local a = {...}

		local b = tostring (a [1])

		for c = 2, #a do b =  b .. '	' .. tostring (a [c]) end

		return print (b)
	end
end

do
	local pq = {}
	_pq.Entity = pq

	pq.Cache = {
		all  = {},
		mvm  = {},
		plys = {},
	}

	function pq:GetEntities () return self.Cache.all end

	function pq:GetPlayers () return self.Cache.plys end
	function pq:GetMVMBots () return self.Cache.mvm end

	function pq:GetList (id) return self.Cache [id] end

	local Entities = Entities

	function pq:PollEntityList ()
		self.Cache = {
			all  = {},
			mvm  = {},
			plys = {},
		}

		for a = 1, 2048 do
			local b = Entities.GetByIndex (a)

			if not b:IsValid () then goto continue end

			self.Cache.all [#self.Cache.all + 1] = b

			local id = b:GetClassID ()

			self.Cache [id] = self.Cache [id] or {}
			self.Cache [id] [#self.Cache [id] + 1] = b

			local cls = b:GetClass ()

			if cls == 'CTFPlayer' then
				if (b:GetFlags () & FL_FAKECLIENT) == FL_FAKECLIENT then
					self.Cache.mvm [#self.Cache.mvm + 1] = b

					goto continue
				end

				self.Cache.plys [#self.Cache.plys + 1] = b
			end

			::continue::
		end
	end
end

do
	local pq = {}
	_pq.Callbacks = pq

	pq.Hooks = {}

	function pq:Hook (h, n, f)
		self.Hooks [h] [n] = f
	end

	function pq:Call (h, ...)
		for _, n in pairs (self.Hooks [h]) do
			local ran, err = pcall (function (...) return n (...) end, ...)

			if (not ran) then print (err) end
		end
	end


	function pq:Register (e, n, c)
		self.Hooks [e] = {}

		Callbacks.Unregister (e, n)
		Callbacks.Register   (e, n, c)
	end

	pq:Register ('Draw', 'pq', function (...) return pq:Call ('Draw', ...) end)
end

do
	local pq = {}

	local draw = Interfaces.GetDraw ()
	local pr = Entities.GetPlayerResource ()

	local med = {
		['Quick-Fix Medic'] = true,
		['Uber Medic'     ] = true,
		['Giant Medic'    ] = true,
	}
	local giant = {
		['Super Scout'                ] = true,
		['Force-A-Nature Super Scout' ] = true,
		['Giant Jumping Sandman Scout'] = true,
		['Major League Scout'         ] = true,
		['Giant Bonk Scout'           ] = true,
		['Armored Giant Sandman Scout'] = true,
		['Giant Soldier'              ] = true,
		['Giant Buff Banner Soldier'  ] = true,
		['Giant Battalion Soldier'    ] = true,
		['Giant Concheror Soldier'    ] = true,
		['Giant Rapid Fire Soldier'   ] = true,
		['Giant Burst Fire Soldier'   ] = true,
		['Giant Charged Soldier'      ] = true,
		['Giant Blast Soldier'        ] = true,
		['Giant Black Box Soldier'    ] = true,
		['Giant Pyro'                 ] = true,
		['Giant Flare Pyro'           ] = true,
		['Giant Rapid Fire Demoman'   ] = true,
		['Giant Burst Fire Demo'      ] = true,
		['Giant Demoknight'           ] = true,
		['Giant Heavy'                ] = true,
		['Giant Shotgun Heavy'        ] = true,
		['Giant Deflector Heavy'      ] = true,
		['Giant Heater Heavy'         ] = true,
	}
	local boss = {
		['Sergeant Crits'          ] = true,
		['Major Crits'             ] = true,
		['Chief Blast Soldier'     ] = true,
		['Major Bomber'            ] = true,
		['Sir Nukesalot'           ] = true,
		['Captain Punch'           ] = true,
		['Giant Heal-on-Kill Heavy'] = true,
	}

	function pq:DrawInfo (n, bot)
		local name = pr:GetPlayerName (bot:GetIndex ())

		if         bot:IsDormant () then draw:SetColor (145,  90, 145, 255)
		elseif not bot:IsAlive   () then draw:SetColor (140,  84, 109, 255)
		elseif     med   [name]     then draw:SetColor (245,  42,  82, 255)
		elseif     giant [name]     then draw:SetColor (157,  32, 230, 255)
		elseif     boss  [name]     then draw:SetColor ( 80, 172, 230, 255)
		else                             draw:SetColor (255,  77, 156, 255)
		end

		local x, y = 15, 15 + (15 * (n - 1))
		
		draw:Text (x     , y, bot:IsDormant () and 'VIS' or bot:GetHealth    ())
		draw:Text (x + 45, y, name)
		
		draw:Line (x, y + 15, x + 90, y + 15)
	end

	function pq:Draw ()
		draw:SetFont (FONT_OSRS)

		local bots = _pq.Entity:GetMVMBots ()
		for a = 1, #bots do
			self:DrawInfo (a, bots [a])
		end
	end

	_pq.Callbacks:Hook ('Draw', 'pq:mvm:Draw',
		function ()
			_pq.Entity:PollEntityList ()

			pq:Draw ()
		end
	)
end