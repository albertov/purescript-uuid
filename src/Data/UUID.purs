module Data.UUID
  ( UUID()
  , GENUUID()
  , genUUID
  , parseUUID
  ) where

import Prelude (class Ord, class Eq, class Show, compare, (==), ($), pure, (<<<), (>>=), map)
import Control.Monad.Eff (Eff, kind Effect)
import Data.Maybe (Maybe(Nothing, Just))
import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode, class Encode, decode, encode)

newtype UUID = UUID String

-- | The effect of generating a new UUID.
foreign import data GENUUID :: Effect

foreign import getUUIDImpl :: forall e. Eff (uuid :: GENUUID | e) String

-- | Generates a v4 UUID
genUUID :: forall e. Eff (uuid :: GENUUID | e) UUID
genUUID = getUUIDImpl >>= pure <<< UUID

foreign import validateV4UUID :: String -> Boolean

-- | Validates a String as a v4 UUID
parseUUID :: String -> Maybe UUID
parseUUID str = case validateV4UUID str of
  true -> Just $ UUID str
  _    -> Nothing

instance showUUID :: Show UUID where
  show (UUID uuid) = uuid

instance eqUUID :: Eq UUID where
  eq (UUID uA) (UUID uB) = uA == uB

instance ordUUID :: Ord UUID where
  compare (UUID uA) (UUID uB) = compare uA uB

derive instance genericUUID :: Generic UUID _
instance encodeUUID :: Encode UUID where
  encode (UUID s) = encode s

instance decodeUUID :: Decode UUID where
  decode = map UUID <<< decode
