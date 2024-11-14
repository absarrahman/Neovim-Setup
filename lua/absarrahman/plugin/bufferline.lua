return {
    'akinsho/bufferline.nvim',
    branch = 'main',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "BufReadPre",
    config = true,
    opts = {
        options = {
            mode = "buffers",
            always_show_bufferline = true,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "Project Explorer",
                    text_align = "left",
                    separator = true,
                },
            },
        },
    }
}
