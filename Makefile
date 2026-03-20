SHELL			= /usr/bin/zsh

NAME			= InTheShadow
PRESET			= Linux
VERSION			= 4.6.1
STATUS			= stable

TOOLS			= $(CURDIR)/.tools
DOWNLOADS		= $(TOOLS)/downloads
GODOT_HOME		= $(TOOLS)/home
GODOT_BIN		= $(TOOLS)/editor/Godot_v$(VERSION)-$(STATUS)_linux.x86_64
EXPORT_TEMPLATE_DIR	= $(GODOT_HOME)/.local/share/godot/export_templates/$(VERSION).$(STATUS)

EXPORT_DIR		= $(CURDIR)/build/linux
EXPORT_FILE		= $(EXPORT_DIR)/$(NAME).x86_64

GODOT_ZIP		= $(DOWNLOADS)/Godot_v$(VERSION)-$(STATUS)_linux.x86_64.zip
TEMPLATES_TPZ		= $(DOWNLOADS)/Godot_v$(VERSION)-$(STATUS)_export_templates.tpz
RELEASE_URL_BASE	= https://github.com/godotengine/godot-builds/releases/download/$(VERSION)-$(STATUS)

all: export-linux

check-tools:
	@command -v curl >/dev/null || { echo "Error: curl is required"; exit 1; }
	@command -v unzip >/dev/null || { echo "Error: unzip is required"; exit 1; }

hello:
	@printf "\033[48;2;100;0;100;1m Export pipeline for %s\033[0m\n\n" "$(NAME)"

$(GODOT_BIN): check-tools
	@mkdir -p "$(DOWNLOADS)" "$(dir $(GODOT_BIN))"
	@printf "\033[48;2;0;155;0;1m Download Godot editor binary\033[0m\n"
	@curl -fL "$(RELEASE_URL_BASE)/$(notdir $(GODOT_ZIP))" -o "$(GODOT_ZIP)"
	@unzip -q -o "$(GODOT_ZIP)" -d "$(dir $(GODOT_BIN))"
	@chmod +x "$(GODOT_BIN)"

$(EXPORT_TEMPLATE_DIR)/linux_release.x86_64: check-tools
	@mkdir -p "$(DOWNLOADS)" "$(EXPORT_TEMPLATE_DIR)"
	@printf "\033[48;2;0;155;0;1m Download and install light Linux export template\033[0m\n"
	@curl -fL "$(RELEASE_URL_BASE)/$(notdir $(TEMPLATES_TPZ))" -o "$(TEMPLATES_TPZ)"
	@unzip -p "$(TEMPLATES_TPZ)" "templates/linux_release.x86_64" > "$(EXPORT_TEMPLATE_DIR)/linux_release.x86_64"
	@unzip -p "$(TEMPLATES_TPZ)" "templates/icudt_godot.dat" > "$(EXPORT_TEMPLATE_DIR)/icudt_godot.dat"
	@unzip -p "$(TEMPLATES_TPZ)" "templates/version.txt" > "$(EXPORT_TEMPLATE_DIR)/version.txt"

export-linux: hello $(GODOT_BIN) $(EXPORT_TEMPLATE_DIR)/linux_release.x86_64
	@mkdir -p "$(EXPORT_DIR)"
	@printf "\033[48;2;0;155;0;1m Export Linux release (%s)\033[0m\n\n" "$(PRESET)"
	@HOME="$(GODOT_HOME)" "$(GODOT_BIN)" --headless --path "$(CURDIR)" --export-release "$(PRESET)" "$(EXPORT_FILE)"
	@printf "\033[48;2;0;0;155;1m Export done: %s\033[0m\n\n" "$(EXPORT_FILE)"

clean:
	@printf "\033[48;2;155;100;0;1m Remove exported build only\033[0m\n"
	@$(RM) -r "$(EXPORT_DIR)"

fclean: clean
	@printf "\033[48;2;155;100;0;1m Remove downloaded Godot tools/templates\033[0m\n"
	@$(RM) -r "$(TOOLS)"

re: fclean all

.PHONY: all hello export-linux clean fclean re check-tools
