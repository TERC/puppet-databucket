define collect_buckets($type) {
  Bucket <<| (type == $type) |>>
}

