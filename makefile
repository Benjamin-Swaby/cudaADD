compile:
	nvcc main.cu -o main
	@echo "done"

run:
	./main > out.txt

profile:
	nvprof ./main

