local M = {}

if vim.fn.isdirectory(vim.fn.expand("~/anaconda3")) then
    M.conda_path = '~/anaconda3'
elseif vim.fn.isdirectory(vim.fn.expand("~/miniconda3")) then
    M.conda_path = '~/miniconda3'
end
M.conda_sh_path = M.conda_path .. '/etc/profile.d/conda.sh'


M.setup = function(options)
    M.conda_path = options.conda_path or M.conda_path

    -- Create a command in Neovim to switch Conda environment
    vim.api.nvim_create_user_command('CondaActivate', function(opts)
        if opts.args == '' then
            get_conda_envs(function(envs)
                require('telescope.pickers').new({}, {
                    prompt_title = 'Select Conda Environment',
                    finder = require('telescope.finders').new_table({
                        results = envs,
                    }),
                    sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
                    attach_mappings = function(prompt_bufnr, map)
                        local function set_env(close)
                            local selection = require('telescope.actions.state').get_selected_entry()
                            activate_conda_env(selection[1])
                            if close then
                                require('telescope.actions').close(prompt_bufnr)
                            end
                        end

                        map('i', '<CR>', function(bufnr)
                            set_env(true)
                        end)

                        map('n', '<CR>', function(bufnr)
                            set_env(true)
                        end)

                        return true
                    end,
                }):find()
            end)
        else
            activate_conda_env(opts.args)
        end
    end, { nargs = '?' })

    -- Create a command in Neovim to deactivate Conda environment
    vim.api.nvim_create_user_command('CondaDeactivate', function()
        deactivate_conda_env()
    end, {})
end

return M
