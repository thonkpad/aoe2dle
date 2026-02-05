import categories.{
  type Civilization, Archer, Cavalry, Civilization as Civ, Defensive, EastEurope,
  Infantry, Mediterranean, Naval, SouthEastAsia,
}
import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html

pub const all: List(Civilization) = [
  Civ(name: "Armenians", class: [Infantry, Naval], region: Mediterranean),
  Civ(name: "Vietnamese", class: [Archer], region: SouthEastAsia),
  Civ(name: "Magyars", class: [Cavalry], region: EastEurope),
  Civ(name: "Georgians", class: [Cavalry, Defensive], region: Mediterranean),
]

fn civ_option(civ: Civilization) -> element.Element(a) {
  html.option([attribute.value(civ.name)], civ.name)
}

pub fn all_civ_strings() {
  list.map(all, civ_option)
}
