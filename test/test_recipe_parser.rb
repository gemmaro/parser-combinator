require "minitest/autorun"
require "pry"
require_relative "spec_helpers"

describe Grammar do
  describe "Real world examples" do
  it "output matches" do
    parser = Grammar.build do
      rule(:eol) { many0 { anyChar([" ", "\t"]) } < anyChar(["\n"]) }
      rule(:instructions) { whitespace <= ( (str("Zubereitung") | str("Anweisungen")) / rule(:eol)) >> many1 { whitespace <= many1 { anyCharBut(["\n"]) } >= rule(:eol) } }
      rule(:ingredient) { whitespace <= many1 { anyCharBut(["\n"]) } / rule(:eol) }
      rule(:ingredients) { whitespace <= (str("Zutaten") / rule(:eol)) < many1 { rule(:ingredient) != rule(:instructions) }  >= rule(:eol) }
      rule(:recipe_name) { (str("Rezept ") <= many1 { anyCharBut(["\n"]) }) / many1 { rule(:eol) } }
      rule(:recipe) { seq rule(:recipe_name), rule(:ingredients), rule(:instructions), lambda { |name, ingredients, instructions| [name, ingredients, instructions] } }

      start(:recipe)
    end

    assert_parses parser, with: 
      "Rezept Tomatensahne

      Zutaten
      1 kg, Tomaten
      100g, Zwiebeln
      30g, Butter
      1, Knoblauchzehe
      1 EL, Mehl
      2-3 EL, Tomatenmark
      2 EL, Tomatenketchup
      1/4 L, Brühe
      1/4 L, Schlagsahne

      Salz
      Cayennepfeffer
      1 TL, Zucker
      1 TL, Zitronensaft
      1 Bd., Basilikum



      Anweisungen
      Zwiebeln fein würfeln.
      Tomaten häuten und würfeln.
      Zwiebeln glasig dünsten, Knoblauch dazupressen.
      Mit Mehl überstäuben, kurz anschwitzen.
      Tomatenmark und -ketchup zugeben. Mit Brühe und Sahne auffüllen.
      Sauce unter Rühren 5 Min. kochen.
      Inzwischen Nudeln kochen, am besten Linguine.
      Tomaten in der Sauce 5 Min. garen.
      Mit Salz, Cayennepfeffer, Zucker und Zitronensaft herzhaft würzen.
      Basilikumblätter abzupfen, in Streifen schneiden und auf die Sauce streuen.",
      remaining: "",
      output: 
      [["Tomatensahne"], ["Zutaten", ["1 kg, Tomaten", "100g, Zwiebeln", "30g, Butter", "1, Knoblauchzehe", "1 EL, Mehl", "2-3 EL, Tomatenmark", "2 EL, Tomatenketchup", "1/4 L, Brühe", "1/4 L, Schlagsahne", "Salz", "Cayennepfeffer", "1 TL, Zucker", "1 TL, Zitronensaft", "1 Bd., Basilikum"]], ["Anweisungen", ["Zwiebeln fein würfeln.", "Tomaten häuten und würfeln.", "Zwiebeln glasig dünsten, Knoblauch dazupressen.", "Mit Mehl überstäuben, kurz anschwitzen.", "Tomatenmark und -ketchup zugeben. Mit Brühe und Sahne auffüllen.", "Sauce unter Rühren 5 Min. kochen.", "Inzwischen Nudeln kochen, am besten Linguine.", "Tomaten in der Sauce 5 Min. garen.", "Mit Salz, Cayennepfeffer, Zucker und Zitronensaft herzhaft würzen.", "Basilikumblätter abzupfen, in Streifen schneiden und auf die Sauce streuen."]]]
  end
  end
end
