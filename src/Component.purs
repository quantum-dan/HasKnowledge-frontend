module Component where

import Prelude
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = String

data Query a
  = SetValue String a
  | GetValue (String -> a)

data Message = Value String

mainBody :: forall m. H.Component HH.HTML Query Unit Message m
mainBody =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState = ""

  render :: State -> H.ComponentHTML Query
  render state =
    let
      label = state
    in
      HH.div_
        [ HH.text label,
          HH.input
          [
            HP.type_ HP.InputText,
            HP.placeholder "New label",
            HE.onValueInput (HE.input SetValue)
          ]
          ]

  eval :: Query ~> H.ComponentDSL State Query Message m
  eval = case _ of
    SetValue value next -> do
      -- state <- H.get
      -- let nextState = not state
      H.put value
      H.raise $ Value value
      pure next
    GetValue reply -> do
      state <- H.get
      pure (reply state)
