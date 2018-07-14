# Distributed under the terms of the GNU General Public License v2
# Mostly borrowed from Fedora spec files

EAPI=4

inherit multilib eutils

MY_PV=3.2.9
DESCRIPTION="Provides for an easy dynamic modification of a user's environment via modulefiles."
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/modules/Modules/modules-${MY_PV}/modules-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm64"
IUSE=""

DEPEND="
	>=dev-lang/tcl-8.4
	>=dev-tcltk/tclx-8.4
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/modules-${MY_PV}"

src_prepare() {
	epatch "${FILESDIR}/modules-errorLine.patch" \
	"${FILESDIR}/${PN}-${MY_PV}-bindir.patch"
	(
		echo "# Add ${PN} bindir to be checked for broken linkage"
		echo "SEARCH_DIRS=\"/usr/share/Modules/bin\""
	) > "${S}/96-${PN}" || die "revdep-rebuild file creation failed"
}

src_configure() {
	# FIXME: this puts binaries into /usr/share, modulecmd should
	# probably be in /usr/libexec, but the packages does not support
	# such a setup
	econf \
		--enable-shell-funcs \
		--enable-shell-alias \
		--enable-shell-eval \
		--disable-versioning \
		--prefix=/usr/share \
		--exec-prefix=/usr/share/Modules \
		--with-man-path=/usr/share/man \
		--with-module-path=/etc/modulefiles \
		--with-tcl-lib=/usr/$(get_libdir) \
		--with-tcl-inc=/usr/include

		#--with-debug=42 --with-log-facility-debug=stderr
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README TODO
	into /usr/share/Modules
	dobin "${FILESDIR}/createmodule.sh"
	insinto /etc/profile.d
	doins "${FILESDIR}/modules.sh"
	sed -i \
		-e 's:@exec_prefix@:/usr/share/Modules:g' \
		"${D}/etc/profile.d/modules.sh" || die "sed failed"
	dosym /usr/share/Modules/init/csh /etc/profile.d/modules.csh
	dodir /etc/modulefiles
	insinto /etc/revdep-rebuild
	doins "96-${PN}"
}
