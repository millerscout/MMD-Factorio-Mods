local speed_multiplier = settings.startup["exp_for_buildings_speed_multiplier"].value
local energy_multiplier = settings.startup["exp_for_buildings_energy_multiplier"].value
local pollution_multiplier = settings.startup["exp_for_buildings_pollution_multiplier"].value
local productivity_multiplier = settings.startup["exp_for_buildings_productivity_multiplier"].value
local max_level = settings.startup["exp_for_buildings_max_level"].value

local container = {}

for i = 1, max_level, 1 do
	-- [Item] --
	s    = "" .. i
	icon = {}
	for i = 1, #s, 1 do
		icon[i] = "__zzz-xp-for-buildings__/graphics/icons/" .. string.sub(s, i, i) .. ".png"
	end
	local item =
	{
		type = "module",
		name = "Xp-buildings-" .. i,
		icons = {
			{
				icon = "__zzz-xp-for-buildings__/graphics/icons/background.png",
				icon_size = 64,
				tint = {
					r = 1,
					g = 1,
					b = 1,
					a = 1
				}
			}
		},
		icon_size = 64,
		subgroup = "module",
		category = "speed",
		tier = i,
		order = "a-" .. i,
		stack_size = 50,
		effect = {
			consumption = { bonus = energy_multiplier * i },
			speed = { bonus = speed_multiplier * i },
			productivity = { bonus = productivity_multiplier * i },
			pollution = { bonus = pollution_multiplier * i }
		},
	}
	ndex = #icon
	pos = {}
	if #icon == 1 then
		pos[1] = { 0, 0 }
	end
	if #icon == 2 then
		pos[1] = { 0, 0 }
		pos[2] = { 11, 0 }
	end
	if #icon == 3 then
		pos[1] = { 0, 0 }
		pos[2] = { 11, 0 }
		pos[3] = { 21, 0 }
	end
	for index, value in ipairs(icon) do
		table.insert(item.icons,
			{
				icon = value,
				icon_size = 64,
				tint = {
					r = 0.5 + 0.5 * i * 0.01,
					g = 0.55,
					b = 0.8,
					a = 0.75
				},
				shift = pos[index]
			})
		ndex = ndex - 1
	end

	table.insert(container, item)
	data:extend(container)

	-- [Recipe] --
	data:extend({
		{
			enabled = true,
			energy_required = 120,
			ingredients = { { "automation-science-pack", 1 } },
			name = "Xp-buildings-" .. i,
			result = "Xp-buildings-" .. i,
			type = "recipe"
		}
	})
end
-- -- [Technology] --
-- data:extend({
--     {
--         effects = {{type = "unlock-recipe", recipe = "speed-module-4"}},
--         icon = "__modules-t4__/graphics/technology/speed-module-4.png",
--         icon_size = 256,
--         name = "speed-module-4",
--         order = "i-c-d",
--         prerequisites = {"speed-module-3"},
--         type = "technology",
--         unit = {
--             count = 500,
--             ingredients = {
--                 {"automation-science-pack", 1}, {"logistic-science-pack", 1},
--                 {"chemical-science-pack", 1}, {"production-science-pack", 1}

--             },
--             time = 60
--         },
--         upgrade = true
--     }
-- })
