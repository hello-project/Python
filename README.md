# Python
[![Azure DevOps builds](https://img.shields.io/azure-devops/build/zengxs/1328e1bb-d2c2-48f3-9eac-9c0927fa3cd5/3.svg?logo=azure-pipelines)](https://dev.azure.com/zengxs/Python/_build?definitionId=3)

Python.framework for macOS

## Install

### Carthage
~~~
github "zengxs/python" "py36"
~~~

## Usage
At the first, you should initial the python framework.

~~~objc
#import <Python/framework-init.h>

PyFramework_Initialize();
~~~
Above code will initial the python package search path.

And then, import header file `<Python/Python.h>` and use the library like in C language.

## Thanks
Special thanks for project [python-portable-macos](https://github.com/carlosperate/python-portable-macos)
