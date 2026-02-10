import civs
import gleam/list
import gleam/string
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

import styles

import categories.{type Civilization, compare_civclass, compare_region}

pub type GuessResult {
  GuessResult(
    name_correct: Bool,
    civclass_similarity: Float,
    region_similarity: Float,
  )
}

pub type Guess {
  Guess(civ: Civilization, result: GuessResult)
}

pub fn compare_answer(correct: Civilization, guess: Civilization) -> GuessResult {
  GuessResult(
    name_correct: correct.name == guess.name,
    civclass_similarity: compare_civclass(correct.class, guess.class),
    region_similarity: compare_region(correct.region, guess.region),
  )
}

pub fn create_row(
  civ: categories.Civilization,
  result: GuessResult,
) -> Element(a) {
  let civclasses =
    civ.class |> list.map(categories.civclass_to_string) |> string.join(", ")
  let region = categories.region_to_string(civ.region)

  let name_style = case result.name_correct {
    True -> styles.box_correct()
    False -> styles.box_wrong()
  }

  let civclass_style = case result.civclass_similarity {
    1.0 -> styles.box_correct()
    0.0 -> styles.box_wrong()
    _ -> styles.box_partial()
  }

  let region_style = case result.region_similarity {
    1.0 -> styles.box_correct()
    0.0 -> styles.box_wrong()
    _ -> styles.box_partial()
  }

  html.div(
    [
      attribute.style("display", "flex"),
      attribute.style("margin-top", "20px"),
      attribute.style("gap", "5px"),
    ],
    [
      html.div(name_style, [element.text(civ.name)]),
      html.div(civclass_style, [element.text(civclasses)]),
      html.div(region_style, [element.text(region)]),
    ],
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

type Model {
  Model(
    draft: String,
    guesses: List(Guess),
    game_state: GameState,
    correct: Civilization,
  )
}

fn init(_args) -> Model {
  Model(
    draft: "",
    guesses: [],
    game_state: Ongoing,
    correct: case civs.find_civ("Georgians") {
      Ok(civ) -> civ
      Error(Nil) ->
        categories.Civilization(
          name: "Franks",
          class: [categories.Cavalry],
          region: categories.WestEurope,
        )
    },
  )
}

type Msg {
  UserTyping(String)
  UserPressedEnter
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserTyping(value) -> Model(..model, draft: value)

    UserPressedEnter ->
      case model.game_state {
        Finished -> model

        Ongoing ->
          case civs.find_civ(model.draft) {
            Error(Nil) ->
              // Invalid civ: ignore submission
              Model(..model, draft: "")

            Ok(civ) -> {
              let result = compare_answer(model.correct, civ)
              let guess = Guess(civ, result)
              let new_state = check_guess(result)

              Model(
                ..model,
                draft: "",
                guesses: [guess, ..model.guesses],
                game_state: new_state,
              )
            }
          }
      }
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.styles([
        #("display", "flex"),
        #("flex-direction", "column"),
        #("padding-top", "20px"),
        #("align-items", "center"),
        #("height", "50vh"),
        #("gap", "0.5rem"),
      ]),
    ],
    [
      html.h1([], [element.text("AoE2dle")]),

      html.input([
        attribute.type_("text"),
        attribute.value(model.draft),
        attribute.placeholder("Enter a civ"),
        attribute.list("civ-suggestions"),
        event.on_input(UserTyping),
        event.on_keydown(fn(key) {
          case key {
            "Enter" -> UserPressedEnter
            _ -> UserTyping(model.draft)
          }
        }),
      ]),

      html.datalist([attribute.id("civ-suggestions")], civs.all_civ_strings()),
      html.div(
        [],
        model.guesses
          |> list.map(fn(guess) {
            let Guess(civ, result) = guess
            create_row(civ, result)
          }),
      ),
    ],
  )
}
