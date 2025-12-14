import { raise_err } from "./utils";

async function intercept_click(e : MouseEvent) {
	let t = e.target as HTMLElement | Document | null;

	while (t && t !== document && "tagName" in t) {
		if (t.tagName === 'A' && (t as HTMLAnchorElement).href) {
			e.preventDefault();
			const { success, success_reason } = await window.systemOpen((t as HTMLAnchorElement).href);
			if (!success)
				raise_err(`Failed to open system browser. Reason: '${success_reason}'`)
			return;
		}
		t = t.parentElement;
	}
}

export function setup_href_redirect() {
	document.addEventListener('click', intercept_click);
}
