{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application () where

import Foundation ( Route(AddR, HomeR), App, resourcesApp )
import Yesod.Core ( mkYesodDispatch )

import Add ( getAddR )
import Home ( getHomeR )

mkYesodDispatch "App" resourcesApp
