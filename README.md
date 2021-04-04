# Qubes VPN 2FA (with a certificate on USB)

Configuration for
[Qubes-vpn-support](https://github.com/tasket/Qubes-vpn-support) to add support
for 2FA. This specific implementation of 2FA is limited to a certificate stored
on a USB stick.

## Prerequisites

 * Qubes-vpn-support installed and working.
 * An USB stick with a certificate. The certificate must be encrypted with a
   password. The certificate must be in the root directory.
 * Configuration for the VPN stored on the USB with the certificate. The file
   must end in ``.ovpn`` and be the only file matching that pattern. It must
   be stored in the root directory.
 * Username and password for the VPN.

## Installation

 * Copy ``00-2fa-usb.conf`` to ``/rw/config/qubes-vpn-handler.service.d``.
 * Copy ``prepare-vpn-usb.sh`` to ``/rw/config``.
 * Restart the ProxyVM or restart the VPN service.be

## Usage

When the VPN service starts an xterm prompt will appear. It will prompt for:

 1. A device path. Attach your USB device to the VM. Usually the script can
    autodetect the correct path and you can simply press enter. If it doesn't
    you have to manually enter the correct path.
 2. A key password. This is the password for the private key for the
    certificate.
 3. Username for the VPN service.
 4. Password for the VPN service.

## Implementation notes

This is implemented by overriding some configuration for Qubes-vpn-handler. The
overriden configuration will cause Qubes-vpn-handler to run
``prepare-vpn-usb.sh`` before the actual service is started. That script will
mount the USB device on top of ``/rw/config/vpn`` and create a RAM disk to
store the passwords in for the VPN service.

## Known issues

 * The VPN service appears to be failing to connect the very first time it
   starts, even if the correct credentials are entered. It will sucecssfully
   connect once systemd automatically restarts it (usually happens after a
   few seconds). Patches are welcome.
