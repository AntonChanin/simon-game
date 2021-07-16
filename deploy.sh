#!/usr/bin/env sh

# остановить публикацию при ошибках
set -e

# сборка
npm run build

# переход в каталог сборки
cd dist

git init
git add -A
git commit -m 'deploy'

# если вы публикуете по адресу https://antonchanin.github.io
# git push -f git@github.com:antonchanin/antonchanin.github.io.git master

# если вы публикуете по адресу https://antonchanin.github.io/simon-game
# git push -f git@github.com:antonchanin/simon-game.git master:gh-pages

cd -