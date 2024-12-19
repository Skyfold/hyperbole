module Example.AppRoute where

import Data.Text (Text, unpack)
import Example.Effects.Users (UserId)
import Text.Read (readMaybe)
import Web.Hyperbole


data AppRoute
  = Main
  | Docs DocRoute
  | Simple
  | Hello Hello
  | Contacts ContactRoute
  | Transitions
  | Query
  | Counter
  | Forms
  | LiveSearch
  | Sessions
  | Requests
  | Redirects
  | RedirectNow
  | LazyLoading
  | Concurrent
  | Errors
  deriving (Eq, Generic, Show)
instance Route AppRoute where
  baseRoute = Just Main


data ContactRoute
  = ContactsAll
  | Contact UserId
  deriving (Eq, Generic, Show)
instance Route ContactRoute where
  baseRoute = Just ContactsAll
  matchRoute [] = pure ContactsAll
  matchRoute [""] = pure ContactsAll
  matchRoute [contactId] = do
    cid <- readMaybe $ unpack contactId
    pure $ Contact cid
  matchRoute _ = Nothing


data Hello
  = Greet Text
  | Redirected
  deriving (Eq, Generic, Route, Show)


data DocRoute
  = Intro
  deriving (Eq, Generic, Route, Show)
