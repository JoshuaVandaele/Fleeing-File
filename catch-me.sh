#!/bin/bash

DEBUG=0

debug() {
    if [ $DEBUG -eq 1 ]; then
        echo "$1"
    fi
}

find_subdir() {
    find . -maxdepth 1 -type d | tail -n +2 |
        grep -v "tmp" |
        grep -v "/\.[^/]*$" |
        grep -v "/dev" |
        grep -v "/sys" |
        grep -v "/proc" |
        grep -v "/run" |
        grep -v "/root" |
        grep -v "/boot" |
        grep -v "/opt" |
        grep -v "/srv" |
        grep -v "/lost+found" |
        grep -v "/cdrom" |
        grep -v "/lib32" |
        grep -v "/libx32" |
        grep -v "/usr" |
        grep -v "/libexec" |
        grep -v "/mnt" |
        grep -v "lib" |
        grep -v "node_modules" |
        grep -v "vendor" |
        grep -v "build" |
        grep -v "dist" |
        grep -v "target" |
        grep -v "out" |
        grep -v "output" |
        grep -v "bin"
}

move_down() {
    local depth=$1
    for ((i = 0; i < depth; i++)); do
        local subdirs=($(find_subdir))
        if [ ${#subdirs[@]} -eq 0 ]; then
            if [ $DEBUG -eq 1 ]; then
                echo "No subdirectories found, quitting early"
            fi
            break
        fi
        local random_index=$((RANDOM % ${#subdirs[@]}))
        local random_dir=${subdirs[$random_index]}
        if [ $DEBUG -eq 1 ]; then
            echo "Moving to ${random_dir}"
        fi
        cd "$random_dir" &>/dev/null || debug "Failed to move to ${random_dir}" && continue
    done
}

move_up() {
    local depth=$1
    for ((i = 0; i < depth; i++)); do
        cd ..
    done
}

main() {
    echo "Gotcha!"
    touch "Gotcha!"
    local cur_dir=$(pwd)
    local bash_file=$(readlink -f "$0")

    while [ ! -w "$(pwd)" ] || [ "$(pwd)" = "$cur_dir" ]; do
        debug "Retrying..."
        debug "Current directory: $(pwd)"
        local up_steps=$((RANDOM % 5 + 1))
        local down_steps=$((RANDOM % 5 + 1))

        debug "Moving up $up_steps steps"
        debug "Moving down $down_steps steps"

        move_up $up_steps
        move_down $down_steps
    done

    debug "Would have moved to $(pwd)"
    if [ $DEBUG -eq 1 ]; then
        exit 0
    fi

    mv "$bash_file" "$(pwd)"

    cd "$cur_dir"
}

main
