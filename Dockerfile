# Kali Linux 
# 10.20.2019
# 
# VERSION               0.0.1

# From the Kali linux base image
FROM kalilinux/kali-linux-docker

# Export display to X410 client on Windows
ENV DISPLAY=docker.for.win.localhost:0.0

# Set working dir
WORKDIR /root/

# Update / Upgrade / Dist-Upgrade
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y 

# Install Kali Large Meta Package
RUN apt-get install -y kali-linux-large	

# Add 32 bit architecture 
RUN dpkg --add-architecture i386
RUN apt-get update

# Cleanup
RUN apt autoremove -y

# Install additional metapackages
RUN apt-get install -y kali-tools-web
RUN apt-get install -y kali-tools-passwords
RUN apt-get install -y kali-tools-post-exploitation
RUN apt-get install -y kali-tools-crypto-stego
RUN apt-get install -y kali-tools-windows-resources

# Cleanup
RUN apt autoremove -y

# More Packages 

RUN apt-get -y install \
gcc-multilib g++-multilib \
rlwrap \
lftp \
python-pip python-smb python-pyftpdlib \
php-curl \
crackmapexec \
winetricks winbind wine32 \
bettercap \
fonts-powerline dconf-editor dbus-x11

# Setup wine environment
RUN wine cmd.exe /c dir
RUN winetricks python27 -q
RUN wine pip.exe install pyinstaller -q

# Setup Password Lists
RUN wget -nd -P /opt/crackstation https://crackstation.net/files/crackstation-human-only.txt.gz
RUN gunzip /opt/crackstation/crackstation-human-only.txt.gz
RUN gunzip -q -k /usr/share/wordlists/rockyou.txt.gz

# setup metasploit
RUN service postgresql start
RUN msfdb init
# searchsploit -u

# Clone git repos
RUN git clone https://github.com/rebootuser/LinEnum.git /opt/LinEnum
RUN git clone https://github.com/jondonas/linux-exploit-suggester-2.git /opt/linux-exploit-suggester-2
RUN git clone https://github.com/bitsadmin/wesng.git /opt/wesng
RUN git clone https://github.com/411Hall/JAWS.git /opt/JAWS
RUN git clone https://github.com/abatchy17/WindowsExploits.git /opt/WindowsExploits
RUN git clone https://github.com/3ndG4me/AutoBlue-MS17-010.git /opt/AutoBlue
RUN git clone https://github.com/m4ll0k/AutoNSE /opt/AutoNSE
RUN git clone https://github.com/SecWiki/linux-kernel-exploits.git /opt/linux-kernel-exploits
RUN git clone https://github.com/SecWiki/windows-kernel-exploits.git /opt/windows-kernel-exploits
RUN git clone https://github.com/diego-treitos/linux-smart-enumeration.git /opt/linux-smart-enumeration
RUN git clone https://github.com/ThePacketBender/pentest_scripts.git /opt/pentest_scripts
RUN git clone https://github.com/M4ximuss/Powerless.git /opt/powerless
RUN git clone https://github.com/andrew-d/static-binaries.git /opt/static-binaries && mkdir /build

# Downloads
RUN wget -nd -P /opt/accesschk https://web.archive.org/web/20071007120748if_/http://download.sysinternals.com/Files/Accesschk.zip
RUN unzip /opt/accesschk/Accesschk.zip -d /opt/accesschk

RUN wget -nd -P /opt/tilix https://github.com/gnunn1/tilix/releases/download/1.9.3/tilix.zip
RUN unzip /opt/tilix/tilix.zip -d /
RUN glib-compile-schemas /usr/share/glib-2.0/schemas/

# Host Linux Files

RUN mkdir /srv/linux

RUN ln -s /opt/LinEnum/LinEnum.sh /srv/linux/linenum.sh
RUN ln -s /usr/share/unix-privesc-check/unix-privesc-check /srv/linux/upc
RUN ln -s /opt/linux-exploit-suggester-2/ /srv/linux/les2.pl
RUN ln -s /opt/linux-smart-enumeration/lse.sh /srv/linux/lse.sh

# Host Windows Files

RUN mkdir /srv/windows

RUN ln -s /opt/accesschk/accesschk.exe /srv/windows/accesschk.exe
RUN ln -s /opt/sysinternals/ /srv/windows/sysinternals
RUN ln -s /usr/share/windows-resources/powersploit/ /srv/windows/powersploit
RUN ln -s /usr/share/nishang/ /srv/windows/nishang
RUN ln -s /opt/JAWS/jaws-enum.ps1 /srv/windows/jaws.ps1
RUN ln -s /usr/share/windows-resources/binaries/nc.exe /srv/windows/nc.exe
RUN ln -s /opt/beroot/beRoot.exe /srv/windows/beroot.exe
RUN ln -s /usr/share/windows-resources/mimikatz/ /srv/windows/mimikatz
RUN ln -s /opt/powerless/Powerless.bat /srv/windows/pless.bat

# Host RFI

RUN mkdir /srv/rfi
RUN echo "<html><body><p>PHP INFO PAGE</p><br /><?php phpinfo(); ?></body></html>" > /srv/rfi/phpinfo.php

# Update db for locate
RUN updatedb

# ZSH
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Indicate we want to expose ports 80 and 443
EXPOSE 8080/tcp
EXPOSE 22/tcp
