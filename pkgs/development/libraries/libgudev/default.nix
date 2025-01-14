{ lib, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, udev
, glib
, gobject-introspection
, gnome
, vala
}:

stdenv.mkDerivation rec {
  pname = "libgudev";
  version = "237";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1al6nr492nzbm8ql02xhzwci2kwb1advnkaky3j9636jf08v41hd";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    meson
    ninja
    vala
  ];

  buildInputs = [
    udev
    glib
  ];

  mesonFlags = [
    # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway
    "-Dtests=disabled"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dintrospection=disabled"
    "-Dvapi=disabled"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A library that provides GObject bindings for libudev";
    homepage = "https://wiki.gnome.org/Projects/libgudev";
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
