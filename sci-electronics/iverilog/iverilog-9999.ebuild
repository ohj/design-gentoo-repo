# Distributed under the terms of the GNU General Public License v2+

EAPI=4

inherit eutils multilib git-2

EGIT_REPO_URI="git://github.com/steveicarus/${PN}.git"
DESCRIPTION="Verilog compiler with event based simulation support"
HOMEPAGE="http://iverilog.icarus.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS=""
IUSE="examples +modulefile"

DEPEND="
	dev-util/gperf
"
RDEPEND="
	modulefile? ( app-admin/environment-modules )
"

# Taken from gentoo ebuild
src_prepare() {
	# Fix tests
	sh autoconf.sh
	mkdir -p lib/ivl
	touch lib/ivl/ivl
	sed -i -e 's/driver\/iverilog -B./IVERILOG_ROOT="." driver\/iverilog -B./' Makefile.in || die
	(
		echo "# Add ${PN} libdir and bindir to be checked for broken linkage"
		echo "SEARCH_DIRS=\"/opt/${PN}/${PV}/$(get_libdir) /opt/${PN}/${PV}/bin\""
	) > "${S}/96-${PN}-${PV}" || die "revdep-rebuild file creation failed"
}

src_configure() {
	econf \
		--prefix=/opt/${PN}/${PV} \
		--mandir=/opt/${PN}/${PV}/share/man \
		--infodir=/opt/${PN}/${PV}/share/info \
		--datadir=/opt/${PN}/${PV}/share \
		--libdir=/opt/${PN}/${PV}/$(get_libdir)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake -j1 \
		prefix="${D}"/opt/${PN}/${PV} \
		mandir="${D}"/opt/${PN}/${PV}/share/man \
		infodir="${D}"/opt/${PN}/${PV}/share/info \
		datadir="${D}"/opt/${PN}/${PV}/share \
		libdir="${D}"/opt/${PN}/${PV}/$(get_libdir) \
		libdir64="${D}"/opt/${PN}/${PV}/$(get_libdir) \
		vpidir="${D}"/opt/${PN}/${PV}/$(get_libdir)/ivl \
		install

	insinto /opt/${PN}/${PV}/share/doc/${PF}
	doins *.txt
	use examples && doins -r examples
	insinto /etc/revdep-rebuild
	doins "96-${PN}-${PV}"
	if use modulefile ; then
		insinto /etc/modulefiles/${PN}
		newins "${FILESDIR}/iverilog.modulefile" "${PV}"
		sed -i \
			-e "s:@version@:${PV}:g" \
			-e "s:@prefix@:/opt/${PN}/\\\$version:g" \
			-e "s:@bindir@:\\\$prefix/bin:g" \
			-e "s:@mandir@:\\\$prefix/share/man:g" \
			"${D}/etc/modulefiles/${PN}/${PV}" || die "sed failed"
	fi
}
