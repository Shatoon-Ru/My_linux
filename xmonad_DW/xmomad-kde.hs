import XMonad
import XMonad.Config.Azerty
import XMonad.Config.Kde
import XMonad.Util.EZConfig -- для привязки клавиш
import XMonad.Util.Ungrab
import qualified XMonad.StackSet as W -- to shift and float windows
import XMonad.Layout.Spacing -- пространство между окнами
import XMonad.Layout.NoBorders  
import XMonad.Layout.PerWorkspace
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.ThreeColumns -- три колонки окон
import XMonad.Layout.Magnifier -- увеличение окна в фокусе

-- Xmobar

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers



main :: IO ()
main = xmonad
       . ewmh
       . ewmhFullscreen 
       . withEasySB (statusBarProp "xmobar ~/.config/xmonad/xmobar/xmobarrc" (pure def)) defToggleStrutsKey
       $ myConfig 
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)


myConfig = kde4Config 
    { modMask = mod4Mask -- use the Windows button as mod
    , manageHook = manageHook kdeConfig <+> myManageHook
    , borderWidth = 1  
    , normalBorderColor = "#2f8f8f"  
    , focusedBorderColor = "#00ff00"
    , layoutHook = myLayout
    , workspaces = myWorkspaces 
    --, keys = myKeys
    }
  `additionalKeysP`
    [ ("M-z", kill)
    , ("M-S-=", unGrab *> spawn "scrot -s"        )
    , ("M-]"  , spawn "firefox"                   )
    ]
myManageHook = composeAll . concat $
    [ [ className   =? c --> doFloat           | c <- myFloats]
    , [ title       =? t --> doFloat           | t <- myOtherFloats]
    , [ className   =? c --> doF (W.shift "2") | c <- webApps]
    , [ className   =? c --> doF (W.shift "3") | c <- ircApps]
    ]
  where myFloats      = ["MPlayer", "Gimp", "ksmserver", "plasmashell"]
        myOtherFloats = ["alsamixer"]
        webApps       = ["firefox", "Opera"] -- open on desktop 2
        ircApps       = ["Ksirc"]                -- open on desktop 3
 
defaultLayouts = tiled ||| Mirror tiled ||| Full  ||| threeCol
  where  
      -- раскладка окон в три ряда
      threeCol = magnifiercz' 2 $ ThreeColMid nmaster delta ratio
      -- алгоритм разбиения по умолчанию разбивает экран на две панели  
      tiled = spacing 3 $ Tall nmaster delta ratio  
   
      --  Количество окон по умолчанию в главной панели 
      nmaster = 1  
   
      --  Доля экрана по умолчанию, занимаемая главной панелью
      ratio = 4/7  
   
      -- Процент увеличения экрана при изменении размера панелей 
      delta = 1/100 
       -- Определите макет для определенных рабочих областей
nobordersLayout = noBorders $ Full  
   
 -- Соберите все макеты вместе 
myLayout = onWorkspace "2:web" nobordersLayout $ defaultLayouts 

  -- Определите количество и названия рабочих областей
myWorkspaces = ["1:main","2:web","3","whatever","5:media","6","7","8:web"]      

-- Xmobar config
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

