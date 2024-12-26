return {
	"echasnovski/mini.base16",
	version = "*",
	config = function()
		require("mini.base16").setup({
			palette = {
				base00 = "#161616",
				base01 = "#262626",
				base02 = "#393939",
				base03 = "#525252",
				base04 = "#c1c8cd",
				base05 = "#dde1e6",
				base06 = "#f2f4f8",
				base07 = "#ffffff",
				base08 = "#fa4d56",
				base09 = "#ff932b",
				base0A = "#f1c21b",
				base0B = "#42be65",
				base0C = "#3ddbd9",
				base0D = "#78a9ff",
				base0E = "#be95ff",
				base0F = "#a2a9b0",

				-- base00: "161616"
				-- base01: "262626"
				-- base02: "393939"
				-- base03: "525252"
				-- base04: "#dde1e6"
				-- base05: "#f2f4f8"
				-- base06: "ffffff"
				-- base07: "#08bdba"
				-- base08: "#3ddbd9"
				-- base09: "#78a9ff"
				-- base0A: "#ee5396"
				-- base0B: "#33b1ff"
				-- base0C: "#ff7eb6"
				-- base0D: "#42be65"
				-- base0E: "#be95ff"
				-- base0F: "#82cfff"
			},
		})
	end,
}
