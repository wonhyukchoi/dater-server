{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Add (getAddR) where

import Foundation ( Handler )
import Yesod.Core
    ( object,
      provideRep,
      selectRep,
      provideJson,
      setTitle,
      whamlet,
      (.=),
      Yesod(defaultLayout),
      TypedContent )

getAddR :: Int -> Int -> Handler TypedContent
getAddR x y = selectRep $ do
    provideRep $ defaultLayout $ do
        setTitle "Addition"
        [whamlet|#{x} + #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x + y
