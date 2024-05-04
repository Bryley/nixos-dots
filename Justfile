
default:
    just --list

generation := `sudo nix-env --list-generations -p /nix/var/nix/profiles/system | grep current | awk '{print "Generation", $1}'`

switch:
	git commit -am "{{generation}}"
	nh os switch .

rebuild:
    bash ./rebuild.sh

# TODO have a squash command to squash all the commits made and push them
