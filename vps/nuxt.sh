cd /home/forge/[site-name]
git checkout .
git pull origin [branch]
npm ci --omit=dev
npm run build
pm2 start npm --name "[site-name]" --watch -- start
