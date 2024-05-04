# vim: set filetype=make:

default:
    just --list

generation := `sudo nix-env --list-generations -p /nix/var/nix/profiles/system | grep current | awk '{print "Generation", $1}'`

switch:
	git checkout local-changes
	git commit -am "{{generation}}"
	nh os switch .
	nh home switch .

push:
	git checkout main
	git pull origin main
	git merge --squash local-changes
	git commit -a
	git push
	git checkout local-changes
	git reset --hard main


# rebuild:
#     bash ./rebuild.sh

# TODO have a squash command to squash all the commits made and push them
