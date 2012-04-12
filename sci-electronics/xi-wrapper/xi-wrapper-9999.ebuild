# Distributed under the terms of the GNU General Public License v2+

EAPI=4
inherit eutils multilib toolchain-funcs git-2

EGIT_REPO_URI="git://github.com/ohj/xi-wrapper.git"
DESCRIPTION="Xilinx ISE Toolchain Wrapper"
HOMEPAGE="https://github.com/ohj/xi-wrapper"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+modulefile"

DEPEND=""
RDEPEND="
	modulefile? ( app-admin/environment-modules )
	${DEPEND}
"

RESTRICT=""

src_compile() {
	emake \
		prefix=/opt/xilinx \
		libdir=/opt/xilinx/$(get_libdir) \
		sysconfdir=/etc || die "emake failed"
}

src_install() {
	emake \
		prefix=/opt/xilinx \
		libdir=/opt/xilinx/$(get_libdir) \
		sysconfdir=/etc \
		DESTDIR="${D}" \
		install || die "emake install failed"
	keepdir /opt/xilinx/share/licences
	# Is needed since gentoo has a ld script as /usr/bin/libusb.so
	for a in ${MULTILIB_ABIS} ; do
		local dir="$(get_abi_LIBDIR ${a})"
		dodir "/opt/xilinx/${dir}"
		dosym "/${dir}/libusb-0.1.so.4" "/opt/xilinx/${dir}/libusb.so"
	done
	insinto /etc/profile.d
	doins xi-env.sh
	insinto /opt/xilinx/share/doc/${PF}
	doins README
	if use modulefile ; then
		insinto /etc/modulefiles/xi-wrapper
		newins libusb.modulefile libusb
		newins usb-driver.modulefile usb-driver
	fi
}
