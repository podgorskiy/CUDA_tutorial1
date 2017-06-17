#include <stdio.h>

__global__ void kernel(float* A) 
{
	int j = blockDim.x * blockIdx.x + threadIdx.x;
	int i = blockDim.y * blockIdx.y + threadIdx.y;

	float cr = float(j) / gridDim.x / blockDim.x * 3.0f - 2.0f;
	float ci = float(i) / gridDim.y / blockDim.y * 3.0f - 1.5f;
	
	float zr = 0.0f;
	float zi = 0.0f;

	int it = 0;

	for (; it < 255 && (zr * zr + zi * zi) < 10.0f; ++it)
	{
		float new_zr = zr * zr - zi * zi + cr;
		float new_zi = 2.0 * zi * zr + ci;
		zr = new_zr;
		zi = new_zi;
	}

	A[j + i * gridDim.x * blockDim.x] = float(it) / 255.0f;
}

int main()
{
	cudaError_t cudaStatus = cudaSetDevice(0);

	int size_x = 80;
	int size_y = 40;

	int threads_in_block_x = 8;
	int threads_in_block_y = 8;

	int blocks_x = size_x / threads_in_block_x;
	int blocks_y = size_y / threads_in_block_y;

	float* device_array = nullptr;
	cudaMalloc(&device_array, size_x * size_y * sizeof(float));

	kernel<<<dim3(blocks_x, blocks_y), dim3(threads_in_block_x, threads_in_block_y)>>>(device_array);

	float* host_array = new float[size_x * size_y];

	cudaMemcpy(host_array, device_array, size_x * size_y * sizeof(float), cudaMemcpyDeviceToHost);

	printf("\n");
	for (int i = 0; i < size_y; ++i)
	{
		for (int j = 0; j < size_x; ++j)
		{
			if (host_array[j + i * size_x] > 0.5)
			{
				printf("#");
			}
			else
			{
				printf("*");
			}
		}
		printf("\n");
	}

 	return 0;
}
