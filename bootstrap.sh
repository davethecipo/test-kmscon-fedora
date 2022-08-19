#!/usr/bin/env bash
# Install requirements
dnf install -y meson systemd-devel kernel-headers libxkbcommon-devel libdrm-devel mesa-libgbm-devel libglvnd-devel pango-devel libxslt check-devel
# Install libtsm
git clone https://github.com/Aetf/libtsm
chown -R vagrant libtsm && mkdir -p libtsm/build && chown -R vagrant libtsm/build  && cd libtsm/build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j4
sudo make install
echo "/usr/local/lib64/" > /etc/ld.so.conf.d/libtsm.conf
ldconfig
# Install kmscon
cd /home/vagrant
git clone https://github.com/Aetf/kmscon
cd /home/vagrant/kmscon
chown -R vagrant kmscon
meson build
meson configure build -Dvideo_fbdev=disabled -Dfont_unifont=disabled -Drenderer_bbulk=disabled -Dextra_debug=true
sudo meson install -C build/
# install fish and oh-my-posh to test if glyphs are rendered
dnf install -y fish
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip
oh-my-posh font install FiraCode
# configure kmscon
# don't use systemd for now, because it introduces other problems; instead launches 
# kmsconvt manually
# cp /usr/lib/systemd/system/kmsconvt\@.service /etc/systemd/system/
# this command is need to allow systemd launchig the kmscon executable
# chcon -R -t bin_t /usr/local/bin/kmscon
# mkdir /etc/kmscon
# echo """font-name=FiraCode Nerd Font Mono
# font-size=18
# drm
# hwaccel
# xkb-layout=en
# """ > /etc/kmscon/kmscon.conf
#systemctl enable --now kmsconvt@tty4.service
# manually run kmscon as root like this:
kmsconvt --vt=tty4 --no-switchvt --debug --font-name="FiraCode Nerd Font Mono" --font-engine=pango --kwaccel &
