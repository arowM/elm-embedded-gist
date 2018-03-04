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

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Keyed as Keyed


{-| Render function to construct a node that generates a script tag for gist embedding in it.

e.g.,

    div
        [ class "wrapper" ]
        [ unsafeEmbeddedGist "arowM/836d478bda8cac261e1e5cab200a5ab0"
        ]

Above Elm view is rendered to bellow.

    <div class="wrapper">
        <div style="padding: 0px;">
            <script>
            function handleGist(json) {
                ...
            }
            </script>
            <script src="https://gist.github.com/arowM/836d478bda8cac261e1e5cab200a5ab0.json?callback=handleGist"></script>
        <div>
    </div>

-}
unsafeEmbeddedGist : String -> Html msg
unsafeEmbeddedGist str =
    Keyed.node "div"
        [ noPadding
        ]
        [ ( str
          , Html.div
                [ noPadding
                ]
                [ Html.div
                    [ Attributes.class <|
                        wrapperId str
                    ]
                    []
                , Html.node "script"
                    []
                    [ Html.text <| """
function """ ++ handlerName str ++ """(json) {
  var targets = document.getElementsByClassName(\"""" ++ wrapperId str ++ """");
  var stylesheet = document.createElement("link");
  stylesheet.rel = "stylesheet";
  stylesheet.href = json.stylesheet;
  Array.prototype.slice.call(targets || []).forEach(function(target) {
    if (!!target.innerHTML) return;
    target.insertAdjacentHTML('beforeend', json.div);
    target.appendChild(stylesheet);
  });
}
              """
                    ]
                , Html.node "script"
                    [ Attributes.src <|
                        String.concat
                            [ "https://gist.github.com/"
                            , str
                            , ".json?callback="
                            , handlerName str
                            ]
                    ]
                    []
                ]
          )
        ]



-- Helper functions


handlerName : String -> String
handlerName str =
    "handleGist" ++ String.filter (\c -> c /= '/') str


wrapperId : String -> String
wrapperId str =
    "js-elm-embedded-gist-" ++ str


noPadding : Attribute msg
noPadding =
    Attributes.style
        [ ( "padding"
          , "0"
          )
        ]
