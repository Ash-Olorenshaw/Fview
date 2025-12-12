
declare global {
    interface Window {
        getQualityText: ((file : string) => Promise<{ result : string, success : boolean }>);
        openExternalLink: ((href : string) => Promise<{ success : boolean, success_reason : string }>);
	}
}
