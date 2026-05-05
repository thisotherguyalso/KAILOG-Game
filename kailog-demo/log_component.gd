class_name LogComponent
extends Node

var log_entries : Array[LogEntry]

func _ready():
	EventBus.connect("add_log_entry", _on_add_log_entry)

func _on_add_log_entry(log_entry: LogEntry):
	log_entries.append(log_entry)
	print(log_entry.description)
