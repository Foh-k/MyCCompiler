CC := dmd

FILES := mycc.d
FILES += myerr.d
FILES += tokens.d
FILES += assembly.d
FILES += rdp.d
# FILES += tools/convgraph.d

EXFILE := mycc
EXFILE += myerr
EXFILE += tokens
EXFILE += rdp
EXFILE += assembly
# EXFILE += tools/convgraph

mycc: $(FILES)
	$(CC) $(FILES)

test: mycc
	./test.sh

clean:
	$(RM) $(EXFILE) *.o *~ tmp*

.PHONY: test clean