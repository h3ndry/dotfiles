return {
    'mfussenegger/nvim-dap-python',


    config = function()
        local dap_python = require('dap-python')
        dap_python.setup('/home/hendry/.cache/pypoetry/virtualenvs/cerberus-backend-T8oS24TV-py3.9/bin/python')
    end
}
