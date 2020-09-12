CC := dmd

FILES := mycc.d
FILES += myerr.d
FILES += tokens.d
FILES += assembly.d
FILES += rdp.d

EXFILE := mycc
EXFILE += myerr
EXFILE += tokens
EXFILE += rdp
EXFILE += assembly


mycc: $(FILES)
	$(CC) $(FILES)

test: mycc
	./test.sh

clean:
	$(RM) $(EXFILE) *.o *~ tmp*

.PHONY: test clean