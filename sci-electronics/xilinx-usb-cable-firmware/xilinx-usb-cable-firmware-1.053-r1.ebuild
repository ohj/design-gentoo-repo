# Distributed under the terms of the GNU General Public License v2

EAPI=3

inherit eutils

MY_P="install_drivers"

DESCRIPTION="Xilinx USB Cable Firmware"
HOMEPAGE="http://www.xilinx.com/support/documentation/configuration_hardware.htm"
SRC_URI="${MY_P}.tar.gz"

LICENSE="Xilinx-EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="fetch"

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/fxload
	sys-fs/udev
	"

S="${WORKDIR}/${MY_P}/linux_drivers/pcusb"

pkg_nofetch() {
	eerror "'${SRC_URI}' can not be fetched automatically. Please go to"
	eerror "  ${HOMEPAGE}"
	eerror "and download the file '${SRC_URI}' from the"
	eerror "Configuration Hardware User Guide section, and put it in"
	eerror "  '${DISTDIR}'"
}

pkg_setup() {
	enewgroup xilinxcable
}

src_compile() {
	:
}

src_install() {
	# impact insists on these being present
	insinto /etc/hotplug/usb/xusbdfwu.fw
	doins *.hex

	insinto /etc/udev/rules.d
	doins "${FILESDIR}/98-xilinx-usb-cable-firmware.rules"
}
