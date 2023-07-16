#!/usr/bin/env bash

go run main.go

typst compile cheat.typ dist/cheat.pdf
