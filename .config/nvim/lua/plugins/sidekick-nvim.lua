return {
  'folke/sidekick.nvim',
  opts = {
    -- add any options here
    cli = {
      -- watch = false,
      -- tools = {
      --   amp = {
      --     cmd = { 'amp', '--ide' },
      --   },
      -- },
      mux = {
        backend = 'zellij',
        enabled = true,
      },
      prompts = {
        resume_update = 'Update the resume in the @main.tex file to align perfectly with the job description provided in @job-description.md . Make sure to highlight relevant skills, experiences, and qualifications that directly match the requirements of the job. Tailor the resume to showcase how your background and expertise make you an ideal candidate for the position. Be sure to emphasize any specific achievements or accomplishments demonstrate your ability to excel in this role.',
        pr = ' Create a pull request from this branch to the Q4Dev branch using this template. Add the following as required reviewers: bonisile.mbambo@expresspros.com and siphamandla.ngwenya@expresspros.com. Add the following as optional reviewers: kobus.schlebusch@expresspros.com, wesley.madziva@expresspros.com, bongani.maluleke@expresspros.com, and sibusiso.cebekhulu@expresspros.com. ',
      },
    },
  },
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    {
      '<leader>aa',
      function()
        require('utils.sidebar').close_others 'sidekick'
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle CLI',
      mode = { 'n', 't' },
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
      end,
      desc = 'Sidekick Select CLI',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').send { msg = '{file}' }
      end,
      desc = 'Sidekick Claude Toggle',
      mode = { 'n', 'v' },
    },

    {
      '<leader>af',
      function()
        require('sidekick.cli').focus()
      end,
      desc = 'Sidekick Claude Toggle',
      mode = { 'n', 'v', 't' },
    },

    {
      '<leader>ag',
      function()
        require('sidekick.cli').toggle { name = 'grok', focus = true }
      end,
      desc = 'Sidekick Grok Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ao',
      function()
        require('sidekick.cli').toggle { name = 'opencode', focus = true }
      end,
      desc = 'Sidekick Opencode Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'v' },
      desc = 'Send Visual Selection',
    },

    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}' }
      end,
      mode = { 'x', 'n' },
      desc = 'Send This',
    },

    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      desc = 'Sidekick Ask Prompt',
      mode = { 'n', 'v' },
    },
  },
}
