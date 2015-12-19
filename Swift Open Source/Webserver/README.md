# Webserver
simplest http server in swift powered by Epoch

# Installation

Install swift 2.2 from swift.org.
Install dependency libraries via homebrew:

```bash
OS X:
$ brew tap zewo/tap
$ brew install libvenice http_parser uri_parser

Ubuntu:
$ git clone https://github.com/Zewo/libvenice.git && cd libvenice
$ make
$ make package
$ dpkg -i libvenice.deb
$ git clone https://github.com/Zewo/http_parser.git && cd http_parser
$ make
$ make package
$ dpkg -i http_parser.deb
$ git clone https://github.com/Zewo/uri_parser.git && cd uri_parser
$ make
$ make package
$ dpkg -i uri_parser.deb
```

Build the project:

```bash
OS X & Ubuntu:
$ git clone git@github.com:cocoaheads-dd/presentations.git
$ cd presentations/Swift\ Open\ Source/Webserver/

OS X:
$ swift build

Ubuntu:
$ /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift build
```

Run the server:

```bash
$ .build/debug/Webserver
```

Now open your browser and type the following address (change the port if your VM is having port forwarding active):

```bash
http://localhost:8080/😁%26🎄%26❤%EF%B8%8F=🎁
```

