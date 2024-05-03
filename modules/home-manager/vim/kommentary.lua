local config = require('kommentary.config')
config.configure_language("default", { prefer_single_line_comments = true })
config.configure_language("nix", { single_line_comment_string = "#" })
