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
import SHA


{-| Render function to construct a node that generates a script tag to generate embedded gist code block in it.

e.g.,

    div
        [ class "wrapper" ]
        [ unsafeEmbeddedGist "arowM/456aaa1ce487170567317cdecec9c87f"
        ]

You can specify a single file in a gist as follows.

    div
        [ class "wrapper" ]
        [ unsafeEmbeddedGist "arowM/456aaa1ce487170567317cdecec9c87f/Multiple2.elm"
        ]

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
                            , gistBaseUrl str
                            , ".json"
                            , "?callback="
                            , handlerName str
                            , case String.split "/" str of
                                user :: hash :: file :: _ ->
                                    String.concat
                                        [ "&file="
                                        , file
                                        ]

                                _ ->
                                    ""
                            ]
                    ]
                    []
                ]
          )
        ]



-- Helper functions


handlerName : String -> String
handlerName str =
    "handleGist" ++ SHA.sha1sum str


wrapperId : String -> String
wrapperId str =
    "js-elm-embedded-gist-" ++ SHA.sha1sum str


gistBaseUrl : String -> String
gistBaseUrl str =
    case String.split "/" str of
        user :: hash :: _ ->
            String.join "/" [ user, hash ]

        _ ->
            str


noPadding : Attribute msg
noPadding =
    Attributes.style
        [ ( "padding"
          , "0"
          )
        ]
