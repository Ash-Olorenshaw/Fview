
declare global {
    interface Window {
        getQualityText: ((file : string) => Promise<{ result : string, success : boolean }>);
        systemOpen: ((link : string) => Promise<{ success : boolean, success_reason : string }>);
		openQualitiesDir : (() => Promise<{ success : boolean, success_reason : string }>)
		openQualityFile : ((file : string) => Promise<{ success : boolean, success_reason : string }>)
	}
}
