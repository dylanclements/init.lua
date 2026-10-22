return {
    'canvanauts/bazel-java.nvim',
    dir = vim.env.BAZEL_JAVA_PLUGIN_DIR,
    lazy = false,
    enabled = function()
        return vim.env.BAZEL_JAVA_ENGINE ~= nil and vim.env.BAZEL_JAVA_WORKSPACE ~= nil
    end,
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
        local cmd = { vim.env.BAZEL_JAVA_ENGINE, '--stdio' }
        local state_directory = vim.env.BAZEL_JAVA_STATE_DIRECTORY
        if state_directory and state_directory ~= '' then
            table.insert(cmd, '--state')
            table.insert(cmd, state_directory)
        end
        require('bazel_java').setup({
            cmd = cmd,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            state_directory = state_directory,
            workspaces = {
                [vim.env.BAZEL_JAVA_WORKSPACE] = {
                    project_view = vim.env.BAZEL_JAVA_PROJECT_VIEW or '.bazelbsp/.bazelproject',
                    bazel = vim.env.BAZEL_JAVA_BAZEL or 'tools/bazel',
                },
            },
        })
    end,
}
