# $Id: $
#
# build rpm package for perl-PrometheusMetrics
#
# Copyright (C) 2021 Académie de Nancy-Metz,
# Xavier Humbert <xavier.humbert@ac-nancy-metz.fr>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

%define rel %(date '+%Y%m%d%H%M')

Name:			perl-PrometheusMetrics
Version:		1.0.4
Release:		%{rel}%{?dist}
Summary:		Export perfdatas in OpenMetrics format
License:		GPL2
Group:			Development/Libraries
BuildArch:		noarch
Source0:		PrometheusMetrics-%{version}.tar.gz

Packager:		Xavier Humbert <xavier.humbert@ac-nancy-metz.fr>
BuildRoot:		%{_tmppath}/%{name}-%{version}-%{release}-root

Provides:		perl(PrometheusMetrics) = %{version}
BuildRequires:	perl-Test-Simple

%description
A perl module that exports perfdatas in OpenMetrics format

%prep
rm -rf %{_builddir}/PrometheusMetrics-%{version}
%setup -D -n PrometheusMetrics-%{version}
chmod -R u+w %{_builddir}/PrometheusMetrics-%{version}

if [ -f pm_to_blib ]; then rm -f pm_to_blib; fi

%build
%{__perl} Makefile.PL OPTIMIZE="$RPM_OPT_FLAGS" INSTALLDIRS=site \
	INSTALLSITEBIN=%{_bindir} INSTALLSITESCRIPT=%{_bindir} \
	INSTALLSITEMAN1DIR=%{_mandir}/man1 INSTALLSITEMAN3DIR=%{_mandir}/man3 \
	INSTALLSCRIPT=%{_bindir}
make %{?_smp_mflags}

%check
make test

%install
rm -rf $RPM_BUILD_ROOT
make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} \;
find $RPM_BUILD_ROOT -type f -name '*.bs' -size 0 -exec rm -f {} \;
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null \;
%{_fixperms} $RPM_BUILD_ROOT/*

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{perl_sitelib}/*
%{_mandir}/man3/*

%changelog
* Wed Sep 1 2021 Xavier Humbert <xavier.humbert@ac-nancy-metz.fr> 1.0.3
- set timestamp in milliseconds

* Wed Aug 18 2021 Xavier Humbert <xavier.humbert@ac-nancy-metz.fr> 1.0
- Initial release
