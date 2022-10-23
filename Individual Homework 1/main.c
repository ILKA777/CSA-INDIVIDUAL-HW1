#include <stdio.h>

static int A[1048576];
static int B[1048576];

extern void fill_array(int n);
extern void print_result(int n);

void fill_array(int n) {
    int i;
    
    for (i = 0; i < n; ++i) {
        scanf("%d",&A[i]);
    }
}

void print_result(int n) {
    int i;
    for (i = 0; i < n; ++i) {
        printf("%d", B[i]);
    }
}

int main(int argc, char** argv)
{
    int n, i, result, evensum, notevensum;
    evensum = 0;
    notevensum = 0;
    

    scanf("%d", &n);
    fill_array(n);
    for (i = 0; i < n; ++i) {
        if (A[i] >= 0) {
            evensum += A[i];
        } else {
            notevensum += A[i];
        }
    }
    
    for (i = 0; i < n; ++i) {
        if (i%2 == 0) {
            B[i] = evensum;
        } else {
            B[i] = notevensum;
        }
    }
    
    print_result(n);
    
    return 0;
}

