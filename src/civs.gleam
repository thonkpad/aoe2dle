import categories.{
  type Civilization, Archer, Cavalry, Civilization as Civ, Defensive, EastEurope,
  Infantry, Mediterranean, Naval, SouthEastAsia,
}

pub const all: List(Civilization) = [
  Civ(name: "Armenians", class: [Infantry, Naval], region: Mediterranean),
  Civ(name: "Vietnamese", class: [Archer], region: SouthEastAsia),
  Civ(name: "Magyars", class: [Cavalry], region: EastEurope),
  Civ(name: "Georgians", class: [Cavalry, Defensive], region: Mediterranean),
]
