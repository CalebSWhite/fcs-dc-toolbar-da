const fcsDCToolbar = (function () {
    'use strict';
    const feature = 'FCS - DC Toolbar DA';

    const setItemFunction = function (pItem2Submit, pAffectedItems, pData) {
        const dcsItem = apex.item(pItem2Submit);
        const dcIDsText = dcsItem?.getValue()?.join(':');
        apex.event.trigger(document, 'fcs_dctoolbarchangedevent', { ids: dcIDsText });
        // handle all affected items
        pAffectedItems.forEach(function (element) {
            const item = apex.item(element);
            // set item text
            item.setValue(dcIDsText);
            // refresh item
            item.refresh();
        });
    };

    const loadData = function (pThis, pAJAXID, pItem2Submit, pAffectedItems) {
        // make ajax call to db
        apex.server.plugin(pAJAXID, {
            pageItems: apex.util.toArray(pItem2Submit),
        }, {
            success: function (pData) {
                apex.debug.info(feature, pData);
                setItemFunction(pItem2Submit, pAffectedItems, pData);
                apex.da.resume(pThis.resumeCallback, false);
            },
            error: function (pjqXHR, pTextStatus, pErrorThrown) {
                console.warn('pjqXHR', pjqXHR);
                console.warn('pTextStatus', pTextStatus);
                console.warn('pErrorThrown', pErrorThrown);
                apex.da.handleAjaxErrors(pjqXHR, pTextStatus, pErrorThrown, pThis.resumeCallback);
            },
        });
    };

    return {
        initialize: function (pThis, pAJAXID, pItem2Submit, pAffectedItems) {
            console.log(feature, pThis);
            const pageItem = pItem2Submit.slice(1);
            console.log(feature, 'Item to Submit', pageItem);
            // const affectedItems = pThis.action.affectedElements.split(',');
            const affectedItems = apex.util.toArray(pAffectedItems, ',').map(item => item.slice(1));
            console.log(feature, 'Affected Items []', affectedItems);

            loadData(pThis, pAJAXID, pageItem, affectedItems);
        },
    };
})();
