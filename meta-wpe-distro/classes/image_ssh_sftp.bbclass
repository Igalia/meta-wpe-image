DESCRIPTION += "with internal-sftp SSH"

# OpenSSH server plus the SFTP server, with the sshd Subsystem switched to
# the built-in internal-sftp implementation (works without a shell account).

# nooelint: oelint.vars.outofcontext
IMAGE_FEATURES += "ssh-server-openssh"

IMAGE_INSTALL:append = " \
    openssh-sftp \
    openssh-sftp-server \
    "

ROOTFS_POSTPROCESS_COMMAND += "ssh_internal_sftp; "

ssh_internal_sftp () {
        for config in sshd_config sshd_config_readonly; do
                if [ -e ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config ]; then
                        sed -i 's/^[#[:space:]]*Subsystem sftp.*/Subsystem sftp internal-sftp/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
                fi
        done
}
