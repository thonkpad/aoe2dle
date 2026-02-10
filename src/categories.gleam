import gleam/int
import gleam/list
import gleam/set
import gleam/string

pub type CivClass {
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

pub fn civclass_to_string(civclass: CivClass) -> String {
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
    CavalryArcher -> "Cavalry Archer"
  }
}

pub type Region {
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

pub fn region_to_string(region: Region) -> String {
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

pub fn compare_civclass(a: List(CivClass), b: List(CivClass)) -> Float {
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

pub fn compare_region(a: Region, b: Region) -> Float {
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

pub type MilitiaLine {
  ManAtArms
  LongSwordsman
  TwoHandedSwordsman
  Champion
}

pub fn militialine_to_string(x: MilitiaLine) -> String {
  case x {
    ManAtArms -> "Man-at-Arms"
    LongSwordsman -> "Long Swordsman"
    TwoHandedSwordsman -> "Two-Handed Swordsman"
    Champion -> "Champion"
  }
}

pub type SpearmanLine {
  Spearman
  Pikeman
  Halberdier
}

pub fn spearmanline_to_string(x: SpearmanLine) -> String {
  case x {
    Spearman -> "Spearman"
    Pikeman -> "Pikeman"
    Halberdier -> "Halberdier"
  }
}

pub type BarracksTechs {
  Arson
  Gambesons
  Squires
}

pub fn barrackstechs_to_string(x: BarracksTechs) -> String {
  case x {
    Arson -> "Arson"
    Gambesons -> "Gambesons"
    Squires -> "Squires"
  }
}

pub type Barracks {
  Barracks(
    militia_line: MilitiaLine,
    spearman_line: SpearmanLine,
    techs: List(BarracksTechs),
  )
}

pub type ArcherLine {
  ArcherUnit
  Crossbowman
  Arbalester
}

pub fn archerline_to_string(x: ArcherLine) -> String {
  case x {
    ArcherUnit -> "Archer"
    Crossbowman -> "Crossbowman"
    Arbalester -> "Arbalester"
  }
}

pub type SkirmisherLine {
  Skirmisher
  EliteSkirmisher
}

pub fn skirmisherline_to_string(x: SkirmisherLine) -> String {
  case x {
    Skirmisher -> "Skirmisher"
    EliteSkirmisher -> "Elite Skirmisher"
  }
}

pub type CavalryArcherLine {
  CavalryArcherUnit
  HeavyCavalryArcher
}

pub fn cavalryarcherline_to_string(x: CavalryArcherLine) -> String {
  case x {
    CavalryArcherUnit -> "Cavalry Archer"
    HeavyCavalryArcher -> "Heavy Cavalry Archer"
  }
}

pub type ArcheryRangeTechs {
  ThumbRing
  ParthianTactics
}

pub fn archeryrangetechs_to_string(x: ArcheryRangeTechs) -> String {
  case x {
    ThumbRing -> "Thumb Ring"
    ParthianTactics -> "Parthian Tactics"
  }
}

pub type ArcheryRange {
  ArcheryRange(
    archer_line: ArcherLine,
    skirmisher_line: SkirmisherLine,
    cavarcher_line: CavalryArcherLine,
    techs: List(ArcheryRange),
  )
}

pub type ScoutLine {
  ScoutCavalry
  LightCavalry
  Hussar
}

pub fn scoutline_to_string(x: ScoutLine) -> String {
  case x {
    ScoutCavalry -> "Scout Cavalry"
    LightCavalry -> "Light Cavalry"
    Hussar -> "Hussar"
  }
}

pub type KnightLine {
  Knight
  Cavalier
  Paladin
}

pub fn knightline_to_string(x: KnightLine) -> String {
  case x {
    Knight -> "Knight"
    Cavalier -> "Cavalier"
    Paladin -> "Paladin"
  }
}

pub type StableTechs {
  Bloodlines
  Husbandry
}

pub fn stabletechs_to_string(x: StableTechs) -> String {
  case x {
    Bloodlines -> "Bloodlines"
    Husbandry -> "Husbandry"
  }
}

pub type Stable {
  Stable(
    scout_line: ScoutLine,
    knight_line: KnightLine,
    techs: List(StableTechs),
  )
}

pub type Civilization {
  Civilization(name: String, class: List(CivClass), region: Region)
}
