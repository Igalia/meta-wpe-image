SUMMARY = "Browser performance benchmark runner scripts"
DESCRIPTION = "This provides a recipe for running run-benchmark and \
               browserperfdash-benchmark perf test scripts"
HOMEPAGE = "https://github.com/Igalia/browserperfrunner"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://browserperfdash-benchmark;md5=5de144702cd7cf4dfde864c5174fb818"

# destsuffix keeps the unpack dir matching the default S (${WORKDIR|UNPACKDIR}/${BP})
# on releases older than whinlatter, where the git fetcher unpacks to 'git' instead
SRC_URI = "git://github.com/psaavedra/browserperfrunner.git;protocol=https;branch=update-20260707-1;destsuffix=${BP}"
SRCREV = "d52d7916a68d1a814d18720aedb89e373309a9e1"

inherit python3-dir

PACKAGES = "${PN}"

FILES:${PN} += "${PYTHON_SITEPACKAGES_DIR}"

# benchmark_builder invokes svn, patch and tar to fetch and prepare the
# benchmark sources, github_downloader calls /usr/bin/curl, and the plan
# create scripts need make (dromaeo), perl (sunspider), ruby (jetstream)
# and python (kraken). The linux browser driver uses python3-pygobject
# with the Gtk 3.0 typelib to query the screen resolution.
# Note: the dromaeo plan additionally needs the crc32 tool (Archive::Zip),
# which is not provided by any wrynose layer.
#
# The python3-* modules below provide what webkitcorepy's AutoInstall would
# otherwise pip-download on first import (the autoinstaller is disabled by
# do_install, see there). python3-tomli comes from meta-python. dnslib has
# no recipe, but it is only imported by webkitpy/layout_tests, which the
# benchmark entry points never reach. twisted is only needed with
# --http-server-type twisted (the default is the builtin http server).
RDEPENDS:${PN} = " \
    curl \
    gobject-introspection \
    gtk+3 \
    make \
    patch \
    perl \
    procps \
    psmisc \
    python3-certifi \
    python3-chardet \
    python3-core \
    python3-idna \
    python3-modules \
    python3-packaging \
    python3-psutil \
    python3-pygobject \
    python3-pyparsing \
    python3-pysocks \
    python3-requests \
    python3-setuptools \
    python3-setuptools-scm \
    python3-six \
    python3-tomli \
    python3-urllib3 \
    python3-wheel \
    ruby \
    subversion \
"

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    install -m 0755 ${S}/browserperfdash-benchmark ${D}${bindir}
    install -m 0755 ${S}/run-benchmark ${D}${bindir}
    # Disable webkitcorepy's AutoInstall: it hooks sys.meta_path ahead of the
    # standard finders and pip-downloads its own copy of every registered
    # module even when the system provides it. With it disabled, imports
    # fall through to the python3-* packages from RDEPENDS. Export
    # DISABLE_WEBKITCOREPY_AUTOINSTALLER=0 to revert to auto-downloading.
    sed -i '1a import os; os.environ.setdefault("DISABLE_WEBKITCOREPY_AUTOINSTALLER", "1")' \
        ${D}${bindir}/browserperfdash-benchmark ${D}${bindir}/run-benchmark
    # webkitpy/__init__.py resolves the bundled WebKit libraries
    # (webkitcorepy, webkitscmpy, webkitbugspy, webkitexpectationspy) from a
    # 'libraries' directory next to the webkitpy package.
    tar -C ${S} -cf - webkitpy libraries | tar -C ${D}${PYTHON_SITEPACKAGES_DIR} --no-same-owner -xf -
}
