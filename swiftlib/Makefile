OCAMLOPT=ocamlopt
OCAMLC=ocamlc
SRC=bitCodeTypes.ml bitCodeReader.ml swiftmoduleTypes.ml swiftmoduleReader.ml

#all: bytecode native

#native: swiftlib.cmxa
#bytecode: swiftlib.cma

#swiftlib.cmxa: $(SRC)
#	ocamlfind $(OCAMLOPT) -g -package extlib,core -thread -safe-string -a -o swiftlib.cmxa $(SRC)

swiftlib.cma: $(SRC)
	ocamlfind $(OCAMLC) -g -linkpkg -package extlib,core -thread -safe-string -o reader $(SRC)

clean:
	rm -rf swiftlib.cmxa swiftlib.cma swiftlib.lib swiftlib.a $(wildcard *.cmx) $(wildcard *.obj) $(wildcard *.o) $(wildcard *.cmi) $(wildcard *.cmo)

#.PHONY: all bytecode native clean

Makefile: ;
$(SRC): ;


