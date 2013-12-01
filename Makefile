INSTALL = /usr/bin/install -c

# Installation directories
prefix = ${DESTDIR}/usr
exec_prefix = ${prefix}
mandir = ${prefix}/share/man/man1
bindir = ${exec_prefix}/bin
etcdir = ${DESTDIR}/etc

man:
	cat debian/README.md | ronn > xscreensaver-pi-hdmi.1

clean:
	rm -f xscreensaver-pi-hdmi.1

install:
	$(INSTALL) -m 755 -d $(bindir)
	$(INSTALL) -m 755 -d $(mandir)
	$(INSTALL) -m 755 bin/xscreensaver-pi-hdmi $(bindir)
	$(INSTALL) -m 644 xscreensaver-pi-hdmi.1 $(mandir)
