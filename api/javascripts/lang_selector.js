/*
Copyright 2008-2013 Concur Technologies, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations
under the License.
*/
function activateLanguage(t){$("#lang-selector a").removeClass("active"),$("#lang-selector a[data-language-name='"+t+"']").addClass("active");for(var e=0;e<languages.length;e++)$(".highlight."+languages[e]).hide();$(".highlight."+t).show()}function setupLanguages(t){languages=t,currentLanguage=languages[0],defaultLanguage=localStorage.getItem("language"),""!=location.search.substr(1)&&-1!=jQuery.inArray(location.search.substr(1),languages)?(activateLanguage(location.search.substr(1)),localStorage.setItem("language",location.search.substr(1))):activateLanguage(null!==defaultLanguage&&-1!=jQuery.inArray(defaultLanguage,languages)?defaultLanguage:languages[0]),$("#lang-selector a").bind("click",function(){return window.location.replace("?"+$(this).data("language-name")+window.location.hash),!1})}languages=[];