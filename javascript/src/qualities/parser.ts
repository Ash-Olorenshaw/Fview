import { parse } from "yaml";
import { raise_err } from "../utils";

export function generate_qualities() : Record<string, string[]> {
	const raw_qualities : string = `RAW_QUALITIES_YAML_STR
	`
	// ^^^^ value auto-resolved by backend

	const parsed_data = parse(raw_qualities)
	for (const line in parsed_data) {
		if (typeof line !== "string") {
			raise_err(`Err - expected all content in 'qualities.yaml' to be text, but received one line of type '${typeof line}'`)
		}
		else if (!Array.isArray(parsed_data[line])) {
			raise_err(`Err - expected all content in 'qualities.yaml' to be text, with a list of related qualities, instead received a '${typeof parsed_data[line]}' for quality '${line}'`)
		}
	}

	return parsed_data
}
