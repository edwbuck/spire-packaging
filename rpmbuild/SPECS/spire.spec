# Generated by go2rpm 1.11.1
%bcond_without check

# https://github.com/spiffe/spire
%global goipath         github.com/spiffe/spire
Version:                1.9.4

%gometa -L

%global common_description %{expand:
The SPIFFE Runtime Environment.}

%global golicenses      LICENSE
%global godocs          doc examples CONTRIBUTING.md MAINTAINERS.md README.md\\\
                        RELEASING.md SECURITY.md ROADMAP.md\\\
                        .markdownlint.yaml ADOPTERS.md CHANGELOG.md CODE-OF-\\\
                        CONDUCT.md release/windows/spire-extras/README.md\\\
                        release/windows/spire/README.md release/posix/spire-\\\
                        extras/README.md release/posix/spire/README.md\\\
                        support/oidc-discovery-provider/README.md

Name:           spire
Release:        %autorelease
Summary:        The SPIFFE Runtime Environment

License:        Apache-2.0
URL:            %{gourl}
Source:         %{gosource}

%description %{common_description}

%gopkg

%prep
%goprep -A
%autopatch -p1

%generate_buildrequires
%go_generate_buildrequires

%build
for cmd in cmd/* ; do
  %gobuild -o %{gobuilddir}/bin/$(basename $cmd) %{goipath}/$cmd
done
for cmd in pkg/common/catalog/testplugin support/oidc-discovery-provider pkg/common/peertracker; do
  %gobuild -o %{gobuilddir}/bin/$(basename $cmd) %{goipath}/$cmd
done

%install
%gopkginstall
install -m 0755 -vd                     %{buildroot}%{_bindir}
install -m 0755 -vp %{gobuilddir}/bin/* %{buildroot}%{_bindir}/

%if %{with check}
%check
%gocheck
%endif

%files
%license LICENSE
%doc doc examples CONTRIBUTING.md MAINTAINERS.md README.md RELEASING.md
%doc SECURITY.md ROADMAP.md .markdownlint.yaml ADOPTERS.md CHANGELOG.md
%doc CODE-OF-CONDUCT.md release/windows/spire-extras/README.md
%doc release/windows/spire/README.md release/posix/spire-extras/README.md
%doc release/posix/spire/README.md support/oidc-discovery-provider/README.md
%{_bindir}/*

%gopkgfiles

%changelog
%autochangelog
