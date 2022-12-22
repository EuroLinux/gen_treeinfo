# Treeinfo generator

Simple scripts to generate treeinfo files. Made for EuroLinux, but can
be easily adapted for any other distro.

## Usage

The usage is simple as you have to provide most of the data on the
command line. You can find the examples :). For example to generate
`.treeinfo` for the EuroLinux 9 for HighAvailbility repository:

```bash
./gen_treeinfo.py repo --arch aarch64 --family EuroLinux --version 9 --variant HighAvailability --output-file /path/to/repo/os/.treeinfo"
```

The BaseOS (main repository for EL 8 and EL 9) that contains images for network
installation/pxe boot is a special case, to create them you firstly need to
calculate checksums (`sha256sum`) for selected files. Note that current
implementation for BaseOS adds AppStream as the second variant.

```bash
./gen_treeinfo.py baseos --arch x86_64 --family EuroLinux \
--version 8 --variant BaseOS --output-file /path/to/repo/os/.treeinfo \
--checksum images/boot.iso:sha256:b35e87b5838011a3637be660e4238af9a55e4edc74404c990f7a558e7f416658 \
--checksum images/efiboot.img:sha256:... \
--checksum images/install.img:sha256:... \
--checksum images/pxeboot/initrd.img:... \
--checksum images/pxeboot/vmlinuz:sha256:..."
```

## Tests

Run `./tests.sh`.

## Why separate script?

The most distributions uses `pungi` or another composer to automatically
generate treeinfo files. With these tools the compose process is:

- slow ( at least for `pungi`)
- tied to the ecosystem

At EuroLinux we are developing independent build stack that uses a lot
of smaller, easier to manage tools. This is one of them.
