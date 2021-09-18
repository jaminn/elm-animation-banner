module Main exposing (..)

import Browser
import Browser.Dom as Dom
import Browser.Events exposing (onAnimationFrameDelta)
import Css exposing (..)
import Css.Transitions as Transition exposing (transition)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (class, css, id)
import Html.Styled.Events exposing (on, onClick, onMouseEnter, onMouseLeave)
import Html.Styled.Keyed as Keyed
import Html.Styled.Lazy exposing (lazy, lazy2)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { textX : Float
    , isPlaying : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1.5 False
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | LogoClicked
    | Tick Float
    | BannerClicked


getBannerX : Bool -> Float -> Float -> Float
getBannerX isPlaying x dt =
    if isPlaying then
        if x > 100 then
            -100

        else
            x + 0.05 * dt

    else
        x * 0.96 + 1.5 * 0.04


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LogoClicked ->
            ( model, Cmd.none )

        Tick t ->
            ( { model
                | textX =
                    getBannerX
                        model.isPlaying
                        model.textX
                        t
              }
            , Cmd.none
            )

        BannerClicked ->
            ( { model | isPlaying = not model.isPlaying }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta Tick ]



-- VIEW


bottomBtnStyle : Style
bottomBtnStyle =
    Css.batch
        [ fontSize (px 30)
        , color (hex "#47f")
        , paddingLeft (px 30)
        , paddingRight (px 30)
        , displayFlex
        , alignItems center
        , hover [ textShadow4 (px 1) (px 1) (px 10) (hex "#00000044") ]
        , transition [ Transition.textShadow 200, Transition.color 200 ]
        , active [ color (hex "#69f") ]
        ]


bannerView bannerStr xVal =
    div
        [ onClick BannerClicked
        , css
            [ position relative
            , height (px 50)
            , paddingLeft (px 10)
            , backgroundColor (hex "#555")
            , overflow hidden
            ]
        ]
        [ div
            [ css
                [ position absolute
                , minWidth (pct 100)
                , fontSize (px 18)
                , color (hex "#fff")
                , top (px 15)
                , whiteSpace noWrap
                , transforms [ translateX (pct xVal) ]
                ]
            ]
            [ text bannerStr ]
        ]


view : Model -> Html Msg
view model =
    div [ css [ position absolute, top zero, bottom zero, right zero, left zero, displayFlex, flexDirection column ] ]
        [ div [ css [ width (pct 100), flexShrink zero, minHeight (px 60), displayFlex, justifyContent spaceBetween, alignItems stretch, boxShadow4 (px 1) (px 1) (px 10) (hex "#00000022") ] ]
            [ div [ onClick LogoClicked, css [ width (px 240), position relative, hover [ textShadow4 (px 1) (px 1) (px 10) (hex "#00000044") ], transition [ Transition.textShadow 200 ] ] ]
                [ i [ class "fas fa-flag", css [ fontSize (px 40), color (hex "#444"), position absolute, top (px 8), left (px 18) ] ] []
                , div [ css [ fontSize (px 22), fontWeight bold, color (hex "#333"), position absolute, top (px 15), left (px 68) ] ]
                    [ text "애니메이션 배너" ]
                ]
            , div [] []
            ]
        , div
            [ css
                [ flexGrow (num 1)
                , overflow auto
                , paddingTop (px 30)
                , paddingBottom (px 30)
                , paddingLeft (px 10)
                , paddingRight (px 10)
                , property "user-select" "text"
                ]
            ]
            [ bannerView "모든 국민은 인간으로서의 존엄과 가치를 가지며, 행복을 추구할 권리를 가진다. " model.textX
            ]
        , div [ css [ width (pct 100), flexShrink zero, minHeight (px 60), displayFlex, justifyContent spaceAround, boxShadow4 (px 1) (px 1) (px 10) (hex "#00000022") ] ]
            [ div [ css [ bottomBtnStyle ] ]
                [ i [ class "fas fa-home" ] [] ]
            , div [ css [ bottomBtnStyle ] ]
                [ i [ class "fas fa-cube" ] [] ]
            , div [ css [ bottomBtnStyle ] ]
                [ i [ class "fas fa-user" ] [] ]
            ]
        ]
