Builds, packages and uploads the gem to s3 all in one step. This is useful for simply compiled gems that do not required any shared .so files during runtime.

Examples:

  $ lambdagem all byebug --s3 lambdagems

So the above command is the same as running:

  $ lambdagem build byebug
  $ lambdagem package byebug
  $ lambdagem upload byebug --s3 lambdagems
