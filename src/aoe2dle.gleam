import gleam/int
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

import categories.{type Civilization, compare_civclass, compare_region}

pub type GuessResult {
  GuessResult(
    name_correct: Bool,
    civclass_similarity: Float,
    region_similarity: Float,
  )
}

pub fn compare_answer(correct: Civilization, guess: Civilization) -> GuessResult {
  GuessResult(
    name_correct: correct.name == guess.name,
    civclass_similarity: compare_civclass(correct.class, guess.class),
    region_similarity: compare_region(correct.region, guess.region),
  )
}

pub fn check_guess(guess: GuessResult) -> GameState {
  case guess {
    GuessResult(
      name_correct: True,
      civclass_similarity: _,
      region_similarity: _,
    ) -> Finished
    _ -> Ongoing
  }
}

pub type GameState {
  Finished
  Ongoing
}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
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

  html.div(
    [
      attribute.style("display", "flex"),
      attribute.style("flex-direction", "column"),
      attribute.style("justify-content", "center"),
      attribute.style("align-items", "center"),
      attribute.style("height", "50vh"),
    ],
    [
      html.button([event.on_click(UserClickedIncrement)], [html.text("+")]),
      html.p([], [html.text(count)]),
      html.button([event.on_click(UserClickedDecrement)], [html.text("-")]),
    ],
  )
}
