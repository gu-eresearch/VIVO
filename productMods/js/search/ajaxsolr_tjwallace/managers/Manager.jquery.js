// $Id$

/**
 * @see http://wiki.apache.org/solr/SolJSON#JSON_specific_parameters
 * @class Manager
 * @augments AjaxSolr.AbstractManager
 */
AjaxSolr.Manager = AjaxSolr.AbstractManager.extend(
  /** @lends AjaxSolr.Manager.prototype */
  {
  executeRequest: function (servlet) {
    var self = this;
    if (this.proxyUrl) {
      jQuery.post(this.proxyUrl, { query: this.store.string() }, function (data) { self.handleResponse(data); }, 'json');
    }
    else {
      var queryString = this.store.string().replace("&q= &","&q=&");
      //jQuery.getJSON(this.solrUrl + servlet + '?' + queryString  +'&q.alt=*:*&fq=-PROHIBITED_FROM_TEXT_RESULTS:1&wt=json&json.wrf=?', {}, function (data) { 
      /*
      jQuery.getJSON(this.solrUrl + servlet + '?' + queryString  +'&q.alt=*:*&fq=-PROHIBITED_FROM_TEXT_RESULTS:1&wt=json', {}, function (data) { 
      	//console.log(1);
        //console.log(data);
      	self.handleResponse(data); 
      });
      */
      
      var posturl = this.solrUrl + servlet;
      var postparams = queryString  +'&q.alt=*:*&fq=-PROHIBITED_FROM_TEXT_RESULTS:1&wt=json';
      
      jQuery.post(posturl, postparams, function (data) { 
      	//console.log(1);
        //console.log(data);
      	self.handleResponse(data); 
      }, 'json');
    }
  }
});
