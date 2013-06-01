{-# LANGUAGE MagicHash #-}
module Whee() where

import Foreign
import Foreign.C
import GHC.Exts(Ptr(..))
import Data.IORef

newtype XChat = XChat (Ptr ())
newtype Hook = Hook (Ptr ())

foreign export ccall xchat_plugin_init ::
    XChat -> Ptr CString -> Ptr CString -> Ptr CString -> CString -> IO CInt

xchat_plugin_init xchat name desc vers _ = do
    poke name (Ptr "whee"#)
    poke desc (Ptr "a plugin in haskell"#)
    poke vers (Ptr "1.0"#)
    register_increase xchat
    return 1  -- 1 means no problem

-- foreign export ccall xchat_plugin_deinit :: XChat -> IO CInt
-- xchat_plugin_deinit _ = return 1

type Command_Hook a = Ptr CString -> Ptr CString -> Ptr a -> IO CInt

foreign import ccall xchat_hook_command ::
    XChat -> CString -> CInt -> FunPtr (Command_Hook a) -> CString -> Ptr a -> IO Hook

foreign import ccall xchat_print :: XChat -> CString -> IO ()

foreign import ccall "wrapper" mk_Command_Hook ::
    Command_Hook a -> IO (FunPtr (Command_Hook a))

register_increase xchat = do
    ref <- newIORef 0
    hook <- mk_Command_Hook (increase xchat ref)
    xchat_hook_command xchat (Ptr "increase"#) 0 hook
      (Ptr "increases an internal number, and prints"#) nullPtr

increase xchat ref _ _ _ = do
    n <- readIORef ref
    writeIORef ref (n+1)
    withCAString ("the next number is " ++ show n) (xchat_print xchat)
    return 3  -- 3 is XCHAT_EAT_ALL
