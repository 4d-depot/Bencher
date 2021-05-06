function replaceText(text, values) {
	let result = '';
	if (text != null) {
		text.split('{').forEach((subpart) => {
			const twoparts = subpart.split('}');
			if (twoparts.length > 1) {
				const [sourceStr, remainStr] = twoparts;
				const value = values[sourceStr];
				result += value + remainStr;
			} else result += subpart;
		});
	}
	return result;
}

class Bencher {

    constructor(ds) {
        this.ds = ds;
        this.$reqPerSec = $("#reqPerSec");
        this.$serverTime = $('#serverTime');
        this.$cacheHits = $('#cacheHits');
        this.$cacheMisses = $('#cacheMisses');
        this.$missRatio = $('#missRatio');
        this.$getRandomEntities = $("#getRandomEntities");
        this.$alterRandomEntities = $("#alterRandomEntities");
        this.$buildData = $("#buildData");
        this.$howManyRecords = $("#howManyRecords");
        this.$buildModel = $("#buildModel");
        this.$toggleListen = $("#toggleListen");
        this.$pendingActions = $(".pendingActions");
        this.$displayServerInfo = $(".displayServerInfo");
        this.$thinProgressTitle = $('.thinProgressTitle');
        this.$thinProgressHandle = $('.thinProgressHandle');
        this.$progressContainer = $('.progress');
        this.$curCacheSize = $('#curCacheSize');
        this.$usedCacheSize = $('#usedCacheSize');
        this.$setCacheSize = $('#setCacheSize');
        this.$preFillCache = $('#preFillCache');
        this.$cachesize = $('#cachesize');

        this.$buildData.on('click', this.handleBuildData.bind(this));
        this.$buildModel.on('click', this.handleBuildModel.bind(this));
        this.$getRandomEntities.on('click', this.handleGetRandomEntities.bind(this));
        this.$alterRandomEntities.on('click', this.handleAlterRandomEntities.bind(this));
        this.$toggleListen.on('click', this.handleToggleTimer.bind(this));

        this.$setCacheSize.on('click', this.handleSetCacheSize.bind(this));
        this.$preFillCache.on('click', this.handlePreFillCache.bind(this));
        
        this.refInterval = null;
        this.nbActions = 0;
        this.curprogress = null;

        ds.initProgressManager();
        ds.addProgressListener(this.updateProgressIndicator.bind(this));
        this.updateCacheInfo();
    }


    async updateCacheInfo() {
        try {
            const cacheinfo = await this.callMethod('getCacheInfo', null);
            const usedMem = Utils.formatNumber(cacheinfo.usedMem, '###,###');
            const maxMem = Utils.formatNumber(cacheinfo.maxMem, '###,###');
            this.$curCacheSize.html(maxMem);
            this.$usedCacheSize.html(usedMem);
        }
        catch (err) {
        }
    }

    async handlePreFillCache() {
        this.$preFillCache.prop("disabled", true);
        const val = this.$howManyRecords.val();
        const csize = parseInt(val);
        try {
            await this.callMethod('preFillCache', null);
            this.updateCacheInfo();
        }
        catch (err) {
        }
        this.$preFillCache.prop("disabled", false);
    }


    async handleSetCacheSize() {
        const val = this.$cachesize.val();
        const csize = parseInt(val);
        try {
            await this.callMethod('setCacheSize', null, csize);
            this.updateCacheInfo();
        }
        catch (err) {
        }
    }

    updateProgressIndicator(command, progress) {
		const $textElem = this.$thinProgressTitle;
		const $progressHandleElem = this.$thinProgressHandle;
		if (command === 'remove') {
			if (progress === this.curprogress) {
				$textElem.html('');
				$progressHandleElem.css('width', '');
                this.curprogress = null;
                this.$progressContainer.addClass('hidden');
			}
		} else if (progress === this.curprogress) {
			// this.$progressElem.css('display', 'block');
			this.$progressContainer.removeClass('hidden');
			let message = replaceText(progress.message, { curValue: progress.curValue, maxValue: progress.maxValue });
			if (progress.title != null && progress.title !== '')
				message = `${progress.title} : ${message}`;
			$textElem.html(message);
			if (progress.maxValue > 0) {
				const ratio = Math.round((progress.curValue * 100) / progress.maxValue);
				$progressHandleElem.css('width', `calc(${ratio}% - 0px)`);
			}
		}
	}
    

    async callMethod(methodName, settings, param1, param2, param3) {
        const that = this;
        const params = [];
        if (param1 !== undefined) {
            params.push(param1);
            if (param2 !== undefined) {
                params.push(param2);
                if (param3 !== undefined) {
                    params.push(param3);
                }
            }
        }
        const body = JSON.stringify({ params: params });
        let url = `/rest/$catalog/${methodName}`;
        return new Promise(async function callmethod(resolve, reject) {
            if (settings != null) {
                url += '?'+Object.entries(settings).map(([key, value]) => key + '=' + value).join('&');
            }
                
            restRequest('POST', url, body, null).then((resp) => {
                let result = null;
                if (resp != null) {
                    result = resp.result;
                }
                resolve(result);
            }).catch(reject);
        });
    }


