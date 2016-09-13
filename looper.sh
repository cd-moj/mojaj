#!/bin/bash
#This file is part of CD-MOJ.
#
#CD-MOJ is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#Foobar is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

SERVER=$1

while true; do
    sleep 3
    for ARQ in ../work/cdmoj2-delegation-server$SERVER/submit*; do
        if [[ ! -e "$ARQ" ]]; then
            continue
        fi
        N="$(basename $ARQ)"
        printf "\n$N\n"
        #submit:$PROBID:$ID:$LINGUAGEM
        ID="$(cut -d: -f3 <<< "$N")"
        PROBID="$(cut -d: -f2 <<< "$N")"
        LING="$(cut -d: -f4 <<< "$N")"
        RESP="$(bash autojudge-sh.sh "$LING" "$PROBID" < "$ARQ")"
        echo "$RESP" > ../work/cdmoj2-delegation-server$SERVER/$ID
        rm "$ARQ"
    done
done
