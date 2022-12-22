#!/usr/bin/env bash
#
# Author(s): Alex Baranowski <alex at euro-linux.com>
# simple bash script that tests if we are able to reproduce .treeinfo, and make them like other distros

run_test(){
    NAME=$1
    URL=$2
    OUR_COMMAND=$3
    CLEAN_COMMAND="$4"
    mkdir -p tests/
    curl -s "$URL" > tests/tested_treeinfo
    # we want it s p l i t t e d
    $OUR_COMMAND --output-file tests/generated_treeinfo
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
    OUR_COMMAND="./gen_treeinfo.py repo --arch x86_64 --family AlmaLinux --version 9 --variant AppStream --timestamp 1668611910"
    CLEAN_COMMENTS=0
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_appstream_87(){
    URL=https://repo.almalinux.org/almalinux/8.7/AppStream/x86_64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch x86_64 --family AlmaLinux --version 8 --variant AppStream --timestamp 1668065004"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_appstream_87_aarch64(){
    URL=https://repo.almalinux.org/almalinux/8.7/AppStream/aarch64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch aarch64 --family AlmaLinux --version 8 --variant AppStream --timestamp 1668065273"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_almalinux_ha_91_ppc64le(){
    URL=https://repo.almalinux.org/almalinux/9.1/HighAvailability/ppc64le/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch ppc64le --family AlmaLinux --version 9 --variant HighAvailability --timestamp 1668611789"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_c8_powertools(){
    URL=https://vault.centos.org/8.5.2111/PowerTools/x86_64/os/.treeinfo
    OUR_COMMAND="./gen_treeinfo.py repo --arch x86_64 --family 'CentOS Linux' --family-short CentOS --version 8 --variant PowerTools --timestamp 1636765473"
    CLEAN_COMMENTS=1
    run_test "${FUNCNAME[0]}" "$URL" "$OUR_COMMAND" $CLEAN_COMMENTS
}

test_c9_stream_ha(){
    URL=https://repo.almalinux.org/almalinux/9.1/AppStream/x86_64/os/.treeinfo
}

test_almalinux_baseos_el8(){
    echo TODO
}

test_almalinux_baseos_el9(){
    echo ok
}

test_almalinux_baseos_el8_aarch64(){
    echo ok
}

test_almalinux_baseos_el9_aarch64(){
    echo ok
}

main(){
  test_c8_powertools
#  test_almalinux_ha_91_ppc64le
#  test_almalinux_appstream_91
#  test_almalinux_appstream_87
#  test_almalinux_appstream_87_aarch64

}
main
