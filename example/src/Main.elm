module Main exposing (..)

import EmbeddedGist
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes exposing (attribute, class)
import Html.Events as Events
import Html.Lazy exposing (lazy)


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( { targetGist = Nothing
      }
    , Cmd.none
    )



-- MODEL


type alias Model =
    { targetGist : Maybe TargetGist
    }


type TargetGist
    = GistDefault
    | GistMap
    | GistSample


gistIdentifier : TargetGist -> String
gistIdentifier target =
    case target of
        GistDefault ->
            "arowM/836d478bda8cac261e1e5cab200a5ab0"

        GistMap ->
            "arowM/3dde727b1c53f9d49953e1c77abd5c84"

        GistSample ->
            "arowM/3af1c5d78c2aa9851838bc36b5134876"



-- UPDATE


type Msg
    = SelectTargetGist TargetGist


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectTargetGist target ->
            ( { model
                | targetGist = Just target
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        []
        [ staticGist
        , lazy gistSelector model.targetGist
        , Html.text "Here is an example embedded gist"
        , lazy embeddedGist model.targetGist
        ]


staticGist : Html Msg
staticGist =
    Html.div
        []
        [ EmbeddedGist.unsafeEmbeddedGist "arowM/456aaa1ce487170567317cdecec9c87f/Multiple2.elm"
        ]


gistSelector : Maybe TargetGist -> Html Msg
gistSelector mtarget =
    Html.div
        []
        [ Html.button
            [ Attributes.disabled <|
                mtarget
                    == Just GistDefault
            , Events.onClick <| SelectTargetGist GistDefault
            ]
            [ Html.text <| gistIdentifier GistDefault
            ]
        , Html.button
            [ Attributes.disabled <|
                mtarget
                    == Just GistMap
            , Events.onClick <| SelectTargetGist GistMap
            ]
            [ Html.text <| gistIdentifier GistMap
            ]
        , Html.button
            [ Attributes.disabled <|
                mtarget
                    == Just GistSample
            , Events.onClick <| SelectTargetGist GistSample
            ]
            [ Html.text <| gistIdentifier GistSample
            ]
        ]


embeddedGist : Maybe TargetGist -> Html Msg
embeddedGist memb =
    Html.div
        []
        [ case memb of
            Just emb ->
                EmbeddedGist.unsafeEmbeddedGist <| gistIdentifier emb

            Nothing ->
                Html.text "(No gist selected)"
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Helper functions


result : (l -> x) -> (r -> x) -> Result l r -> x
result onErr onOk res =
    case res of
        Err l ->
            onErr l

        Ok r ->
            onOk r
