FROM l3iggs/archlinux

MAINTAINER Mikkel Kroman <mk@maero.dk>

ADD mirrorlist /etc/pacman.d/mirrorlist

RUN pacman -Sy --noconfirm --noprogressbar base-devel wget && \
  rm -rf /var/cache/pacman/pkg

RUN useradd -m -U user && \
  echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER user

# Get the cower developers gpg key for package verification.
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 487EACC08557AD082088DABA1EB2638FF56C0C53 

RUN mkdir ~/src && cd ~/src && \
  wget https://aur.archlinux.org/packages/co/cower/cower.tar.gz && \
  tar xvzf cower.tar.gz && cd cower && \
  makepkg --noconfirm --syncdeps --install && cd .. && \
  rm -rf cower/ cower.tar.gz

# Download and install pacaur.
RUN cd ~/src && cower -d pacaur && cd pacaur && \
  makepkg --noconfirm --syncdeps --install && cd .. && \
  rm -rf pacaur/ pacaur.tar.gz
