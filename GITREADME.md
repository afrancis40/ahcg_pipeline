EADME
#Alicia Francis 

#Steps to change the remote url for git repositories
- git clone https://github.com/shashidhar22/ahcg_pipeline.git
- fork original repository on github
- ls -a
- cd .git
- vim config
- find url line
- git remote set-url origin htttps://github.com/username/otherrepository.git
	- change the username to your own
- save :x
- git remote -v (to check if remote URL has changed)

#To not share a project
- ls -a 
- vi .gitignore 
- to not push certain files add filenames 	
	Ex: *.a -> no .a files
	Ex: !lib.a -> no track lib.a files

#Commit the file that youve changed in your local repository
-git add "file name" <-----DO THIS ONE 
-git commit -m "Some comment"  ....and add small message what you changed

#Put on Github
-git push origin master
