#!/bin/bash

echo "Making FlatHub FOSS-only..."
flatpak remote-modify --subset=floss flathub

echo "Scanning for proprietary Flatpak applications..."

flatpak list --app --columns=application | while read -r app_id; do
    if flatpak info "$app_id" | grep -qi "Proprietary"; then
        echo "----------------------------------------------------"
        echo "Found proprietary Flatpak: $app_id"
        echo "Attempting to uninstall..."
        flatpak uninstall -y "$app_id" > /dev/null
        if [ $? -eq 0 ]; then
            echo "Successfully uninstalled: $app_id"
        else
            echo "Failed to uninstall: $app_id"
        fi
        echo "----------------------------------------------------"
    else
        echo "Skipping FOSS Flatpak: $app_id"
    fi
done

echo "Scan complete. Cleaning up unused Flatpak runtimes..."
flatpak uninstall --unused
echo "Cleanup complete."
