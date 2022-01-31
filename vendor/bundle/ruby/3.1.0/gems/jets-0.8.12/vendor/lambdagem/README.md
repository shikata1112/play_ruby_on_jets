# Lambdagem

Tool to manage gems designed for AWS Lambda. Some gems require compiled binary dependencies. Lambdagem is useful for handling these types of gems.  This tool does the following:

* Builds, packages, and uploads a gem artifact to s3.
* Downloads and extracts the gem from s3 in a consistent fashion.

## Summary

Summary of the important folders and files:

Folder  | Description
------------- | -------------
/tmp/lambdagem  | Original area where gem is built.  You can find the generated Gemfile in here.
/tmp/lambdagem/bundled/gems  | Where built gems are vendored.
/tmp/lambdagem/artifacts/byebug-9.1.0/bundled  | Folder where the slimmed version of the artifacts are copied over.  Care is taken to include only the necessary files to keep the size small.
/tmp/lambdagem/artifacts/byebug-9.1.0-x86_64-linux.tgz  |  The created tarball.  The tarball contains "bundled" folder which contain the original underlying folder structure.
s3://lambdagems/gems/2.5.0/byebug/byebug-9.1.0-x86_64-linux.tgz  | Example bucket path where the tarball gets uploaded.  The tgz file contains the containing `bundled` folder.

## Usage

### Build Gem

The build command should be run on an AWS Lambda AMI EC2 instance. To build the latest version of a gem:

```sh
lambdagem build byebug
```

The gem gets built in the `/tmp/lambdagem` folder and is vendored to `/tmp/lambdagem/bundled/gems`. The `/tmp/lambdagem` folder is cleared out at the beginning of each run. To build a specific version append the version to the name like so:

```sh
lambdagem build byebug-0.9.1
```

The build command produces a `bundled` folder containing the gem and any compiled .so extensions belonging to the gem.

The bundled folder does not include system library files outside of the gem. The bundled folder is left in place though so that additional scripts can add system library dependencies to the same bundled folder.  If there are no system dependencies to be added, move onto creating the tarball package.

To package up the bundled folder into a tarball:

```sh
lambda package byebug
```

The package command produces a compressed tarball that contains the bundled folder and its binary extensions. Lambdagem temporarily stores the tarball at:

```
/tmp/lambdagem/artifacts/byebug-9.1.0-x86_64-linux.tar.gz
```

Next, upload to s3:

```sh
lambdagem upload byebug --s3 S3_BUCKET
```

The file will be uploaded to s3 with this path structure:

```
s3://S3_BUCKET/gems/MINOR_RUBY_VERSION/byebug/byebug-9.1.0-x86_64-linux.tgz
```

Gems uploaded to s3 are public-read by default.  You can override this behavior by setting the environment variable `LAMBDAGEM_S3_ACL=private`.

### Extract Gem

The extract command can be run from any environment. Though the extracted gems will only work in an AWS Lambda Linux based environment.

The `--s3` option is required for the extract command. Here's an example how you would download a gem from s3 and extracts it in a standard way:

```sh
lambdagem extract byebug-0.9.1 --s3 lambdagems
```

This extracts the gem and produces a top-level `bundled` folder.  This bundled folded is meant to be added to your project folder.

AWS Lambda extracts your code to `/var/task` so this will result in producing a final `/var/task/bundled` folder in the Lambda environment.

# Concepts to Understand

To understand how this tool works it is helpful to see how ruby structures gems on the file system.  The `lambdagem build` command makes a lot more sense when you understand the underlying structure.

## Bundling

There are 2 important folders to under the `bundled/gems` folder: gems and extensions.  Here are their paths with some helpful surrounding context:

* bundled/gems/ruby/2.5.0/gems/byebug-9.1.0
* bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0

Here are the relevant parts of the tree structure to help further understand:

```sh
$ tree -L 4 bundled/gems/ruby/2.5.0 # deleted some info to keep short
bundled/gems/ruby/2.5.0
├── extensions
│   └── x86_64-linux
│       └── 2.5.0-static
│          └── byebug-9.1.0
│── gems
│    └── byebug-9.1.0
└── specifications
$
```

So the strategy we'll employ is to tarball up the relevant gem folders from underneath the `bundled/gems/ruby/2.5.0` folder:

* 2.5.0/gems/byebug-9.1.0
* 2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0
* 2.5.0/specifications

We will then be able to extract the `bundled` folder and reproduce the `bundled/gems/ruby` path structure.

The tarball could be named `bundled.tgz` to be consistent with the `bundled` folder that is packaged up, but we elect to name the file with the gem info instead, example: `byebug-9.1.0-x86_64-linux.tgz`.

## S3 Uploaded Path

The `byebug-9.1.0-x86_64-linux.tgz` file gets uploaded to s3 at following path:

* s3://S3_BUCKET/gems/2.5.0/byebug/byebug-9.1.0-x86_64-linux.tgz

### Gem Extraction

To extract the gem and restore the directory structure, you can use the `lambdagem extract` command.  Also understanding the underlying folder structure helps make clear what the `lambdagem extract` command does.

Reminder that 2 important folders to under the `bundled/gems/ruby/2.5.0` folder are: gems, extensions and specifications.  Here are their paths with some helpful surrounding context:

* bundled/gems/ruby/2.5.0/gems/byebug-9.1.0
* bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0
* specifications

The `lambdagem extract` command should be run at the root of the project because it contains files for `bundled` folder with the original path structure.

Lambdagem will untar the file and **replace** the relevant folders under the `bundle/gems/ruby/2.5.0` folder.  For example, the existing gem folders will be deleted and replaced entirely:

* bundled/gems/ruby/2.5.0/gems/byebug-9.1.0
* bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0

Only the gem the `byebug-9.1.0` gem folders get replaced, the other gems are left alone.  Extra system dependencies added under the `bundled` folder are also left untouched.
