## Data container for the results of a single round.
## Passed to the evaluation screen for display.
class_name RoundResults
extends RefCounted

var round_number: int = 0
var time_remaining: float = 0.0
var money: float = 0.0
var grocery_complete: bool = false
## Positive = flood increases (bad). Negative = flood decreases (good).
var flood_delta: float = 0.0
