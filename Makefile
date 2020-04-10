# make git m="Commit Message"
git:
	git add .
	git commit -m "$m"
	git push -u origin master
