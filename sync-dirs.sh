#!/bin/bash

rsync -avz --progress index.html /home/craig/craigEC2/documentation/
rsync -avz --progress styleWEB.css /home/craig/craigEC2/documentation/
rsync -avz --progress 00* /home/craig/craigEC2/documentation/ --delete
rsync -avz --progress images/ /home/craig/craigEC2/documentation/images/ --delete
