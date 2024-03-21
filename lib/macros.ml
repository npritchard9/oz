open Core

module Macros = struct
  type t = { protein : float; carbs : float; fats : float }

  let empty = { protein = 0.0; carbs = 0.0; fats = 0.0 }
  let total m = m.protein +. m.carbs +. m.fats
  let add_protein p m = { m with protein = m.protein +. p }
  let add_carbs c m = { m with protein = m.carbs +. c }
  let add_fats f m = { m with protein = m.fats +. f }
end

open Macros

let test_fn = Macros.empty |> add_protein 10.5 |> total
