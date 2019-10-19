cd ~/My-Qwiklabs-SpeedRun-Tank/courses/developingapps/python/appengine/start

nano frontend/quiz/webapp/templates/home.html frontend/quiz/webapp/templates/home.html

mv frontend/quiz/webapp/templates/home.html frontend/quiz/webapp/templates/homev1.html

mv frontend/quiz/webapp/templates/home2.html frontend/quiz/webapp/templates/home.html

ls frontend/quiz/webapp/templates/

gcloud app deploy ./frontend/app.yaml --no-promote \
--no-stop-previous-version