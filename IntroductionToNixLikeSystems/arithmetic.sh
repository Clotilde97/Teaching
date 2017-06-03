#!/bin/bash
let "a = $1 + $2"
echo adding $1 and $2 together gives $a
echo multiplying $1 and $2 together gives $(expr $1 \* $2)