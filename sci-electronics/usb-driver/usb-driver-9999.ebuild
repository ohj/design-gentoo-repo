# Distributed under the terms of the GNU General Public License v2+

EAPI=4
inherit eutils multilib git-2

EGIT_REPO_URI="git://git.zerfleddert.de/usb-driver"

DESCRIPTION="Library for using XILINX JTAG tools on Linux without proprietary kernel modules"
HOMEPAGE="http://rmdir.de/~michael/xilinx/"
SRC_URI=""

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/libusb:0
"
RDEPEND="${DEPEND}"

src_prepare() {
	(
		echo "# Add ${PN} libdir to be checked for broken linkage"
		echo "SEARCH_DIRS=\"/opt/xilinx/$(get_libdir)\""
	) > "${S}/96-${PN}" || die "revdep-rebuild file creation failed"
	epatch "${FILESDIR}/0001-add-support-for-passing-CFLAGS-and-CPPFLAGS-to-Makef.patch"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	insinto "/opt/xilinx/$(get_libdir)"
	insopts -m755
	doins libusb-driver.so libusb-driver-DEBUG.so
	insinto "/opt/xilinx/share/doc/${PF}"
	insopts -m644
	doins README index.html
	insinto /etc/revdep-rebuild
	doins "96-${PN}"
}
