# Bash completion for "remove" command
_remove_complete() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Collect installed .deb packages
    local debs=$(dpkg-query -W -f='${Package}\n')

    # Collect installed Flatpak apps
    local flatpaks=$(flatpak list --app --columns=application 2>/dev/null)

    # Collect installed Snap packages
    local snaps=$(snap list 2>/dev/null | awk 'NR>1 {print $1}')

    # Merge all into one list
    opts="$debs $flatpaks $snaps"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _remove_complete remove
