#!/usr/bin/env bash

echo "raco exe..."
raco exe main.rkt

echo "raco distribute..."
raco distribute distribution main

echo "tar..."
tar cvf alas.tar distribution/

echo "done."
