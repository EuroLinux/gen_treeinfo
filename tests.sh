#!/usr/bin/env bash
#
# Author(s): Alex Baranowski <alex at euro-linux.com>
# simple bash script that tests if we are able to reproduce .treeinfo, and make
# them like other distros :)

run_test(){
    NAME=$1
    URL=$2
    OUR_COMMAND=$3
    CLEAN_COMMAND="$4"
    mkdir -p tests/
    curl -s "$URL" > tests/tested_treeinfo
    # we want it s p l i t t e d
    $OUR_COMMAND
    set +x
    if [ "$CLEAN_COMMAND" -eq 1 ]; then
        grep -F -v ';' tests/generated_treeinfo > tests/tmp_file
        mv tests/tmp_file tests/generated_treeinfo
    fi
    diff tests/generated_treeinfo tests/tested_treeinfo > /dev/null 2>/dev/null
    diff_exit=$?
    if [[ $diff_exit -eq 0 ]]; then
        echo -e "\e[32m[OK]:\e[0m $NAME"
    else
        echo -e "\e[31m[FAIL]:\e[0m $NAME"
        diff -y tests/generated_treeinfo tests/tested_treeinfo
    fi
}

test_almalinux_appstream_91(){
    URL=https://repo.almalinux.org/almalinux/9.1/AppStream/x86_64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch x86_64 --family AlmaLinux --version 9 --variant AppStream --timestamp 1668611910 --output-file tests/generated_treeinfo"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_appstream_87(){
    URL=https://repo.almalinux.org/almalinux/8.7/AppStream/x86_64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch x86_64 --family AlmaLinux --version 8 --variant AppStream --timestamp 1668065004 --output-file tests/generated_treeinfo"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_appstream_87_aarch64(){
    URL=https://repo.almalinux.org/almalinux/8.7/AppStream/aarch64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch aarch64 --family AlmaLinux --version 8 --variant AppStream --timestamp 1668065273 --output-file tests/generated_treeinfo"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_ha_91_ppc64le(){
    URL=https://repo.almalinux.org/almalinux/9.1/HighAvailability/ppc64le/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch ppc64le --family AlmaLinux --version 9 --variant HighAvailability --timestamp 1668611789 --output-file tests/generated_treeinfo"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_c8_powertools(){
    URL=https://vault.centos.org/8.5.2111/PowerTools/x86_64/os/.treeinfo
    OUR_COMMAND=""
    CLEAN_COMMENTS=0
    # we have to make that way because CentOS Linux
    ./gen_treeinfo.py repo --arch x86_64 --family 'CentOS Linux' --family-short CentOS --version 8 --variant PowerTools --timestamp 1636765473  --output-file tests/generated_treeinfo
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_baseos_87(){
    URL=https://repo.almalinux.org/almalinux/8.7/BaseOS/x86_64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py baseos --arch x86_64 --family AlmaLinux \
    --version 8 --variant BaseOS --timestamp 1668065004 --output-file \
    tests/generated_treeinfo \
    --checksum images/boot.iso:sha256:a4fc8c53878e09f63849f2357228db9e2b547beea6f2b47758da2995bd59356e \
    --checksum images/efiboot.img:sha256:4fa8782b233703d869e83e833730e0de14a51c4bac02f7675d04913b79ef0319 \
    --checksum images/install.img:sha256:114e22e447952085f665fa6641ec6f2ef4ad0beacf76cd35c4b84c843c892442 \
    --checksum images/pxeboot/initrd.img:sha256:a7a0a630c179e23a5b2cb9a054d3705b6fd1c52a316f82f3c633005c0acfae4c \
    --checksum images/pxeboot/vmlinuz:sha256:161b5a65ab34fb4fe45223a14e9bb5270073be9066a97db3cde05897cad1cd30"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_baseos_91(){
    URL=https://repo.almalinux.org/almalinux/9.1/BaseOS/x86_64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py baseos --arch x86_64 --family AlmaLinux \
    --version 9 --variant BaseOS --timestamp 1668611910 --output-file \
    tests/generated_treeinfo \
    --checksum images/boot.iso:sha256:9f22bd98c8930b1d0b2198ddd273c6647c09298e10a0167197a3f8c293d03090 \
    --checksum images/efiboot.img:sha256:adff3d7cf76139a7459a3b287e14f4dbb8d67bfe2432818875f3e92b0173f24e \
    --checksum images/install.img:sha256:af4bc8a26fdacda5dc1c2fba5c820ae22a1e63988294d31ab54eaa225a25d219 \
    --checksum images/pxeboot/initrd.img:sha256:098a4cff399295a08e0d620f0292c31b45f19ae374615183c6f99fe6aa8bef91 \
    --checksum images/pxeboot/vmlinuz:sha256:553e7134206817f3862fc06aaaab479158438a344bed3157894e2ed7cda536f1"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_baseos_87_aarch64(){
    URL=https://repo.almalinux.org/almalinux/8.7/BaseOS/aarch64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py baseos --arch aarch64 --family AlmaLinux \
    --version 8 --variant BaseOS --timestamp 1668065273 --output-file \
    tests/generated_treeinfo \
    --checksum images/boot.iso:sha256:e5e1b1bc7fb973b389ad9a0a3e5019f91b1d3a81b3489cacacb357c5e960d76d \
    --checksum images/efiboot.img:sha256:aacb3c5e5bdefab7dd6d568cfc7fa2c8ed220ea469735e940653f6a6d4ffd725 \
    --checksum images/install.img:sha256:78543ee6d0766f76a3061eb23ee54d31b6f75b1bf23b7d7ccfa31bc316f8be2b \
    --checksum images/pxeboot/initrd.img:sha256:526b21eb1e7541d7f927859c64855ba15eeac46fe95f10232b1c90dfa72153dc \
    --checksum images/pxeboot/vmlinuz:sha256:ea4add33820ee0e48cbc7a5d83c7d03b0d9cba79b90f59c1105a0f58ae7d240b"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_baseos_91_aarch64(){
    URL=https://repo.almalinux.org/almalinux/9.1/BaseOS/aarch64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py baseos --arch aarch64 --family AlmaLinux \
    --version 9 --variant BaseOS --timestamp 1668610994 --output-file \
    tests/generated_treeinfo \
    --checksum images/boot.iso:sha256:62fa5b37098b82a6657b678e28b52e9b50a5d2ec8e99db151557ad820e6f4e14 \
    --checksum images/efiboot.img:sha256:ea9485dd4067598086f9ba5f08eb2d7ca98257e83becebb9f1075248f2b5e96b \
    --checksum images/install.img:sha256:245a1bfdfaed42feedfc361c33c1b618546a3e8a72fb23b8b52ef633afec2364 \
    --checksum images/pxeboot/initrd.img:sha256:5e71313c641e82d51f62d2087b36bcd69b37fa4622e4fcd99acc6792c220b978 \
    --checksum images/pxeboot/vmlinuz:sha256:f1d6cbe06b50411f158851338e8db397792ab828119f656a0d41b6a253287a63"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_baseos_91_ppc64le(){
    URL=https://repo.almalinux.org/almalinux/9.1/BaseOS/ppc64le/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py baseos --arch ppc64le --family AlmaLinux \
    --version 9 --variant BaseOS --timestamp 1668611789 --output-file \
    tests/generated_treeinfo \
    --checksum images/boot.iso:sha256:5af004362dcc4eecc95f6e627303e07bb73cda265d18bf25ed6f9874160c117b \
    --checksum images/install.img:sha256:eb455049f86a14f889eec80145ca176eb9aff6c61de681fba594ce835d1fe4bc \
    --checksum ppc/ppc64/initrd.img:sha256:47a9f1a13a09460e17392b446c53328523819ab8f41159eeab84f54a8eafe61f \
    --checksum ppc/ppc64/vmlinuz:sha256:727c128459ecd2ce024150c7b5b6cf36de65586bf2dd29d856506013f64d5d67"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_rl_90_ppcle(){
    URL=dl.rockylinux.org/vault/rocky/9.0/BaseOS/ppc64le/os/.treeinfo
    CLEAN_COMMENTS=0
    OUR_COMMAND=""
    # rocky have family and family short name :/
    ./gen_treeinfo.py baseos --arch ppc64le --family "Rocky Linux" --family-short Rocky \
    --version 9.0 --variant BaseOS --timestamp 1656987215 --output-file \
    tests/generated_treeinfo \
    --checksum images/boot.iso:sha256:d40eac05a1a5130d89fe97a46ea3b91eeba980945a38dbd457f5510758751582 \
    --checksum images/install.img:sha256:08d0644739c82096a48901eea423d3e8c80e0cf0424f76ed489530c4397c6e39 \
    --checksum ppc/ppc64/initrd.img:sha256:c89eb13f0d86acb5436b6459d29ae1d14982971d85cd4982b80b98345bf17523 \
    --checksum ppc/ppc64/vmlinuz:sha256:17cbf164fb29fe072f2c883aece6c56ccd4bbc99bd8049c1a3ff5769e473bab3
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS

}




main(){
  # repo tests
  test_c8_powertools
  test_almalinux_ha_91_ppc64le
  test_almalinux_appstream_91
  test_almalinux_appstream_87
  test_almalinux_appstream_87_aarch64
  # baseos tests
  test_almalinux_baseos_87
  test_almalinux_baseos_91
  test_almalinux_baseos_87_aarch64
  test_almalinux_baseos_91_aarch64
  test_almalinux_baseos_91_ppc64le
  test_rl_90_ppcle 
}
main
