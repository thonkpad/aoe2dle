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

pub fn compare_answer(correct: Civilization, guess: Civilization) -> GuessResult {
  GuessResult(
    name_correct: correct.name == guess.name,
    civclass_similarity: compare_civclass(correct.class, guess.class),
    region_similarity: compare_region(correct.region, guess.region),
  )
}

pub fn create_row(civ: categories.Civilization, result: GuessResult) {
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

// pub fn show_guess(civ: Civilization) {
//   let george = case list.last(civs.all) {
//     Ok(x) -> x
//     Error(Nil) ->
//       categories.Civilization(
//         name: "Lmao",
//         class: [categories.Infantry, categories.Cavalry],
//         region: categories.NativeAmerica,
//       )
//   }

//   compare_answer(george, civ)
//   |> todo
// }

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
  Model(draft: String, committed_items: List(String))
}

fn init(_args) -> Model {
  Model("", [])
}

type Msg {
  UserTyping(String)
  UserPressedEnter
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserTyping(value) -> Model(..model, draft: value)
    UserPressedEnter ->
      Model(draft: "", committed_items: [model.draft, ..model.committed_items])
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
      html.h1(
        [attribute.styles([#("margin", "0"), #("margin-bottom", "10px")])],
        [element.text("AoE2dle")],
      ),
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
        list.map(model.committed_items, fn(item) {
          html.p([], [element.text(item)])
        }),
      ),

      test_civ(),
    ],
  )
}

fn test_civ() {
  let x = case civs.all |> list.last {
    Ok(x) -> x
    Error(Nil) ->
      categories.Civilization(
        name: "Lmao",
        class: [categories.Infantry],
        region: categories.Africa,
      )
  }

  // Compare against the first civ or create a test civ
  let correct = x
  // categories.Civilization(
  //   name: "Armenians",
  //   class: [categories.Infantry, categories.Naval],
  //   region: categories.Mediterranean,
  // )

  let result = compare_answer(correct, x)

  create_row(x, result)
}
