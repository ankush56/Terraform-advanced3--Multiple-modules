rg_group_names = ["rg1", "rg2", "rg3"]
resource_group_location = "eastus2"
acr_names = ["acr1hazel", "acr2hazel", "acr3hazel"]
avengers = [ "hulk", "spiderman", "ironman", "thor" ]
avengers_powers = {
    hulk      : "smash",
    spiderman  : "web",
    thor :  "lighting"
  }

# Used with if-else. false will set count =0  which means resource wont be created
create_rg = false