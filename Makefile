# only works with the Java extension of yacc: 
# byacc/j from http://troi.lincom-asg.com/~rjamison/byacc/

JFLEX  = java -jar JFlex.jar 
BYACCJ = ./yacc.linux -tv -J
JAVAC  = javac
TESTS_FOLDER = ./tests
BIN_FOLDER = ./bin

.PHONY: all test clean

all: Parser.class

clean:
	rm -f *~ *.class *.o *.s Yylex.java Parser.java y.output
	rm -rf bin

Parser.class: TS_entry.java TabSimb.java Yylex.java Parser.java
	$(JAVAC) Parser.java

Yylex.java: cmm.flex
	$(JFLEX) cmm.flex

Parser.java: cmm.y
	$(BYACCJ) cmm.y

test: all
	@pass=0; total=0; \
	echo "=========== RUNNING TEST CASES ==========="; \
	for cmmfile in $$(find $(TESTS_FOLDER) -name "*.cmm"); do \
		cfile="$${cmmfile%.cmm}.c"; \
		if [ ! -f "$$cfile" ]; then \
			echo "⚠️ WARNING: C file not found for $$cmmfile"; \
			continue; \
		fi; \
		total=$$((total+1)); \
		./run.x "$$cmmfile"; \
		cmm_bin="$(BIN_FOLDER)/$$(basename "$$cmmfile" .cmm)"; \
		c_bin="$(BIN_FOLDER)/$$(basename "$$cfile" .c)-c"; \
		gcc "$$cfile" -o "$$c_bin"; \
		cmm_out="$(BIN_FOLDER)/$$(basename "$$cmmfile" .cmm).cmm.out"; \
		c_out="$(BIN_FOLDER)/$$(basename "$$cfile" .c).c.out"; \
		"$$cmm_bin" > "$$cmm_out" 2>&1; \
		"$$c_bin" > "$$c_out" 2>&1; \
		if ! diff -q "$$cmm_out" "$$c_out" > /dev/null; then \
			echo "❌ FAIL: $$(basename "$$cmmfile" .cmm)"; \
			echo "---- .cmm output ----"; cat "$$cmm_out"; \
			echo "---- .c output ----"; cat "$$c_out"; \
			echo "---------------------"; \
		else \
			echo "✅ PASS: $$(basename "$$cmmfile" .cmm)"; \
			pass=$$((pass+1)); \
		fi; \
	done; \
	echo "================= SUMMARY ================="; \
	if [ $$pass -eq $$total ]; then \
		echo "🎉🎉 All tests passed! 🎉🎉"; \
	else \
		echo "⚠️⚠️ Some tests failed ⚠️⚠️"; \
	fi; \