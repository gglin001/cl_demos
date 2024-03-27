kernel void
absf (global const float *in,
      global float *out)
{
  printf("gid: %d, lid: %d, gid: %d \n",
    get_global_id(0), get_local_id(0), get_group_id(0));
  size_t gid = get_global_id(0);
  out[gid] = in[gid] * -1;
}
