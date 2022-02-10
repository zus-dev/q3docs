<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.or
g/TR/html4/loose.dtd">
changequote([*,*])dnl
changecom([*<!--*],[*-->*])dnl
define(ENT_title,[*(TITLE HERE)*])dnl
define(TITLE,<h1>$1</h1>)dnl
define(SYNOPSIS,<h2>Synopsis</h2><p>$1</p>)dnl
define(ENT_mod,game module)dnl
define(ENT_angbra,[*&lt;*])dnl
define(ENT_angket,[*&gt;*])dnl
define(ENT_amp,[*&amp;*])dnl
define(ENT_authornick,PhaethonH)dnl
define(ENT_authormail,[*PhaethonH@gmail.com*])dnl
define(FILENAME,<tt>$1</tt>)dnl
define(FUNCNAME,<var>$1</var>)dnl
define(VARNAME,<var>$1</var>)dnl
define(CONSTNAME,<tt>$1</tt>)dnl
define(VERBATIM,<hr><pre>$1</pre><hr>)dnl
define(KEYB,<tt>$1</tt>)dnl
define(_P,<p>$1</p>)dnl
define(SECT,<a name="$1"></a><h2>$2</h2>[*undefine([*_SN*])define(_SN,$1)*])dnl
define(SECT1,<h3>$1</h3>)dnl
define(SECT2,<h4>$1</h4>)dnl
define(QUOT,&quot;$1&quot;)dnl
define(XREF,[*<a href="#$1">$2</a>*])dnl
define(QV,[*See also <a href="#$1">$1</a>*])dnl quod vide -> "see which"
define(LIST_ORDERED,<ol>$1</ol>)dnl
define(LIST_UNORDERED,<ul>$1</ul>)dnl
define(LIST_DICT,<dl>$1</dl>)dnl
define(LI,<li>$1</li>)dnl
define(DT,<dt>$1</dt>)dnl
define(DD,<dd>$1</dd>)dnl
define(DICT,[*DT(<a name="_SN().$1">[*$1*])DD([*$2*])*])dnl
define(ADDRESS,[*<address>$1</address>*])dnl
define(_LF,[*<br>*])dnl
dnl
