## GNU Make Variables
top_srcdir := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

## Project Variables
VERSION=1.9.4
DOWNLOAD_URL=github.com/spiffe/spire/archive/refs/tags/v$(VERSION).tar.gz

## RPM variables
RPM_TOPDIR := $(top_srcdir)rpmbuild
RPM_RPMDIR := $(shell rpm --define="_topdir $(RPM_TOPDIR)" --eval %{_rpmdir})
RPM_SOURCEDIR := $(shell rpm --define="_topdir $(RPM_TOPDIR)" --eval %{_sourcedir})
RPM_SPECDIR := $(shell rpm --define="_topdir $(RPM_TOPDIR)" --eval %{_specdir})
RPM_SRCRPMDIR := $(shell rpm --define="_topdir $(RPM_TOPDIR)" --eval %{_srcrpmdir})
RPM_BUILDDIR := $(shell rpm --define="_topdir $(RPM_TOPDIR)" --eval %{_builddir})

RPM_SPECFILE := $(RPM_SPECDIR)/spire.spec
RPM_SRC_TGZ := $(RPM_SOURCEDIR)/spire-$(VERSION).tar.gz
SRPM_OUTFILE := $(RPM_SRCRPMDIR)/$(shell rpm -q --specfile rpmbuild/SPECS/spire.spec --eval "%{_rpmfilename}" | grep spire-1.9.4).rpm


## PRISTINE RPM variables
PRISTINE_TOPDIR := $(top_srcdir)pristine
PRISTINE_RPMDIR := $(shell rpm --define="_topdir $(PRISTINE_TOPDIR)" --eval %{_rpmdir})
PRISTINE_SOURCEDIR := $(shell rpm --define="_topdir $(PRISTINE_TOPDIR)" --eval %{_sourcedir})
PRISTINE_SPECDIR := $(shell rpm --define="_topdir $(PRISTINE_TOPDIR)" --eval %{_specdir})
PRISTINE_SRCRPMDIR := $(shell rpm --define="_topdir $(PRISTINE_TOPDIR)" --eval %{_srcrpmdir})
PRISTINE_BUILDDIR := $(shell rpm --define="_topdir $(PRISTINE_TOPDIR)" --eval %{_builddir})

PRISTINE_SPECFILE := $(PRISTINE_SPECDIR)/spire.spec


$(PRISTINE_SPECFILE): $(SRPM_OUTFILE) | $(PRISTINE_RPMDIR) $(PRISTINE_SOURCEDIR) $(PRISTINE_SPECDIR) $(PRISTINE_SRCRPMDIR) $(PRISTINE_BUILDDIR)
	rpm --define="_topdir $(PRISTINE_TOPDIR)" --install $(SRPM_OUTFILE)

rpm: $(SRPM_OUTFILE) $(PRISTINE_SPECFILE)
	rpmbuild --define="_topdir $(PRISTINE_TOPDIR)" -bb $(PRISTINE_SPECFILE)
	
.PHONY: download
download: $(RPM_SRC_TGZ)

.PHONY: srpm
srpm: $(SRPM_OUTFILE)

.PHONY: rpmbuild
rpmbuild: $(RPM_TOPDIR)

.PHONY: rpmbuild/RPMS
rpmbuild/RPMS: $(RPM_RPMDIR)

.PHONY: rpmbuild/SOURCES
rpmbuild/SOURCES: $(RPM_RPMSRCDIR)

.PHONY: rpmbuild/SOURCES
rpmbuild/SOURCES: $(RPM_SOURCEDIR)

.PHONY: rpmbuild/SPECS
rpmbuild/SPECS: $(RPM_SPECDIR)

.PHONY: rpmbuild/SRPMS
rpmbuild/SRCRPMS: $(RPM_SRCRPMDIR)

.PHONY: rpmbuild/BUILD
rpmbuild/BUILD: $(RPM_BUILDDIR)

$(RPM_SRC_TGZ): | $(RPM_SOURCEDIR)
	wget -O "$(RPM_SRC_TGZ)" "$(DOWNLOAD_URL)"

$(RPM_TOPDIR):
	mkdir $(RPM_TOPDIR)

$(RPM_RPMDIR): | $(RPM_TOPDIR)
	mkdir $(RPM_RPMDIR)

$(RPM_SOURCEDIR): | $(RPM_TOPDIR)
	mkdir $(RPM_SOURCEDIR)

$(RPM_SPECDIR): | $(RPM_TOPDIR)
	mkdir $(RPM_SPECDIR)

$(RPM_SRCRPMDIR): | $(RPM_TOPDIR)
	mkdir $(RPM_SRCRPMDIR)

$(RPM_BUILDDIR): | $(RPM_TOPDIR)
	mkdir $(RPM_BUILDDIR)

$(SRPM_OUTFILE): $(RPM_SRC_TGZ) $(RPM_SPECFILE) | $(RPM_RPMDIR) $(RPM_SOURCEDIR) $(RPM_SPECDIR) $(RPM_SRCRPMDIR) $(RPM_BUILDDIR)
	rpmbuild --define="_topdir $(RPM_TOPDIR)" -bs $(RPM_SPECFILE)

$(PRISTINE_TOPDIR):
	mkdir $(PRISTINE_TOPDIR)

$(PRISTINE_RPMDIR): | $(PRISTINE_TOPDIR)
	mkdir $(PRISTINE_RPMDIR)

$(PRISTINE_SOURCEDIR): | $(PRISTINE_TOPDIR)
	mkdir $(PRISTINE_SOURCEDIR)

$(PRISTINE_SPECDIR): | $(PRISTINE_TOPDIR)
	mkdir $(PRISTINE_SPECDIR)

$(PRISTINE_SRCRPMDIR): | $(PRISTINE_TOPDIR)
	mkdir $(PRISTINE_SRCRPMDIR)

$(PRISTINE_BUILDDIR): | $(PRISTINE_TOPDIR)
	mkdir $(PRISTINE_BUILDDIR)

.PHONY: clean
clean:
	rm -rf $(RPM_SRCRPMDIR)
	rm -rf $(RPM_RPMDIR)
	rm -rf $(RPM_BUILDDIR)
