Pakcages gem into a tarball. The tarball created is named after the gem name with version, but it contains the "bundled" folder with the underlying full structure.

It is meant to be extracted via:

  mkdir -p /var/task
  tar zxf byebug-0.9.1.tgz -C /var/task
  # creates /var/task/bundled

Same as:

  mkdir -p /var/task
  cd /var/task && tar zxf byebug-0.9.1.tgz
  # creates /var/task/bundled

Examples:

  $ lambdagem package byebug

  $ lambdagem package byebug-0.9.1

