(function(){
  var CDN = 'https://cdn.jsdelivr.net/npm/prismjs@1.29.0';

  function onReady(fn){
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }

  function addEl(tag, attrs){
    var el = document.createElement(tag);
    for (var k in attrs) if (Object.prototype.hasOwnProperty.call(attrs, k)) el.setAttribute(k, attrs[k]);
    document.head.appendChild(el);
    return el;
  }

  function loadScript(src){
    return new Promise(function(resolve, reject){
      var s = document.createElement('script');
      s.src = src;
      s.onload = function(){ resolve(); };
      s.onerror = function(e){ reject(e); };
      document.head.appendChild(s);
    });
  }

  onReady(function(){
    try {
      if (window.Prism && typeof Prism.highlightAllUnder === 'function') {
        Prism.highlightAllUnder(document, false);
        return;
      }
    } catch (e) {}

  // Rely on site's existing Prism styles (no CDN theme injection)

    loadScript(CDN + '/components/prism-core.min.js')
      .then(function(){ return loadScript(CDN + '/plugins/autoloader/prism-autoloader.min.js'); })
      .then(function(){
        window.Prism = window.Prism || {};
        Prism.plugins = Prism.plugins || {};
        Prism.plugins.autoloader = Prism.plugins.autoloader || {};
        Prism.plugins.autoloader.languages_path = CDN + '/components/';
        if (typeof Prism.highlightAllUnder === 'function') {
          Prism.highlightAllUnder(document, false);
        }
      })
      .catch(function(err){
        if (typeof console !== 'undefined' && console.warn) console.warn('Prism loader failed:', err);
      });
  });
})();
