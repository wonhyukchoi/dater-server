{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}
module Foundation ( Route(AddR, HomeR), Handler, App(App), resourcesApp ) where

import Yesod.Core
    ( mkYesodData, parseRoutesFile, Yesod, RenderRoute(renderRoute) , Route)

data App = App

mkYesodData "App" $(parseRoutesFile "routes.yesodroutes")

instance Yesod App
