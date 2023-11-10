@echo on
cd C:\ia
git fetch origin
git reset --hard origin/main
REM Înapoim la starea inițială
powershell -Command "(Get-Content 'C:\ia\config\puma.rb') -replace 'workers ENV.fetch\(\"WEB_CONCURRENCY\"\) { 4 }', '#workers ENV.fetch(\"WEB_CONCURRENCY\") { 4 }' | Set-Content 'C:\ia\config\puma_temp.rb'"
move /y "C:\ia\config\puma_temp.rb" "C:\ia\config\puma.rb"
cd C:\ia
del tmp\pids\server.pid
rails s
pause