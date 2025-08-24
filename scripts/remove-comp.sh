# Bash completion for "remove" command
_remove_complete() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # --- DEB packages ---
    local debs deb_names
    debs=$(dpkg-query -W -f='${Package}\n')
    deb_names=$(dpkg-query -W -f='${Package} ${Description}\n' | awk '{print $2}' | sed 's/ /_/g')  # human-readable

    # --- Snap packages ---
    local snaps snap_names
    snaps=$(snap list 2>/dev/null | awk 'NR>1 {print $1}')
    snap_names=$(snap list 2>/dev/null | awk 'NR>1 {print $2}' | sed 's/ /_/g')

    # --- Flatpak apps ---
    local flatpak_ids flatpak_names
    flatpak_ids=$(flatpak list --app --columns=application 2>/dev/null)
    flatpak_names=$(flatpak list --app --columns=name 2>/dev/null | sed 's/ /_/g')

    # Merge all options
    opts="$debs $deb_names $snaps $snap_names $flatpak_ids $flatpak_names"

    # Generate completions
    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
    return 0
}

complete -F _remove_complete remove
