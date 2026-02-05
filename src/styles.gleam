import lustre/attribute

fn box(color: String) -> List(attribute.Attribute(a)) {
  [
    attribute.styles([
      #("width", "70px"),
      #("height", "70px"),
      #("background-color", "white"),
      #("border", "2px solid " <> color),
      #("padding", "10px"),
      //   #("margin", "10px"),
      #("display", "flex"),
      #("justify-content", "center"),
      #("align-items", "center"),
    ]),
  ]
}

pub fn box_neutral() -> List(attribute.Attribute(a)) {
  box("black")
}

pub fn box_correct() -> List(attribute.Attribute(a)) {
  box("green")
}

pub fn box_partial() -> List(attribute.Attribute(a)) {
  box("yellow")
}
