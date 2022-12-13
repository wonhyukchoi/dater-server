{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}

import Data.Text
import Yesod
import Dater (process)

data App = App

mkYesod "App" [parseRoutes|
/ HomeR GET
/dater/#Text DaterR GET
|]

instance Yesod App

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Minimal Multifile"
    [whamlet|
        <p>
            <a href=@{DaterR "sample"}>HTML addition
    |]

getDaterR :: Text -> Handler Html
getDaterR input = defaultLayout $ do
  setTitle "Dater: A Web Version"
  processed <- liftIO $ process $ unpack input
  let result = case processed of
                 Left err  -> err
                 Right val -> val
  [whamlet|#{result}|]

main :: IO ()
main = warp 3000 App
