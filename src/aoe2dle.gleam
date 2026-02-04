import gleam/int
import gleam/list
import gleam/set
import gleam/string
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import lustre/server_component

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type CivClass {
  Archer
  Cavalry
  Infantry
  Siege
  Gunpowder
  Camel
  Elephant
  Naval
  Defensive
  CavalryArcher
}

fn civclass_to_string(civclass: CivClass) -> String {
  case civclass {
    Archer -> "Archer"
    Cavalry -> "Cavalry"
    Infantry -> "Infantry"
    Siege -> "Siege"
    Gunpowder -> "Gunpowder"
    Camel -> "Camel"
    Elephant -> "Elephant"
    Naval -> "Naval"
    Defensive -> "Defensive"
    CavalryArcher -> "CavalryArcher"
  }
}

type Region {
  NativeAmerica
  SouthAsia
  NorthAfrica
  EastEurope
  WestEurope
  SouthEastAsia
  Mediterranean
  EastAsia
  Africa
  CentralEurope
  SouthEurope
  MiddleEast
}

fn region_to_string(region: Region) -> String {
  case region {
    NativeAmerica -> "Native America"
    SouthAsia -> "South Asia"
    NorthAfrica -> "North Africa"
    EastEurope -> "East Europe"
    WestEurope -> "West Europe"
    SouthEastAsia -> "South East Asia"
    Mediterranean -> "Mediterranean"
    EastAsia -> "East Asia"
    Africa -> "Africa"
    CentralEurope -> "Central Europe"
    SouthEurope -> "South Europe"
    MiddleEast -> "Middle East"
  }
}

fn jaccard_similarity(a: set.Set(a), b: set.Set(a)) -> Float {
  let intersection_size =
    set.intersection(a, b)
    |> set.size
    |> int.to_float

  let union_size =
    set.union(a, b)
    |> set.size
    |> int.to_float

  intersection_size /. union_size
}

fn compare_civclass(a: List(CivClass), b: List(CivClass)) -> Float {
  let set_a =
    a
    |> list.map(civclass_to_string)
    |> set.from_list

  let set_b =
    b
    |> list.map(civclass_to_string)
    |> set.from_list

  jaccard_similarity(set_a, set_b)
}

fn compare_region(a: Region, b: Region) -> Float {
  let set_a =
    region_to_string(a)
    |> string.split(on: " ")
    |> set.from_list

  let set_b =
    region_to_string(b)
    |> string.split(on: " ")
    |> set.from_list

  jaccard_similarity(set_a, set_b)
}

type Civilization {
  Civilization(name: String, class: List(CivClass), region: Region)
}

type GuessResult {
  GuessResult(
    name_correct: Bool,
    civclass_similarity: Float,
    region_similarity: Float,
  )
}

fn compare_answer(correct: Civilization, guess: Civilization) -> GuessResult {
  GuessResult(
    name_correct: correct.name == guess.name,
    civclass_similarity: compare_civclass(correct.class, guess.class),
    region_similarity: compare_region(correct.region, guess.region),
  )
}

type GameState {
  Finished
  Started
  NotStarted
}

type Model =
  Int

fn init(_args) -> Model {
  0
}

type Msg {
  UserClickedIncrement
  UserClickedDecrement
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserClickedIncrement -> model + 1
    UserClickedDecrement -> model - 1
  }
}

fn view(model: Model) -> Element(Msg) {
  let count = int.to_string(model)

  html.div([], [
    html.button([event.on_click(UserClickedIncrement)], [html.text("+")]),
    html.p([], [html.text(count)]),
    html.button([event.on_click(UserClickedDecrement)], [html.text("-")]),
  ])
}
