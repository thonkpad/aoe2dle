import gleam/int
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

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
