kernel void
absf (__global const float *in,
      __global float *out)
{
  // printf("absf in cl\n");
  int gid = get_global_id(0);
  out[gid] = abs(in[gid]);
}
