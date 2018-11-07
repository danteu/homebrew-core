class Gtkspell3 < Formula
  desc "Gtk widget for highlighting and replacing misspelled words"
  homepage "https://gtkspell.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtkspell/3.0.10/gtkspell3-3.0.10.tar.xz"
  sha256 "b040f63836b347eb344f5542443dc254621805072f7141d49c067ecb5a375732"

  bottle do
    sha256 "8649edc45b2ac203946b689fbeb11a5624e17d0f9dbcbad0e7f767a5835a1e78" => :mojave
    sha256 "9f4f62410af27e84a4cec1f05b4f3017e9712f40f0d937041b89c29cf2a1dcd0" => :high_sierra
    sha256 "2cf46aa9544572a29d3278fd3420582171e239f2731ade416e00d0521a883f9b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "enchant"
  depends_on "gtk+3"

  def install
    system "autoreconf", "-fi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--enable-vala",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkspell/gtkspell.h>

      int main(int argc, char *argv[]) {
        GList *list = gtk_spell_checker_get_language_list();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    enchant = Formula["enchant"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{enchant.opt_include}/enchant-2
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/gtkspell-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{enchant.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lenchant-2
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtkspell3-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
