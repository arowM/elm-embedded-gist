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
    Html.div
        [ noPadding
        ]
        [ Html.node "script"
            []
            [ Html.text """
function handleGist(json) {
    var scripts = document.getElementsByTagName("script");
    var thisTag = scripts[scripts.length - 1];
    var stylesheet = document.createElement("link");
    stylesheet.rel = "stylesheet";
    stylesheet.href = json.stylesheet;
    Array.prototype.slice.call(thisTag.parentNode.children).forEach(function(child){
      if (child.tagName === "SCRIPT") return;
      thisTag.parentNode.removeChild(child);
    });
    thisTag.parentNode.insertAdjacentHTML('beforeend', json.div);
    thisTag.parentNode.appendChild(stylesheet);
}
            """
            ]
        , Keyed.node "div"
            [ noPadding
            ]
            [ ( str
              , Html.node "script"
                    [ Attributes.src <|
                        String.concat
                            [ "https://gist.github.com/"
                            , str
                            , ".json?callback=handleGist"
                            ]
                    ]
                    []
              )
            ]
        ]



-- Helper functions


noPadding : Attribute msg
noPadding =
    Attributes.style
        [ ( "padding"
          , "0"
          )
        ]
