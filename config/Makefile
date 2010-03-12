all:
	@echo 'Usage:'
	@echo ''
	@echo ' make pack  -  pack all files into huskycfg.tar.gz'
	@echo ' make ru    -  extract russian config from files into ru folder'
	@echo ' make en    -  extract english config from files into en folder'
	@echo ''
pack:
	tar -cvzf huskycfg.tar.gz Makefile areas cc_cfg fileareas htick_cfg links \
	   	config nltools_cfg packer path robots route_cfg
en:
	-@mkdir en
	grep -v '^#RU#' config | sed s/^#EN#/#/ >./en/config
	grep -v '^#RU#' areas | sed s/^#EN#/#/ >./en/areas
	grep -v '^#RU#' cc_cfg | sed s/^#EN#/#/ >./en/cc_cfg
	grep -v '^#RU#' fileareas | sed s/^#EN#/#/ >./en/fileareas
	grep -v '^#RU#' htick_cfg | sed s/^#EN#/#/ >./en/htick_cfg
	grep -v '^#RU#' links | sed s/^#EN#/#/ >./en/links
	grep -v '^#RU#' nltools_cfg | sed s/^#EN#/#/ >./en/nltools_cfg
	grep -v '^#RU#' packer | sed s/^#EN#/#/ >./en/packer
	grep -v '^#RU#' path | sed s/^#EN#/#/ >./en/path
	grep -v '^#RU#' robots | sed s/^#EN#/#/ >./en/robots
	grep -v '^#RU#' route_cfg | sed s/^#EN#/#/ >./en/route_cfg
ru:
	-@mkdir ru
	grep -v '^#EN#' config | sed s/^#RU#/#/ >./ru/config
	grep -v '^#EN#' areas | sed s/^#RU#/#/ >./ru/areas
	grep -v '^#EN#' cc_cfg | sed s/^#RU#/#/ >./ru/cc_cfg
	grep -v '^#EN#' fileareas | sed s/^#RU#/#/ >./ru/fileareas
	grep -v '^#EN#' htick_cfg | sed s/^#RU#/#/ >./ru/htick_cfg
	grep -v '^#EN#' links | sed s/^#RU#/#/ >./ru/links
	grep -v '^#EN#' nltools_cfg | sed s/^#RU#/#/ >./ru/nltools_cfg
	grep -v '^#EN#' packer | sed s/^#RU#/#/ >./ru/packer
	grep -v '^#EN#' path | sed s/^#RU#/#/ >./ru/path
	grep -v '^#EN#' robots | sed s/^#RU#/#/ >./ru/robots
	grep -v '^#EN#' route_cfg | sed s/^#RU#/#/ >./ru/route_cfg

