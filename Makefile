# make push m="Commit Message"
push:
	git add *
	git commit -m "$m"
	git push -u origin master

# make pull
pull:
	git pull