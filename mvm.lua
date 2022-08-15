
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

	function pq:PrintTable (t, n, c)
		if type (t) ~= 'table' then return self:Print (t) end

		n = n or 0
		c = c or {[_pq] = true}

		c [t] = true

		local p = ('	'):rep (n)

		local _, err = pcall (
			function ()
				for a, b in pairs (t) do
					self:Print (p, a, b)

					if (type (b) == 'table') and (not c [b]) then
						self:PrintTable (b, n + 1, c)
					end
				end
			end
		)

		if not _ then
			self:Print (p, err)
		end
	end

	_print      = function (...) return pq:Print      (...) end
	_printtable = function (...) return pq:PrintTable (...) end
end

do
	local pq = {}
	_pq.Objects = pq

	function pq:bt  (...) return ... or {} end
	function pq:bmt (...) return ... or {} end

	function pq:CreateObject (b, mt) return setmetatable (self:bt (b), self:bmt (mt)) end
end

do
	local pq = {}

	pq.pr = Entities.GetPlayerResource ()

	function pq:GetPing       (...) return self.pr:GetPing       (self.i, ...) end
	function pq:GetKills      (...) return self.pr:GetKills      (self.i, ...) end
	function pq:GetDeaths     (...) return self.pr:GetDeaths     (self.i, ...) end
	function pq:GetConnected  (...) return self.pr:GetConnected  (self.i, ...) end
	function pq:GetTeam       (...) return self.pr:GetTeam       (self.i, ...) end
	function pq:IsAlive       (...) return self.pr:IsAlive       (self.i, ...) end
	function pq:GetHealth     (...) return self.pr:GetHealth     (self.i, ...) end
	function pq:GetAccountID  (...) return self.pr:GetAccountID  (self.i, ...) end
	function pq:GetValid      (...) return self.pr:GetValid      (self.i, ...) end
	function pq:GetPlayerName (...) return self.pr:GetPlayerName (self.i, ...) end
	function pq:GetScore      (...) return self.pr:GetScore      (self.i, ...) end
	function pq:GetDamage     (...) return self.pr:GetDamage     (self.i, ...) end
	function pq:GetMaxHealth  (...) return self.pr:GetMaxHealth  (self.i, ...) end

	function pq:IsValid      (...) return self.e:IsValid      (...) end
	function pq:GetIndex     (...) return self.e:GetIndex     (...) end
	function pq:GetOrigin    (...) return self.e:GetOrigin    (...) end
	function pq:GetAngles    (...) return self.e:GetAngles    (...) end
	function pq:GetEyeAngles (...) return self.e:GetEyeAngles (...) end
	function pq:GetClassID   (...) return self.e:GetClassID   (...) end
	function pq:GetClass     (...) return self.e:GetClass     (...) end
	function pq:GetHealth    (...) return self.e:GetHealth    (...) end
	function pq:GetAmmo      (...) return self.e:GetAmmo      (...) end
	function pq:GetFlags     (...) return self.e:GetFlags     (...) end
	function pq:GetEyePos    (...) return self.e:GetEyePos    (...) end
	function pq:IsDormant    (...) return self.e:IsDormant    (...) end
	function pq:IsAlive      (...) return self.e:IsAlive      (...) end
	function pq:GetTeam      (...) return self.e:GetTeam      (...) end
	function pq:SetOrigin    (...) return self.e:SetOrigin    (...) end
	function pq:SetAngles    (...) return self.e:SetAngles    (...) end
	function pq:SetEyeAngles (...) return self.e:SetEyeAngles (...) end
	function pq:GetCriticals (...) return self.e:GetCriticals (...) end

	pq.__index = pq

	_pq.EntityHelper = {}
	function _pq.EntityHelper:Apply (ent)
		return _pq.Objects:CreateObject (
			{
				e = ent,
				i = ent:GetIndex ()
			}, pq
		)
	end

	pqEntity =
		function (...)
			return _pq.EntityHelper:Apply (...)
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

	pq.Lookup = {
		plysidx = {},
		plysaid = {},
		plysuid = {},

		plyclass = {},
	}

	pq.classidx = {
		[0] = 'na',

		'scout'   ,
		'sniper'  ,
		'soldier' ,
		'demoman' ,
		'medic'   ,
		'heavy'   ,
		'pyro'    ,
		'spy'     ,
		'engineer',
	}

	function pq:GetEntities () return self.Cache.all end

	function pq:GetPlayers () return self.Cache.plys end
	function pq:GetMVMBots () return self.Cache.mvm end

	function pq:GetList (id) return self.Cache [id] end

	function pq:LookupPlayerIDX (idx) return self.Lookup.plysidx [id] end
	function pq:LookupPlayerAID (aid) return self.Lookup.plysaid [id] end

	function pq:LookupPlayerUID (uid) return self.Lookup.plysidx [self.eng:GetPlayerForUserID (uid)] end

	function pq:GetPlayerClass (ply) return self.Lookup.plyclass [ply:GetAccountID ()] or self.classidx [0] end

	pq.ents = Entities
	pq.eng  = Interfaces.GetEngine ()

	function pq:PollEntityList ()
		self.Cache = {
			all  = {},
			mvm  = {},
			plys = {},
		}

		for a = 1, 2048 do
			local b = self.ents.GetByIndex (a)

			if not b:IsValid () then goto continue end

			b = pqEntity (b)

			self.Cache.all [#self.Cache.all + 1] = b

			local id = b:GetClassID ()

			self.Cache [id] = self.Cache [id] or {}
			self.Cache [id] [#self.Cache [id] + 1] = b

			local cls = b:GetClass ()

			if cls == 'CTFPlayer' then
				if (b:GetFlags () & FL_FAKECLIENT) ~= 0 then
					self.Cache.mvm [#self.Cache.mvm + 1] = b

					goto continue
				end

				self.Cache.plys [#self.Cache.plys + 1] = b

				self.Lookup.plysidx [a                ] = b
				self.Lookup.plysaid [b:GetAccountID ()] = b
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
		local rem = {}

		for n, f in pairs (self.Hooks [h]) do
			local ran, err = pcall (function (...) return f (...) end, ...)

			if not ran then rem [#rem + 1] = n print (err) end
		end

		for a = 1, #rem do
			self.Hooks [h] [rem [a]] = nil
		end
	end


	function pq:Register (h, n, c)
		self.Hooks [h] = {}

		Callbacks.Unregister (h, n)
		Callbacks.Register   (h, n, c)
	end

	pq:Register ('Draw'         , 'pq', function (...) return pq:Call ('Draw'         , ...) end)
	pq:Register ('FireGameEvent', 'pq', function (...) return pq:Call ('FireGameEvent', ...) end)
end

do
	local pq = {}
	_pq.GameEvents = pq

	pq.Hooks = {}
	pq.Hooked = {}

	pq.Helpers = {}

	function pq:Hook (h, n, f)
		self.Hooked [h] = true

		self.Hooks [h] = self.Hooks [h] or {}
		self.Hooks [h] [n] = f
	end

	function pq:Call (h, ...)
		local ran, ret = pcall (function (...) if not pq.Helpers [h] then return false end return pq.Helpers [h] (...) end, ...)

		if not ran then return false end

		local rem = {}

		for n, f in pairs (self.Hooks [h]) do
			local ran, err = pcall (function (...) return f (...) end, ret)

			if not ran then rem [#rem + 1] = n end
		end

		for a = 1, #rem do
			self.Hooks [h] [rem [a]] = nil
		end
	end

	function pq:RegisterHelper (h, f)
		self.Helpers [h] = f
	end

	_pq.Callbacks:Hook ('FireGameEvent', 'pq:mvm:Listen',
		function (e, ...)
			local n = e:GetName ()

			if not pq.Hooked [n] then return end

			pq:Call (n , e, ...)
		end
	)
end

do
	local pq = {}
	_pq.Color = {}

	function pq:Create (r, g, b, a)
		r, g, b, a = tonumber (r) or 255, tonumber (g) or 255, tonumber (b) or 255, tonumber (a) or 255

		if r > 255 then
			self.r = r >> 16
			self.g = (0xFF00FF | r) - 0xFF00FF >> 8
			self.b = (0xFFFF00 | r) - 0xFFFF00
			self.a = 255
		else
			self.r = r
			self.g = g
			self.b = b
			self.a = a
		end

		return self
	end

	function pq:Unpack () return self.r or 255, self.g or 255, self.b or 255, self.a or 255 end

	pq.__index = pq

	function _pq.Color:Apply (...)
		return _pq.Objects:CreateObject ({
			_type = 'Color'
		}, pq):Create (...)
	end

	pqColor =
		function (...)
			return _pq.Color:Apply (...)
		end
end

do
	local pq = {}

	function pq:Text (...)
		local _ = {...}
		if type (_ [1]) == 'table' and _ [1]._type == 'Color' then
			self:SetColor (_ [1])

			return self.d:Text (_ [2], _ [3], _ [4])
		end

		return self.d:Text (...)
	end

	function pq:Line         (...) return self.d:Line         (...) end
	function pq:Rect         (...) return self.d:Rect         (...) end
	function pq:OutlinedRect (...) return self.d:OutlinedRect (...) end
	function pq:FilledCircle (...) return self.d:FilledCircle (...) end

	function pq:SetColor (r, g, b, a, ...)
		if type (r) == 'table' and r._type == 'Color' then
			local _1, _2, _3, _4 = r:Unpack ()

			return self.d:SetColor (_1, _2, _3, _4)
		end

		return self.d:SetColor (r, g, b, a, ...)
	end

	function pq:SetFont (...) return self.d:SetFont (...) end
	function pq:W2S     (...) return self.d:W2S     (...) end

	pq.__index = pq

	_pq.Draw = {}
	function _pq.Draw:Apply (draw)
		return _pq.Objects:CreateObject (
			{
				d = draw
			}, pq
		)
	end

	pqDraw =
		function (...)
			return _pq.Draw:Apply (...)
		end
end

do
	local pq = {}

	_pq.MVM_DrawInfo = pq

	pq.GameEventNoDraw = false
	pq.Currency = {}

	pq.draw   = pqDraw (Interfaces.GetDraw ())
	pq.engine = Interfaces.GetEngine ()

	pq.med = {
		['Quick-Fix Medic'] = true,
		['Uber Medic'     ] = true,
		['Giant Medic'    ] = true,
	}
	pq.giant = {
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
	pq.boss = {
		['Sergeant Crits'          ] = true,
		['Major Crits'             ] = true,
		['Chief Blast Soldier'     ] = true,
		['Major Bomber'            ] = true,
		['Sir Nukesalot'           ] = true,
		['Captain Punch'           ] = true,
		['Giant Heal-on-Kill Heavy'] = true,
	}

	pq._pd = {
		hpdead     = pqColor (0xff0040),
		hpalive    = pqColor (0x38ff6a),

		botdormant = pqColor (0x915a91),
		botdead    = pqColor (0x8c546d),
		botmed     = pqColor (0xf52a52),
		botgiant   = pqColor (0x9d20e6),
		botboss    = pqColor (0x50ace6),
		botdefault = pqColor (0xff4d9c),

		plydormant = pqColor (0x915a91),
		plydead    = pqColor (0x8c546d),
		plydefault = pqColor (0xa463ff),

		plyovrheal = pqColor (0xff1f48),

		plymoney   = pqColor (0x5eff91),
	}

	pq._cls = {
		na       = pqColor (0xb0b0b0),

		scout    = pqColor (0xffc87a),
		sniper   = pqColor (0xff2e8f),
		soldier  = pqColor (0x6bff9c),
		demoman  = pqColor (0xffbe30),
		medic    = pqColor (0xff758a),
		heavy    = pqColor (0x4dbeff),
		pyro     = pqColor (0xff123d),
		spy      = pqColor (0xd1faff),
		engineer = pqColor (0xd8ffd1),
	}

	pq.ss = pq.engine:GetScreenSize ()

	function pq:DrawBotInfo (n, bot)
		local name, hp = bot:GetPlayerName (), bot:GetHealth () .. '/' .. bot:GetMaxHealth ()

		local nameclr = self._pd.botdefault

		if         bot:IsDormant ()  then nameclr = self._pd.botdormant hp = 'VIS'
		elseif not bot:IsAlive   ()  then nameclr = self._pd.botdead    hp = 'DEAD'
		elseif     self.med   [name] then nameclr = self._pd.botmed
		elseif     self.giant [name] then nameclr = self._pd.botgiant
		elseif     self.boss  [name] then nameclr = self._pd.botboss
		end

		local hpclr = (hp == 'DEAD') and self._pd.hpdead or ((bot:GetHealth () > bot:GetMaxHealth ()) and self._pd.plyovrheal or self._pd.hpalive)

		local x, y = (self.ss.x / 2) - 440, (self.ss.y / 2) - 230 + (15 * (n - 1))

		self.draw:Text (hpclr  , x     , y, hp  )
		self.draw:Text (nameclr, x + 75, y, name)
		
		self.draw:Line (x, y + 15, x + 90, y + 15)
	end

	function pq:DrawPlayerInfo (n, ply)
		local name, hp, currency, class = ply:GetPlayerName (), ply:GetHealth () .. '/' .. ply:GetMaxHealth (), self.Currency [ply:GetIndex ()] or 0, _pq.Entity:GetPlayerClass (ply)

		local classclr = self._cls [class]
		local nameclr  = self._pd.plydefault

		if         ply:IsDormant ()  then nameclr = self._pd.plydormant hp = 'VIS'
		elseif not ply:IsAlive   ()  then nameclr = self._pd.plydead    hp = 'DEAD'
		end

		local hpclr = (hp == 'DEAD') and self._pd.hpdead or ((ply:GetHealth () > ply:GetMaxHealth ()) and self._pd.plyovrheal or self._pd.hpalive)

		local x, y = 30, 30 + (15 * (n - 1))

		self.draw:Text (hpclr            , x      , y, hp      )
		self.draw:Text (self._pd.plymoney, x + 45 , y, currency)
		self.draw:Text (classclr         , x + 75 , y, class   )
		self.draw:Text (nameclr          , x + 130, y, name    )

		self.draw:Line (x, y + 15, x + 130, y + 15)
	end

	function pq:Draw ()
		self.draw:SetFont (FONT_OSRS)

		if not self.GameEventNoDraw then
			local bots = _pq.Entity:GetMVMBots ()

			for a = 1, #bots do
				self:DrawBotInfo (a, bots [a])
			end
		end

		local plys = _pq.Entity:GetPlayers ()

		for a = 1, #plys do
			self:DrawPlayerInfo (a, plys [a])
		end

		-- 285 units
	end

	_pq.Callbacks:Hook ('Draw', 'pq:mvm:Draw',
		function ()
			_pq.Entity:PollEntityList ()

			pq:Draw ()
		end
	)
end

do
	local pq = {}

	do
		_pq.GameEvents:RegisterHelper ('player_changeclass',
			function (e)
				return {
					userid = e:GetInt 'userid',
					class  = e:GetInt 'class' ,
				}
			end
		)

		_pq.GameEvents:RegisterHelper ('mvm_begin_wave',
			function (e)
				return {
					wave_index = e:GetInt 'wave_index',
					max_waves  = e:GetInt 'max_waves' ,
					advanced   = e:GetInt 'advanced'  ,
				}
			end
		)
		_pq.GameEvents:RegisterHelper ('mvm_wave_complete',
			function (e)
				return {
					advanced = e:GetString 'advanced',
				}
			end
		)
		_pq.GameEvents:RegisterHelper ('mvm_mission_complete',
			function (e)
				return {
					mission = e:GetInt 'mission',
				}
			end
		)
		_pq.GameEvents:RegisterHelper ('mvm_wave_failed',
			function (e)
				return {
				}
			end
		)

		_pq.GameEvents:RegisterHelper ('mvm_pickup_currency',
			function (e)
				return {
					player   = e:GetInt 'player'  ,
					currency = e:GetInt 'currency',

				}
			end
		)
		_pq.GameEvents:RegisterHelper ('mvm_sniper_headshot_currency',
			function (e)
				return {
					userid   = e:GetInt 'userid'  ,
					currency = e:GetInt 'currency',
				}
			end
		)
	end

	pq.eng = Interfaces.GetEngine ()

	function pq:Hook_PlayerChangeClass (t)
		local id = _pq.Entity:LookupPlayerUID (t.userid):GetAccountID ()

		_pq.Entity.Lookup.plyclass [id] = _pq.Entity.classidx [t.class]
	end

	_pq.GameEvents:Hook ('player_changeclass', 'pq:mvm:?', function (...) return pq:Hook_PlayerChangeClass (...) end)

	-- function pq:Hook_BeginWave       (t) _pq.MVM_DrawInfo.GameEventNoDraw = false _pq.MVM_DrawInfo.Currency = {} end
	-- function pq:Hook_CompleteWave    (t) _pq.MVM_DrawInfo.GameEventNoDraw = true  end
	-- function pq:Hook_CompleteMission (t) _pq.MVM_DrawInfo.GameEventNoDraw = true  end
	-- function pq:Hook_FailWave        (t) _pq.MVM_DrawInfo.GameEventNoDraw = true  end

	-- _pq.GameEvents:Hook ('mvm_begin_wave'      , 'pq:mvm:?', function (...) return pq:Hook_BeginWave       (...) end)
	-- _pq.GameEvents:Hook ('mvm_wave_complete'   , 'pq:mvm:?', function (...) return pq:Hook_CompleteWave    (...) end)
	-- _pq.GameEvents:Hook ('mvm_mission_complete', 'pq:mvm:?', function (...) return pq:Hook_CompleteMission (...) end)
	-- _pq.GameEvents:Hook ('mvm_wave_failed'     , 'pq:mvm:?', function (...) return pq:Hook_FailWave        (...) end)

	-- function pq:Hook_PickupCurrency (t)
	-- 	local id = _pq.Entity:LookupPlayerIDX (t.player):GetAccountID ()

	-- 	_pq.MVM_DrawInfo.Currency [id] = (_pq.MVM_DrawInfo.Currency [id] or 0) + t.currency
	-- end
	-- function pq:Hook_SniperCurrency (t)
	-- 	local id = _pq.Entity:LookupPlayerUID (t.userid):GetAccountID ()

	-- 	_pq.MVM_DrawInfo.Currency [id] = (_pq.MVM_DrawInfo.Currency [id] or 0) + t.currency
	-- end

	-- _pq.GameEvents:Hook ('mvm_pickup_currency'         , 'pq:mvm:?', function (...) return pq:Hook_PickupCurrency (...) end)
	-- _pq.GameEvents:Hook ('mvm_sniper_headshot_currency', 'pq:mvm:?', function (...) return pq:Hook_SniperCurrency (...) end)
end
