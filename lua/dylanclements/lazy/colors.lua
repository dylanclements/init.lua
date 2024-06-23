return {
    {
        "santos-gabriel-dario/darcula-solid.nvim",
        dependencies = {
            'rktjmp/lush.nvim'
        },
        name = "darcula-solid",
        config= function()
            -- require('darcula-solid').setup()
            vim.cmd("colorscheme darcula-solid")
        end
    }
}
