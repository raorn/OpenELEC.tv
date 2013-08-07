################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="dbus"
PKG_VERSION="1.6.12"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://dbus.freedesktop.org"
PKG_URL="http://dbus.freedesktop.org/releases/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS="expat"
PKG_BUILD_DEPENDS_TARGET="toolchain expat"
PKG_BUILD_DEPENDS_HOST="toolchain expat:host"
PKG_PRIORITY="required"
PKG_SECTION="system"
PKG_SHORTDESC="dbus: simple interprocess messaging system"
PKG_LONGDESC="D-Bus is a message bus, used for sending messages between applications. This package contains the D-Bus daemon and related utilities and the dbus shared library."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="export ac_cv_have_abstract_sockets=yes \
                           --libexecdir=/usr/lib/dbus \
                           --enable-verbose-mode \
                           --enable-asserts \
                           --enable-checks \
                           --disable-tests \
                           --disable-ansi \
                           --disable-xml-docs \
                           --disable-doxygen-docs \
                           --enable-abstract-sockets \
                           --disable-x11-autolaunch \
                           --disable-selinux \
                           --disable-libaudit \
                           --disable-systemd \
                           --enable-dnotify \
                           --enable-inotify \
                           --with-xml=expat \
                           --without-x \
                           --with-dbus-user=dbus"

PKG_CONFIGURE_OPTS_HOST="--enable-verbose-mode \
                         --enable-asserts \
                         --enable-checks \
                         --disable-tests \
                         --disable-xml-docs \
                         --disable-doxygen-docs"

post_makeinstall_host() {
  $ROOT/$TOOLCHAIN/bin/dbus-daemon --introspect > introspect.xml
}

post_makeinstall_target() {
  rm -rf $INSTALL/lib/systemd
  rm -rf $INSTALL/etc/rc.d
  rm -rf $INSTALL/usr/lib/dbus-1.0/include
}

post_install() {
  add_user dbus x 81 81 "System message bus" "/" "/bin/sh"
  add_group dbus 81
  add_group netdev 497

  echo "chmod 4750 $INSTALL/usr/lib/dbus/dbus-daemon-launch-helper" >> $FAKEROOT_SCRIPT
  echo "chown 0:81 $INSTALL/usr/lib/dbus/dbus-daemon-launch-helper" >> $FAKEROOT_SCRIPT
}
