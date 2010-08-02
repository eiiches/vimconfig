" Vim syntax file example
" Put it to ~/.vim/after/syntax/ and tailor to your needs.

let glib_deprecated_errors = 1
let gobject_deprecated_errors = 1
let gdk_deprecated_errors = 1
let gdkpixbuf_deprecated_errors = 1
let gtk_deprecated_errors = 1
let gimp_deprecated_errors = 1

if version < 600
  so <sfile>:p:h/glib.vim
  so <sfile>:p:h/gobject.vim
  so <sfile>:p:h/gdk.vim
  so <sfile>:p:h/gdkpixbuf.vim
  so <sfile>:p:h/gtk.vim
  so <sfile>:p:h/gimp.vim
else
	runtime! syntax/atk.vim
	runtime! syntax/atspi.vim
	runtime! syntax/cairo.vim
	runtime! syntax/clutter.vim
	runtime! syntax/dbusglib.vim
	runtime! syntax/evince.vim
	runtime! syntax/gail.vim
	runtime! syntax/gconf.vim
	runtime! syntax/gdkpixbuf.vim
	runtime! syntax/gdk.vim
	runtime! syntax/gimp.vim
	runtime! syntax/gio.vim
	runtime! syntax/glib.vim
	runtime! syntax/gnomedesktop.vim
	runtime! syntax/gnomevfs.vim
	runtime! syntax/gobject.vim
	runtime! syntax/goocanvas.vim
	runtime! syntax/gtkglext.vim
	runtime! syntax/gtksourceview.vim
	runtime! syntax/gtk.vim
	runtime! syntax/libglade.vim
	runtime! syntax/libgnomecanvas.vim
	runtime! syntax/libgnomeui.vim
	runtime! syntax/libgnome.vim
	runtime! syntax/libgsf.vim
	runtime! syntax/libnotify.vim
	runtime! syntax/liboil.vim
	runtime! syntax/librsvg.vim
	runtime! syntax/libsoup.vim
	runtime! syntax/libunique.vim
	runtime! syntax/libwnck.vim
	runtime! syntax/orbit2.vim
	runtime! syntax/pango.vim
	runtime! syntax/poppler.vim
	runtime! syntax/vte.vim
	runtime! syntax/xlib.vim
	runtime! syntax/gtkextends.vim
endif


" vim: set ft=vim :
