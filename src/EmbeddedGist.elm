module EmbeddedGist
    exposing
        ( unsafeEmbeddedGist
        )

{-| An unrecommended (but useful) module to embed gist code block in Elm view.

⚠⚠⚠⚠⚠⚠⚠⚠🐐WARNING🐐⚠⚠⚠⚠⚠⚠⚠⚠

This module is harmful, so you should use it carefully.

  - this module could create an element that Elm cannot handle

⚠⚠⚠⚠⚠⚠⚠⚠🐐WARNING🐐⚠⚠⚠⚠⚠⚠⚠⚠


# Renderers

@docs unsafeEmbeddedGist

-}

import Html exposing (Html)
import Html.Attributes as Attributes


{-| Render function to construct a node that generates a script tag for gist embedding in it.

e.g.,

    div
        [ class "wrapper" ]
        [ unsafeEmbeddedGist "arowM/836d478bda8cac261e1e5cab200a5ab0"
        ]

Above Elm view is rendered to bellow.

    <div class="wrapper">
        <script src="https://gist.github.com/arowM/836d478bda8cac261e1e5cab200a5ab0.js"></script>
    </div>

-}
unsafeEmbeddedGist : String -> Html msg
unsafeEmbeddedGist str =
    Html.node "script"
        [ Attributes.src <|
            String.concat
                [ "https://gist.github.com/"
                , str
                , ".js"
                ]
        ]
        []
