import civs
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

type Model {
  Model(draft: String, committed: String)
}

fn init(_args) -> Model {
  Model("", "")
}

type Msg {
  UserTyping(String)
  UserPressedEnter
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserTyping(value) -> Model(..model, draft: value)

    UserPressedEnter -> Model(draft: "", committed: model.draft)
  }
}

fn view(model: Model) -> Element(Msg) {
  let display_value = case model.committed {
    "" -> model.draft
    _ -> model.committed
  }
  html.div(
    [
      attribute.styles([
        #("display", "flex"),
        #("flex-direction", "column"),
        #("justify-content", "center"),
        #("align-items", "center"),
        #("height", "50vh"),
        #("gap", "0.5rem"),
      ]),
    ],
    [
      html.input([
        attribute.type_("text"),
        attribute.value(display_value),
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

      // Replace this with another implementation eventually for styling support
      html.datalist([attribute.id("civ-suggestions")], civs.all_civ_strings()),
      html.p([], [element.text("" <> model.committed)]),
    ],
  )
}
