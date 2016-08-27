include("cuda11.jl")

function cuda11src(f, j, ex; BLK=128, THR=128)
"""
__global__ void _$(f)_32_11(int n, float *x, float *y, float *z) {
  int i = threadIdx.x + blockIdx.x * blockDim.x;
  while (i < n) {
    z[i] = $ex;
    i += blockDim.x * gridDim.x;
  }
}
extern "C" {
  void $(f)_32_11(int n, float *x, float *y, float *z) {
    _$(f)_32_11<<<$BLK,$THR>>>(n,x,y,z);
  }    
}
__global__ void _$(f)_64_11(int n, double *x, double *y, double *z) {
  int i = threadIdx.x + blockIdx.x * blockDim.x;
  while (i < n) {
    z[i] = $ex;
    i += blockDim.x * gridDim.x;
  }
}
extern "C" {
  void $(f)_64_11(int n, double *x, double *y, double *z) {
    _$(f)_64_11<<<$BLK,$THR>>>(n,x,y,z);
  }    
}
"""
end

for a in cuda11
    isa(a,Tuple) || (a=(a,))
    print(cuda11src(a...))
end
