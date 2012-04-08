# Distributed under the terms of the GNU General Public License v2+

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Xilinx ISE Design Suite"
HOMEPAGE="http://www.xilinx.com/support/download/index.htm"
SRC_URI="!dummy? ( ${P}.tar )"

LICENSE="Xilinx-EULA"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE="dummy +modulefile"

DEPEND=""
RDEPEND="
	modulefile? (
		app-admin/environment-modules
		sci-electronics/xi-wrapper[modulefile?]
	)
	media-fonts/font-bitstream-100dpi
	media-fonts/font-bitstream-75dpi
	media-fonts/font-adobe-100dpi
	media-fonts/font-adobe-75dpi
	net-nds/portmap
	sys-libs/libstdc++-v3
	x11-libs/openmotif:2.2
	${DEPEND}
"

RESTRICT="fetch strip"

pkg_prepare() {
	local arch="`tc-arch`"
	case "$arch" in
	x86)
		;;
	x86_64)
		;;
	*)
		eerror "unsupported architecture '$arch'"
		;;
	esac
}

pkg_nofetch() {
	eerror "No '${SRC_URI}' found in"
	eerror "'${DISTDIR}'. Please go to"
	eerror "  ${HOMEPAGE}"
	eerror "and download ISE version ${PV}."
	eerror "Proceed with unpacking it, and running the 'xsetup' program,"
	eerror "found in the directory. Install the software into"
	eerror "  ${DISTDIR}/${P}"
	eerror "You probably need to fix some permissions, the installer usually"
	eerror "installs some files with write permissions for group and/or other."
	eerror "When done fixing permissions"
	eerror "  cd \"${DISTDIR}\" && tar -cvf \"${P}.tar\" \"${P}\""
	eerror "Rerun the ebuild install when done."
}

src_unpack() {
	if use dummy ; then
		mkdir -p "${S}"
	else
		unpack ${A}
	fi
}

src_compile() {
	:
}

src_install() {
	dodir /opt/xilinx/${PV}
	if use dummy ; then
		dodir /opt/xilinx/${PV}/ISE_DS
	else
		mv "${S}/ISE_DS" "${D}/opt/xilinx/${PV}" || \
			die "failed to copy files to install image"
	fi
	if use modulefile ; then
		insinto /etc/modulefiles/xilinx
		newins "${FILESDIR}/xilinx.modulefile" "${PV}"
		sed -i \
			-e "s:@version@:${PV}:g" \
			-e "s:@prefix@:/opt/xilinx/${PV}:g" \
			"${D}/etc/modulefiles/xilinx/${PV}" || die "sed failed"
	fi
}
