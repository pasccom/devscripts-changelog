
first:
	@echo "Nothing to build"

install: install-progs install-docs

install-rpm2deb-change: rpm2deb-change
	[ -d $(DESTDIR)/usr/bin ] || mkdir -p $(DESTDIR)/usr/bin
	install -c rpm2deb-change $(DESTDIR)/usr/bin/rpm2deb-change

install-rpm2deb-changelog: rpm2deb-changelog
	[ -d $(DESTDIR)/usr/bin ] || mkdir -p $(DESTDIR)/usr/bin
	install -c rpm2deb-changelog $(DESTDIR)/usr/bin/rpm2deb-changelog

install-vc-debian: vc-debian
	[ -d $(DESTDIR)/usr/bin ] || mkdir -p $(DESTDIR)/usr/bin
	install -c vc-debian $(DESTDIR)/usr/bin/vc-debian

install-doc-rpm2deb-change: rpm2deb-change.1
	[ -d $(DESTDIR)/usr/share/man/man1 ] || mkdir -p $(DESTDIR)/usr/share/man/man1
	install -c -m 644 rpm2deb-change.1 $(DESTDIR)/usr/share/man/man1/rpm2deb-change.1

install-doc-rpm2deb-changelog: rpm2deb-changelog.1
	[ -d $(DESTDIR)/usr/share/man/man1 ] || mkdir -p $(DESTDIR)/usr/share/man/man1
	install -c -m 644 rpm2deb-changelog.1 $(DESTDIR)/usr/share/man/man1/rpm2deb-changelog.1

install-doc-vc-debian: vc-debian.1
	[ -d $(DESTDIR)/usr/share/man/man1 ] || mkdir -p $(DESTDIR)/usr/share/man/man1
	install -c -m 644 vc-debian.1 $(DESTDIR)/usr/share/man/man1/vc-debian.1

install-progs: install-rpm2deb-change install-rpm2deb-changelog install-vc-debian

install-docs: install-doc-rpm2deb-change install-doc-rpm2deb-changelog install-doc-vc-debian
