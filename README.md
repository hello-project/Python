# Python
Python.framework for macOS

## Python & dependencies version
| Name | Git repo | Version | Tag | License |
|:-----|:---------|:--------|:----|:--------|
| Python | https://github.com/python/cpython.git | 3.7.3 | `v3.7.3` | [Python-2.0](https://opensource.org/licenses/Python-2.0) |
| OpenSSL | https://github.com/openssl/openssl.git | 1.1.1c | `OpenSSL_1_1_1c` | [Apache-2.0](https://opensource.org/licenses/Apache-2.0) |
| SQLite3 | http://repo.or.cz/sqlite.git | 3.28.0 | `version-3.28.0` | Public Domain |
| zlib | https://github.com/madler/zlib.git | 1.2.11 | `v1.2.11` | [zlib](https://opensource.org/licenses/Zlib) |
| bzip2 | https://sourceware.org/git/bzip2.git | 1.0.7 | `bzip2-1.0.7` | [bzip2-1.0.6](https://spdx.org/licenses/bzip2-1.0.6.html) |
| xz | https://git.tukaani.org/xz.git | 5.2.4 | `v5.2.4` | *see below* |

### xz license
> The most interesting parts of XZ Utils (e.g. liblzma) are in the public domain. You can do whatever you want with the public domain parts.
>
> Some parts of XZ Utils (e.g. build system and some utilities) are under different free software licenses such as GNU LGPLv2.1, GNU GPLv2, or GNU GPLv3.

Python.framework only link with `liblzma` which in the public domain.

## Build
~~~sh
brew install automake autoconf libtool gettext
make -j$(nproc)
~~~
