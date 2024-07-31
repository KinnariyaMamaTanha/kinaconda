local M = {}
local Job = require('plenary.job')
local init = require("kinaconda.init")
-- Function to switch conda environment
function M.activate_conda_env(env_name)
    local shell_command = string.format([[
    source %s && conda activate %s && env
  ]], init.conda_sh_path, env_name)

    Job:new({
        command = 'bash',
        args = { '-c', shell_command },
        on_exit = vim.schedule_wrap(function(j, return_val)
            if return_val == 0 then
                print('Successfully switched to conda environment: ' .. env_name)

                -- Update Neovim's environment variables
                local result = j:result()
                for _, line in ipairs(result) do
                    local key, value = string.match(line, "([^=]+)=([^=]+)")
                    if key and value then
                        vim.fn.setenv(key, value)
                    end
                end

                -- Restart coc.nvim to reload the environment
                vim.cmd('CocRestart')

                -- Optionally, wait a bit and then reload the current buffer
                vim.defer_fn(function()
                    vim.cmd('e')
                end, 1000)
            else
                print('Failed to switch conda environment. Error: ' .. table.concat(j:stderr_result(), '\n'))
            end
        end),
    }):start()
end

return M
