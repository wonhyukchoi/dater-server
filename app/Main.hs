{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# LANGUAGE MultiParamTypeClasses #-}

import Data.Text
import Yesod
import Dater (process)

data App = App

mkYesod "App" [parseRoutes|
/       HomeR GET
/dater DaterR GET
|]

instance Yesod App

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

getHomeR :: Handler ()
getHomeR = redirect DaterR

inputForm :: Html -> MForm Handler (FormResult Text, Widget)
inputForm = renderDivs $ areq textField "" Nothing

getDaterR :: Handler Html
getDaterR = do
  ((formResult, widget), enctype) <- runFormGet inputForm
  defaultLayout $ do
    setTitle "Dater: A Web Version"
    let input = case formResult of
                  FormSuccess val -> show val
                  FormFailure xs  -> show xs
                  _               -> ""
    processed <- liftIO $ process input
    let result = if formResult == FormMissing
                   then ""
                   else case processed of
                     Left err  -> err
                     Right val -> val
    [whamlet|
      <h1> Dater
      <form enctype=#{enctype}>
          ^{widget}
      <p> #{result}
    |]

main :: IO ()
main = warp 3000 App
