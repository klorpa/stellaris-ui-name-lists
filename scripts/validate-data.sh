#!/bin/bash

function validateNameLists() {
    local PATTERN="${@}"

    for NAME_LIST in $(find "name-lists" -type f -name "*.xml"); do
        local FINDING=$(grep -n "${PATTERN}" "${NAME_LIST}")

        if [ -n "${FINDING}" ]; then
            echo "${NAME_LIST}:"
            echo "${FINDING}"
        fi
    done
}

function validateNameLists_multiLine() {
    local PATTERN="${@}"

    for NAME_LIST in $(find "name-lists" -type f -name "*.xml"); do
        local FINDING=$(grep -Pzo "${PATTERN}" "${NAME_LIST}")

        if [ -n "${FINDING}" ]; then
            echo "${NAME_LIST}:"
            echo "${FINDING}"
        fi
    done
}

# Validate XML structure
validateNameLists_multiLine "\n\s*<(/[^>]*)>.*\n\s*<\1>\n" # Double tags
validateNameLists "<\([^>]*\)>\s*</\1>" # Empty tags - single-line
validateNameLists_multiLine "\n\s*<([^>]*)>\s*\n\s*</\1>\n" # Empty tags - multi-line
validateNameLists_multiLine "\n\s*</Characters>\n\s*<Characters>\s*\n" # Multiple <Characters> tags
validateNameLists_multiLine "\n\s*<Values>\n\s*<Url>" # <Url> inside <Values>

validateNameLists_multiLine "\n\s*<[^N][a-zA-Z]*[^p]>\n\s*<Name>" # <Name> outside <NameGroup>

validateNameLists_multiLine "\n(\s*)<[a-zA-Z]*>\n\1<[a-zA-Z]*>"

validateNameLists "<Url>https://github.com" # Non-raw GitHub URLs
