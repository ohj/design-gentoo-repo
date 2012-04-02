# Distributed under the terms of the GNU General Public License v2+

EAPI=4
inherit eutils

MY_PV="v2p6_Oct2011"

DESCRIPTION="Open Verification Language"
HOMEPAGE="http://www.accellera.org/downloads/standards/ovl/"
SRC_URI="${PN}_${MY_PV}.tgz"

LICENSE=""
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE="+modulefile"

DEPEND=""
RDEPEND="
	modulefile? (
		app-admin/environment-modules
	)
	${DEPEND}
"

RESTRICT="fetch"

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	eerror "No '${SRC_URI}' found in"
	eerror "'${DISTDIR}'. Please go to"
	eerror "  ${HOMEPAGE}"
	eerror "and download Open Verification Language v${PV}."
	eerror "Proceed with copying '${SRC_URI}' into"
	eerror "  ${DISTDIR}"
}

src_compile() {
	:
}

src_install() {
	dodir /opt/${PN}/${PV}
	insinto /opt/${PN}/${PV}
	doins -r .
	if use modulefile ; then
		insinto "/etc/modulefiles/${PN}"
		newins "${FILESDIR}/${PN}.modulefile" "${PV}"
		sed -i \
			-e "s:@version@:${PV}:g" \
			-e "s:@prefix@:/opt/${PN}:g" \
			-e "s:@bindir@:/opt/${PN}/bin:g" \
			"${D}/etc/modulefiles/${PN}/${PV}" || die "sed failed"
	fi
	insinto "/opt/${PN}/bin"
	insopts -m0755
	doins "${FILESDIR}/ovl-config"
}
