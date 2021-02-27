#include "stdio.h"
#include <time.h>
#include <stdlib.h>
#include "string.h"


__global__ void add(int *a , int *b, int *c, int n)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < n)
        c[index] = a[index] + b[index]; 

}


void randomints(int *arr, int size)
{
    for(int i = 0; i < size; i++)
    {   
        int rand = random();
        arr[i] = rand;
        
    }
    
}


void printRESULT(int *result, char *name)
{   
    printf("--------------%s-----------------\n",name);
    for(int i = 0; result[i] != NULL; i++)
    {
        printf("%d , ",result[i]);

    }
    printf("\n");


}


#define N (16384*16384)
#define THREADS_PER_BLOCK 512
int main(int argc, char *argv[])
{
    //init time
    srand(time(NULL));
    int show = 0;

    //check for cli args
    if(argc > 1)
    {
        printf("%s",argv[1]);
        if(strcmp(argv[1],"show") == 0)
        {
            show = 1;
        }
    }


    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = N * sizeof(int);
    
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);

    
    a = (int *)malloc(size); randomints(a,N);
    b = (int *)malloc(size); randomints(b,N);
    c = (int *)malloc(size);
    
    if(show)
    {
        printRESULT(a,"a");
        printRESULT(b,"b");
    } 

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    add<<<(N+THREADS_PER_BLOCK-1)/ THREADS_PER_BLOCK, THREADS_PER_BLOCK>>>(d_a, d_b, d_c,N);
    
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
    
    if(show)
    { 
        printRESULT(c,"c");
    }

    free(a); free(b), free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);

    return 0;



}
