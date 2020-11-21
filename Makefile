
SUBDIRS = Luma3ds Homebrew GodMode9 DSP1 CtrNoTimeOffset
ALL = $(SUBDIRS) output

Package := dkp-pacman

VERSION_MAJOR	:=	3
VERSION_MINOR	:=	7
VERSION_MICRO	:=	5
GIT_REV="$(shell git rev-parse --short HEAD)"

all: $(ALL)


clean:
	@rm -rf Outputs
	@$(foreach dir, $(SUBDIRS), $(MAKE) -C $(dir) clean &&) true

Luma3ds:
	@$(MAKE) --always-make -C Luma3ds

Homebrew:
	@$(MAKE) --always-make -C Homebrew

GodMode9:
	@$(MAKE) --always-make -C GodMode9

DSP1:
	@$(MAKE) --always-make -C DSP1

CtrNoTimeOffset:
	@$(MAKE) --always-make -C CtrNoTimeOffset


output:
	mkdir -p Outputs
	cp Luma3ds/boot.firm Outputs
	cp Homebrew/boot.3dsx Outputs
	mkdir -p Outputs/luma/payloads
	cp GodMode9/output/GodMode9.firm Outputs/luma/payloads
	mkdir -p Outputs/CIA\(Tool\)
	mkdir -p Outputs/3ds/DSP1
	cp DSP1/DSP1.3dsx Outputs/3ds/DSP1
	cp DSP1/DSP1.smdh Outputs/3ds/DSP1
	bannertool makebanner -i "DSP1/cia/banner.png" -a "DSP1/cia/audio.wav" -o "DSP1/cia/banner.bnr"
	bannertool makesmdh -i "DSP1/cia/icon.png" -l "DSP1 - dsp firm dumper" -s "DSP1" -p "zoogie" -o "DSP1/cia/icon.icn"
	makerom -f cia -o DSP1/DSP1.cia -rsf DSP1/cia/template.rsf -target t -elf DSP1/DSP1.elf -icon DSP1/cia/icon.icn -banner DSP1/cia/banner.bnr -exefslogo
	cp DSP1/DSP1.cia Outputs/CIA\(Tool\)
	mkdir -p Outputs/3ds/ctr-no-timeoffset
	cp CtrNoTimeOffset/ctr-no-timeoffset.3dsx Outputs/3ds/ctr-no-timeoffset
	cp CtrNoTimeOffset/ctr-no-timeoffset.smdh Outputs/3ds/ctr-no-timeoffset

install:
	sudo $(Package) -S 3ds-dev 3ds-portlibs

update:
	@for dir in $(SUBDIRS); do git --git-dir $$dir/.git pull; done

fetch:
	git clone https://github.com/LumaTeam/Luma3DS.git
	git clone https://github.com/fincs/new-hbmenu.git
	git clone https://github.com/d0k3/GodMode9/tree/v1.9.2pre1
	git clone https://github.com/zoogie/DSP1.git
	git clone https://github.com/ihaveamac/ctr-no-timeoffset.git

.PHONY: $(SUBDIRS) clean output install update fetch