    async handleToggleTimer() {
        if (this.refInterval == null) {
            this.$displayServerInfo.removeClass('hidden');
            this.refInterval = setInterval(this.handleTimer.bind(this), 1000);
            this.$toggleListen.html('Stop Listening');
        } else {
            clearInterval(this.refInterval);
            this.$displayServerInfo.addClass('hidden');
            this.refInterval = null;
            this.$toggleListen.html('Start Listening');
        }
    }


    async handleTimer() {
        let display = 'n/a';
        let displayTime = 'n/a';
        let cacheMisses = '';
        let cacheHits = '';
        let ratio = '';
        try {
            const result = await this.callMethod('getMeasures', null);
            if (result != null) {
                const nbreq = result.count;
                const elapsed = result.elapsed;
                const nbreqpersec = Math.round(nbreq * 1000 / elapsed);
                display = '' + nbreqpersec;
                displayTime = '' + result.time;
                const dataAccesses = result.dataAccesses;
                if (dataAccesses != null) {
                    try {
                        const hits = dataAccesses.DB.cacheReadCount.value;
                        const misses = dataAccesses.DB.cacheMissCount.value;
                        const missratio = misses / hits * 100;
                        cacheMisses = Utils.formatNumber(misses, '###,###');
                        cacheHits = Utils.formatNumber(hits, '###,###');
                        ratio = Utils.formatNumber(missratio, "###,##0.000 %");
                        const usedMem = Utils.formatNumber(dataAccesses.cache.usedMem, '###,###');
                        const maxMem = Utils.formatNumber(dataAccesses.cache.maxMem, '###,###');
                        this.$curCacheSize.html(maxMem);
                        this.$usedCacheSize.html(usedMem);
                    }
                    catch (err2) {
                        cacheMisses = 'n/a';
                        cacheHits = 'n/a';
                    }
                }
            }
        }
        catch (err) {
            diplay = 'n/a'
        }
        this.$reqPerSec.html(display);
        this.$serverTime.html(displayTime);
        this.$cacheHits.html(cacheHits);
        this.$cacheMisses.html(cacheMisses);
        this.$missRatio.html(ratio);
    }


    async handleBuildData() {
        const val = this.$howManyRecords.val();
        const nbrec = parseInt(val);
        
        this.curprogress = this.ds.newProgressIndicator();
        
        try {
            await this.callMethod('generateData', { $progressWebInfo: this.curprogress.getRefID() }, nbrec);
            
        }
        catch(err) {
        }
        

    }


    async handleBuildModel() {
    }


    async handleGetRandomEntities() {
        let cont = true;
        this.nbActions++;
        const curAction = this.nbActions;

        const id = 'nbreq' + curAction;
        let html = '<div class="pendingAction">';
        html += `<div class="infotext">Get Random Entity: </div><div class="infotext value" id="${id}">0</div><div class="infotext">requests per sec</div>`;
        html += '</div>';
        this.$pendingActions.append(html);
        this.$pendingActions.removeClass('hidden');

        let nbreq = 0;
        let start = new Date().getTime();
        while (cont) {
            const entity = await this.callMethod('randomGetEntity', null);
            nbreq++;
            const t = new Date().getTime();
            const elapsed = Math.abs(t - start);
            const nbreqpersec = Math.round(nbreq * 1000 / elapsed);
            if (elapsed > 1000) {
                nbreq = 0;
                start = t;
                $('#' + id).html('' + nbreqpersec);
            }
                
            
        }
    }


    async handleAlterRandomEntities() {
        let cont = true;
        this.nbActions++;
        const curAction = this.nbActions;

        const id = 'nbreq' + curAction;
        let html = '<div class="pendingAction">';
        html += `<div class="infotext">Alter Random Entity: </div><div class="infotext value" id="${id}">0</div><div class="infotext">requests per sec</div>`;
        html += '</div>';
        this.$pendingActions.append(html);
        this.$pendingActions.removeClass('hidden');

        let nbreq = 0;
        let start = new Date().getTime();
        while (cont) {
            const entity = await this.callMethod('randomAlterEntity', null);
            nbreq++;
            const t = new Date().getTime();
            const elapsed = Math.abs(t - start);
            const nbreqpersec = Math.round(nbreq * 1000 / elapsed);
            if (elapsed > 1000) {
                nbreq = 0;
                start = t;
                $('#' + id).html('' + nbreqpersec);
            }
                
            
        }
    }

}




window.addEventListener('bundle:ready', async ({ data: ds, caughtErr: err }) => {
    /*
    DataSource.buildDependencies();
    DataSource.createRequestOptimization();
    await DataSource.computeInitialValues();
    */
    
    let bencher = new Bencher(ds);

    

})

