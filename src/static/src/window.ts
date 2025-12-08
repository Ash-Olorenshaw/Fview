
declare global {
    interface Window {
        getQualityText: ((file : string) => Promise<{ result : string, success : boolean }>);
	}
}
