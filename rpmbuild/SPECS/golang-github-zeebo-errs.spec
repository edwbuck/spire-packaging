# Generated by go2rpm 1.11.1
%bcond_without check
%global debug_package %{nil}

# https://github.com/zeebo/errs
%global goipath         github.com/zeebo/errs
Version:                1.3.0

%gometa -L 

%global common_description %{expand:
Errs is a package for making errors friendly and easy.}

%global golicenses      LICENSE
%global godocs          README.md AUTHORS errdata/README.md

Name:           golang-github-zeebo-errs
Release:        %autorelease
Summary:        Errs is a package for making errors friendly and easy

License:        MIT
URL:            %{gourl}
Source:         %{gosource}

%description %{common_description}

%gopkg

%prep
%goprep -A
%autopatch -p1

%generate_buildrequires
%go_generate_buildrequires

%install
%gopkginstall

%if %{with check}
%check
%gocheck
%endif

%gopkgfiles

%changelog
%autochangelog
