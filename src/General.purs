module General where
-- This module contains components used by multiple pages

import Prelude
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

data NavBarState = NavBarHome | NavBarQuizzes | NavBarSummaries | NavBarNotes | NavBarAccount
derive instance eqNavBarState :: Eq NavBarState
navBarStates :: Array String
navBarStates = ["Home", "Quizzes", "Summaries", "Notes", "Account"]

data NavBarMessage = NavState NavBarState

toNavBarState :: String -> NavBarState
toNavBarState = case _ of
  "Home" -> NavBarHome
  "Quizzes" -> NavBarQuizzes
  "Summaries" -> NavBarSummaries
  "Notes" -> NavBarNotes
  "Account" -> NavBarAccount
  _ -> NavBarHome

data NavBarQuery a =
  SetNav String a
  | GetNav (NavBarState -> a)

navBar :: forall m. H.Component HH.HTML NavBarQuery Unit NavBarMessage m
navBar =
  H.component {
    initialState: const initialState,
    render,
    eval,
    receiver: const Nothing
              }
  where
    initialState :: NavBarState
    initialState = NavBarHome

    render :: NavBarState -> H.ComponentHTML NavBarQuery
    render state = HH.div_ $ map (\s ->
                                   if toNavBarState s == state
                                   then HH.span_ [HH.text s, HH.text "Selected"]
                                   else HH.span [
                                     HE.onClick (HE.input_ (SetNav s))
                                                ] [HH.text s]) navBarStates

    eval :: NavBarQuery ~> H.ComponentDSL NavBarState NavBarQuery NavBarMessage m
    eval = case _ of
      SetNav val next -> do
        H.put $ toNavBarState val
        H.raise $ NavState $ toNavBarState val
        pure next
      GetNav reply -> do
        state <- H.get
        pure (reply state)
