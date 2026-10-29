#You can start the MyST web server later with: myst start 
#You can build all content with: myst build --all

build:
	myst build --all

html:
	HOST=0.0.0.0 myst build --keep-host --html 

readthedocs:
	myst init --readthedocs

init:
	HOST=0.0.0.0 myst init

start:
	HOST=0.0.0.0 JUPYTER_BASE_URL="http://localhost:8888" JUPYTER_TOKEN=""  myst start --keep-host 

clean:
	myst clean --all

toc:
	myst init --write-toc

purge:
	kill -9 `lsof -i|grep *:3000| cut -d ' ' -f 2`
