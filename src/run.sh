#!/bin/bash
rm java/lexer.java
cd jflex
jflex scanner.flex -d ../java
cd ..
