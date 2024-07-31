local M = {}
local Job = require('plenary.job')
-- Function to get conda environments
function M.get_conda_envs(callback)
    local envs = {}
    Job:new({
        command = 'conda',
        args = { 'env', 'list' },
        on_exit = vim.schedule_wrap(function(j, return_val)
            if return_val == 0 then
                local result = j:result()
                for _, line in ipairs(result) do
                    local env_name = string.match(line, "^%s*(%S+)")
                    if env_name and not env_name:find('#') and not env_name:find('/') then
                        table.insert(envs, env_name)
                    end
                end
                callback(envs)
            else
                print('Failed to get conda environments. Error: ' .. table.concat(j:stderr_result(), '\n'))
            end
        end),
    }):start()
end

return M
