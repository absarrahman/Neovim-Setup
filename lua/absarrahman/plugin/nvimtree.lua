return {
    {
        "nvim-tree/nvim-tree.lua"
    },
    {
        'nvim-tree/nvim-web-devicons'
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
}
