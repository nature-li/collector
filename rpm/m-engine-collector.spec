Name: m-engine-collector
Version: 1.0.0
Release: 1
Summary: xxx engine lyg test
License: Commercial
Group: xxx
Packager: lyg@xxx.com
BuildRoot:%{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: x86_64
AutoReq: no

%define datapath $RPM_BUILD_ROOT/www/collector

%description
xxx engine lyg test

%prep

%build

%install
rm -fr $RPM_BUILD_ROOT
mkdir -p %{datapath}

TRUNK_ROOT_DIR="$OLDPWD/target"
cp -r $TRUNK_ROOT_DIR/collector-1.0/*                  %{datapath}/
chmod +x %{datapath}/bin/*.sh

%post

%postun
rm -rf %{datapath}/

%files
%defattr(-,lyg,lyg)
/www/collector

%debug_package %{nil}
%changelog
* Tue Sep 5 2017 liyanguo <lyg@xxx.com>
- create this spec file
