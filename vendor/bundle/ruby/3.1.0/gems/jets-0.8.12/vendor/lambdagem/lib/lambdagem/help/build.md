Builds a gem. Examples:

  lambdagem build byebug
  lambdagem build byebug-0.9.1

The lambdagem builds the gem in `/tmp/lambdagem`.  This is where you'll find the Gemfile that is produces and where you can test the gem.

A slim down version of `/tmp/lambdagem/bundled/gems` the is initial created in `/tmp/lambdagem/artifacts/byebug-0.9.1/bundled/gems`.  This slim down version contains only the byebug gem files.

When you are ready, the gem can be packaged to tarball with the `bundle package` command.  The tarball is stored at:

```
/tmp/lambdagem/artifacts/byebug-9.1.0-x86_64-linux.tar.gz
```
