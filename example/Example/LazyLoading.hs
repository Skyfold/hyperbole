{-# LANGUAGE UndecidableInstances #-}

module Example.LazyLoading where

import Data.Text (pack)
import Effectful
import Example.Effects.Debug
import Web.Hyperbole


-- this is already running in a different context
page :: (Hyperbole :> es, Debug :> es) => Page es '[Contents]
page = do
  pure $ do
    row (pad 20) $ do
      col (gap 10 . border 1 . pad 20) $ do
        hyper Contents viewInit


data Contents = Contents
  deriving (Show, Read, ViewId)
instance HyperView Contents where
  type Action Contents = ContentsAction


data ContentsAction
  = Load
  | Reload Int
  deriving (Show, Read, ViewAction)


instance (Debug :> es) => Handle Contents es where
  handle Load = do
    -- Pretend the initial Load takes 1s to complete
    delay 1000
    pure $ onLoad (Reload 1) 1000 $ do
      el id "Loaded, should reload once more..."
  handle (Reload n) = do
    -- then reload after a 1s delay (client-side)
    pure $ onLoad (Reload (n + 1)) 1000 $ do
      col (gap 10) $ do
        el_ "Reloaded! polling..."
        el_ $ text $ pack $ show n


viewInit :: View Contents ()
viewInit = do
  onLoad Load 0 $ do
    el id "Lazy Loading..."
