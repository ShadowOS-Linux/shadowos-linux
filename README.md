# ShadowOS Linux &nbsp; [![bluebuild build badge](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build.yml/badge.svg)](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build.yml) [![iso build badge](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build-iso.yml/badge.svg)](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build-iso.yml)

*This software cannot be used in jurisdictions where age verification is mandated by law.*

*I am therefore not responsible if you downloaded ShadowOS Linux in those areas.*

# Installation

## ISO
You can download the latest iso file from the actions page.

## Rebase
> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First, make an environment variable for the variant of your choice:
  
<details>
<summary><b>ShadowOS (AMD/Intel)</b></summary>

```bash
VARIANT=shadowos-linux
```
</details>
  
<details>
<summary><b>ShadowOS (NVIDIA)</b></summary>

```bash
VARIANT=shadowos-linux-nvidia
```
</details>

<details>
<summary><b>ShadowOS (AMD/Intel) with Steam</b></summary>

```bash
VARIANT=shadowos-linux-steam
```
</details>

<details>
<summary><b>ShadowOS (NVIDIA) with Steam</b></summary>

```bash
VARIANT=shadowos-linux-nvidia-steam
```
</details>

- Then rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/shadowos-linux/$VARIANT:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  (source /etc/os-release && rpm-ostree rebase ostree-image-signed:docker://ghcr.io/shadowos-linux/$VARIANT_ID:latest)
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/shadowos-linux/shadowos-linux
```
