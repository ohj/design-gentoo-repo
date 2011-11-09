# Distributed under the terms of the GNU General Public License v2+

EAPI=4

MODULE_AUTHOR="WSNYDER"
inherit perl-module

DESCRIPTION="Perl parsing, utilities and extensions to the SystemC language"

LICENSE="|| ( Artistic-2 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-perl/Verilog-Perl-3.313
"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_install() {
	perl-module_src_install
	insinto /usr/include/${PN}
	doins src/*.{cpp,h}
	use examples && dodoc -r example
}
