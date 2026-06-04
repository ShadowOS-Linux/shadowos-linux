# ShadowOS Linux &nbsp; [![bluebuild build badge](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build.yml/badge.svg)](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build.yml) [![iso build badge](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build-iso.yml/badge.svg)](https://github.com/shadowos-linux/shadowos-linux/actions/workflows/build-iso.yml)

*I prohibit the usage of this software in areas where age verification is required by law.*

*I am therefore not responsible if you downloaded ShadowOS Linux in those areas.*

# Installation

## ISO
You can download the latest ISO file from:
- [The official website](https://shadowos-linux.github.io/)* 
- The '[Actions](https://github.com/ShadowOS-Linux/shadowos-linux/actions/workflows/build-iso.yml)' page

**credits to [nightly.link](https://github.com/oprypin/nightly.link) for being able to download artifacts without needing an account*
## Rebase
> [!WARNING]  
> [This is an experimental feature](https://fedoraproject.org/wiki/Changes/OstreeNativeContainer), try at your own discretion.

<details>
<summary><b>First, make an environment variable for the variant of your choice</b></summary>

First, pick a desktop environment:

<details>
<summary><b>Cosmic (Recommended)</b></summary>

```bash
DE=linux
```
</details>
  
<details>
<summary><b>Gnome</b></summary>

```bash
DE=gnome
```
</details>

<details>
<summary><b>XFCE</b></summary>

```bash
DE=xfce
```
</details>

Then, select your gpu:

<details>
<summary><b>AMD/Intel</b></summary>

```bash
GPU=
```
</details>

<details>
<summary><b>NVIDIA (GTX 16xx and RTX series)</b></summary>

```bash
GPU=-nvidia
```
</details>

<details>
<summary><b>NVIDIA Legacy (GTX 9xx-10xx series)</b></summary>

```bash
GPU=-nvidia-legacy
```
</details>

After that, choose if you would like steam or not:

<details>
<summary><b>Steam</b></summary>

```bash
steam=-steam
```
</details>

<details>
<summary><b>No Steam</b></summary>

```bash
steam=
```
</details>

Finally, run this command:
```bash
VARIANT="shadowos-${DE}${GPU}${STEAM}"
```

</details>

After that, either:

<details>
<summary><b>Rebase an existing atomic Fedora installation to the latest build</b></summary>

- Rebase to the unsigned image, to get the proper signing keys and policies installed:
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
  
</details>

<details>
<summary><b>Rebase an existing ShadowOS Linux installation to another variant</b></summary>

  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/shadowos-linux/$VARIANT:latest
  ```
</details>

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/shadowos-linux/shadowos-linux
```
