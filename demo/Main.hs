module Main where

import Prelude
import qualified Strelka.RequestParser as A
import qualified Strelka.ResponseBuilder as B
import qualified Strelka.WAI as D


main =
  D.strelkaServer 3000 (return . Right . runIdentity) route
  where
    route =
      A.consumeSegmentIfIs "hi" *> hi <|>
      A.consumeSegmentIfIs "bye" *> bye <|>
      notFound
      where
        hi =
          A.ensureThatAcceptsHTML *> html <|>
          text
          where
            html =
              pure (B.html "<h1>Hello world</h1>")
            text =
              pure (B.text "Hello world")
        bye =
          A.ensureThatAcceptsHTML *> html <|>
          text
          where
            html =
              pure (B.html "<h1>Goodbye world</h1>")
            text =
              pure (B.text "Goodbye world")
        notFound =
          pure (B.notFoundStatus <> B.text "Nothing's found")

