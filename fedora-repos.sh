#!/bin/sh
# Simple script to enable flathub and RPM Fusion, third party repositories.

# Enabling Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enabling RPM Fusion repositories
sudo dnf install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# AppStream metadata
sudo dnf groupupdate core
