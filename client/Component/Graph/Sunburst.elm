module Component.Graph.Sunburst exposing (Dial(..), graph)

import Browser
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Dict
import Set

type Direction
  = Clockwise
  | CounterClockwise

type Dial = Dial
  { value: Int
  , children: List Dial
  , label: String
  }

type alias InternalDial =
  { depth: Int
  , proportion: Float
  , startProportion: Float
  , color: String
  , label: String
  }

filterDials : List InternalDial -> List InternalDial
filterDials dials =
  dials
    |> List.filter (\di -> di.proportion > 0.005)

toInternal : List Dial -> List InternalDial
toInternal dials =
  let
    childrenToColor d =
      if List.length d.children == 0 then
        "#77dd77"
      else
        "#a5d6f7"
    recursiveInternal : List Dial -> Int -> Float -> Float -> List InternalDial
    recursiveInternal externalDials depth maxProportion startProportion =
      let
        total = List.foldl (\(Dial di) acc -> acc + di.value) 0 externalDials
      in
        (List.foldl (\(Dial di) acc ->
          { dials = InternalDial
              depth
              ((toFloat di.value) / (toFloat total) * maxProportion)
              acc.occupiedProportion
              (childrenToColor di)
              di.label
              :: List.concat
                [ recursiveInternal
                  di.children
                  (depth + 1)
                  ((toFloat di.value) / (toFloat total) * maxProportion)
                  acc.occupiedProportion
                , acc.dials
                ]
            , occupiedProportion = acc.occupiedProportion + ((toFloat di.value) / (toFloat total) * maxProportion)
          }
        ) {dials = [], occupiedProportion = startProportion} externalDials).dials
  in
    recursiveInternal dials 0 1 0

update _ model =
  model

move : (Float, Float) -> String
move (x, y) =
  "M " ++ (String.fromFloat <| x) ++ " " ++ (String.fromFloat <| y)

curve : (Float, Float) -> (Float, Float) -> (Float, Float) -> String
curve (x1, y1) (x2, y2) (x, y) =
  "C " ++ (String.fromFloat x1) ++ " " ++ (String.fromFloat y1) ++ ", " ++ (String.fromFloat x2) ++ " " ++ (String.fromFloat y2) ++ ", " ++ (String.fromFloat x) ++ " " ++ (String.fromFloat y)

smartCurve : Direction -> Float -> Float -> Float -> String
smartCurve direction radius startAngle proportion =
  let
    maxProportion = 0.2
  in
    if proportion <= 0 || isNaN proportion then
      ""
    else
      let
        angle = (Basics.min maxProportion proportion) * 2 * pi
        endAngle =
          case direction of
            Clockwise -> startAngle + angle
            CounterClockwise -> startAngle - angle
        control = 4/3 * tan(pi/(2 * (1/(angle/(pi*2))))) * radius
        (startControlXModifier, startControlYModifier) =
          case direction of
            Clockwise -> (-1, 1)
            CounterClockwise -> (1, -1)
        (endControlXModifier, endControlYModifier) =
          case direction of
            Clockwise -> (1, -1)
            CounterClockwise -> (-1, 1)
      in
        String.join " "
          [ curve
            (control * sin startAngle * startControlXModifier + radius * cos startAngle, control * cos startAngle * startControlYModifier + radius * sin startAngle)
            (control * sin endAngle * endControlXModifier + radius * cos endAngle, control * cos endAngle * endControlYModifier + radius * sin endAngle)
            (radius * cos endAngle, radius * sin endAngle)
          , smartCurve direction radius endAngle (proportion - maxProportion)
          ]

line : (Float, Float) -> String
line (x, y) =
  "L " ++ (String.fromFloat x) ++ " " ++ (String.fromFloat y)

graph : List Dial -> Svg msg
graph dials =
  let
    size = 100
    maxRadius = size / 2
    emptyCenterRadius = 15
    levels = Set.size <| List.foldl (\di acc -> Set.insert di.depth acc) Set.empty <| filterDials <| toInternal dials
    thickness = (maxRadius - emptyCenterRadius) / (toFloat levels)
    dial : InternalDial -> Svg msg
    dial {depth, proportion, startProportion, color, label} =
      let
        startAngle = startProportion * 2 * pi
        endAngle = startAngle + proportion * 2 * pi
        outerRadius = maxRadius - (toFloat (levels - depth - 1)) * thickness
        innerRadius = maxRadius - thickness - (toFloat (levels - depth - 1)) * thickness
        start =
          move (outerRadius * cos startAngle, outerRadius * sin startAngle)
        exterior =
          smartCurve Clockwise outerRadius startAngle proportion
        bridge =
          line (innerRadius * cos endAngle, innerRadius * sin endAngle)
        interior =
          smartCurve CounterClockwise innerRadius endAngle proportion
        closing =
          line (outerRadius * cos startAngle, outerRadius * sin startAngle)
      in
        Svg.path
          [ d <| String.join " " [start, exterior, bridge, interior, closing]
          , Html.Attributes.style "fill" color
          , Html.Attributes.style "stroke" "white"
          , Html.Attributes.style "stroke-width" "0.4"
          ] [ Svg.title [] [ text label ] ]
  in
    svg
      [ viewBox <| "-" ++ (String.fromFloat <| maxRadius) ++ " -" ++ (String.fromFloat <| maxRadius) ++ " " ++ (String.fromInt size) ++ " " ++ (String.fromInt size)
      , Html.Attributes.style "background-color" "white"
      , Html.Attributes.style "max-height" "90vh"
      ] <| List.map dial <| filterDials <| toInternal dials
