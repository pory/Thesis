require 'models/chapter'
require 'models/thesis_parser'
require 'modules/thesis_builder'

class Thesis
  extend ThesisBuilder

  THESIS_PATH = File.dirname(__FILE__) + "/../thesis/"

  chapter "Úvodní strana", :numbering => :no, :path => ThesisBuilder::THESIS_ROOT
  chapter "Abstrakt", :numbering => :no
  chapter "Úvod", :numbering => :no
  chapter "Interaktivní podoba diplomové práce"
  chapter "Proč Ruby" do |c|
    c.section "Kultura"
    c.section "Jak vypadá kód"
    c.section "Svoboda"
    c.section "Monkey Patching"
    c.section "Vlastnosti jazyka" do |s|
      s.section "Skriptovací jazyky"
      s.section "Interpretované jazyky"
      s.section "Imperativní programování"
      s.section "Funkcionální programování"
    end
  end
  chapter "Ruby vs Java" do |c|
    c.section "První aplikace"
    c.section "Kam se poděly závorky"
    c.section "Dynamické typování"
    c.section "Datové typy" do |s|
      s.section "Čísla"
      s.section "Řetězce"
      s.section "Symboly"
      s.section "Pole"
      s.section "Asociativní pole"
      s.section "Intervaly, posloupnosti"
      s.section "Regulární výrazy"
    end
    c.section "Algoritmické konstrukce" do |s|
      s.section "Příkazy pro větvení"
      s.section "Cykly"
    end
    c.section "Iterátory a bloky" do |s|
      s.section "Bloky kódu"
      s.section "Iterátory"
    end    
    c.section "Metody" do |s|
      s.section "Pojmenované argumenty"
      s.section "Libovolný počet argumentů"
    end    
    c.section "Třídy" do |s|
      s.section "Definice třídy a konstruktor"
      s.section "Tvorba instance a instanční metody"
      s.section "Přístupové metody "
      s.section "Dědičnost"
      s.section "Konstanty"
      s.section "Virtuální atributy"
      s.section "Proměnné třídy a metody třídy"
      s.section "Modifikátory přístupu"
    end
    c.section "Moduly" do |s|
      s.section "Jmenné prostory"
      s.section "Mixiny"
    end
  end
  chapter "Programovací techniky" do |c|
    c.section "Dynamické typování" do |s|
      s.section "Duck typing"
      s.section "Třídy nejsou datové typy"
    end
    c.section "Callbacks (zpětná volání)" do |s|
      s.section "Method missing"
    end
    c.section "Funkcionální programování" do |s|
      s.section "Referenční transparentnost"
      s.section "Princip kompozicionality"
      s.section "Jednoduché funkce v Ruby"
      s.section "Funkce vyšších řádů"
    end
    c.section "Domain Specific Language" do |s|
      s.section "Language Oriented Programming"
      s.section "Interní DSL v Ruby"
      s.section "Metaprogramování"
    end
  end
  chapter "Závěr", :numbering => :no
  chapter "Použitá literatura", :numbering => :no

end