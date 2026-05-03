return {
  'seblyng/roslyn.nvim',
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  ft = { 'cs', 'razor' },
  opts = {
    -- your configuration comes here; leave empty for default settings
  },

  -- ADD THIS:

  dependencies = {
    {
      -- By loading as a dependencies, we ensure that we are available to set
      -- the handlers for Roslyn.
      'tris203/rzls.nvim',
      config = true,
    },
  },
  lazy = false,
  config = function()
    local mason_registry = require 'mason-registry'

    local rzls_path = vim.fn.expand '$MASON/packages/rzls/libexec'
    local cmd = {
      'roslyn',
      '--stdio',
      '--logLevel=Information',
      '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.log.get_filename()),
      '--razorSourceGenerator=' .. vim.fs.joinpath(rzls_path, 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
      '--razorDesignTimePath=' .. vim.fs.joinpath(rzls_path, 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
      '--extension',
      vim.fs.joinpath(rzls_path, 'RazorExtension', 'Microsoft.VisualStudioCode.RazorExtension.dll'),
    }

    -- GLOBAL handler to block Roslyn file watch registration.
    -- This MUST be set before vim.lsp.enable so it intercepts the registration
    -- request. The on_init / client.handlers approach is unreliable because
    -- the Razor extension registers watches through a separate code path.
    local _orig_register = vim.lsp.handlers["client/registerCapability"]
    vim.lsp.handlers["client/registerCapability"] = function(err, result, ctx, config)
      if ctx and ctx.client_id then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == "roslyn" then
          if result and result.registrations then
            result.registrations = vim.tbl_filter(function(reg)
              return reg.method ~= "workspace/didChangeWatchedFiles"
            end, result.registrations)
            if #result.registrations == 0 then
              return {}  -- success response, nothing to register
            end
          end
        end
      end
      if _orig_register then
        return _orig_register(err, result, ctx, config)
      end
    end

    vim.lsp.config('roslyn', {
      cmd = cmd,
      handlers = require 'rzls.roslyn_handlers',
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,

          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    })
    vim.lsp.enable 'roslyn'
  end,
  init = function()
    -- We add the Razor file types before the plugin loads.
    vim.filetype.add {
      extension = {
        razor = 'razor',
        cshtml = 'razor',
      },
    }
  end,
}
