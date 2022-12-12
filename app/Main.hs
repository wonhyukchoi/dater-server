import Application () -- for YesodDispatch instance
import Foundation ( App(App) )
import Yesod.Core ( warp )

main :: IO ()
main = warp 3000 App
