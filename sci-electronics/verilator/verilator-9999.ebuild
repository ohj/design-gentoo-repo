# Distributed under the terms of the GNU General Public License v2+

EAPI=4
inherit autotools multilib git-2

EGIT_REPO_URI="http://git.veripool.org/git/verilator"

DESCRIPTION="Verilog compiler and simulator"
HOMEPAGE="http://www.veripool.org/wiki/verilator"
SRC_URI=""

LICENSE="|| ( Artistic-2 LGPL-3 )"
SLOT="${PV}"
KEYWORDS=""
IUSE="doc +modulefile"

DEPEND="
	dev-perl/SystemPerl
	dev-perl/Verilog-Perl
	doc? ( app-text/texlive )
"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoconf
	(
		echo "# Add ${PN} bindir to be checked for broken linkage"
		echo "SEARCH_DIRS=\"/opt/${PN}/${PV}/bin\""
	) > "${S}/96-${P}" || die "revdep-rebuild file creation failed"
}

src_configure() {
	econf \
		--enable-defenv \
		--prefix /opt/${PN}/${PV} \
		--mandir=/opt/${PN}/${PV}/share/man \
		--infodir=/opt/${PN}/${PV}/share/info \
		--datadir=/opt/${PN}/${PV}/share
		--sysconfdir=/etc \
		--libdir=/opt/${PN}/${PV}/$(get_libdir)
}

src_compile() {
	emake SYSTEMPERL_INCLUDE=/usr/include/SystemPerl || die "emake failed"
	emake SYSTEMPERL_INCLUDE=/usr/include/SystemPerl README || \
		die "emake README failed"
	if use doc ; then
		emake SYSTEMPERL_INCLUDE=/usr/include/SystemPerl info || \
			die "emake info failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	insinto /opt/${PN}/${PV}/share/doc/${PF}
	doins README
	use doc && doins verilator.html verilator.pdf verilator.txt
	insinto /etc/revdep-rebuild
	doins "96-${P}"
	if use modulefile ; then
		insinto /etc/modulefiles/${PN}
		newins "${FILESDIR}/verilator.modulefile" "${PV}"
		sed -i \
			-e "s:@version@:${PV}:g" \
			-e "s:@prefix@:/opt/${PN}/\\\$version:g" \
			-e "s:@bindir@:\\\$prefix/bin:g" \
			-e "s:@mandir@:\\\$prefix/share/man:g" \
			"${D}/etc/modulefiles/${PN}/${PV}" || die "sed failed"
	fi
}
