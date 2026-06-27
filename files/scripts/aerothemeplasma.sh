#!/usr/bin/env bash
set -oue pipefail

mkdir -p /tmp/win7theme/
cd /tmp/win7theme/

# fonts (script by github.com/winblues)
git clone https://github.com/mrbvrz/segoe-ui-linux
mkdir -p /usr/share/fonts/Microsoft/TrueType/SegoeUI/
mv segoe-ui-linux/font/* /usr/share/fonts/Microsoft/TrueType/SegoeUI
fc-cache -f /usr/share/fonts/Microsoft/TrueType/SegoeUI/

# plymouth (script by github.com/winblues)

git clone https://github.com/furkrn/PlymouthVista
cd PlymouthVista

bash ./compile.sh

bash ./gen_blur.sh

    # I won't bother with a proper better way, this just works :\
    sed -i '/# START_WIN7_CONFIG/,/# END_WIN7_CONFIG/{ 
    /# START_WIN7_CONFIG/!{ 
        /# END_WIN7_CONFIG/!d 
    } 
    r /dev/stdin
}' PlymouthVista.script <<EOF
// Use Vista boot which is available even on Windows 11.
// 1 - Use Vista boot screen
// 0 - Use 7 boot screen
global.UseLegacyBootScreen = 0;

// Add shadow effect to shutdown screen text.
// 0 - Windows Vista style, no text shadow.
// 1 - Windows 7 style, show text shadow. 
global.UseShadow = 1;

// Change the background of the shutdown screen.
// vista - Use Vista background and branding.
// 7 - Use 7 background and branding.
global.AuthuiStyle = "7";
EOF


# "Do you want fade in effects in shutdown?"
# "1 - Automatic (Fade when shutdown is called from your desktop, don't fade when shutdown is called from SDDM)"
# "2 - Always (Fade when shutdown is called from your desktop, fade when shutdown is called from SDDM)"
# "3 - Never (Don't fade when shutdown is called from your desktop, don't fade when shutdown is called from SDDM)"
INPUT=2

if [[ $INPUT != 1 ]] && [[ $INPUT != 2 ]] then
    $INPUT = 0;
fi

sed -i '/# START_USED_BY_INSTALL_SCRIPT_PREF/,/# END_USED_BY_INSTALL_SCRIPT_PREF/{ 
    /# START_USED_BY_INSTALL_SCRIPT_PREF/!{ 
        /# END_USED_BY_INSTALL_SCRIPT_PREF/!d 
    } 
    r /dev/stdin
}' PlymouthVista.script <<EOF
global.Pref = $INPUT;
EOF

cp ./lucon_disable_anti_aliasing.conf /etc/fonts/conf.d/10-lucon_disable_anti_aliasing.conf

rm -rf /usr/share/plymouth/themes/PlymouthVista

cp -r $(pwd) /usr/share/plymouth/themes/PlymouthVista
ls -la /usr/share/plymouth/themes/PlymouthVista

if [[ $INPUT = 1 ]] then
    echo "Creating automatic services"
    chmod -R 777 /usr/share/plymouth/themes/PlymouthVista/

    cp $(pwd)/systemd/system/* /etc/systemd/system
    for f in $(pwd)/systemd/system/*.service; do
        systemctl enable $(basename $f)
    done

    cp $(pwd)/systemd/user/* /etc/systemd/user
        for f in $(pwd)/systemd/user/*.service; do
        systemctl --user -M $SUDO_USER@ enable update-plymouth-vista-state-logon.service
    done

fi

plymouth-set-default-theme PlymouthVista

cd ..

# theme
## theme dependencies
dnf install -y gcc gcc-c++ cmake make extra-cmake-modules plasma-workspace-devel libksysguard-devel unzip kvantum qt6-qtmultimedia-devel qt6-qt5compat-devel libplasma-devel qt6-qtbase-devel qt6-qtwayland-devel plasma-activities-devel kf6-kpackage-devel kf6-kglobalaccel-devel qt6-qtsvg-devel wayland-devel plasma-wayland-protocols kf6-ksvg-devel kf6-kcrash-devel kf6-kguiaddons-devel kf6-kcmutils-devel kf6-kio-devel kdecoration-devel kf6-ki18n-devel kf6-knotifications-devel kf6-kirigami-devel kf6-kiconthemes-devel cmake gmp-ecm-devel kf5-plasma-devel libepoxy-devel kwin-devel kf6-karchive kf6-karchive-devel plasma-wayland-protocols-devel qt6-qtbase-private-devel qt6-qtbase-devel kf6-knewstuff-devel kf6-knotifyconfig-devel kf6-attica-devel kf6-krunner-devel kf6-kdbusaddons-devel kf6-sonnet-devel plasma5support-devel plasma-activities-stats-devel polkit-qt6-1-devel qt-devel libdrm-devel kf6-kitemmodels-devel kf6-kstatusnotifieritem-devel kf6-frameworkintegration-devel wayland-protocols-devel kscreenlocker-devel --setopt=disable_excludes=*

git clone https://gitgud.io/wackyideas/aerothemeplasma.git aerothemeplasma
cd aerothemeplasma
## fake sudo for the theme install script
function sudo() { "$@"; }
export -f sudo

LIBEXEC_DIR=libexec UAC_LIBEXEC_DIR=libexec/kf6 bash install.sh --skip-x11

## removing fake sudo
unset -f sudo

cd ..

# execbin
git clone https://gitgud.io/catpswin56/execbin
cd execbin
bash install.sh
bash add_rule.sh
cd ..

# gtk theme
git clone https://gitgud.io/Gamer95875/Windows-7-Better /etc/skel/.themes/Windows-7-Better
ln -s ../.themes/Windows-7-Better/gtk-4.0 /etc/skel/.config/gtk-4.0
chmod +x /usr/libexec/topgrade/windows-7-gtk-theme-update
echo '"Windows 7 GTK Theme" = "/usr/libexec/topgrade/windows-7-gtk-theme-update"' >> /etc/ublue-os/topgrade.toml

rm -rf /tmp/win7theme
