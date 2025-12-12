async function intercept_click(e : MouseEvent) {
	let t = e.target as HTMLElement | Document | null;

	while (t && t !== document && "tagName" in t) {
		if (t.tagName === 'A' && (t as HTMLAnchorElement).href) {
			e.preventDefault();
			window.openExternalLink((t as HTMLAnchorElement).href);
			return;
		}
		t = t.parentElement;
	}
}

export function setup_href_redirect() {
	document.addEventListener('click', intercept_click);
}
