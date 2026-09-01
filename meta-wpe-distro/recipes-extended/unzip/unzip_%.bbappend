S = "${WORKDIR}/unzip60"

# Makefile uses CF_NOOPT instead of CFLAGS.  We lifted the values from
# Makefile and add CFLAGS.  Optimization will be overriden by unzip
# configure to be -O3.
#
EXTRA_OEMAKE = "-e MAKEFLAGS= STRIP=true LF2='' \
                'CF_NOOPT=-I. -Ibzip2 -DUNIX ${CFLAGS} -DLARGE_FILE_SUPPORT -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64'"
