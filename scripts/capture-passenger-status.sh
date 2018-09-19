#!/bin/bash

vagrant ssh -c 'sudo passenger-status --show=xml 2>/dev/null' 2>/dev/null
