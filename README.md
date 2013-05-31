This is a toy plugin for XChat written in Haskell (compiler GHC) on Linux.

It still has some potential problems:

* memory allocated for strings is not freed
* similarly, a FunPtr is not freed
* magic number 3 is used where it should be XCHAT_EAT_ALL

Further reading:

* my [calling Haskell shared libraries from C (Linux)](http://www.vex.net/~trebla/haskell/so.xhtml)
* [XChat plugin interface doc](http://xchat.org/docs/plugin20.html)
