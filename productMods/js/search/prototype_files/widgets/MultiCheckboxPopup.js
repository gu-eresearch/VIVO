(function ($) {

var cESCAPE = 27;
var isIE7orLess = $.browser.msie && $.browser.version <= 8;

var FilterableDataView = function() {
    var dataView = new Slick.Data.DataView();
    var self = dataView;

    // extend Slick.Data.DataView
    $.extend(dataView, {
        getFilteredItems: function() {
            var items = [];
            for (var i=0;i<self.getLength();i++) {
                items.push(self.getItem(i));
            }
            return items;
        },
        getItemMetadata: function(row) {
            return {
                'cssClasses': 'ui-element'
            }
        }
    });
    return dataView;
};

var PostRenderGrid = function(selector, data, columns, options) {
    var grid = new Slick.Grid(selector, data, columns, options);
    $.extend(grid, {
        onPostRenderJob: new Slick.Event(),
        _render: grid.render,
        render: function() {
            grid.onPostRenderJob.notify();
            grid._render();
        }
    });
    return grid;
};

var setupGrid = function (gridHandles, columns, options, data) {
    var dataView = new FilterableDataView();
    var grid = new PostRenderGrid(gridHandles.selector, dataView, columns, options);
//    grid.setSelectionModel(new Slick.RowSelectionModel());

    // wire up model events to drive grid
    dataView.onRowCountChanged.subscribe(function(e,args) {
        grid.updateRowCount();
        grid.render();
    });

    dataView.onRowsChanged.subscribe(function(e,args) {
        grid.invalidateRows(args.rows);
        grid.render();
//        if (selectedRowIds.length > 0)
//        {
//            // since how the original data maps onto rows has changed,
//            // the selected rows in the grid need to be updated
//            var selRows = [];
//            for (var i = 0; i < selectedRowIds.length; i++)
//            {
//                var idx = dataView.getRowById(selectedRowIds[i]);
//                if (idx != undefined)
//                    selRows.push(idx);
//            }
//
//            grid.setSelectedRows(selRows);
//        }
    });

    // filtering
    $('#' + gridHandles.searchID).keydown(interceptEscape);
    $('#' + gridHandles.searchID).keyup(filterTitleFactory(grid));
    dataView.beginUpdate();
    dataView.setItems(data);
    dataView.setFilterArgs({
        searchString: searchString
    });
    dataView.setFilter(myFilter);
    dataView.endUpdate();

    // sorting
    grid.onSort.subscribe(sortTitleFactory(grid));

    // attach events & classes after render
    grid.onPostRenderJob.subscribe(function(e, args) {
        addHoverEffects();
        $('.ui-item-text').disableSelection();
    });

    // attach data & dataView to grid for future reference
    grid.data = data;
    grid.dataView = dataView;
    grid.IDs = gridHandles;

    // sort defaults (slickgrid format)
    grid.sortCol = {field: 'title'};
    grid.sortAsc = true;

    // move the filter panel defined in a hidden div into grid top panel
//    grid.showTopPanel();
//    $('#' + gridHandles.filterID).appendTo(grid.getTopPanel()).show();

    // display it
    grid.render();

    return grid;
};

var addHoverEffects = function() {
    $('.slick-row')
        .addClass("ui-corner-all")
        .mouseover(function(e) {
            $(e.target).addClass("ui-state-hover")
        })
        .mouseout(function(e) {
            $(e.target).removeClass("ui-state-hover")
        })
    ;
};

/**
 *  Create IDs from target string
 *  - generates unique IDs for popup sub-components
 */
var generateIDs = function(target, suffix) {
    var selector = target + '-'+ suffix;
    var id = selector.replace(/#/g, '');
    return {
        selector: selector,
        ID: id,
        filterID: id + '-filter',
        searchID: id + '-search'
    }
};

/**
 * Moves all data in the grid 'from' to the grid 'to'
 *  - used by select all/deselect all links
 */
var swapAllRowsFactory = function(from, to) {
    function swapAllRows(e) {
        var rows = from.dataView.getFilteredItems();
        
        $.each(rows, function(i, row) {
            from.dataView.deleteItem(row.id);
        });

        from.dataView.refresh();
        from.render();

        to.data = to.data.concat(rows);
        to.dataView.setItems(to.data);
        to.dataView.refresh();
        to.onSort.notify(to);
        to.render();

        e.preventDefault();
    }
    return swapAllRows;
};

/**
 * Move selected row data
 * @param from  grid item with selected row
 * @param to    grid item where data is to move
 */
var swapRowFactory = function(from, to) {
    function swapRow(e, args) {
    	var filteredRows = from.dataView.getFilteredItems();
        var row = filteredRows[args.row];
        
        // move into 'to' grid if it doesn't exist
        if (!to.dataView.getItemById(row.id)) {
            to.dataView.addItem(row);
        }
        to.dataView.refresh();
        to.onSort.notify(to);
        to.render();

        from.dataView.deleteItem(row.id);
        from.dataView.refresh();
        from.render();
    }
    return swapRow;
};

var filterTitleFactory = function(grid) {
    var filterTitle = function (e) {
//        Slick.GlobalEditorLock.cancelCurrentEdit();
        if (e.which == cESCAPE) this.value = '';

        var searchString = this.value;
        grid.dataView.setFilterArgs({
            searchString: searchString
        });
        grid.dataView.setFilter(titleFilter);
        grid.dataView.refresh();
        e.preventDefault();
        e.stopPropagation();
    };
    return filterTitle;
};

var sortTitleFactory = function(grid) {
    var sortTitle = function(e, args) {
        var sortcol = args.sortCol.field;
        var sortasc = args.sortAsc;
        if (isIE7orLess) {
            // die in a fire, IE
            grid.dataView.fastSort(sortcol, sortasc);
        } else {
            var comparer = function (a, b) {
                var x = a[sortcol], y = b[sortcol];
                return (x == y ? 0 : (x > y ? 1 : -1));
            };
            grid.dataView.sort(comparer, sortasc);
        }
        // store the sort on the grid so we can autosort it
        // when needed
        grid.sortCol = args.sortCol;
        grid.sortAsc = args.sortAsc;
    };
    return sortTitle;
};

/**
 * Prevent ESC from propagating to stop popups from closing)
 * @param e     Event
 */
var interceptEscape = function(e) {
    if (e.which == cESCAPE) {
        e.preventDefault();
        e.stopPropagation();
    }
};

/**
* SlickGrid search filter
*/
var titleFilter = function(item, args) {
    var title = item['title'].toLowerCase();
    var searchString = args.searchString.toLowerCase();
    return !(args.searchString != "" && title.indexOf(searchString) == -1);
}

AjaxSolr.MultiCheckboxPopup = AjaxSolr.AbstractFacetWidget.extend({

    popupTemplate: function(gridA_IDs, gridS_IDs) {
        return $(
            '<div class="ui-multiselect2" style="position:relative">'+
                '<div>'+
                    '<table border="0">'+
                        '<tr>'+
                            '<td>'+
                '<div id="' + gridA_IDs.filterID + '" class="actions ui-widget-header ui-helper-clearfix search-cell search-cell-left">'+
                    '<input class="textFilter" type="text" id="' + gridA_IDs.searchID + '">'+
                    '<a href="#" id="selectAllLink" class="swapAllLink">Add All</a>'+
                '</div>'+
                '</td>'+
                '<td>'+
                '<div id="' + gridS_IDs.filterID + '" class="actions ui-widget-header ui-helper-clearfix search-cell search-cell-right">'+
                    '<input class="textFilter" type="text" id="' + gridS_IDs.searchID + '">'+
                    '<a href="#" id="deSelectAllLink" class="swapAllLink">Remove All</a>'+
                '</div>' +
                '</tr>'+
                '<tr class="ui-dual-grid">'+
                            '</td>'+
                            '<td>'+
                                '<span id="' + gridA_IDs.ID + '" style="float:left;width:317px;height:400px;" class="search-grid-left-col"></span>'+
                            '</td>'+
                            '<td>'+
                                '<span id="' + gridS_IDs.ID + '" style="float:left;width:317px;height:400px;" class="search-grid-right-col"></span>'+
                            '</td>'+
                        '</tr>'+
                    '</table>'+
                '</div>'+
            '</div>' //+
//            '<div id="' + gridA_IDs.filterID + '" class="actions ui-widget-header ui-helper-clearfix">'+
//                'Search: <input type="text" id="' + gridA_IDs.searchID + '">'+
//                '<a href="#" id="selectAllLink">Add All</a>'+
//            '</div>'+
//            '<div id="' + gridS_IDs.filterID + '" class="actions ui-widget-header ui-helper-clearfix">'+
//                'Search: <input type="text" id="' + gridS_IDs.searchID + '">'+
//                '<a href="#" id="deSelectAllLink">Remove All</a>'+
//            '</div>'
        );
    },

    afterRequest: function() {
        var self = this;

        if (self.manager.response.response.numFound) {
            var facets = self.facets();
            var activeFacets = self.getActive();

            // Don't continue if there is nothing to work with
            if (facets < 1 && activeFacets < 1) return $(self.target).empty();

            var activeFacetsArr = {};
            if (activeFacets.length > 0) {
                for (var j=0; j < activeFacets.length; j++) {
                    activeFacetsArr[ activeFacets[j] ] = activeFacets[j];
                }
            }

            //generate the data arrays
            var dataAvailable = [], dataSelected = [];
            if (facets.length != 0) {
                for (var i=0; i<facets.length; i++) {
                    var item = {
                        title: facets[i].value,
                        count: facets[i].count,
                        id: i
                    };
                    if (self.exists(activeFacetsArr[item.title]) ) {
                        dataSelected.push(item);
                    } else {
                        dataAvailable.push(item);
                    }
                }
            }

            // add popup template
            var gridA_IDs = generateIDs(self.target, 'gridA');
            var gridS_IDs = generateIDs(self.target, 'gridS');
            $(self.target).empty().append(
                self.popupTemplate(gridA_IDs, gridS_IDs)
            );

            var columnsAvailable = [
                {
                    id: "title",
                    name: "Available Items",
                    field: "title",
                    width: 283, minWidth: 283,
                    cssClass: "cell-title",
                    sortable: true,
                    resizable: false,
//                    behaviour: "select"
                }
            ];
            var columnsSelected = [
                {
                    id:"title",
                    name:"Selected Items",
                    field:"title",
                    width: 283, minWidth: 283,
                    cssClass:"cell-title",
                    sortable:true,
                    resizable: false
                }
            ];
            var options = {
                editable: false,
//                enableCellNavigation: true,
                asyncEditorLoading: true,
//                forceFitColumns: true,
                topPanelHeight: 25,
                height: 400,
                defaultColumnWidth: 300
            };

            var available = new setupGrid(gridA_IDs, columnsAvailable, options, dataAvailable);
            var selected = new setupGrid(gridS_IDs, columnsSelected, options, dataSelected);

            //  wire up behaviours between the two grids

            $('#selectAllLink').click(
                swapAllRowsFactory(available, selected)
            );
            $('#deSelectAllLink').click(
                swapAllRowsFactory(selected, available)
            );

            available.onClick.subscribe(
                swapRowFactory(available, selected)
            );
            selected.onClick.subscribe(
                swapRowFactory(selected, available)
            );

            self.gridAvailable = available;
            self.gridSelected = selected;
        }
    },

    exists: function(data){
        return !(!data || data == null || data == 'undefined' || typeof(data) == 'undefined');
    },

    /**
    *  Click handler for "Any" checkboxes
    */
    allResultsClickHandler: function() {
        var self = this;
        return function () {
            $(this).blur();
            self.clear();
            self.manager.doRequest(0);
            return false;
        }
    },

    /**
    * Click handler for normal checkboxes
    */
    clickHandler: function () {
        var self = this;
        return function() {
            var values = [];

            $(self.gridSelected.data).each(function() {
                values.push(this.title);
            });

            // If all have been unchecked, reset the facet to 'Any'
            if (values.length < 1 || self.gridAvailable.data.length == 0) {
                self.clear();
                self.manager.doRequest(0);
                return false;
            }

            var param = new AjaxSolr.Parameter({
                name: 'fq',
                key: self.field,
                value: values,
                filterType: 'subquery',
                operator: 'OR'
            });

            if (self.tagAndExclude) {
                var tag = (self.id.indexOf('_popup') > 0) ? self.id.substring(0,self.id.indexOf('_popup')) : self.id;
                param.local('tag', tag);
            }

            if (self.set.call(self, param)) {
                self.manager.doRequest(0);
            }

            return false;
        }
    },


    /**
    * Get all active filters for this facet
    */
    getActive: function() {
        var keys;
        var facets = [];
        if (keys = this.manager.store.findByKey('fq', this.field)) {
            for (var i = 0; i < keys.length; i++) {
                var param = this.manager.store.params['fq'][keys[i]];
                if (AjaxSolr.isArray(param.value)) {
                    for (var j = 0; j < param.value.length; j++) {
                        facets.push(param.value[j]);
                    }
                }
                else {
                    facets.push(param.value);
                }
            }
        }
        return facets;
    },


    /**
    * Override this function to prevent extra quotes from being added
    */
    fq: function (value, exclude) {
        return value;
    },

/**
* Define options for jQueryUI dialogs
*
* @see http://jqueryui.com/demos/dialog/
*/
    popupOptions: function() {
        var self = this;
        var handler = this.clickHandler();
        return {
            title: self.title,
            height: 530, // 520,
            width: 635,
            buttons: {
                Update: function() {
                    $(this).dialog( "close" );
                    $(document).scrollTop(0);
                    handler();
                },
                Cancel: function() {
                    $(this).dialog( "close" );
                }
            }
        }
    }

});

})(jQuery);