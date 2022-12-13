{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}
{-# OPTIONS_GHC -fno-warn-unused-local-binds #-}

import Data.Text
import Yesod

import Data.Either (isLeft)
import Text.Cassius (renderCss)
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
                  FormSuccess val -> unpack val
                  FormFailure xs  -> show xs
                  _               -> ""
    processed <- liftIO $ process input
    let 
        result :: Text
        result = pack $ case processed of
                   Left err  -> err
                   Right val -> val

        textColor :: Text
        textColor = if isLeft processed
                      then "red"
                      else "black"

        css = renderCss ([cassius|
                         #result
                            color: #{textColor}
                        |] undefined)
    [whamlet|
      $doctype 5
      <head>
          <style>
            #{css}
      <body>
          <h1> Dater
          <form enctype=#{enctype}>
              ^{widget}
          $if formResult == FormMissing
            <p>
          $else 
            <p> <span id="result">#{result}
    |]

main :: IO ()
main = warp 3000 App
