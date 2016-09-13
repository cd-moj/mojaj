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

LING="$1"
PROBID="$2"
CODIGO="$3"

exec 2> $HOME/log/$PROBID-$CODIGO-$(date +"%Y-%m-%d-%H-%M-%S")
set -x


PROBSDIR="$HOME/problems"
LING="$(tr '[A-Z]' '[a-z]' <<< $LING)"
TMPDIR="$(mktemp -d)"
TLMULT=1
TLDRIFT="0.1"


cat > $TMPDIR/Main.$LING

if [[ "$LING" == "cpp" ]]; then
  g++ -O2 -lm $TMPDIR/Main.$LING -o $TMPDIR/exe -lm &>/dev/null
elif [[ "$LING" == "pas" ]]; then
  fpc -O2 -o$TMPDIR/exe $TMPDIR/Main.$LING &>/dev/null
  TLDRIFT="0.4"
elif [[ "$LING" == "java" ]]; then
  (cd $TMPDIR && javac -J-Xms10m -J-Xmx100m -J-Xss10m Main.java)
  if [[ -e $TMPDIR/Main.class ]]; then
    TLDRIFT=1
    printf "#!/bin/bash\nCLASSPATH=$TMPDIR java -Xms10m -Xmx500m -Xss10m Main\nexit \$?" > $TMPDIR/exe
    chmod a+x $TMPDIR/exe
  fi
else
  CORRETOR=
  if [[ -e "$PROBSDIR/$PROBID/files/corretor.c" ]]; then
    CORRETOR="$PROBSDIR/$PROBID/files/corretor.c"
  fi
  gcc -O2 -lm $CORRETOR $TMPDIR/Main.$LING -o $TMPDIR/exe -lm &>/dev/null
fi

RESP=
if [[ ! -e $TMPDIR/exe ]]; then
  echo "Compilation Error"
  exit 0
fi

TL=$(< $PROBSDIR/$PROBID/tl)
((TL=TL*TLMULT))

chmod a+rX $TMPDIR

((MAXTIME= TL * 2 + 4 ))

#contagem de presentation errors
PE=0

for TESTE in $PROBSDIR/$PROBID/tests/in*; do
  if [[ ! -e $TESTE ]]; then
    continue;
  fi
  echo "=== Rodando $TESTE ===" >&2
  INFILE="/tmp/in$$"
  OUTFILE="$(sed -e "s#\/in\([0-9]\)#\/out\1#g" <<< "$TESTE")"
  cp "$TESTE" $INFILE
  touch $TMPDIR/out
  chmod a+rw $TMPDIR/out
  cp libc-wrapper.so $TMPDIR/

  cat << EOF > $TMPDIR/run
#!/bin/bash -x
  ulimit -t $MAXTIME
  ulimit -f 500000
  if [[ "$LING" != "java" ]]; then
    ulimit -v 524288
  fi
  timeout $((MAXTIME-1)) $TMPDIR/wrapper.sh
  exit \$?
EOF
  cat << EOF > $TMPDIR/wrapper.sh
#!/bin/bash -x
  if [[ "$LING" != "java" ]]; then
    export LD_PRELOAD=$TMPDIR/libc-wrapper.so
  fi
  exec $TMPDIR/exe < $INFILE > $TMPDIR/out
  exit \$?
EOF
  chmod a+x $TMPDIR/run $TMPDIR/wrapper.sh

  ssh coderunner@localhost "/usr/bin/time -p $TMPDIR/run" 2> $TMPDIR/tempo
  SAIDA="$?"
  chmod go-w $TMPDIR/out
  rm "$INFILE"

  TEMPO=$(grep '^real' $TMPDIR/tempo|awk '{print $NF}')

  if echo "($TEMPO - $TL) > $TLDRIFT"|bc -l|grep -q 1; then
    RESP="Time Limit Exceeded"
    break

  elif [[ "$SAIDA" != "0" ]]; then
    RESP="RunTime Error"
    break

  elif diff $OUTFILE $TMPDIR/out >&2; then
    RESP="Accepted"

  #Presentation Error nao pode acusar no primeiro erro, todas as saidas devem ser testadas
  elif diff -bB $OUTFILE $TMPDIR/out >&2; then
    RESP="Presentation Error"
    ((PE++))

  else
    RESP="Wrong Answer"
    break
  fi
done

if [[ "$RESP" == "Accepted" ]] && ((PE != 0)); then
  RESP="Presentation Error"
fi

echo "$RESP"

rm -rf $TMPDIR
