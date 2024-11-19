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
    local up_steps=$((RANDOM % 5 + 1))
    local down_steps=$((RANDOM % 5 + 1))

    debug "Current directory: $(pwd)"
    debug "Moving up $up_steps steps"
    debug "Moving down $down_steps steps"

    move_up $up_steps
    move_down $down_steps
    while [ $(pwd) == "$cur_dir" ]; do
        debug "The random directory is the same as the current directory, trying again"
        move_up 10
        move_down $down_steps
    done

    if [ $DEBUG -eq 1 ]; then
        echo "Would have moved to $(pwd)"
        cd "$cur_dir"
    else
        mv "$bash_file" "$(pwd)/$(basename $bash_file)"
    fi
}

main
