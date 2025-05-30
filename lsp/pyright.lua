local cwd = vim.fn.getcwd()
return {
	settings = {
		pyright = {
			disableOrganizeImports = true,
			openFilesOnly = false,
		},
		python = {
			venvPath = cwd,
			venv = "venv",
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "off",
				enableReachabilityAnalysis = true,
				useLibraryCodeForTypes = true,
				-- autoImportCompletions = true,
				-- autoSearchPaths = true,
				-- useLibraryCodeForTypes = true,
				-- diagnosticMode = "workspace",
				-- extraPaths = { site_packages }, -- adjust version if needed
				--
				-- diagnosticSeverityOverrides = {
				-- 	reportAttributeAccessIssue = "warning",
				-- 	reportArgumentType = "none",
				-- 	reportInvalidTypeForm = "warning",
				-- 	reportReturnType = "warning",
				-- 	reportOptionalMemberAccess = "warning",
				-- 	reportGeneralTypeIssues = "warning",
				-- 	reportTypedDictNotRequiredAccess = "warning",
				-- },
			},
		},
	}
}
