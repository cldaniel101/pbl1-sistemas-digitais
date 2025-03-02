#ifndef __MATRIX_H__
#define __MATRIX_H__

#include <mpu/common.h>

typedef struct {
    u8 length;
    i8 data[5][5];
} Matrix;

void mpu_add(Matrix *x, Matrix *y, Matrix *out);
void mpu_sub(Matrix *x, Matrix *y, Matrix *out);

#endif