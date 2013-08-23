#!/bin/bash
ssh -T git@github.com
rake generate
git add .
read -p "Commit description: " desc
git commit -m "$desc"
git push origin source
rake deploy

