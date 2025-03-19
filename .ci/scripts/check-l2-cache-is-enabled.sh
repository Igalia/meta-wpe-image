#/bin/sh

BOOT_CONFIG=/boot/config.txt
PROC_CONFIG=/proc/config.gz

success() {
    echo "$@"
    exit 0
}

error() {
    echo "$@"
    exit 1
}

# RPi3 check.
if [ -f ${BOOT_CONFIG} ]; then
    if grep -E -q "^disable_l2cache=1$" ${BOOT_CONFIG}; then
        error "L2 cache disabled"
    else
        success "L2 cache enabled"
    fi
fi

# Wandboard.
if [ -f ${PROC_CONFIG} ]; then
    if zcat ${PROC_CONFIG} | grep -E -q "^CONFIG_CACHE_L2X0=y$"; then
        success "L2 cache enabled"
    fi
fi

# Rely on lscpu output.
if lscpu | grep -q "L2 cache"; then
    success "L2 cache enabled"
fi

# Otherwise return error.
error "L2 cache disabled"
