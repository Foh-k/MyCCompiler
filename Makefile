mycc: mycc.d

test: mycc
	./test.sh

clean:
	rm -f mycc *.o *~ tmp*

.PHONY: test clean