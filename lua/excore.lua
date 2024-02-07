local C = {}

function C.setup(opts)
	opts = opts or {}
	local notify_args = {
		title = "excore.nvim",
	}
	local mappings = {}
	local cache_dir = opts.cache_dir

	vim.api.nvim_create_user_command("ExDir", function(opts)
		cache_dir = opts.fargs[1]
		vim.notify("Set cache_dir to " .. cache_dir)
	end, { nargs = 1 })

	vim.api.nvim_create_user_command("ExLoad", function()
		local file_path = nil
		if cache_dir == nil then
			local pipe = io.popen("excore cache-dir")
			file_path = pipe:read("*l")
			if file_path == nil or pipe == nil then
				vim.notify(
					"Error when getting excore cache-dir, make sure you're in a excore project.",
					vim.log.levels.ERROR
				)
				vim.notify("Or you can pass cache-dir manually using ExDir.", vim.log.levels.ERROR)
				return
			end
			pipe:close()
		else
			file_path = cache_dir
		end

		file_path = file_path .. "/class_mapping.json" -- hardcore
		vim.notify("Load " .. file_path)
		local data = vim.api.nvim_call_function("readfile", { file_path })
		local json_data = vim.api.nvim_call_function("json_decode", { data })
		for key, value in pairs(json_data) do
			mappings[key] = value
		end
	end, {})

	vim.api.nvim_create_user_command("ToClass", function()
		local current_word = vim.fn.expand("<cword>")
		if next(mappings) == nil then
			vim.notify("call ExLoad to load mappings", vim.log.levels.WARN, notify_args)
			return
		end
		local mapping = mappings[current_word]
		if mapping == nil then
			vim.notify("Mapping not found for " .. current_word, vim.log.levels.WARN, notify_args)
			return
		end

		local path, line = unpack(mapping)

		vim.cmd("edit " .. path)
		vim.cmd(":" .. line)
	end, {})
end

return C
