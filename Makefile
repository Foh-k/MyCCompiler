CC := dmd
FILES := mycc.d myerr.d
EXF := mycc myerr

mycc: $(FILES)
	$(CC) $(FILES)

test: mycc
	./test.sh

clean:
	$(RM) $(EXF) *.o *~ tmp*

.PHONY: test clean