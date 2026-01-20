#include <assert.h>
#include <stdio.h>

// Function under test
int add(int a, int b) {
    return a + b;
}

int main() {
    assert(add(2,3) == 5);
    assert(add(-1,1) == 0);
    assert(add(0,0) == 0);

    printf("All unit tests passed!\n");
    return 0;
}

